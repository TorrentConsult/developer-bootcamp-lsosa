/* ------------ Used in Writing Async Apex Live Session ------------ */

public with sharing class AsyncApexExampleBatchable implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug(bc.getJobId() + ' job has started');
        return Database.getQueryLocator('SELECT Id, Name FROM Account');
    }

     public void execute(Database.BatchableContext bc, List<SObject> scope) { 
        List<Task> tasks = new List<Task>();
        for (Account acct : (List<Account>)scope) {
            System.debug('Account Name: ' + acct.Name);
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug(bc.getJobId() + ' job has finished');
    }

}