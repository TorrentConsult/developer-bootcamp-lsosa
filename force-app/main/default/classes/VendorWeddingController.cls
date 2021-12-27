public inherited sharing class VendorWeddingController {

    @AuraEnabled(cacheable=true)
    public static List<Account> getVendorOption(String vendorType ,String weddingId) {
       
        String soql = 
                    'SELECT Id, Name, ShippingCity, ShippingState, Phone, Website, Type, ' +
                    '(SELECT Id , Wedding__c FROM Vendor_Options__r WHERE Wedding__c = \'' + weddingId + '\' ) '+
                    'FROM Account ' +
                    'WHERE RecordType.Name =\'Vendor\' ' +
                    ' WITH SECURITY_ENFORCED LIMIT 100';
                    System.debug(soql);
        return Database.query(soql);
        
    }
 
 }


 