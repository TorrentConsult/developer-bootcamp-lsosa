import { LightningElement, api } from 'lwc';

export default class VendorOptionItem extends LightningElement {

    @api 
    vendor = {Name: ''};
    iconStyle='';

    if(vendor.hasOwnProperty('Vendor_Options__r'))
    {
        iconStyle='action:approval';
    }
    else
    {
    iconStyle='action:delete';
    }

    handleSelection() {
        const selectEvent = new CustomEvent('vendorselected', {
            detail: this.vendor.Name
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