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

        List<Invitation__c > invitationsList=new List<Invitation__c>();

        for (Invitation__c a : scope) {
            

            if(!emails.contains(a.Invitee_Email__c))
            {    
                Date startDate = Date.today();
                Date endDate = a.wedding__r.Start_Date__c;
                Integer noOfDays = startDate.daysBetween( endDate );

                if(noOfDays>=7 && noOfDays<=14 )
                {
                    Name=a.Wedding__r.Name ;
                    body='Reminder for Wedding Name '+ a.Wedding__r.Name+' this are the - meal choices ' + a.Wedding__r.Meal_Choices__c;

                    for(Invitation__c b :invitations)
                    {
                        if(b.Wedding__r.Name==Name)
                        {
                            emails.add(b.Invitee_Email__c);
                            emailSentRecors++;
                            b.reminer_sent__c=TRUE;
                            invitationsList.add(b);
                        }
                    }
                    if( emailSentRecors<=15)
                    {
                        sendEmail(emails,body);
                        emailSentRecors=emailSentRecors+emails.size();
                    }
                }

            }

        }
        System.debug('testing '+invitationsList);

        update invitationsList;


    }   


    public void sendEmail(List<String> toAddresses, String Body)
    {

        System.debug(toAddresses);
                // First, reserve email capacity for the current Apex transaction to ensure
        // that we won't exceed our daily email limits when sending email after
        // the current transaction is committed.

        // Processes and actions involved in the Apex transaction occur next,
        // which conclude with sending a single email.

        // Now create a new single email message object
        // that will send out a single email to the addresses in the To, CC & BCC list.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();


        // Assign the addresses for the To and CC lists to the mail object.
        mail.setToAddresses( toAddresses);

        // Specify the address used when the recipients reply to the email. 
        mail.setReplyTo('support@acme.com');

        // Specify the name used as the display name.
        mail.setSenderDisplayName('Salesforce Support');

        // Specify the subject line for your email address.
        mail.setSubject('New Case Created : ' + case.Id);

        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);

        // Optionally append the salesforce.com email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);

        // Specify the text content of the email.
        mail.setPlainTextBody(Body);

        /*mail.setHtmlBody('Your case:<b> ' + case.Id +' </b>has been created.<p>'+
            'To view your case <a href=https://yourInstance.salesforce.com/'+case.Id+'>click here.</a>');
            */

        // Send the email you have created.

        System.debug(mail);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
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
