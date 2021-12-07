/* ------------ Used in Writing Apex Triggers Live Session ------------ */

trigger WeddingTrigger on Wedding__c (after insert) {

    AccountTriggerHandler handler = new AccountTriggerHandler(trigger.new, trigger.oldMap);

    switch on Trigger.operationType {    
        when AFTER_INSERT { 
            handler.afterInsert();
        }
       
    }    

/*

    ContentDocumentLink cd = new  ContentDocumentLink (	ContentDocumentId='0695f000002MztQAAS',LinkedEntityId='a025f000004TpTRAA0')

    insert(cd);

    */
   
}
