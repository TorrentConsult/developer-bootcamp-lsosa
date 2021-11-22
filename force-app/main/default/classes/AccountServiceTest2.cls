/* ------------ Used in Testing Apex Triggers Live Session ------------ */

@isTest
class AccountServiceTest2 {

    final static Integer PARENT_RECORD_COUNT = 200;

    @testSetup
    static void makeData() {
        //Step 1: Use @testSetup to create any dependent data
        List<Account> vendorParents = TestDataFactory.generateVendorParents(PARENT_RECORD_COUNT);
        insert vendorParents;
    }

    @isTest static void queryAccountsChildCounts_test() { 

        //Step 2: Get existing data and create new data as needed
        List<Account> vendorParents = [SELECT Id FROM Account WHERE RecordTypeId = :TestDataFactory.VENDOR_RECORDTYPE];

        //Create random number of child accounts for each parent account
        List<Account> vendorChildren = TestDataFactory.generateVendorChildren(vendorParents, 1, 3);
        Map<Id, Decimal> expectedCountbyParent = new Map<Id, Decimal>();
        for (Account a : vendorChildren) {
            expectedCountbyParent.put(
                a.ParentId, 
                expectedCountbyParent.containsKey(a.ParentId) ? expectedCountbyParent.get(a.ParentId) + 1 : 1
            );
        }

        //Bypass Trigger since it's not important for this test
        AccountTriggerHandler.bypassTrigger = true;
        insert vendorChildren;

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Call our Service Method to get Aggregate Results
        List<AggregateResult> aggregateResults = AccountService.queryAccountsChildCounts(expectedCountbyParent.keySet());
        System.debug(aggregateResults.size());

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();
        
        //Step 6: Assert our results are as expected
        System.assertEquals(PARENT_RECORD_COUNT, aggregateResults.size(), 'Parent record count should match');
        for (AggregateResult ar : aggregateResults) {
            System.assertEquals(
                expectedCountbyParent.get((Id)ar.get('ParentId')),     //Expected Result from Map
                (Decimal)ar.get('cnt'),                                //Actual Result from Query
                'Child record count should match'
            );
        }

    }


}