/* ------------ Used in Testing Apex Triggers Live Session ------------ */
/* ------------ Used in Writing Async Apex Live Session  ------------ */

@isTest
public with sharing class TestDataFactory {

    @TestVisible final Static Id VENDOR_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Vendor').getRecordTypeId();
    @TestVisible final Static Id CUSTOMER_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer_Household').getRecordTypeId();

    /* Testing Apex Triggers Live Session */
    public static List<Account> generateVendorParents(Integer recordCount) {
        List<Account> vendorParents = new List<Account>();
        for (Integer i=0; i<recordCount; i++) {
            vendorParents.add(
                new Account(
                    Name = 'Vendor Parent ' + i,
                    ParentId = null,
                    Number_of_Child_Accounts__c = 0,
                    RecordTypeId = VENDOR_RECORDTYPE
                )
            );
        }
        return vendorParents;
    }

    /* Testing Apex Triggers Live Session */
    public static List<Account> generateVendorChildren(List<Account> vendorParents, Integer min, Integer max) {
        List<Account> vendorChildren = new List<Account>();
        Integer vendorChildrenSize = Math.floor(Math.random() * (max - min + 1) + min).intValue();
        for (Integer i=0; i<vendorParents.size(); i++) {    
            for (Integer j=0; j<vendorChildrenSize; j++) {
                //Add to child account list
                vendorChildren.add(
                    new Account(
                        Name = 'Vendor Child ' + i + ':' + j,
                        ParentId = vendorParents[i].Id,
                        RecordTypeId = VENDOR_RECORDTYPE
                    )
                );
            }
        }
        return vendorChildren;
    }

    /* Testing Apex Triggers Live Session */
    public static List<Account> generateCustomerAccounts(Integer recordCount) {
        List<Account> customerAccounts = new List<Account>();
        for (Integer i=0; i<recordCount; i++) {
            customerAccounts.add(
                new Account(
                    Name = 'Customer Account ' + i,
                    RecordTypeId = CUSTOMER_RECORDTYPE
                )
            );
        }
        return customerAccounts;
    }

    /* Testing Apex Triggers Live Session */
    public static List<Wedding__c> generateWeddings(List<Account> customerAccounts) {
        List<Wedding__c> weddings = new List<Wedding__c>();
        for (Integer i=0; i<customerAccounts.size(); i++) {    
            //Add to contacts list
            weddings.add(
                new Wedding__c(
                    Name = 'Wedding ' + i,
                    Wedding_Account__c = customerAccounts[i].Id,
                    Wedding_City__c = 'Ann Arbor',
                    Name_of_Wedding_Financier__c = 'None',
                    Budget__c = 20000,
                    Start_Date__c = Date.today() + 365
                )
            );
        }
        return weddings;
    }

    /* Testing Apex Triggers Live Session */
    public static List<Contact> generateContacts(List<Account> accounts, Integer min, Integer max) {
        List<Contact> contacts = new List<Contact>();
        Integer contactsSize = Math.floor(Math.random() * (max - min + 1) + min).intValue();
        for (Integer i=0; i<accounts.size(); i++) {    
            for (Integer j=0; j<contactsSize; j++) {
                //Add to contacts list
                contacts.add(
                    new Contact(
                        LastName = 'Contact ' + i + ':' + j,
                        AccountId = accounts[i].Id,
                        Email = 'noreply@torrentconsulting.com.' + i + '.invalid',
                        Role_in_Wedding__c = 'Other'
                    )
                );
            }
        }
        return contacts;
    }

    /* Testing Apex Triggers Live Session */
    public static List<Vendor_Option__c> generateVendorOptions(List<Wedding__c> weddings, List<Account> vendorAccounts) {
        List<Vendor_Option__c> vendorOptions = new List<Vendor_Option__c>();
        for (Integer i=0; i<weddings.size(); i++) {    
            for (Integer j=0; j<vendorAccounts.size(); j++) {
                //Add to contacts list
                vendorOptions.add(
                    new Vendor_Option__c(
                        Wedding__c = weddings[i].Id,
                        Vendor_Account__c = vendorAccounts[j].Id,
                        Vendor_Status__c = null //We'll set this in our individual test classes
                    )
                );
            }
        }
        return vendorOptions;
    }

    /* Writing Async Apex Live Session */
    public static List<Opportunity> generateOpportunities(List<Account> customerAccounts) {
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i=0; i<customerAccounts.size(); i++) {    
            //Add to contacts list
            opportunities.add(
                new Opportunity(
                    Name = 'Opportunity ' + i,
                    AccountId = customerAccounts[i].Id,
                    LeadSource = 'Website',
                    Maximum_Budget__c = '$10k - $25k',
                    Wedding_City__c = 'Ann Arbor',
                    CloseDate = Date.today() + 30,
                    Wedding_Date__c = Date.today() + 365,
                    StageName = 'New'
                )
            );
        }
        return opportunities;
    }

}