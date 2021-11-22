/* ------------ Used in Writing Apex Triggers Live Session ------------ */

public with sharing class AccountService {

    /* 
     * Calculates Count of Account Children for each Parent Account Id
	*/
    public static void updateAccountChildCountsBad(Set<Id> parentAccountIds) {
        
        for (Id parentId : parentAccountIds) {

            //Query Child Accounts for Current Account
            List<Account> childAccounts = [
                SELECT Id 
                FROM Account
                WHERE ParentId =: parentId
            ];

            //Query Parent Account
            Account parentAccount = [
                SELECT Id, Number_of_Child_Accounts__c 
                FROM Account 
                WHERE Id =: parentId
            ];

            //Set Number of Child Accounts based on Child Query Size
            parentAccount.Number_of_Child_Accounts__c = childAccounts.size();

            //Update Parent Account record
            update parentAccount;
        }
    }

    /* 
     * Calculates Count of Account Children for each Parent Account Id
	*/
    public static void updateAccountChildCountsOK(Set<Id> parentAccountIds) {
        
        //Query Current List of Accounts for Parent Account Ids
    	List<Account> childAccounts = [
            SELECT Id, ParentId
            FROM Account
            WHERE ParentId IN: parentAccountIds
        ];
        
        //Store Map of Parent Account Id to its corresponding Child Account Count
        Map<Id, Decimal> countsById = new Map<Id, Decimal>();
        for (Account acct : childAccounts) {
            countsById.put(
                acct.Id,
                countsById.containsKey(acct.ParentId) ? countsById.get(acct.ParentId) + 1 : 1
            );
        }
        
        //Loop through Parent Account Ids and add to new List of Accounts
        //Grab Child Account Count if its in the map, otherwise set value to Null
        List<Account> accounts = new List<Account>();
        for (Id accountId : parentAccountIds) {
            accounts.add(
                new Account(
                    Id = accountId, 
                    Number_of_Child_Accounts__c = 
                    	countsById.containsKey(accountId) ? countsById.get(accountId) : 0
                )
            );
        }
        
        //Update all Parent Accounts that were passed in
        update accounts;
    }

    /* 
     * Calculates Count of Account Children for each Parent Account Id
	*/
    public static void updateAccountChildCounts(Set<Id> parentAccountIds) {
        
    	List<AggregateResult> aggregateResults = queryAccountsChildCounts(parentAccountIds);
        Map<Id, Decimal> countsById = getChildCountsByAccountId(aggregateResults);

        //Loop through Parent Account Ids and add to new List of Accounts
        //Grab Child Account Count if its in the map, otherwise set value to Null
        List<Account> accounts = new List<Account>();
        for (Id accountId : parentAccountIds) {
            accounts.add(
                new Account(
                    Id = accountId, 
                    Number_of_Child_Accounts__c =
                    	countsById.containsKey(accountId) ? countsById.get(accountId) : 0
                )
            );
        }
        
        //Update all Parent Accounts that were passed in
        update accounts;
    }
    
    @TestVisible static List<AggregateResult> queryAccountsChildCounts(Set<Id> parentAccountIds) {
        //Query Current List of Accounts for Parent Account Ids
    	List<AggregateResult> aggregateResults = [
            SELECT ParentId, Count(Id) cnt 
            FROM Account
            WHERE ParentId IN: parentAccountIds
            GROUP BY ParentId
        ];
        return aggregateResults;
    }

    @TestVisible static Map<Id, Decimal> getChildCountsByAccountId(List<AggregateResult> aggregateResults ) {
        //Store Map of Parent Account Id to its corresponding Child Account Count
        Map<Id, Decimal> countsById = new Map<Id, Decimal>();
        for (AggregateResult ar : aggregateResults) {
            countsById.put((Id)ar.get('ParentId'), (Decimal)ar.get('cnt'));
        }
        return countsById;
    }


}