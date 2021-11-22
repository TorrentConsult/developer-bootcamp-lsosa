/* ------------ Used in Writing Async Apex Live Session ------------ */

public with sharing class CaseStatusQueueableChain implements Queueable {

    @TestVisible Map<Id, String> caseIdToStatus;
 
    public CaseStatusQueueableChain(Map<Id, String> caseIdToStatus) {
        this.caseIdToStatus = caseIdToStatus;
    }
 
    public void execute(QueueableContext qc) {
        
        List<Case> cases = [SELECT Id, ParentId, Status FROM Case WHERE Id IN :caseIdToStatus.keySet()];
        
        Map<Id, String> parentIdToStatus = new Map<Id, String>();
        for (Case c : cases) {
            c.Status = caseIdToStatus.get(c.Id);
            parentIdToStatus.put(c.ParentId, caseIdToStatus.get(c.Id));
        }

        //Bypass Queueable from getting called from the Trigger a second time
        //Otherwise we will get a Queueable Job Error (Too many added to queue)
        CaseTriggerHandler.bypassQueueable = true;
        update cases;
        CaseTriggerHandler.bypassQueueable = false;


        if (!Test.isRunningTest() && !parentIdToStatus.isEmpty()) {
            Id jobId = System.enqueueJob(new CaseStatusQueueableChain(parentIdToStatus));
        }
    }

}