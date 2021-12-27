import { LightningElement, api } from 'lwc';

export default class VendorOptionItem extends LightningElement {

    @api vendor = {Name: ''};
    
    get iconStyle()
    {
        return(this.vendor.hasOwnProperty('Vendor_Options__r')?'utility:delete':'action:approval')
     
    }

    get iconStyleAfter()
    {
        return(this.vendor.hasOwnProperty('Vendor_Options__r')?'utility:add':'utility:delete')
     
    }

    detailsOptions = {vendorId:'', recordId:''};
    
    handleSelection(event) {
        this.detailsOptions.vendorId=this.vendor.Id;
        this.detailsOptions.recordId=this.vendor.hasOwnProperty('Vendor_Options__r')? this.vendor.Vendor_Options__r[0] :null
      

        const selectEvent = new CustomEvent('vendorselected', {
            detail: this.detailsOptions
           
        });
        this.dispatchEvent(selectEvent);
          event.target.iconName=this.iconStyleAfter;
          
    }

    get upperCasedName() {
        return this.truncate(`${this.vendor.Name}`.trim().toUpperCase(), 32);
    }


    truncate(str, maxlength) {
        return (str.length > maxlength) ? str.slice(0, maxlength - 1) + '…' : str;
    }



}