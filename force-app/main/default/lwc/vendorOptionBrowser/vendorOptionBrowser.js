import { LightningElement, wire, track , api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getVendorOption from '@salesforce/apex/VendorWeddingController.getVendorOption';
import createVendor from '@salesforce/apex/VendorOptionCreate.vendorOptionAdd';
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
    rec = 
    {
        Vendor_Account__c : '',
        Wedding__c : ''
    }

    handleClick(event) {
        this.rec.Vendor_Account__c=event.detail
        this.rec.Wedding__c=this.recordId
        
        createVendor({ vendor : this.rec})
            .then(result => {
                this.message = result;
                this.error = undefined;
                if(this.message !== undefined) {
                  
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Account created',
                            variant: 'success',
                        }),
                    );
                }
                
                console.log(JSON.stringify(result));
                console.log("result", this.message);
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                console.log("error", JSON.stringify(this.error));
            });
    }



}
