/* ------------ Used in Writing Apex Triggers Assignment------------ */

public with sharing class VendorOptionVenueService {

    @TestVisible static Id VENUE_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Venue').getRecordTypeId();

    public static void venueSelectedUpdates(List<Vendor_Option__c> vendorOptions) {
        if (vendorOptions.isEmpty()) return;

        Map<Id, Account> weddingToVenue = getWeddingToVenue(vendorOptions);

        //Query Weddings to get Estimated RSVP Value used in Cost Calculation
        Map<Id, Wedding__c> weddings = new Map<Id, Wedding__c>(
            [SELECT Id, Estimated_RSVP__c FROM Wedding__c WHERE Id IN :weddingToVenue.keySet()]
        );

        for (Vendor_Option__c vo : vendorOptions) {
            if (weddings.containsKey(vo.Wedding__c)) {
                Wedding__c wedding = new Wedding__c(
                    Id = vo.Wedding__c,
                    Venue__c = weddingToVenue.get(vo.Wedding__c).Id,
                    Venue_Cost__c = getVenueCost(vo, weddings.get(vo.Wedding__c))
                );
                weddings.put(vo.Wedding__c, wedding);
            }
        }
        update weddings.values();
    }

    //Calculate Vendor Cost based on Vendor Option Unit Type
    @TestVisible static Decimal getVenueCost(Vendor_Option__c vendorOption, Wedding__c wedding) {

        Decimal venueCost;
        switch on vendorOption.Unit_Type__c {
            when 'No Variable Cost' {
                venueCost = vendorOption.Fixed_Fee__c;
            }
            when 'Per Head' {
                venueCost = vendorOption.Fixed_Fee__c + (vendorOption.Variable_Cost_per_Unit__c * wedding.Estimated_RSVP__c);
            }
            when 'Per Hour' {
                venueCost = vendorOption.Fixed_Fee__c + (vendorOption.Variable_Cost_per_Unit__c * vendorOption.Num_Hours__c);
            }
        }
        return venueCost;
    }

    //Returns a Map of Wedding Id to Venue Account Record
    @TestVisible static Map<Id, Account> getWeddingToVenue(List<Vendor_Option__c> vendorOptions) {

        Map<Id, Account> venues = getVenueAccounts(vendorOptions);
        Map<Id, Account> weddingToVenue = new Map<Id, Account>();
        for (Vendor_Option__c vo : vendorOptions) {
            if (venues.containsKey(vo.Vendor_Account__c)) {
                weddingToVenue.put(vo.Wedding__c, venues.get(vo.Vendor_Account__c));
            }
        }
        return weddingToVenue;
    }    

    //Returns a Map of Venue Account Id to Venues
    @TestVisible static Map<Id, Account> getVenueAccounts(List<Vendor_Option__c> vendorOptions) {

        //Get Account Ids from Vendor Options 
        Set<Id> accountIds = new Set<Id>();
        for (Vendor_Option__c vo : vendorOptions) {
            accountIds.add(vo.Vendor_Account__c);
        }

        //Query Accounts from Vendor Options that are of type Venue
        Map<Id, Account> venues = new Map<Id, Account>(
            [SELECT Id FROM Account WHERE Id IN :accountIds AND RecordTypeId = :VENUE_RECORDTYPE]
        );
        return venues;
    }


}