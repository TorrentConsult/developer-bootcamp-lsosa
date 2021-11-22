/* ------------ Used in Deep Dive into Apex Live Session ------------ */

public with sharing class AccountLastFive {

    public List<String> names = new List<String>();
    public List<Account> accounts;
    {
        accounts = 
            [SELECT Id, Name, Phone FROM Account ORDER BY CreatedDate DESC LIMIT 5];
        System.debug('Initializor has run');
    }
    
    public AccountLastFive() {
        for (Account acct : this.accounts) {
            this.names.add(acct.Name);
        }
    }

    public static void run() {

        //Create First Instance of AccountLastFive
        AccountLastFive alf1 = new AccountLastFive();
        System.debug(alf1.names);

        //Create New Account and
        //Create Second Instance of AccountLastFive
        insert new Account(
            Name = EncodingUtil.convertToHex(crypto.generateAesKey(128)).substring(0, 10)
        );
        AccountLastFive alf2 = new AccountLastFive(); 
        System.debug(alf2.names);
        System.debug(alf2.accounts);                   
        
    }

}