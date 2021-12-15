/* ------------ Used in Testing Apex Triggers Live Session ------------ */
/* ------------ Used in Writing Async Apex Live Session  ------------ */


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

    public static List<Invitation__c> generateWeddingInvitation(List<Wedding__c> weddingList, Integer recordCount) {
        
        List<Invitation__c> invitations = new List<Invitation__c>();
        for (Wedding__c wedding : weddingList) {
            for (Integer i = 0; i < recordCount; i++) {
                invitations.add(new Invitation__c(
                    Invitee_First_Name__c = 'First Name' + i,
                    Invitee_Last_Name__c = 'Last Name' + i,
                    Invitee_Email__c = 'lalesescobar@gmail.com',
                    Wedding__c = wedding.Id,
                    Street__c = 'Street Address',
                    City__c = 'City',
                    State__c = 'State',
                    Postal_Code__c = 'Postal Code',
                    Country__c = 'Country',
                    Status__c ='Invited - Pending Response',
                    Meal_Request__c = 'Meat'
                ));
            }
        }
        return invitations;
    }

    /* Testing Apex Triggers Live Session */
    public static List<Wedding__c> generateWeddings(List<Account> customerAccounts) {
        List<Wedding__c> weddings = new List<Wedding__c>();
        for (Integer i=0; i<customerAccounts.size(); i++) {    
            //Add to contacts list
            weddings.add(
                new Wedding__c(
                    Name = 'Wedding Test' + i,
                    Wedding_Account__c = customerAccounts[i].Id,
                    Wedding_City__c = 'Ann Arbor',
                    Name_of_Wedding_Financier__c = 'None',
                    Budget__c = 20000,
                    Start_Date__c = Date.today() + 10,
                    Meal_Choices__c='PopKorn'
                )
            );
        }
        return weddings;
    }

    public static List<Wedding__c> generateWeddingsParams(List<Account> customerAccounts,String Status, Date openDate) {
        List<Wedding__c> weddings = new List<Wedding__c>();
        for (Integer i=0; i<customerAccounts.size(); i++) {    
            //Add to contacts list
            weddings.add(
                new Wedding__c(
                    Name = 'Wedding Test' + i,
                    Wedding_Account__c = customerAccounts[i].Id,
                    Wedding_City__c = 'Ann Arbor',
                    Name_of_Wedding_Financier__c = 'None',
                    Budget__c = 20000,
                    Start_Date__c = openDate,
                    Meal_Choices__c='PopKorn',
                    Status__c=Status,
                    
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
                    Name = 'Opportunity Test' + i,
                    AccountId = customerAccounts[i].Id,
                    LeadSource = 'Website',
                    Maximum_Budget__c = '$10k - $25k',
                    Wedding_City__c = 'Ann Arbor',
                    CloseDate = Date.today() + 30,
                    Wedding_Date__c = Date.today() + 365,
                    StageName = 'New',
                    Name_of_Wedding_Financier__c='None'
                )
            );
        }
        return opportunities;
    }






    public static List<ContentVersion> generateDocuments(Integer nRecords)
    {
   
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'); 
        
        List<ContentVersion> contentVersion_1 = new List<ContentVersion>();
        for(Integer a=0;a<nRecords; a++)
        {
                contentVersion_1.add(new ContentVersion(
                Title='SampleTitle'+a, 
                PathOnClient ='SampleTitle'+a+'.jpg',
                VersionData = bodyBlob, 
                origin = 'H'
                )
                );
        }

        return contentVersion_1;


    }

    public static List<Task> generateTasktoOportunity(List<Opportunity> oppList, Integer nRecords)
    {
   
        
        List<Task> taskLists = new List<Task>();
        Id sOptyId;

        for (Opportunity oOpty : oppList) {
            sOptyId = oOpty.Id;
                for (Integer a=0; a<nRecords; a++)
                {
                    taskLists.add(new Task(Subject='Won Opportunity Follow up Number '+a, ActivityDate=Date.today()+10, WhatId=sOptyId ));
                }
        }

        return taskLists;
    }

     public static List<Task> generateClosedTasktoOportunity(List<Opportunity> oppList, Integer nRecords)
    {
   
        
        List<Task> taskLists = new List<Task>();
        Id sOptyId;

        for (Opportunity oOpty : oppList) {
            sOptyId = oOpty.Id;
                for (Integer a=0; a<nRecords; a++)
                {
                    taskLists.add(new Task(Subject='Won Opportunity Follow up Number '+a, ActivityDate=Date.today()+10, WhatId=sOptyId , Status ='Completed'));
                }
        }

        return taskLists;
    }

    public static List<Event> generateClosedEventtoOportunity(List<Opportunity> oppList, Integer nRecords)
    {
   
        
        List<Event> EventLists = new List<Event>();
        Id sOptyId;
        DateTime startDateTime = DateTime.newInstance(2021, 12,1, 7, 8, 16);
        DateTime endDateTime = DateTime.newInstance(2021, 12, 5, 7, 8, 16);

        for (Opportunity oOpty : oppList) {
            sOptyId = oOpty.Id;
            for (Integer a=0; a<nRecords; a++)
            {
                EventLists.add(new Event(Subject='Won Opportunity Follow up Number '+a,  WhatId=sOptyId, startDateTime=startDateTime, endDateTime=endDateTime ));
            }
        }

        return EventLists;
    }

    public static List<Event> generateEventtoOportunity(List<Opportunity> oppList, Integer nRecords)
    {
   
        
        List<Event> EventLists = new List<Event>();
        Id sOptyId;
        DateTime startDateTime = DateTime.newInstance(2021, 12,6, 7, 8, 16);
        DateTime endDateTime = DateTime.newInstance(2021, 12, 15, 31, 8, 16);

        for (Opportunity oOpty : oppList) {
            sOptyId = oOpty.Id;
            for (Integer a=0; a<nRecords; a++)
            {
                EventLists.add(new Event(Subject='Won Opportunity Follow up Number '+a,  WhatId=sOptyId, startDateTime=startDateTime, endDateTime=endDateTime ));
            }
        }

        return EventLists;
    }


    

    public static List<ContentDocumentLink> generateOpportunitiesWithDocuments(List<Opportunity> opsList, Set <Id> Documents) {

        List<ContentDocumentLink> linkDocumentOps = new List<ContentDocumentLink>();
    
        Integer cont=0;
        for (Opportunity ops : opsList)
        {

                ContentDocumentLink contentlink = new ContentDocumentLink();
                contentlink.LinkedEntityId = ops.id;
                contentlink.contentdocumentid = Documents.iterator().next() ;
                contentlink.ShareType = 'V';
                linkDocumentOps.add(contentlink);
                cont++;

        }
        
        return linkDocumentOps;

    }

    public static List<Wedding__c> generateWeddingsWithOpportunities(List<Opportunity> opportunityList,List<Account> generateCustomerAccounts ){
       
        List<Wedding__c> listWedding = generateWeddings(generateCustomerAccounts);

        for (Integer a=0; a< opportunityList.size(); a++)
        {

            listWedding[a].Opportunity__c=opportunityList[a].Id;

        }
        
        return listWedding;

    }






}