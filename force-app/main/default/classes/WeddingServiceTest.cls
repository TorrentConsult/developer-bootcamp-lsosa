@isTest
public with sharing class WeddingServiceTest {

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

        //weddingsWithDocs as the trigger will not working I need to create weddings with oportunities related but without the documents of the oportunity
        List<Wedding__c> weddingOps=  TestDataFactory.generateWeddingsWithOpportunities(opsList1,accList);
        
        WeddingTriggerHandler.bypassTrigger=true;
        insert weddingOps;

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

    
    @isTest static void createDocumentWeddingOp() { 

        String Name = 'Wedding Test';
        
        List<Wedding__c> newRecordsWedding = new List<Wedding__c> ([select id from Wedding__c  limit :NUMBER_RECORD]);
        System.debug(newRecordsWedding);
        
        Set<Id> weddingIds = new Set<Id>();
        for (Wedding__c a : newRecordsWedding) {
            weddingIds.add(a.Id);
        }

        Set<Id> oppId=WeddingService.queryWeddingsOpportunities(weddingIds) ;


        Test.startTest();
        if(oppId.size()>0 )
        {

            WeddingService.inserDocumentIdPerWedding(weddingIds,oppId);

        }

        test.stopTest();

        //compare both documentid in wedding and opprotunity

        List<ContentDocumentLink> documentWeddIdList = [SELECT ContentDocumentId FROM ContentDocumentLink 
        WHERE LinkedEntityId  IN: weddingIds];

        List<ContentDocumentLink> documentOppIdList = [SELECT ContentDocumentId FROM ContentDocumentLink 
        WHERE LinkedEntityId  IN: oppId];
        //test Scenario 1 , 2
        //this cover two scenarios because we are checkin Opportinities Id's are still on document link
        // and weddingsID are now on document link
        System.assert(weddingIds.size()>0,' Wedding and Opportinities should have the same docID');
        System.assertEquals(documentWeddIdList.size(),documentOppIdList.size(),' Wedding and Opportinities should have the same docID');
        

    }

    @isTest static void updateTaskOp() { 

  
        
        List<Wedding__c> newRecordsWedding = new List<Wedding__c> ([select id from Wedding__c  where name like : NameWedd + '%' ]);

        
        Set<Id> weddingIds = new Set<Id>();
        for (Wedding__c a : newRecordsWedding) {
            weddingIds.add(a.Id);
        }

        Set<Id> oppId=WeddingService.queryWeddingsOpportunities(weddingIds) ;


        Test.startTest();
        WeddingService.updateTaskOpportunity(weddingIds,oppId);
        test.stopTest();

       
        List<Task> oldTasks = new List<Task>([select id from task where whatid in :oppId]);
        List<Task> newTasks = new List<Task>([select id from task where whatid in :weddingIds]);

         //Scenario 3  closed event were moved because now opportunity have only one, and wedding have the other 2 open
        
         System.assertEquals(oldTasks.size(),1,' open event should be on oportunity ');
         System.assertEquals(newTasks.size(),2, ' open event should  be in the wedding  ');

        //Scenario 4   opne where not moved becausse the one closed is still on the opportunity and wedding has only two

        System.assert(oldTasks.size()<2,' closed event should not be in the opportunity  '); 
        System.assert(newTasks.size()>1,' closed event should  be in the wedding  ');
        
              
        
        
        

        

    }


    @isTest static void updateEventOp() { 

        
        List<Wedding__c> newRecordsWedding = new List<Wedding__c> ([select id from Wedding__c  where name like : NameWedd + '%' ]);

        
        Set<Id> weddingIds = new Set<Id>();
        for (Wedding__c a : newRecordsWedding) {
            weddingIds.add(a.Id);
        }

        Set<Id> oppId=WeddingService.queryWeddingsOpportunities(weddingIds) ;


        Test.startTest();
        WeddingService.updateEventOpportunity(weddingIds,oppId);
        test.stopTest();

 
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
