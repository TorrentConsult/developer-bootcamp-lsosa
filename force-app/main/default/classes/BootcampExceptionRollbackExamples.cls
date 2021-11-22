/* ------------ Used in Exception Handling Live Session ------------ */

public with sharing class BootcampExceptionRollbackExamples {

    public static void rollbackSyntax() {

        Account account = new Account(Name='Account before Savepoint');

        Savepoint sp1 = Database.setSavePoint();
        insert new Account(Name='Account 1 in First Savepoint');
        insert new Account(Name='Account 2 in First Savepoint');
        
        Savepoint sp2 = Database.setSavePoint();
        insert new Account(Name='Account 1 in Second Savepoint');
        insert new Account(Name='Account 2 in Second Savepoint');
        Database.rollback(sp2);

    }


    public static Result processRequest(Request req) {
        Result res = new Result();
        Account acct = new Account(Name=req.companyName);
        insert acct;
        insert new Contact(LastName=req.lastName, Email=req.email, AccountId=acct.Id, Role_in_Wedding__c='Other');
        res.success = true;
        res.message = 'success';
        return res;
    }

    public static Result processRequestWithRollback(Request req) {
        SavePoint sp = Database.setSavePoint();
        Result res = new Result();
        try {
            Account acct = new Account(Name=req.companyName);
            insert acct;
            insert new Contact(LastName=req.lastName, Email=req.email, AccountId=acct.Id, Role_in_Wedding__c='Other');
            res.success = true;
            res.message = 'success';
        } catch (Exception e) {
            Database.rollback(sp);
            res.success = false;
            res.message = e.getMessage();
        }
        return res;
    }

    public class Request {
        public String companyName;
        public String lastName;
        public String email;
        public Request(String companyName, String lastName, String email) {
            this.companyName = companyName;
            this.lastName = lastName;
            this.email = email;
        }
    }

    public class Result {
        public Boolean success;
        public String message;
    }

    public static void run() {

        BootcampExceptionRollbackExamples.Request req1 = new BootcampExceptionRollbackExamples.Request(
            'Company', 'Last11', 'ron.reed11@torrentconsulting.com'
        );
        BootcampExceptionRollbackExamples.Result res1 = BootcampExceptionRollbackExamples.processRequest(req1);
        // Throws an Exception and doesn't return a Result Object
        System.debug(res1);


        BootcampExceptionRollbackExamples.Request req2 = new BootcampExceptionRollbackExamples.Request(
            'Company', 'Last11', 'ron.reed11@torrentconsulting.com'
        );
        BootcampExceptionRollbackExamples.Result res2 = BootcampExceptionRollbackExamples.processRequestWithRollback(req2);
        System.debug(res2);

    }

}