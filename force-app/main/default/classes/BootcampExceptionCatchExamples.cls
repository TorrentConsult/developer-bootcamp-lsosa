/* ------------ Used in Exception Handling Live Session ------------ */

public with sharing class BootcampExceptionCatchExamples {

    // Math Exception
    public static Decimal divideNumbers(Integer dividend, Integer divisor) {
        return dividend / divisor;
    }

    // Query Exception
    public static User getUserByAlias(String alias) {
        return [SELECT Id, FirstName, LastName, Email FROM User WHERE Alias = :alias];
    }

    // Limit Exceptions
    public static List<Contact> getContactsByAccountId(Set<Id> accountIds) {
        List<Contact> contacts = new List<Contact>();
        for (Id accountId : accountIds) {
            contacts.addAll([SELECT Id FROM Contact WHERE AccountId = :accountId]); // Don't ever do this
        }
        return contacts;
    }


    // Try / Catch / Finally Syntax
    public static void tryCatchFinallyBlockSyntax() {

        try {
            // Do something in your code
        } catch (DMLException e) {
            // Catch a more specific type of exception that occurs
        } catch (Exception e) {
            // Catch a general type of exception that occurs
        } finally {
            // Do something at the end
        }

    }

    // Try / Catch / Finally Example
    public static void tryCatchFinallyBlockExample(String accountIdString, String fieldName) {

        try {
            Id accountId = accountIdString;
            Account acct = [SELECT Id FROM Account WHERE Id = :accountId];
            String fieldValue = (String)acct.get(fieldName);
        } catch (QueryException e) {
            System.debug('QueryException caught: ' + e.getMessage());    
        } catch (SObjectException e) {
            System.debug('SObjectException caught: ' + e.getMessage());    
        } catch (Exception e) {
            System.debug('Exception caught: ' + e.getMessage());    
        }
        
    }


    // Avoiding Math Exceptions
    public static Decimal safelyDivideNumbers(Integer dividend, Integer divisor) {
        return (divisor == 0 ? null : dividend / divisor);
    }


    // Resolving the Issue Date from String
    public static Date getDateFromString(String dateString) {

        Date dt;
        try {
            dt = Date.valueOf(dateString);  // YYYY-MM-DD
        } catch (Exception e) {
            dt = Date.parse(dateString);    // MM/DD/YYYY
        }
        return dt;

    }
    

    // User Friendly Message Update Record
    public class BootcampException extends Exception { }
    public static void insertAccount(Account acct) {

        try {
            insert acct;
        } catch (DmlException e) {
            if (e.getDmlType(0) == StatusCode.STRING_TOO_LONG && e.getDmlFieldNames(0)[0] == 'Name') {
                throw new BootcampException('The Account Name can not be longer than 255 characters.', e);
            }
        }

    }

    
    // Continue Logic Email Exception
    public static Boolean runNewAccountSetup(String accountName) {
        Account newAccount = new Account(Name=accountName);
        insert newAccount;

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setWhatId(newAccount.Id);
        message.setToAddresses(new List<String>{UserInfo.getUserEmail()});
        message.setPlainTextBody('Account Id: ' + newAccount.Id);
        message.setSubject('New Account ' + newAccount.Name + ' Created');
        message.setSaveAsActivity(false);

        Boolean success = true;
        try {
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{message});
        } catch (System.EmailException e) {
            success = (e.getDmlType(0) == StatusCode.NO_MASS_MAIL_PERMISSION);  //Deliverability Turned off in Sandbox
        } catch (Exception e) {
            success = false;
        } finally {
            System.debug('Email Success Status: ' + success);
        }
        return success;
    }

    public static void run() {

        // Math Exception
        Decimal quotient = BootcampExceptionCatchExamples.divideNumbers(3, 0);

        // Query Exception
        User u = BootcampExceptionCatchExamples.getUserByAlias('rreed123');

        // Limit Exception
        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Contact> contacts = BootcampExceptionCatchExamples.getContactsByAccountId(accounts.keySet());



        // Try / Catch / Finally Example
        BootcampExceptionCatchExamples.tryCatchFinallyBlockExample('1234', 'Id');                //Invalid Account Id

        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        BootcampExceptionCatchExamples.tryCatchFinallyBlockExample(accountId, 'Name');           //Field Name not Queried

        BootcampExceptionCatchExamples.tryCatchFinallyBlockExample('0010V00002IOvyZQAT', 'Id');  //Account Id Doesn't Exist

        
        // Resolving the Issue Date from String
        Date dt1 = BootcampExceptionCatchExamples.getDateFromString('2021-11-03');   // Does not throw Exception
        Date dt2 = BootcampExceptionCatchExamples.getDateFromString('11/03/2021');   // Throws Exception
        

            // User Friendly Message Update Record
        try {
            Account acct = new Account(Name='r'.repeat(256));
            BootcampExceptionCatchExamples.insertAccount(acct);
        } catch (DmlException e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }

        // Avoid Math Exception
        Decimal safeQuotient = BootcampExceptionCatchExamples.safelyDivideNumbers(3, 0);
        System.debug(safeQuotient);
        

        // Continue Logic Email Exception
        Boolean success = BootcampExceptionCatchExamples.runNewAccountSetup('new account');
        System.debug(success);

    }

}