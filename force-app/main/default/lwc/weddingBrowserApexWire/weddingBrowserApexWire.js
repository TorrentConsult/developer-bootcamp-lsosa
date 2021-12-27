import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getWeddings from '@salesforce/apex/WeddingBrowserController.getWeddings';

export default class WeddingBrowserApexWire extends LightningElement {

    @track type = '';
    vendorOptions;
    selectedWedding = 'None Selected';

    @wire(getWeddings, { weddingType: '$type' })
    vendorOptionsData;

    handleChange(event) {
        this.weddings = this.weddingData.data.filter(function(wedding) {
            return wedding.Status__c == event.target.value || event.target.value == ''
        });   
    } 

    handleWeddingSelected(event) {
        this.selectedWedding = event.detail;
        this.showNotification('Selected', this.selectedWedding + ' Wedding has been selected', 'info');
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    get statusOptions() {
        return [
            { label: 'Show All Weddings', value: '' }, { label: 'Initial Planning', value: 'Initial Planning' }, 
            { label: 'Vendor Selection & Invitations', value: 'Vendor Selection & Invitations' },
            { label: 'Finalized', value: 'Finalized' }, { label: 'Completed', value: 'Completed' }, { label: 'Cancelled', value: 'Cancelled' }
        ];
    }

}