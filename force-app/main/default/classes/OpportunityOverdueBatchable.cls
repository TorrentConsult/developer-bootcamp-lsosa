/* ------------ Used in Writing Async Apex Live Session ------------ */

public inherited sharing class OpportunityOverdueBatchable implements Database.Stateful, Database.Batchable<SObject> {
    
    @TestVisible String query;
    @TestVisible Integer recordCount = 0;

    public OpportunityOverdueBatchable() {
        this.query = 'SELECT Id, Name, OwnerId, CloseDate ' + 
                'FROM Opportunity ' + 
                'WHERE IsClosed = FALSE ' + 
                'AND CloseDate = YESTERDAY';
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(this.query);
     }

    public void execute(Database.BatchableContext bc, List<SObject> scope) { 

        recordCount += scope.size();
        List<Task> tasks = new List<Task>();
        for (Opportunity o : (List<Opportunity>)scope) {
            tasks.add(
                new Task(
                    WhatId = o.Id,
                    OwnerId = o.OwnerId,
                    Subject = o.Name + ' Opportunity is overdue',
                    Description = 'Please update the Close Date or mark the Opportunity as Closed.',
                    ActivityDate = Date.today().addDays(7)
                )
            );
        }
        insert tasks;
    }

    public void finish(Database.BatchableContext bc) {

        // Get the Id for our custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName 
            FROM CustomNotificationType WHERE DeveloperName='Apex_Custom_Notification'];
        
        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle('Opportunity Overdue Batch');
        notification.setBody('Batch Job is Complete. ' + recordCount + ' record(s) processed.');
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId('000000000000000AAA'); //Dummy Target
        
        // Actually send the notification
        notification.send(new Set<String>{UserInfo.getUserId()});

    }

    public static void runJob() {

        Id jobId = Database.executeBatch(
            new OpportunityOverdueBatchable(), 2000
        ); 
        System.debug(jobId);

    }    

}