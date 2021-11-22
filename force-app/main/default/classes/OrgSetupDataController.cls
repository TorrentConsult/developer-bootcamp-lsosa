public class OrgSetupDataController {

    @AuraEnabled
    public static void executeAction(String requestMethod, String staticResourceName, DateTime staticResourceDateTime, String objectName, String fileName) {
        OrgSetupAction.Request request = new OrgSetupAction.Request();
        request.requestMethod = requestMethod;
        request.staticResourceName = staticResourceName;
        request.staticResourceDateTime = staticResourceDateTime;
        request.objectName = objectName;
        request.fileName = fileName;
        
        publishPlatformEvent(requestMethod, objectName, true, 'Job has been queued...');
        
        OrgSetupDataQueueable job = new OrgSetupDataQueueable(request);
        Id jobId = System.enqueueJob(job);
    }
        
    @TestVisible static void publishPlatformEvent(String requestMethod, String objectName, Boolean success, String message) {
        Sample_Data_Load__e evt = new Sample_Data_Load__e(
            Message__c = message,
            Request_Method__c = requestMethod,
            Object__c = objectName,
            Success__c = success
        );
        EventBus.publish(evt);
    }
    
}