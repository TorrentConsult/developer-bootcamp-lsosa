/* ------------ Used in Writing Async Apex Live Session ------------ */

public with sharing class CaseTriggerHandler {

    @TestVisible static Boolean bypassTrigger = false; 
    public static Boolean bypassQueueable = false;

    final List<Case> newRecords;
    final Map<Id, Case> oldMap;

    public CaseTriggerHandler(List<Case> newRecords, Map<Id, Case> oldMap) {
        this.newRecords = newRecords;
        this.oldMap = oldMap;
    }

    public void afterUpdate() {
        if (bypassTrigger || bypassQueueable) return;

        Map<Id, String> parentIdToStatus = new Map<Id, String>();
        for (Case c : newRecords) {
            if (c.ParentId != null && c.Status != oldMap.get(c.Id).Status) {
                parentIdToStatus.put(c.ParentId, c.Status);         
            }
        }
        Id jobId = System.enqueueJob(new CaseStatusQueueableChain(parentIdToStatus));
    }

}