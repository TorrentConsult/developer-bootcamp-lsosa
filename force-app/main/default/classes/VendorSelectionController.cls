/* ------------ Used in Apex Classes and Methods Live Session ------------ */

public with sharing class VendorSelectionController {
    
    public List<VendorWrapper> vendorWrapper;

    public List<Account> getSelectedVendors() {
        List<Account> vendors = new List<Account>();
        for (VendorWrapper vw : vendorWrapper) {
            if (vw.selected == true) {
                vendors.add(vw.vendor);
            }
        }
        return vendors;
    }

    public class VendorWrapper {
        public Boolean selected;
        public Account vendor;
        public VendorWrapper(Boolean selected, Account vendor) {
            this.selected = selected;
            this.vendor = vendor;
        }
    }

    public static void run() {
        VendorSelectionController con = new VendorSelectionController();
        VendorSelectionController.VendorWrapper vw1 = new VendorSelectionController.VendorWrapper(
            true, new Account(Name = 'Torrent Consulting')
        );
        VendorSelectionController.VendorWrapper vw2 = new VendorSelectionController.VendorWrapper(
            false, new Account(Name = 'Salesforce')
        );
        con.vendorWrapper = new List<VendorSelectionController.VendorWrapper>{vw1, vw2};

        System.debug(con.vendorWrapper);        //Get All Vendors
        System.debug(con.getSelectedVendors()); //Get Selected Vendor Accounts
    }

}