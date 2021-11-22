/* ------------ Used in Writing Async Apex Live Session ------------ */

public with sharing class AsyncApexExampleQueueableChain implements Queueable {

    @TestVisible List<Account> accounts;
 
    public AsyncApexExampleQueueableChain(List<Account> accounts) {
        this.accounts = accounts;
    }
 
    public void execute(QueueableContext qc) {
        Set<Id> parentIds = new Set<Id>();
        for (Account acct : accounts) {
            System.debug('Account Name: ' + acct.Name);
            if (acct.ParentId != null) {
                parentIds.add(acct.ParentId);
            }
        }
        List<Account> parentAccounts = [SELECT Id, ParentId FROM Account WHERE Id IN :parentIds];
        Id jobId = System.enqueueJob(new AsyncApexExampleQueueableChain(parentAccounts));
    }
 
 }