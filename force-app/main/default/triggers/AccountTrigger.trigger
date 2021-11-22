/* ------------ Used in Writing Apex Triggers Live Session ------------ */

trigger AccountTrigger on Account (after insert, after update, after delete, after undelete) {

    AccountTriggerHandler handler = new AccountTriggerHandler(trigger.new, trigger.oldMap);

    switch on Trigger.operationType {    
        when AFTER_INSERT { 
            handler.afterInsert();
        }
        when AFTER_UPDATE {
            handler.afterUpdate();
        }    
        when AFTER_DELETE {
            handler.afterDelete();
        }      
        when AFTER_UNDELETE {
            handler.afterUndelete();
        }          
    }    
    
}