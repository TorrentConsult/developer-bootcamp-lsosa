/* ------------ Used in Testing Apex Triggers Live Session ------------ */

@isTest
class VendorOptionValidateServiceTest {

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

    @isTest static void getVendorAccountIds_test() {

        //Step 2: Get existing data and create new data as needed
        Map<Id, Account> vendorAccounts = new Map<Id, Account>([SELECT Id FROM Account WHERE RecordTypeId = :TestDataFactory.VENDOR_RECORDTYPE]);
        List<Wedding__c> weddings = [SELECT Id FROM Wedding__c];

        List<Vendor_Option__c> vendorOptions = TestDataFactory.generateVendorOptions(weddings, vendorAccounts.values());
        //Don't Insert Vendor Options - Not Necessary for Test

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Call our Service Method to get Vendor Account Ids
        Set<Id> vendorAccountIds = VendorOptionValidateService.getVendorAccountIds(vendorOptions);

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
        System.assertEquals(vendorAccounts.size(), vendorAccountIds.size(), 'Vendor Accounts size should match');
        for (Id vendorAccountId : vendorAccounts.keySet()) {
            System.assert(vendorAccountIds.contains(vendorAccountId), 'Vendor Account Id should be in set');
        }
    }

    @isTest static void getContactsByVendorAccount_hasContacts_test() {

        //Step 2: Get existing data and create new data as needed
        Map<Id, Account> vendorAccounts = new Map<Id, Account>([SELECT Id FROM Account WHERE RecordTypeId = :TestDataFactory.VENDOR_RECORDTYPE]);
        
        //Each Vendor Account should have between 1 and 3 Contacts
        List<Contact> contacts = TestDataFactory.generateContacts(vendorAccounts.values(), 1, 3);
        insert contacts;

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Call our Service Method to get Contacts by Vendor Account
        Map<Id, List<Contact>> contactsByVendorAccount = VendorOptionValidateService.getContactsByVendorAccount(vendorAccounts.keySet());
        
        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
        System.assertEquals(vendorAccounts.size(), contactsByVendorAccount.size(), 'Vendor Accounts size should match');
        for (Id vendorAccountId : contactsByVendorAccount.keySet()) {
            Integer contactsSize = contactsByVendorAccount.get(vendorAccountId).size();
            System.debug(contactsSize);
            System.assert(contactsSize >= 1 && contactsSize <= 3, 'Each Vendor Account should have between 1 and 3 Contacts');
        }
    }

    @isTest static void getContactsByVendorAccount_noContacts_test() {

        //Step 2: Get existing data and create new data as needed
        Map<Id, Account> vendorAccounts = new Map<Id, Account>([SELECT Id FROM Account WHERE RecordTypeId = :TestDataFactory.VENDOR_RECORDTYPE]);
        
        //No Contacts Inserted

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Call our Service Method to get Contacts by Vendor Account
        Map<Id, List<Contact>> contactsByVendorAccount = VendorOptionValidateService.getContactsByVendorAccount(vendorAccounts.keySet());
        
        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
        System.assertEquals(0, contactsByVendorAccount.size(), 'Vendor Accounts size should be 0');
    }

    @isTest static void validateVendorContacts_hasContacts_test() {

        //Step 2: Get existing data and create new data as needed
        Map<Id, Account> vendorAccounts = new Map<Id, Account>([SELECT Id FROM Account WHERE RecordTypeId = :TestDataFactory.VENDOR_RECORDTYPE]);
        List<Wedding__c> weddings = [SELECT Id FROM Wedding__c];

        //Each Vendor Account should have between 1 and 3 Contacts
        List<Contact> contacts = TestDataFactory.generateContacts(vendorAccounts.values(), 1, 3);
        insert contacts;

        List<Vendor_Option__c> vendorOptions = TestDataFactory.generateVendorOptions(weddings, vendorAccounts.values());
        //Don't Insert Vendor Options - Not Necessary for Test

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Call our Service Method to Validate Vendor has Related Contacts
        VendorOptionValidateService.validateVendorContacts(vendorOptions);

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
        for (Vendor_Option__c vo : vendorOptions) {
            System.assertEquals(false, vo.hasErrors(), 'Should not have an error');
        }
    }

    @isTest static void validateVendorContacts_noContacts_test() {

        //Step 2: Get existing data and create new data as needed
        Map<Id, Account> vendorAccounts = new Map<Id, Account>([SELECT Id FROM Account WHERE RecordTypeId = :TestDataFactory.VENDOR_RECORDTYPE]);
        List<Wedding__c> weddings = [SELECT Id FROM Wedding__c];

        //No Contacts Inserted

        List<Vendor_Option__c> vendorOptions = TestDataFactory.generateVendorOptions(weddings, vendorAccounts.values());
        //Don't Insert Vendor Options - Not Necessary for Test

        //Step 3: Run Test.startTest() to reset governor limits
        Test.startTest();

        //Step 4: Call our Service Method to Validate Vendor has no Related Contacts
        VendorOptionValidateService.validateVendorContacts(vendorOptions);

        //Step 5: Run Test.stopTest() to mark end of test
        Test.stopTest();

        //Step 6: Assert our results are as expected
        for (Vendor_Option__c vo : vendorOptions) {
            System.assertEquals(true, vo.hasErrors(), 'Should have an error');
            Database.Error err = vo.getErrors()[0];
            System.assert(err.getMessage().contains(VendorOptionValidateService.NOCONTACT_WEDDINGVENDOR_ERROR), 'Should contain error message');
        }
    }

}