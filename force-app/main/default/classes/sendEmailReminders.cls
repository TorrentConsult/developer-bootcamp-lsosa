public with sharing class sendEmailReminders implements
    Database.Batchable<sObject> {


    public Integer emailSentRecors = 0;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT id, reminer_sent__c, invitee_email__c, wedding__r.start_date__c , wedding__r.name, wedding__r.meal_choices__c, wedding__r.status__c '+
            +' FROM invitation__c '+
            +' WHERE status__c =\'Invited - pending response\' '+
                +'and wedding__c  not in ( select id from wedding__c where status__c in (\'Completed,Cancelled\'))'+
                +'and  reminer_sent__c=false'
        );
    }

    public void execute(Database.BatchableContext bc, List<Invitation__c > scope){
        // process each batch of records
        String Name,body;
        List<String>  emails = new List<String>();
        List<Invitation__c > invitations=scope;
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage> ();
        List<String> weddingCovered= new List<String>();

        for (Invitation__c invitationObj : scope) {
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            

            if(!weddingCovered.contains(invitationObj.Wedding__r.Name ))
            {    
                Date startDate = Date.today();
                Date endDate = invitationObj.wedding__r.Start_Date__c;
                Integer noOfDays = startDate.daysBetween( endDate );

                if(noOfDays>=7 && noOfDays<=14 )
                {
                    Name=invitationObj.Wedding__r.Name ;
                    body='Reminder for Wedding Name '+ invitationObj.Wedding__r.Name+' this are the - meal choices ' + invitationObj.Wedding__r.Meal_Choices__c;
                    weddingCovered.add(Name);

                    for(Invitation__c invitationObjWeeding :invitations)
                    {
                        if(invitationObjWeeding.Wedding__r.Name==Name)
                        {
                            emails.add(invitationObjWeeding.Invitee_Email__c);
                            emailSentRecors++;
                            invitationObjWeeding.reminer_sent__c=TRUE;
                        }
                    }
                        mail.setReplyTo('support@acme.com');
                        mail.setSenderDisplayName('Salesforce Support');
                        mail.setSubject('New Case Created : ' + case.Id);
                        mail.setBccSender(false);
                        mail.setUseSignature(false);
                        mail.setPlainTextBody(Body);
                        mail.setToAddresses( emails);
                        mail.setWhatId(invitationObj.Wedding__c);
                        mailList.add(mail);
                }

            }

        }

        sendEmail(mailList);



    }   


    public void sendEmail(List<Messaging.SingleEmailMessage> listEmails)
    {

        Try{
            Messaging.sendEmail(listEmails);
        }
        catch (Exception e)
        {
            throw new MomException('Error sending Messages',listEmails );
        }
        
    }


    public void finish(Database.BatchableContext bc) {

        // Get the Id for our custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName
             FROM CustomNotificationType WHERE DeveloperName='Apex_Custom_Notification'];
       
        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle('Opportunity Overdue Batch');
        notification.setBody('Batch Job is Complete');
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId('000000000000000AAA'); //Dummy Target
       
        // Actually send the notification

        notification.send(new Set<String>{UserInfo.getUserId()});
 
    }
 
 
}
