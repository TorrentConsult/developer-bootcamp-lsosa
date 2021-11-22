/* ------------ Used in Testing Apex Triggers Live Session ------------ */

public with sharing class AccountNamingService {

    public static void updateName(Account acct) {
        acct.Name = 'New Account Name';
    }

}