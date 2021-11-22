/* ------------ Used in Writing Apex Triggers Live Session ------------ */

public with sharing class AccountTriggerHandler {

    @TestVisible static Boolean bypassTrigger = false; 

    final List<Account> newRecords;
    final Map<Id, Account> oldMap;

    public AccountTriggerHandler(List<Account> newRecords, Map<Id, Account> oldMap) {
        this.newRecords = newRecords;
        this.oldMap = oldMap;
    }

    /* 
     * Collect Parent Account Ids of new records that are non-null
     * Call Method to calculate Child Counts
	*/
    public void afterInsert() {
        if (bypassTrigger) return;

        Set<Id> parentAccountIds = new Set<Id>();
        for (Account a : newRecords) {
            if (a.ParentId != null) {
                parentAccountIds.add(a.ParentId);
            }
        }
        AccountService.updateAccountChildCounts(parentAccountIds);
    }
    
    
    /* 
     * Collect Parent Account Ids of records that have been updated
     * 		Include Previous Parent Account Id if it is non-null
     * 		Include Current Parent Account Id if it is non-null 
     * Call Method to calculate Child Counts
	*/
    public void afterUpdate() {
        if (bypassTrigger) return;

        Set<Id> parentAccountIds = new Set<Id>();
        for (Account a : newRecords) {
            if (a.ParentId != oldMap.get(a.Id).ParentId) {
                if (a.ParentId != null) {
                	parentAccountIds.add(a.ParentId);
                }
                if (oldMap.get(a.Id).ParentId != null) {
                	parentAccountIds.add(oldMap.get(a.Id).ParentId);
                }                
            }
        }
        AccountService.updateAccountChildCounts(parentAccountIds);
    }

    
    /* 
     * Collect Parent Account Ids of deleted records that were non-null
     * Call Method to calculate Child Counts
	*/
    public void afterDelete() {
        if (bypassTrigger) return;

        Set<Id> parentAccountIds = new Set<Id>();
        for (Account a : oldMap.values()) {
            if (a.ParentId != null) {
                parentAccountIds.add(a.ParentId);
            } 
        }
        AccountService.updateAccountChildCounts(parentAccountIds);
    }
    
    /* 
     * Collect Parent Account Ids of undeleted records that are non-null
     * Call Method to calculate Child Counts
	*/
    public void afterUndelete() {
        if (bypassTrigger) return;

        Set<Id> parentAccountIds = new Set<Id>();
        for (Account a : newRecords) {
            if (a.ParentId != null) {
                parentAccountIds.add(a.ParentId);
            }
        }
        AccountService.updateAccountChildCounts(parentAccountIds);
    }
    
}