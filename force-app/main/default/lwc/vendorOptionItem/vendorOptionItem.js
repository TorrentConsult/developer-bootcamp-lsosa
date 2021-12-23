import { LightningElement, api } from 'lwc';

export default class VendorOptionItem extends LightningElement {

    @api vendor = {Name: ''};
    
    get iconStyle()
    {
        return(this.vendor.hasOwnProperty('Vendor_Options__r')?'utility:delete':'utility:add')
     
    }


    handleSelection() {
        const selectEvent = new CustomEvent('vendorselected', {
            detail: this.vendor.Id,
            isInsert: (this.vendor.hasOwnProperty('Vendor_Options__r'))?false:true
        });
        this.dispatchEvent(selectEvent);
    }

    get upperCasedName() {
        return this.truncate(`${this.vendor.Name}`.trim().toUpperCase(), 32);
    }


    truncate(str, maxlength) {
        return (str.length > maxlength) ? str.slice(0, maxlength - 1) + '…' : str;
    }



}