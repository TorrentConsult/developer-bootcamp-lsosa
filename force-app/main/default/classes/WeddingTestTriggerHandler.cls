@isTest
public with sharing class WeddingTestTriggerHandler {
    final static Integer NUMBER_RECORD = 1;
    final static String  NameWedd = 'Wedding Test';


    @testSetup
    static void makeData() {
        //Step 1: Use @testSetup to create any dependent data
        
        List<Account> accList = TestDataFactory.generateCustomerAccounts(NUMBER_RECORD);
        insert accList;

        List<Opportunity> opsList1 =  TestDataFactory.generateOpportunities(accList);
        insert opsList1;

        
        List<ContentVersion> docList=  TestDataFactory.generateDocuments(NUMBER_RECORD);
        insert docList;

        Set<Id> versionIds = new Set<Id>();
        for (ContentVersion a : docList) {
            versionIds.add(a.Id );
        }

        List<ContentVersion> contentVersionId = [SELECT Id, ContentDocumentId 
                            FROM ContentVersion WHERE Id IN :versionIds];
        
        Set<Id> documentIds = new Set<Id>();
        for (ContentVersion a : contentVersionId) {
            documentIds.add(a.ContentDocumentId );
        }

        List<ContentDocumentLink> listIdDocsOp= TestDataFactory.generateOpportunitiesWithDocuments(opsList1,documentIds);
        insert listIdDocsOp; 

        System.debug(listIdDocsOp);



        //make 2 events closed and 1 opeen the same for and tasks

        List<Task> taskLists= TestDataFactory.generateClosedTasktoOportunity(opsList1, 2);
        insert taskLists;

        List<Event> EventList= TestDataFactory.generateClosedEventtoOportunity(opsList1, 2);
        insert EventList;
  
        List<Task> taskListsOpen= TestDataFactory.generateTasktoOportunity(opsList1, 1);
        insert taskListsOpen;

        List<Event> EventListOpen= TestDataFactory.generateEventtoOportunity(opsList1, 1);
        insert EventListOpen;
  
        
    }

    
    @isTest static void closedWonOpportunities() { 
        
        List<Opportunity> opsList = new List<Opportunity> ([select id from Opportunity  limit :NUMBER_RECORD]);
        List<Account> accList = new List<Account> ([select id from Account  limit :NUMBER_RECORD]);

        for(Opportunity opUpdate: opsList)
        {
            opUpdate.StageName='Closed Won';
            opUpdate.Amount=120000;
        }

        Test.startTest();
        
            update opsList;

        test.stopTest();

        List<Wedding__c> newRecordsWedding = new List<Wedding__c> ([select id from Wedding__c  limit :NUMBER_RECORD]);

        Set<Id> weddingIds = new Set<Id>();
        for (Wedding__c a : newRecordsWedding) {
            weddingIds.add(a.Id);
        }
        Set<Id> oppId=WeddingService.queryWeddingsOpportunities(weddingIds) ;


        List<ContentDocumentLink> documentWeddIdList = [SELECT ContentDocumentId FROM ContentDocumentLink 
        WHERE LinkedEntityId  IN: weddingIds];

        List<ContentDocumentLink> documentOppIdList = [SELECT ContentDocumentId FROM ContentDocumentLink 
        WHERE LinkedEntityId  IN: oppId];
        //test Scenario 1 , 2
        //this cover two scenarios because we are checkin Opportinities Id's are still on document link
        // and weddingsID are now on document link
        System.assert(weddingIds.size()>0,' Document Id were not linked  to the wedding');
        System.assertEquals(documentWeddIdList.size(),documentOppIdList.size(),' Wedding and Opportinities should have the same docID');
        
    }

    @isTest static void closedLooseOpportunities() { 
        
        List<Opportunity> opsList = new List<Opportunity> ([select id from Opportunity  limit :NUMBER_RECORD]);
        List<Account> accList = new List<Account> ([select id from Account  limit :NUMBER_RECORD]);

        for(Opportunity opUpdate: opsList)
        {
            opUpdate.StageName='Closed Lost';
            opUpdate.Lost_Reason__c ='Location';
            opUpdate.Amount=120000;

        }

        Test.startTest();
        
            update opsList;

        test.stopTest();

        List<Wedding__c> newRecordsWedding = new List<Wedding__c> ([select id from Wedding__c  limit :NUMBER_RECORD]);

        Set<Id> weddingIds = new Set<Id>();
        for (Wedding__c a : newRecordsWedding) {
            weddingIds.add(a.Id);
        }
        System.debug(newRecordsWedding.size());

        System.assert(newRecordsWedding.size()==0,' Wedding should not exist as the Stage is Closed Loose');

    }




    @isTest static void updateTaskOp() { 


        List<Opportunity> opsList = new List<Opportunity> ([select id from Opportunity  limit :NUMBER_RECORD]);
        List<Account> accList = new List<Account> ([select id from Account  limit :NUMBER_RECORD]);

        for(Opportunity opUpdate: opsList)
        {
            opUpdate.StageName='Closed Won';
            opUpdate.Amount=120000;
        }
  


        Test.startTest();
        update opsList;
        test.stopTest();

        List<Wedding__c> newRecordsWedding = new List<Wedding__c> ([select id from Wedding__c  limit :NUMBER_RECORD]);

        Set<Id> weddingIds = new Set<Id>();
        for (Wedding__c a : newRecordsWedding) {
            weddingIds.add(a.Id);
        }
        Set<Id> oppId=WeddingService.queryWeddingsOpportunities(weddingIds) ;

        //test Scenario 3 get tasks with old ID ahould be cero
        List<Task> oldTasks = new List<Task>([select id from task where whatid in :oppId]);
        List<Task> newTasks = new List<Task>([select id from task where whatid in :weddingIds]);

          //Scenario 3  closed event were moved because now opportunity have only one, and wedding have the other 2 open
        
          System.assertEquals(oldTasks.size(),1,' open event should be on oportunity ');
          System.assertEquals(newTasks.size(),2, ' open event should  be in the wedding  ');

        //Scenario 4   opne where not moved becausse the one closed is still on the opportunity and wedding has only two

        System.assert(oldTasks.size()<2,' closed event should not be in the opportunity  '); 
        System.assert(newTasks.size()<=2,' closed event should  be in the wedding  ');
        
              
        
      
        

        

    }


    @isTest static void updateEventOp() { 

        
        List<Opportunity> opsList = new List<Opportunity> ([select id from Opportunity  limit :NUMBER_RECORD]);
        List<Account> accList = new List<Account> ([select id from Account  limit :NUMBER_RECORD]);

        for(Opportunity opUpdate: opsList)
        {
            opUpdate.StageName='Closed Won';
            opUpdate.Amount=120000;
        }
  

        Test.startTest();
        update opsList;
        test.stopTest();

        List<Wedding__c> newRecordsWedding = new List<Wedding__c> ([select id from Wedding__c  limit :NUMBER_RECORD]);

        Set<Id> weddingIds = new Set<Id>();
        for (Wedding__c a : newRecordsWedding) {
            weddingIds.add(a.Id);
        }
        Set<Id> oppId=WeddingService.queryWeddingsOpportunities(weddingIds) ;

        //test Scenario 3 get tasks with old ID ahould be zero
        List<Event> oldevents = new List<Event>([select id from event where whatid in :oppId]);
        List<Event> newEvents = new List<Event>([select id from event where whatid in :weddingIds]);
        


         //Scenario 5  closed event were moved

        System.assertEquals(oldevents.size(),1,' open event should be on oportunity ');
        System.assertEquals(newEvents.size(),2, ' open event should  be in the wedding  ');
        
        //Scenario 6   closed event keep on opportunity

        System.assert(oldevents.size()<2,' closed event should not be in the opportunity  '); 
        System.assert(newEvents.size()>1,' closed event should  be in the wedding  ');

        

    }
}

