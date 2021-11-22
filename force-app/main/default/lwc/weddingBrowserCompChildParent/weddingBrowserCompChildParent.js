import { LightningElement } from 'lwc';
import { weddings as weddingData } from 'c/weddingData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class WeddingBrowserCompChildParent extends LightningElement {

    status = '';
    weddings = weddingData;
    selectedWedding = 'None Selected';

    handleChange(event) {
        this.weddings = weddingData.filter(function(wedding) {
            return wedding.status == event.target.value || event.target.value == ''
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