/* ------------ Used in Writing Async Apex Live Session ------------ */

@isTest
class OpportunityOverdueBatchableTest {

    final static Integer CUSTOMER_RECORD_COUNT = 200;

    @testSetup
    static void makeData() {
        List<Account> customerAccounts = TestDataFactory.generateCustomerAccounts(CUSTOMER_RECORD_COUNT);
        insert customerAccounts;

        List<Opportunity> opportunities = TestDataFactory.generateOpportunities(customerAccounts);
        for (Integer i=0; i<opportunities.size(); i++) {
            if (Math.mod(i, 2) == 0) {      //Make half of the Opportunities overdue
                opportunities[i].CloseDate = Date.today().addDays(-1);
            }
        }
        insert opportunities;
    }

    @isTest static void batch_test() {

        List<Opportunity> overdueOpportunities = [SELECT Id FROM Opportunity WHERE CloseDate = YESTERDAY];

        Test.startTest();

        OpportunityOverdueBatchable job = new OpportunityOverdueBatchable();
        Id jobId = Database.executeBatch(job, 200);

        Test.stopTest();

        List<Task> tasks = [SELECT Id, WhatId FROM Task WHERE WhatId IN :overdueOpportunities];
        System.assertEquals(overdueOpportunities.size(), tasks.size(), 'There should be one task for each overdue opportunity');
    }

}