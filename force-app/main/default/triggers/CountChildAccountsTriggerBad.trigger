/* ------------ Used in Writing Apex Triggers Live Session ------------ */

trigger CountChildAccountsTriggerBad on Account (after insert, after update, after delete, after undelete) {

    for (Account a : trigger.new) {

        //Query Child Accounts for Current Account
        List<Account> childAccounts = [
            SELECT Id 
            FROM Account
            WHERE ParentId =: a.parentId
        ];

        //Query Parent Account
        Account parentAccount = [
            SELECT Id, Number_of_Child_Accounts__c 
            FROM Account 
            WHERE Id =: a.parentId
        ];

        //Set Number of Child Accounts based on Child Query Size
        parentAccount.Number_of_Child_Accounts__c = childAccounts.size();

        //Update Parent Account record
        update parentAccount;  
                 
    }

}