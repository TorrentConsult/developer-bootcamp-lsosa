/* ------------ Used in Accessing Data in LWC Live Session ------------ */

public inherited sharing class WeddingBrowserController {

    @AuraEnabled(cacheable=true)
    public static List<Wedding__c> getWeddings(String weddingStatus) {
        String soql = 'SELECT Name, Start_Date__c, Status__c, Budget__c, Total_Cost__c, Meal_Option__c, Meal_Choices__c ' + 
                        ' FROM Wedding__c' + 
                        (String.isNotEmpty(weddingStatus) ? ' WHERE Status__c = :weddingStatus' : '') + 
                        ' WITH SECURITY_ENFORCED';
        return Database.query(soql);
    }

}