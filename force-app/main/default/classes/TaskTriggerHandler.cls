/* ------------ Used in Exception Handling Live Session ------------ */

public with sharing class TaskTriggerHandler {

    @TestVisible static Boolean bypassTrigger = false; 
    public static Boolean runCustomValidation = false;

    final List<Task> newRecords;
    final Map<Id, Task> oldMap;

    public TaskTriggerHandler(List<Task> newRecords, Map<Id, Task> oldMap) {
        this.newRecords = newRecords;
        this.oldMap = oldMap;
    }

    /* 
        * Run Custom Validation Logic
    */
    public void beforeInsert() {
        if (bypassTrigger || !runCustomValidation) return;

        for (Task t : newRecords) {
            if (t.WhatId != null && t.WhatId.getSObjectType() == Account.SObjectType && 
                    t.WhoId != null && t.WhoId.getSObjectType() == Lead.SObjectType) {
                t.addError('You must select a Contact when selecting an Account');          //Displays at the top of the page
                //t.WhoId.addError('You must select a Contact when selecting an Account');  //Displays next to the field
            }
        }

    }

    public static void run() {

        Lead l = [SELECT Id FROM Lead LIMIT 1];
        Account a = [SELECT Id FROM Account LIMIT 1];

        TaskTriggerHandler.runCustomValidation = true;
        Task t = new Task(WhoId=l.Id, WhatId=a.id);
        insert t;

    }

}