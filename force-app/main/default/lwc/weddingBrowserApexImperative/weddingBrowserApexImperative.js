import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getWeddings from '@salesforce/apex/WeddingBrowserController.getWeddings';

export default class WeddingBrowserApexImperative extends LightningElement {

    @track status = '';
    selectedWedding = 'None Selected';

    weddings;
    error;

    loadWeddings() {
        getWeddings({ weddingStatus: this.status })
            .then(result => {
                this.weddings = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    connectedCallback() {
        this.loadWeddings();
    }

    handleChange(event) {
        this.status = event.target.value;
        this.loadWeddings();
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