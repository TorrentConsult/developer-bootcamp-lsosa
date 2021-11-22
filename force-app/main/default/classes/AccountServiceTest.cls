/* ------------ Used in Testing Apex Triggers Live Session ------------ */

@isTest
class AccountServiceTest {

    final static Integer PARENT_RECORD_COUNT = 200;
    final static Id VENDOR_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Vendor').getRecordTypeId();

    @testSetup
    static void makeData() {
        //Step 1: Use @testSetup to create any dependent data
        List<Account> vendorAccounts = new List<Account>();
        for (Integer i=0; i<PARENT_RECORD_COUNT; i++) {
            vendorAccounts.add(
                new Account(
                    Name = 'Vendor Parent ' + i,
                    ParentId = null,
                    Number_of_Child_Accounts__c = 0,
                    RecordTypeId = VENDOR_RECORDTYPE
                )
            );
        }
        insert vendorAccounts;
    }

    @isTest static void queryAccountsChildCounts_test() { 

        //Step 2: Get existing data and create new data as needed
        List<Account> vendorParents = [SELECT Id FROM Account WHERE RecordTypeId = :VENDOR_RECORDTYPE];

        //Create random number of child accounts for each parent account
        List<Account> vendorChildren = new List<Account>();
        Map<Id, Decimal> expectedCountbyParent = new Map<Id, Decimal>();

        for (Integer i=0; i<vendorParents.size(); i++) {
            //Create random number of child accounts between 1 and 3
            Integer vendorChildrenize = Math.floor(Math.random() * 3 + 1).intValue();
            //Store expected number of child accounts per parent
            expectedCountbyParent.put(vendorParents[i].Id, vendorChildrenize);
            for (Integer j=0; j<vendorChildrenize; j++) {
                //Add to child account list
                vendorChildren.add(
                    new Account(
                        Name = 'Vendor Child ' + i,
                        ParentId = vendorParents[i].Id,
                        RecordTypeId = VENDOR_RECORDTYPE
                    )
                );
            }
        }
        //Bypass Trigger since it's not important for this test
        AccountTriggerHandler.bypassTrigger = true;
        insert vendorChildren;

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Call our Service Method to get Aggregate Results
        List<AggregateResult> aggregateResults = AccountService.queryAccountsChildCounts(expectedCountbyParent.keySet());

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