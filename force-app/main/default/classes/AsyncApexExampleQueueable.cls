/* ------------ Used in Writing Async Apex Live Session ------------ */

public with sharing class AsyncApexExampleQueueable implements Queueable {

    @TestVisible List<Account> accounts;
 
    public AsyncApexExampleQueueable(List<Account> accounts) {
        this.accounts = accounts;
    }
 
    public void execute(QueueableContext qc) {
        for (Account acct : accounts) {
            System.debug('Account Name: ' + acct.Name);
        }
    }
 
 }