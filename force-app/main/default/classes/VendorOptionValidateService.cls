/* ------------ Used in Writing Apex Triggers Live Session ------------ */

public with sharing class VendorOptionValidateService {

    @TestVisible final static String NOCONTACT_WEDDINGVENDOR_ERROR = System.Label.No_Contact_Wedding_Vendor_Error;

    /* 
     * Contradicts Salesforce best practices including Query in Loop 
     *   and hard-coding User-displayed messages
    */    
    public static void validateVendorContactsBad(List<Vendor_Option__c> vendorOptions) {
        for (Vendor_Option__c vo : vendorOptions) {
            List<Contact> contacts = [SELECT Id, AccountId 
                                    FROM Contact 
                                    WHERE AccountId = :vo.Vendor_Account__c];
            if (contacts.isEmpty()) {
                vo.addError('The Vendor Account must have at least one related Contact');
            }
        }
    }


    /* 
     * For Vendors with Vendor Status as Selected, add an error if there  
     *   are no related Contacts associated with the Vendor Account
    */
    public static void validateVendorContacts(List<Vendor_Option__c> vendorOptions) {

        if (vendorOptions.isEmpty()) return;   

        Set<Id> vendorAccountIds = getVendorAccountIds(vendorOptions);
        Map<Id, List<Contact>> contactsByVendorAccount = getContactsByVendorAccount(vendorAccountIds);
        
        for (Vendor_Option__c vo : vendorOptions) {
            if (!contactsByVendorAccount.containsKey(vo.Vendor_Account__c)) {
                vo.addError(NOCONTACT_WEDDINGVENDOR_ERROR);
            }
        }

    }

    /* 
     * Gather all the Vendor Accounts Ids from the Vendor Options
    */
    @TestVisible static Set<Id> getVendorAccountIds(List<Vendor_Option__c> vendorOptions) {

        Set<Id> vendorAccountIds = new Set<Id>();
        for (Vendor_Option__c vo: vendorOptions) {
            vendorAccountIds.add(vo.Vendor_Account__c);
        }
        return vendorAccountIds;

    }

    /* 
     *  For each Vendor Account, get the associated Related Contacts
    */
    @TestVisible static Map<Id, List<Contact>> getContactsByVendorAccount(Set<Id> vendorAccountIds) {

        Map<Id, List<Contact>> contactsByVendorAccount = new Map<Id, List<Contact>>();
        List<Contact> contacts = [SELECT Id, AccountId 
                                    FROM Contact 
                                    WHERE AccountId IN :vendorAccountIds];
        for (Contact c : contacts) {
            List<Contact> vendorContacts = 
                contactsByVendorAccount.containsKey(c.AccountId) ?
                contactsByVendorAccount.get(c.AccountId) :
                new List<Contact>();
            vendorContacts.add(c);
            contactsByVendorAccount.put(c.AccountId, vendorContacts);
        }
        return contactsByVendorAccount;

    }

}