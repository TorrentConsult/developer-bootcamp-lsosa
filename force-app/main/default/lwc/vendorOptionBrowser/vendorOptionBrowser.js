import { LightningElement, wire, track , api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getVendorOption from '@salesforce/apex/VendorWeddingController.getVendorOption';
import createVendor from '@salesforce/apex/VendorOptionCreate.vendorOptionAdd';
import deleteVendor from '@salesforce/apex/VendorOptionCreate.vendorOptionDel';
import Vendor from '@salesforce/schema/ConferenceNumber.Vendor';
import RightSize from '@salesforce/schema/Dashboard.RightSize';

export default class VendorOptionBrowser extends LightningElement {
   
    @api recordId;
    @track Type = '';

    selectedVendor = 'None Selected';
    @wire( getVendorOption, { vendorType: '$Type' , weddingId: '$recordId' })
    vendorsData;

    get vendors() {
        if (this.Type) {
            return this.vendorsData.data.filter(vendor => {
                return vendor.Type == this.Type || vendor.Name == this.Type || vendor.ShippingCity == this.Type 
                /*
                ||vendor.hasOwnProperty('Vendor_Options__r')? vendor.Vendor_Options__r[0].Wedding__c  == this.Type :false 
                || (this.Type=='Unselected')?!vendor.hasOwnProperty('Vendor_Options__r'): false
                */
                
            });
        }
        return this.vendorsData.data ? this.vendorsData.data : [];      
    }


error;
   loadVendor() {
    getVendorOption({ Type: this.Type })
           .then(result => {
               this.vendors  = result;
           })
           .catch(error => {
               this.error = error;
           });
   }

   connectedCallback() {
    this.loadVendor();
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
        this.rec.Vendor_Account__c=event.detail.vendorId
        this.rec.Wedding__c=this.recordId
        

     if(!event.detail.recordId)
     {
        createVendor({ vendor : this.rec})
            .then(result => {
                this.message = result;
                this.error = undefined;
                if(this.message !== undefined) {
                  
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Vendor added to wedding ',
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
        else{
            this.rec.Id =event.detail.recordId.Id

            deleteVendor({ vendor : this.rec})
            .then(result => {
                this.message = result;
                this.error = undefined;
                if(this.message !== undefined) {
                  
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Vendor Deleted from wedding ',
                            variant: 'success',
                        }),
                    );
                }
        
                console.log(JSON.stringify(result));
                console.log("result", this.message);
                this.loadVendor();
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


   



}
