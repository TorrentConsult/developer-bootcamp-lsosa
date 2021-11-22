/* ------------ Used in OOP Using Apex Live Session ------------ */

public with sharing class ShippingInjector {

    public static Object instantiate() {
        String className = getShippingPreference();
        Type t = Type.forName(className);
        return t.newInstance();
    }

    private static String getShippingPreference() {
        User u = [SELECT Id, Shipping_Preference__c FROM User WHERE Id = :UserInfo.getUserId()];
        Shipping_Service__mdt shippingService = 
                    [SELECT Id, Class_Name__c 
                    FROM Shipping_Service__mdt 
                    WHERE DeveloperName = :u.Shipping_Preference__c];
        return shippingService.Class_Name__c;
    }

}