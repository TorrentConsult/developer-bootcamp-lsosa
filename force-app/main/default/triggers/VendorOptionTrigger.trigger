/* ------------ Used in Writing Apex Triggers Live Session ------------ */

trigger VendorOptionTrigger on Vendor_Option__c (before insert, before update) {

    VendorOptionTriggerHandler handler = new VendorOptionTriggerHandler(trigger.new, trigger.oldMap);

    switch on Trigger.operationType {
        when BEFORE_INSERT {                /* Writing Trigger Session */
            handler.beforeInsert();
        }
        when BEFORE_UPDATE {                /* Writing Trigger Session */
            handler.beforeUpdate();
        }                  
    } 

}