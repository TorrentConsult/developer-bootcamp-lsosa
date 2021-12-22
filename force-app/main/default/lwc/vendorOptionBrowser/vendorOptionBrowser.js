
import { LightningElement, wire, track , api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getVendorOption from '@salesforce/apex/VendorWeddingController.getVendorOption';
export default class VendorOptionBrowser extends LightningElement {
   
    @api recordId;
    @track Type = '';
    selectedVendor = 'None Selected';
    @wire( getVendorOption, { vendorType: '$Type' , weddingId: '$recordId' })
    vendorsData;

    get vendors() {
        if (this.Type) {
            return this.vendorsData.data.filter(vendor => {
                return vendor.Type == this.Type
            });
        }
        return this.vendorsData.data ? this.vendorsData.data : [];      
    }


    handleChange(event) {
       this.Type=event.target.value;
    } 

    handleVendorSelected(event) {
        this.selectedVendor = event.detail;
        this.showNotification('Selected', this.selectedVendor + ' Vendor has been selected', 'info');
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }



}
