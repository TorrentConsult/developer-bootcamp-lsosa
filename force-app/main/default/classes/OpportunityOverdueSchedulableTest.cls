/* ------------ Used in Writing Async Apex Live Session ------------ */

@isTest
class OpportunityOverdueSchedulableTest {

    @isTest static void execute_test() {
        Test.startTest();

        OpportunityOverdueSchedulable job = new OpportunityOverdueSchedulable();
        Id jobId = System.schedule('OpportunityOverdueSchedulableTest', OpportunityOverdueSchedulable.CRON_EXP, job);

        Test.stopTest();

        System.assertNotEquals(null, jobId, 'Should return a Scheduled Job Id');
    }

    @isTest static void scheduleIt_test() {
        Test.startTest();

        Id jobId = OpportunityOverdueSchedulable.scheduleIt();

        Test.stopTest();

        System.assertNotEquals(null, jobId, 'Should return a Scheduled Job Id');
    }

}