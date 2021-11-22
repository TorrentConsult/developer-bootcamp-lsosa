/* ------------ Used in Testing Apex Triggers Live Session ------------ */

@isTest
class AccountTriggerHandlerTest {

    final static Integer PARENT_RECORD_COUNT = 200;
    final Static Id VENDOR_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Vendor').getRecordTypeId();

    @testSetup
    static void makeData() {
        //Step 1: Use @testSetup to create any dependent data
        List<Account> vendorParents = new List<Account>();
        for (Integer i=0; i<PARENT_RECORD_COUNT; i++) {
            vendorParents.add(
                new Account(
                    Name = 'Vendor Parent ' + i,
                    ParentId = null,
                    Number_of_Child_Accounts__c = 0,
                    RecordTypeId = VENDOR_RECORDTYPE
                )
            );
        }
        insert vendorParents;
    }

    @isTest static void afterInsert_setParent() {    //Test Scenario 1

        //Step 2: Get existing data and create new data as needed
        List<Account> vendorParents = [SELECT Id FROM Account WHERE RecordTypeId = :VENDOR_RECORDTYPE];

        //Create random number of child accounts for each parent account
        List<Account> vendorChildren = new List<Account>();
        Map<Id, Decimal> expectedCountbyParent = new Map<Id, Decimal>();

        for (Integer i=0; i<vendorParents.size(); i++) {
            //Create random number of child accounts between 1 and 3 (https://stackoverflow.com/a/7228322)
            Integer vendorChildrenize = Math.floor(Math.random() * 3 + 1).intValue();
            //Store expected number of child accounts per parent
            expectedCountbyParent.put(vendorParents[i].Id, vendorChildrenize);
            for (Integer j=0; j<vendorChildrenize; j++) {
                //Add to child account list but don't insert yet
                vendorChildren.add(
                    new Account(
                        Name = 'Vendor Child ' + i,
                        ParentId = vendorParents[i].Id,
                        RecordTypeId = VENDOR_RECORDTYPE
                    )
                );
            }
        }

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Insert records to test our logic
        insert vendorChildren;

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
    	List<Account> requeryVendorParents = [
            SELECT Id, Number_of_Child_Accounts__c
            FROM Account
            WHERE Id IN: vendorParents
        ];
        System.assertEquals(PARENT_RECORD_COUNT, requeryVendorParents.size(), 'Parent record count should match');
        for (Account a : requeryVendorParents) {
            System.assertEquals(
                expectedCountbyParent.get(a.Id),     //Expected Result from Map
                a.Number_of_Child_Accounts__c,       //Actual Result from Query
                'Child record count should match'
            );
        }

    }

    @isTest static void afterInsert_noParent() {     //Test Scenario 10

        //Step 2: Get existing data and create new data as needed
        List<Account> vendorParents = [SELECT Id FROM Account WHERE RecordTypeId = :VENDOR_RECORDTYPE];

        //Create a child account but don't set a ParentId
        List<Account> vendorChildren = new List<Account>();
        for (Integer i=0; i<vendorParents.size(); i++) {
            //Add to child account list but don't insert yet
            vendorChildren.add(
                new Account(
                    Name = 'Vendor Child ' + i,
                    ParentId = null,
                    RecordTypeId = VENDOR_RECORDTYPE
                )
            );
        }

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Insert records to test our logic
        insert vendorChildren;

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
    	List<Account> requeryVendorParents = [
            SELECT Id, Number_of_Child_Accounts__c
            FROM Account
            WHERE Id IN: vendorParents
        ];
        System.assertEquals(PARENT_RECORD_COUNT, requeryVendorParents.size(), 'Parent record count should match');
        for (Account a : requeryVendorParents) {
            System.assertEquals(
                0,                                  //Expected Result is 0
                a.Number_of_Child_Accounts__c,      //Actual Result from Query
                'Child record count should be 0'
            );
        }

    }

    @isTest static void afterUpdate_changedOldNewParent() {    //Test Scenario 2

        //Step 2: Get existing data and create new data as needed
        List<Account> vendorParents = [SELECT Id FROM Account WHERE RecordTypeId = :VENDOR_RECORDTYPE];

        //Create random number of child accounts for each initial parent account
        List<Account> vendorChildren = new List<Account>();
        Map<Id, Decimal> expectedCountbyParent = new Map<Id, Decimal>();

        //Use the first half of the parent account list - 0 to 99 to set initial parent
        for (Integer i=0; i<(vendorParents.size() / 2); i++) {     
            //These will get reparented so set expected count to 0
            expectedCountbyParent.put(vendorParents[i].Id, 0);
            //Create random number of child accounts between 1 and 3
            Integer vendorChildrenize = Math.floor(Math.random() * 3 + 1).intValue();
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
        //Need to insert child accounts with initial parent ids
        insert vendorChildren;

        //Loop through child accounts and assign to new parent
        for (Account a : vendorChildren) { 
            //Generate random number from 100 to 199 - second half of parent account list
            Integer randomParentAccountIndex = Math.floor(Math.random() * 100).intValue() + 99;
            a.ParentId = vendorParents[randomParentAccountIndex].Id;
            expectedCountbyParent.put(
                a.ParentId,
                expectedCountbyParent.containsKey(a.ParentId) ? expectedCountbyParent.get(a.ParentId) + 1 : 1
            );
        }

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Update records to test our logic
        update vendorChildren;

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
    	List<Account> requeryvendorParents = [
            SELECT Id, Number_of_Child_Accounts__c
            FROM Account
            WHERE Id IN: vendorParents
        ];
        System.assertEquals(PARENT_RECORD_COUNT, requeryVendorParents.size(), 'Parent record count should match');
        for (Account a : requeryVendorParents) {
            System.assertEquals(
                expectedCountbyParent.containsKey(a.Id) ? expectedCountbyParent.get(a.Id) : 0,    //Expected Result from Map
                a.Number_of_Child_Accounts__c,                                                    //Actual Result from Query
                'Child record count should match'
            );
        }

    }

    @isTest static void afterUndelete() {        //Test Scenario 7

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
                //Add to child account list but don't insert yet
                vendorChildren.add(
                    new Account(
                        Name = 'Vendor Child ' + i,
                        ParentId = vendorParents[i].Id,
                        RecordTypeId = VENDOR_RECORDTYPE
                    )
                );
            }
        }
        //Let's insert records and then immediately delete
        insert vendorChildren;
        delete vendorChildren;   

        //Requery the parent records to make sure counts were set back to 0
        List<Account> requeryVendorParents = [
            SELECT Id, Number_of_Child_Accounts__c
            FROM Account
            WHERE Id IN: vendorParents
        ];
        for (Account a : requeryVendorParents) {
            System.assertEquals(
                0,                                  //Expected Result is 0
                a.Number_of_Child_Accounts__c,      //Actual Result from Query
                'Child record count should be 0'
            );
        }        

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Undelete records to test our logic
        undelete vendorChildren;

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
    	List<Account> requeryVendorParents2 = [
            SELECT Id, Number_of_Child_Accounts__c
            FROM Account
            WHERE Id IN: vendorParents
        ];
        System.assertEquals(PARENT_RECORD_COUNT, requeryVendorParents2.size(), 'Parent record count should match');
        for (Account a : requeryVendorParents2) {
            System.assertEquals(
                expectedCountbyParent.get(a.Id),    //Expected Result from Map
                a.Number_of_Child_Accounts__c,      //Actual Result from Query
                'Child record count should match'
            );
        }

    }

    @isTest static void afterUpdate_mergedParents() {    //Test Scenario 8

        final Integer MERGE_COUNT = 10;

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
                //Add to child account list but don't insert yet
                vendorChildren.add(
                    new Account(
                        Name = 'Vendor Child ' + i,
                        ParentId = vendorParents[i].Id,
                        RecordTypeId = VENDOR_RECORDTYPE
                    )
                );
            }
        }

        //Insert child accounts prior to merge
        insert vendorChildren;

        //Add Counts from Merge Accounts to Master Accounts
        for (Integer i=0; i<MERGE_COUNT; i++) {     
            Account masterAccount = vendorParents[i];
            Account mergeAccount = vendorParents[i + 100];

            //Add Master and Merge Child Counts to Master Account
            expectedCountbyParent.put(masterAccount.Id, 
                expectedCountbyParent.get(masterAccount.Id) + expectedCountbyParent.get(mergeAccount.Id));

            //Set Merge Child Counts to 0
            expectedCountbyParent.put(mergeAccount.Id, 0);
        }

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Merge records to test our logic
        for (Integer i=0; i<MERGE_COUNT; i++) {     
            //Generally you don't want to perform DML operation in bulk
            //Can't perform a merge operation on a list of records
            merge vendorParents[i] vendorParents[i + 100];
        }

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
    	List<Account> requeryVendorParents = [
            SELECT Id, Number_of_Child_Accounts__c
            FROM Account
            WHERE Id IN: vendorParents
        ];
        System.assertEquals(PARENT_RECORD_COUNT - MERGE_COUNT, requeryVendorParents.size(), 'Parent record count should match');
        for (Account a : requeryVendorParents) {
            System.assertEquals(
                expectedCountbyParent.get(a.Id),        //Expected Result from Map
                a.Number_of_Child_Accounts__c,          //Actual Result from Query
                'Child record count should match'
            );
        }

    }

}