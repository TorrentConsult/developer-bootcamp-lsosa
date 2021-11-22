/* ------------ Used in Exception Handling Live Session ------------ */

public with sharing class BootcampExceptionDatabaseResultExamples {
    
    public static void insertAccount(Boolean allOrNothing) {

        List<Account> accounts = new List<Account>{
            new Account(Name='Account' + DateTime.now().getTime()),
            new Account(Name='Account' + 'z'.repeat(255)),
            new Account()
        };

        List<Database.SaveResult> saveResults = Database.insert(accounts, allOrNothing);
        for (Integer i=0; i<saveResults.size(); i++) {
            Database.SaveResult sr = saveResults[i]; 
            if (sr.isSuccess()) {                              // Success, get Record Id
                System.debug('Account Id: ' + sr.getId());
            } else {   
                for (Database.Error err : sr.getErrors()) {    // Failed, get Errors        
                    System.debug('Error Message: ' + err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Fields Causing Error: ' + err.getFields());
                }
            }
        }
        //What happens to this account when you use True/False for AllOrNothing?
        insert new Account(Name='Testing Exception Behavior');
    }

    public static void run() {

        // Partial Success
        BootcampExceptionDatabaseResultExamples.insertAccount(false);

        // All or Nothing
        BootcampExceptionDatabaseResultExamples.insertAccount(true);
    }


}