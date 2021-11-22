/* ------------ Used in Testing Apex Triggers Live Session ------------ */

@isTest
class VendorOptionTriggerHandlerTest {

    //Setting Counts to 10 since Vendor Options will be 10*10
    final static Integer VENDOR_RECORD_COUNT = 10;
    final static Integer CUSTOMER_RECORD_COUNT = 10;

    @testSetup
    static void makeData() {

        //Step 1: Use @testSetup to create any dependent data
        List<Account> vendorAccounts = TestDataFactory.generateVendorParents(VENDOR_RECORD_COUNT);
        insert vendorAccounts;

        List<Account> customerAccounts = TestDataFactory.generateCustomerAccounts(CUSTOMER_RECORD_COUNT);
        insert customerAccounts;

        List<Wedding__c> weddings = TestDataFactory.generateWeddings(customerAccounts);
        insert weddings;

    }

    @isTest static void beforeInsert_hasContacts_setSelected() { //Test Scenario 1 - Positive Test

        //Step 2: Get existing data and create new data as needed
        Map<Id, Account> vendorAccounts = new Map<Id, Account>([SELECT Id FROM Account WHERE RecordTypeId = :TestDataFactory.VENDOR_RECORDTYPE]);
        List<Wedding__c> weddings = [SELECT Id FROM Wedding__c];

        //Each Vendor Account should have between 1 and 3 Contacts
        List<Contact> contacts = TestDataFactory.generateContacts(vendorAccounts.values(), 1, 3);
        insert contacts;

        //Generate Vendor Options and set Status to Selected
        List<Vendor_Option__c> vendorOptions = TestDataFactory.generateVendorOptions(weddings, vendorAccounts.values());
        for (Vendor_Option__c vo : vendorOptions) {
            vo.Vendor_Status__c = 'Selected';
        }

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Call our Service Method to Validate Vendor has Related Contacts
        try {
            insert vendorOptions;
        } catch (Exception ex) {
            System.assert(false, 'Should not throw an error');
        }

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
        List<Vendor_Option__c> requeryVendorOptions = [SELECT Id FROM Vendor_Option__c WHERE Id IN :vendorOptions];
        System.assertEquals(vendorOptions.size(), requeryVendorOptions.size(), 'Vendor Option counts should match.'); 

    }

    @isTest static void beforeInsert_noContacts_setSelected() { //Test Scenario 1 - Negative Test

        //Step 2: Get existing data and create new data as needed
        Map<Id, Account> vendorAccounts = new Map<Id, Account>([SELECT Id FROM Account WHERE RecordTypeId = :TestDataFactory.VENDOR_RECORDTYPE]);
        List<Wedding__c> weddings = [SELECT Id FROM Wedding__c];

        //No Contacts Inserted

        //Generate Vendor Options and set Status to Selected
        List<Vendor_Option__c> vendorOptions = TestDataFactory.generateVendorOptions(weddings, vendorAccounts.values());
        for (Vendor_Option__c vo : vendorOptions) {
            vo.Vendor_Status__c = 'Selected';
        }

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Call our Service Method to Validate Vendor has no Related Contacts
        try {
            insert vendorOptions;
            System.assert(false, 'Should throw an error and not reach this point');
        } catch (Exception ex) {
            System.assert(true, 'Should throw an error');
        }

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
        List<Vendor_Option__c> requeryVendorOptions = [SELECT Id FROM Vendor_Option__c WHERE Id IN :vendorOptions];
        System.assertEquals(0, requeryVendorOptions.size(), 'Vendor Options should not be returned.'); 

    }

    @isTest static void beforeUpdate_hasContacts_setSelected() { //Test Scenario 2 - Positive Test

        //Step 2: Get existing data and create new data as needed
        Map<Id, Account> vendorAccounts = new Map<Id, Account>([SELECT Id FROM Account WHERE RecordTypeId = :TestDataFactory.VENDOR_RECORDTYPE]);
        List<Wedding__c> weddings = [SELECT Id FROM Wedding__c];

        //Each Vendor Account should have between 1 and 3 Contacts
        List<Contact> contacts = TestDataFactory.generateContacts(vendorAccounts.values(), 1, 3);
        insert contacts;

        //Generate Vendor Options and set Status to Prospective
        List<Vendor_Option__c> vendorOptions = TestDataFactory.generateVendorOptions(weddings, vendorAccounts.values());
        for (Vendor_Option__c vo : vendorOptions) {
            vo.Vendor_Status__c = 'Prospective';
        }

        //Turn trigger off before inserting records since this is an Update test
        VendorOptionTriggerHandler.bypassTrigger = true;
        insert vendorOptions;
        VendorOptionTriggerHandler.bypassTrigger = false;

        //Update Vendor Options and set Status to Selected
        for (Vendor_Option__c vo : vendorOptions) {
            vo.Vendor_Status__c = 'Selected';
        }

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Call our Service Method to Validate Vendor has Related Contacts
        try {
            update vendorOptions;
        } catch (Exception ex) {
            System.assert(false, 'Should not throw an error');
        }

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
        List<Vendor_Option__c> requeryVendorOptions = [SELECT Id FROM Vendor_Option__c WHERE Id IN :vendorOptions AND Vendor_Status__c = 'Selected'];
        System.assertEquals(vendorOptions.size(), requeryVendorOptions.size(), 'Vendor Option counts should match.'); 

    }

    @isTest static void beforeUpdate_noContacts_setSelected() { //Test Scenario 2 - Negative Test

        //Step 2: Get existing data and create new data as needed
        Map<Id, Account> vendorAccounts = new Map<Id, Account>([SELECT Id FROM Account WHERE RecordTypeId = :TestDataFactory.VENDOR_RECORDTYPE]);
        List<Wedding__c> weddings = [SELECT Id FROM Wedding__c];

        //No Contacts Inserted

        //Generate Vendor Options and set Status to Prospective
        List<Vendor_Option__c> vendorOptions = TestDataFactory.generateVendorOptions(weddings, vendorAccounts.values());
        for (Vendor_Option__c vo : vendorOptions) {
            vo.Vendor_Status__c = 'Prospective';
        }

        //Turn trigger off before inserting records since this is an Update test
        VendorOptionTriggerHandler.bypassTrigger = true;
        insert vendorOptions;
        VendorOptionTriggerHandler.bypassTrigger = false;

        //Update Vendor Options and set Status to Selected
        for (Vendor_Option__c vo : vendorOptions) {
            vo.Vendor_Status__c = 'Selected';
        }

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Call our Service Method to Validate Vendor has no Related Contacts
        try {
            insert vendorOptions;
            System.assert(false, 'Should throw an error and not reach this point');
        } catch (Exception ex) {
            System.assert(true, 'Should throw an error');
        }

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
        List<Vendor_Option__c> requeryVendorOptions = [SELECT Id FROM Vendor_Option__c WHERE Id IN :vendorOptions AND Vendor_Status__c = 'Selected'];
        System.assertEquals(0, requeryVendorOptions.size(), 'Vendor Options should not be returned.'); 

    }

    @isTest static void beforeUpdate_hasContacts_reparented() { //Test Scenario 4 - Positive Test

        //Step 2: Get existing data and create new data as needed
        Map<Id, Account> vendorAccounts = new Map<Id, Account>([SELECT Id FROM Account WHERE RecordTypeId = :TestDataFactory.VENDOR_RECORDTYPE]);
        List<Wedding__c> weddings = [SELECT Id FROM Wedding__c];

        //Each Vendor Account should have between 1 and 3 Contacts
        List<Contact> contacts = TestDataFactory.generateContacts(vendorAccounts.values(), 1, 3);
        insert contacts;

        //Generate Vendor Options for the First Vendor and set Status to Selected
        List<Vendor_Option__c> vendorOptions = TestDataFactory.generateVendorOptions(weddings, new List<Account>{vendorAccounts.values()[0]});
        for (Vendor_Option__c vo : vendorOptions) {
            vo.Vendor_Status__c = 'Selected';
        }

        //Turn trigger off before inserting records since this is an Update test
        VendorOptionTriggerHandler.bypassTrigger = true;
        insert vendorOptions;
        VendorOptionTriggerHandler.bypassTrigger = false;

        //Update Vendor Options to new Vendor Account Parent
        for (Vendor_Option__c vo : vendorOptions) {
            vo.Vendor_Account__c = vendorAccounts.values()[1].Id;
        }

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Call our Service Method to Validate Vendor has Related Contacts
        try {
            update vendorOptions;
        } catch (Exception ex) {
            System.assert(false, 'Should not throw an error');
        }

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
        List<Vendor_Option__c> requeryVendorOptions = [SELECT Id FROM Vendor_Option__c WHERE Id IN :vendorOptions AND Vendor_Account__c = :vendorAccounts.values()[1].Id];
        System.assertEquals(vendorOptions.size(), requeryVendorOptions.size(), 'Vendor Options should all be reparented'); 

    }

    @isTest static void beforeUpdate_noContacts_reparented() { //Test Scenario 4 - Negative Test

        //Step 2: Get existing data and create new data as needed
        Map<Id, Account> vendorAccounts = new Map<Id, Account>([SELECT Id FROM Account WHERE RecordTypeId = :TestDataFactory.VENDOR_RECORDTYPE]);
        List<Wedding__c> weddings = [SELECT Id FROM Wedding__c];

        //Only First Vendor Account should have between 1 and 3 Contacts
        List<Contact> contacts = TestDataFactory.generateContacts(new List<Account>{vendorAccounts.values()[0]}, 1, 3);
        insert contacts;

        //Generate Vendor Options for the First Vendor and set Status to Selected
        List<Vendor_Option__c> vendorOptions = TestDataFactory.generateVendorOptions(weddings, new List<Account>{vendorAccounts.values()[0]});
        for (Vendor_Option__c vo : vendorOptions) {
            vo.Vendor_Status__c = 'Selected';
        }

        //Turn trigger off before inserting records since this is an Update test
        VendorOptionTriggerHandler.bypassTrigger = true;
        insert vendorOptions;
        VendorOptionTriggerHandler.bypassTrigger = false;

        //Update Vendor Options to new Vendor Account Parent
        for (Vendor_Option__c vo : vendorOptions) {
            vo.Vendor_Account__c = vendorAccounts.values()[1].Id;
        }

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Call our Service Method to Validate Vendor has no Related Contacts
        try {
            insert vendorOptions;
            System.assert(false, 'Should throw an error and not reach this point');
        } catch (Exception ex) {
            System.assert(true, 'Should throw an error');
        }
        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
        List<Vendor_Option__c> requeryVendorOptions = [SELECT Id FROM Vendor_Option__c WHERE Id IN :vendorOptions AND Vendor_Account__c = :vendorAccounts.values()[1].Id];
        System.assertEquals(0, requeryVendorOptions.size(), 'Vendor Options should not be reparented'); 

    }

}