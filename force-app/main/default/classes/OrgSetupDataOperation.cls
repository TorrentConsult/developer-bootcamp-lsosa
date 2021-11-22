public class OrgSetupDataOperation {

    private static OrgSetupDataOperation OrgSetupDataOperationInstance = null;
    private OrgSetupAction.Request request;

    public static OrgSetupDataOperation instance(OrgSetupAction.Request request) {
        if (OrgSetupDataOperationInstance == null) {
        	OrgSetupDataOperationInstance = new OrgSetupDataOperation(request);
        }
        return OrgSetupDataOperationInstance;
    }

    private OrgSetupDataOperation(OrgSetupAction.Request request) {
        this.request = request;
    }
    
    public OrgSetupDataResult isSetupComplete() {
        try {
            Org_Sample_Data_Resource__mdt sampleDataResource = 
                OrgSetupDataHelper.instance(request.staticResourceName, null).sampleDataResource;
            return new OrgSetupDataResult(sampleDataResource.Setup_Complete__c, null);
        } catch (Exception ex) {
            return new OrgSetupDataResult(false, ex.getMessage() + '\n' + ex.getStackTraceString());
        }
        
    }

    public OrgSetupDataResult toggleSetupComplete() {
        try {
            Org_Sample_Data_Resource__mdt sampleDataResource = 
                OrgSetupDataHelper.instance(request.staticResourceName, null).sampleDataResource;
            String jobId = CustomMetadata.Operations
                .callback(
                    // Simple callback that outputs to debug
                    new CustomMetadata.DebugCallback())                    
                .enqueueUpsertRecords(
                    // Custom Metadata object type
                    Org_Sample_Data_Resource__mdt.getSObjectType(), 
                    new List<Map<SObjectField, Object>> {
                        // Custom Metadata record 
                        new Map<SObjectField, Object> {
                            Org_Sample_Data_Resource__mdt.DeveloperName => sampleDataResource.DeveloperName,
                            Org_Sample_Data_Resource__mdt.Label => sampleDataResource.Label,
                            Org_Sample_Data_Resource__mdt.Setup_Complete__c => sampleDataResource.Setup_Complete__c == true ? false : true
                } } )
                .deployId;
        } catch (Exception ex) {
            return new OrgSetupDataResult(false, ex.getMessage() + '\n' + ex.getStackTraceString());
        }
        return new OrgSetupDataResult(true, null);
    }
    
    public OrgSetupDataResult purgeObjectList() {
        try {
            List<String> objectNames = new List<String>();
            List<Org_Sample_Data_SObject__mdt> sampleDataObjects = 
                OrgSetupDataHelper.instance(request.staticResourceName, OrgSetupDataHelper.OperationType.DELETE_DATA).sampleDataObjects;
            for (Org_Sample_Data_SObject__mdt sdo : sampleDataObjects) {
                objectNames.add('• ' + sdo.Label);
            }
            return new OrgSetupDataResult(true, String.join(objectNames, '\n'));
        } catch (exception ex) {
            return new OrgSetupDataResult(false, ex.getMessage() + '\n' + ex.getStackTraceString());
        }
    }

    /*
    public OrgSetupDataResult purgeObject() {
        try {
            String soql = 'SELECT Id FROM ' + request.objectName;
            List<SObject> records = Database.query(soql);            
            Database.deleteImmediate(records);        
            return new OrgSetupDataResult(true, request.objectName + ' data has been removed.');
        } catch (exception ex) {
            return new OrgSetupDataResult(false, ex.getMessage() + '\n' + ex.getStackTraceString());
        }
    }
    */
    
    public OrgSetupDataResult generateObjectList() {
        try {
            List<String> objectNames = new List<String>();
            List<Org_Sample_Data_SObject__mdt> sampleDataObjects = 
                OrgSetupDataHelper.instance(request.staticResourceName, OrgSetupDataHelper.OperationType.INSERT_DATA).sampleDataObjects;
            for (Org_Sample_Data_SObject__mdt sdo : sampleDataObjects) {
                objectNames.add('• ' + sdo.Label);
            }
            return new OrgSetupDataResult(true, String.join(objectNames, '\n'));
        } catch (exception ex) {
            return new OrgSetupDataResult(false, ex.getMessage() + '\n' + ex.getStackTraceString());
        }
    }

    /*
    public OrgSetupDataResult generateObject() {

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
                    return new OrgSetupDataResult(true, sObjType + ' data has been loaded.');
                } else {
                    return new OrgSetupDataResult(false, sObjType +  String.join(messages, '\n'));
                }
            } else {
                insert records;
                return new OrgSetupDataResult(true, sObjType + ' data has been loaded.');
            }
        } catch (exception ex) {
            return new OrgSetupDataResult(false, ex.getMessage() + '\n' + ex.getStackTraceString());
        }
    }
	*/
    
}