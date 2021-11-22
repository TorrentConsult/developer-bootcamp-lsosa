/* ------------ Used in Writing Apex Triggers Live Session ------------ */

public inherited sharing class VendorOptionTriggerHandler {

    @TestVisible static Boolean bypassTrigger = false; 

    final List<Vendor_Option__c> newRecords;
    final Map<Id, Vendor_Option__c> oldMap;

    public VendorOptionTriggerHandler(List<Vendor_Option__c> newRecords, Map<Id, Vendor_Option__c> oldMap) {
        this.newRecords = newRecords;
        this.oldMap = oldMap;
    }

    /* 
     * Only run logic for Vendor Options that are inserted if their
     * Vendor Status is set to Selected
	*/
    public void beforeInsert() {
        if (bypassTrigger) return;

        List<Vendor_Option__c> selectedVendorOptions = new List<Vendor_Option__c>();
        for (Vendor_Option__c vo : newRecords) {
            if (vo.Vendor_Status__c == 'Selected') {
                selectedVendorOptions.add(vo);
            }
        }
        VendorOptionValidateService.validateVendorContacts(selectedVendorOptions);
    }

    /* 
     * Only run logic for Vendor Options that are updated if their
     * Vendor Account or Vendor Status has changed and Vendor Status
     * is set to Selected
	*/
    public void beforeUpdate() {
        if (bypassTrigger) return;

        List<Vendor_Option__c> selectedVendorOptions = new List<Vendor_Option__c>();
        for (Vendor_Option__c vo : newRecords) {
            if ((vo.Vendor_Account__c != oldMap.get(vo.Id).Vendor_Account__c || 
                    vo.Vendor_Status__c != oldMap.get(vo.Id).Vendor_Status__c) && 
                    vo.Vendor_Status__c == 'Selected') {
                selectedVendorOptions.add(vo);
            }
        }
        VendorOptionValidateService.validateVendorContacts(selectedVendorOptions);
    }

}