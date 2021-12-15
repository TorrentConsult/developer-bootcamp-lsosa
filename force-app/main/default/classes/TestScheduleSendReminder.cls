
@isTest 
public with sharing class TestScheduleSendReminder {
    public static String CRON_EXP = '0 0 12 * * ?';
     @TestSetup
        static void makeData() {

            List<Account> listAccount = TestDataFactory.generateCustomerAccounts(5);
            insert  listAccount;

            List<Wedding__c> listWedding = TestDataFactory.generateWeddings(listAccount);
            insert listWedding;

          

            List<Invitation__c> invitatiosList= TestDataFactory.generateWeddingInvitation(listWedding,2);
            insert invitatiosList;
 
        }


        @istest
        static void testSendEmail()
        {
            List<Invitation__c> lt = [SELECT Id
                                        FROM Invitation__c
                                     WHERE  reminer_sent__c = TRUE];
            
            System.assertEquals(0, lt.size(), 'Invitation  not exist before job has run');


            Test.startTest();
            String jobId = System.schedule('ScheduledApexTest',
                CRON_EXP,
                new ScheduleSendEmailReminder());

            Test.stopTest();
            
            lt = [SELECT Id,reminer_sent__c
                FROM Invitation__c 
                WHERE reminer_sent__c = FALSE
                ];


            System.assertEquals(10, lt.size(), 'Reminder was not send to a valid status and date range');


        }
      


    
}
