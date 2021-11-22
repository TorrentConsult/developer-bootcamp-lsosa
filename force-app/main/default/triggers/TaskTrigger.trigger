/* ------------ Used in Exception Handling Live Session ------------ */

trigger TaskTrigger on Task (before insert) {

    TaskTriggerHandler handler = new TaskTriggerHandler(trigger.new, trigger.oldMap);

    switch on Trigger.operationType {    
        when BEFORE_INSERT {
            handler.beforeInsert();
        }      
    }   

}