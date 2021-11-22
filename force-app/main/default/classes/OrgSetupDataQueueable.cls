public class OrgSetupDataQueueable implements Queueable, Database.AllowsCallouts  {
    
    private OrgSetupAction.Request request;
    
    public OrgSetupDataQueueable(OrgSetupAction.Request request) {
        this.request = request;
    }
    
    public void execute(QueueableContext context) {

        if (request.requestMethod == 'purgeObject') {
            purgeObject();
        } else if (request.requestMethod == 'generateObject') {
            generateObject();
        }
    }

    @TestVisible void purgeObject() {
        try {
            String soql = 'SELECT Id FROM ' + request.objectName;
            List<SObject> records = Database.query(soql);            
            Database.deleteImmediate(records);        
            publishPlatformEvent(true, request.objectName + ' data has been removed.');
        } catch (exception ex) {
            publishPlatformEvent(false, ex.getMessage() + '\n' + ex.getStackTraceString());
        }
    }
    
    @TestVisible void generateObject() {
        try {
            String resourceURL = '/resource/'
                + request.staticResourceDateTime.getTime() + '/' 
                + request.staticResourceName + '/' 
                + request.fileName;
            PageReference fileRef = new PageReference(resourceURL);
            Blob file = fileRef.getContent();
        
            SObjectType sObjType = Schema.getGlobalDescribe().get(request.objectName).getDescribe().SObjectType;
            
            Map<SObjectType, SObjectField> externalKeyByObject = 
                OrgSetupDataHelper.instance(request.staticResourceName, OrgSetupDataHelper.OperationType.INSERT_DATA).externalKeyByObject;
            
            List<SObject> records = new CSVToSObject(
                sObjType,
                file,
                externalKeyByObject
            ).parseFile().records;
            
            if (externalKeyByObject.containsKey(sObjType)) {
                System.debug(records);
            	List<Database.UpsertResult> results = Database.upsert(records, externalKeyByObject.get(sObjType));  
                Boolean success = true;
                List<String> messages = new List<String>();
                for (Database.UpsertResult sr : results) {
                    System.debug(sr);
                    if (!sr.isSuccess()) {
                        success = false;
                        for (Database.Error err : sr.getErrors()) {
                            messages.add(err.getMessage());
                        }
                    }
                }
                if (success) {
                    publishPlatformEvent(true, sObjType + ' data has been loaded.');
                } else {
                    publishPlatformEvent(false, sObjType +  String.join(messages, '\n'));
                }
            } else {
                insert records;
                publishPlatformEvent(true, sObjType + ' data has been loaded.');
            }
        } catch (exception ex) {
            publishPlatformEvent(false, ex.getMessage() + '\n' + ex.getStackTraceString());
        }
    }
    
    
    @TestVisible void publishPlatformEvent(Boolean success, String message) {
        Sample_Data_Load__e evt = new Sample_Data_Load__e(
            Message__c = message,
            Request_Method__c = request.requestMethod,
            Object__c = request.objectName,
            Success__c = success,
            Complete__c = true
        );
        EventBus.publish(evt);
    }
    
}