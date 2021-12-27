public with sharing class VendorOptionCreate {
    
    @AuraEnabled
    public static Vendor_Option__c vendorOptionAdd( Vendor_Option__c vendor){
        try {

            system.debug('acc'+vendor);
            insert vendor;
            return vendor;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Vendor_Option__c vendorOptionDel( Vendor_Option__c vendor){
        try {

            system.debug('acc'+vendor);
            delete vendor;
            return vendor;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}
