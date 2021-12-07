/* ------------ Used in Writing Apex Triggers Live Session ------------ */

public with sharing class WeddingTriggerHandler {

    @TestVisible static Boolean bypassTrigger = false; 

    final List<Wedding__c> newRecords;
    final Map<Id, Wedding__c> oldMap;

    public WeddingTriggerHandler(List<Wedding__C> newRecords, Map<Id, Wedding__c> oldMap) {
        this.newRecords = newRecords;
        this.oldMap = oldMap;
    }


    public void afterInsert() {
        if (bypassTrigger) return;

        Set<Id> weddingIds = new Set<Id>();
        for (Wedding__c a : newRecords) {
            weddingIds.add(a.Id);
        }

        Set<Id> oppId=WeddingService.queryWeddingsOpportunities(weddingIds);

        if(oppId.size()>0)
        {

            WeddingService.inserDocumentIdPerWedding(weddingIds,oppId);
            WeddingService.updateTaskOpportunity(weddingIds,oppId);
            WeddingService.updateEventOpportunity(weddingIds,oppId);
        }

      

    }

    
    
}