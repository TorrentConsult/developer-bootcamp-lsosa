import { LightningElement } from 'lwc';
import { weddings as weddingData} from 'c/weddingData';
export default class WeddingBrowser extends LightningElement {

    status = '';
    weddings = weddingData;
    handleChange(event) {
        this.weddings = weddingData.filter(function(wedding) {
            return wedding.status == event.target.value || event.target.value == ''
        });   
    }

    get statusOptions() {
        return [
            { label: 'Show All Weddings', value: '' }, { label: 'Initial Planning', value: 'Initial Planning' },
            { label: 'Vendor Selection & Invitations', value: 'Vendor Selection & Invitations' },
            { label: 'Finalized', value: 'Finalized' }, { label: 'Completed', value: 'Completed' }, { label: 'Cancelled', value: 'Cancelled' }
        ];
    }

}