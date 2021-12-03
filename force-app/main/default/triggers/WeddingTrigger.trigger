trigger WeddingTrigger on Wedding__c (after insert) {

    WeddingTriggerHandler handler = new WeddingTriggerHandler(trigger.new, trigger.oldMap);

    switch on Trigger.operationType {    
        when AFTER_INSERT { 
            handler.afterInsert();
        }
       
    }    

   
}