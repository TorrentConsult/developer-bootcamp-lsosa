/* ------------ Used in Writing Apex Triggers Live Session ------------ */

public with sharing class WeddingService {


    public static Set<Id> queryWeddingsOpportunities(Set<Id> weddingIds) {
    	

        Set<Id> OppMapId = new Map<Id,Opportunity>([SELECT id FROM opportunity  
        WHERE id in (SELECT OPPORTUNITY__c FROM Wedding__C WHERE ID IN :weddingIds )]).keyset();
    
        return OppMapId;
    }

    @TestVisible static Set<Id> queryWeddingsDocumentsId(Set<Id> OpportunitiesIds) {

    	List<ContentDocumentLink> documentIdList = [SELECT ContentDocumentId,Id FROM ContentDocumentLink 
        WHERE LinkedEntityId  IN: OpportunitiesIds];
        Set<id> documentIds = new Set<id>();

        for(ContentDocumentLink dId: documentIdList)
        {
            documentIds.add(dId.ContentDocumentId);
        }

        return documentIds;
        }


    public static void inserDocumentIdPerWedding(Set<Id> weddingIds,Set<Id> OpportunitiesIds ) {
        
        Set<Id> documentsIds = new  Set<Id>();
        
      
            documentsIds = WeddingService.queryWeddingsDocumentsId(OpportunitiesIds);
        
            List<ContentDocumentLink> documentsLink = new List<ContentDocumentLink>();
            
            for (Id WeddingId : weddingIds) {
                for(Id docId:documentsIds )
                {
                    documentsLink.add(
                        new ContentDocumentLink(
                            ContentDocumentId = docId, 
                            LinkedEntityId = WeddingId
                        )
                    );
                }
            }
            System.debug(documentsLink);

            insert(documentsLink);
        
    }
 
    public static void updateTaskOpportunity(Set<Id> weddingIds,Set<Id> OpportunitiesIds) {
        
        List<task> idTasks = [SELECT id FROM task where whatid in :OpportunitiesIds and isclosed = true];

        System.debug(idTasks);

        if (idTasks.size()>0 )
        {
            for(Id wedId:weddingIds)
            {   
                for (Task taskU : idTasks) 
                {
                    taskU.WhatId=wedId;
                    
                }
            }
           
            Database.SaveResult[] MySaveResult = Database.update(idTasks, false);
            for(Database.SaveResult sr:MySaveResult){
                if(!sr.isSuccess())
                System.debug(sr.getErrors()[0]+'--'+ sr.getId());
            }
        }
    }

    public static void updateEventOpportunity(Set<Id> weddingIds,Set<Id> OpportunitiesIds ) {
        
        List<Event> idEvents = [SELECT id FROM Event where whatid in :OpportunitiesIds and EndDateTime < :system.now() ] ;

        System.debug(idEvents);

        if (idEvents.size()>0 )
        {
            for(Id wedId:weddingIds)
            {   
                for (Event evU : idEvents) 
                {
                    evU.WhatId=wedId;
                    
                }
            }


                Database.SaveResult[] MySaveResult = Database.update( idEvents, false);
                
                for(Database.SaveResult sr:MySaveResult){
                    if(!sr.isSuccess())
                    System.debug(sr.getErrors()[0]+'--'+ sr.getId());
                }
            
        }
    }
 

}

