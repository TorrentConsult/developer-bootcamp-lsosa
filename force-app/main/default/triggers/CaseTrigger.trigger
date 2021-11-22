/* ------------ Used in Writing Async Apex Live Session ------------ */

trigger CaseTrigger on Case (after update) {

    CaseTriggerHandler handler = new CaseTriggerHandler(trigger.new, trigger.oldMap);

    switch on Trigger.operationType {    
        when AFTER_UPDATE {
            handler.afterUpdate();
        }          
    }    
    
}