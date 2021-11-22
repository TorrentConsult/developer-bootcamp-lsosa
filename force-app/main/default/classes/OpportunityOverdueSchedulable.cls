/* ------------ Used in Writing Async Apex Live Session ------------ */

public with sharing class OpportunityOverdueSchedulable implements Schedulable {

    //Runs Every Day at 11PM
    @TestVisible final static String CRON_EXP = '0 0 23 * * ?';

    public void execute(SchedulableContext sc) {

        Id jobId = Database.executeBatch(new OpportunityOverdueBatchable(), 200);

    }

     public static Id scheduleIt() {

        return System.schedule('Overdue Opportunities Batch', CRON_EXP, new OpportunityOverdueSchedulable());

    }

}