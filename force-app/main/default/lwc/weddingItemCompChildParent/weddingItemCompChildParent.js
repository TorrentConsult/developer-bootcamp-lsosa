import { LightningElement, api } from 'lwc';

export default class WeddingItemCompChildParent extends LightningElement {

    @api wedding = {name: ''};

    handleSelection() {
        const selectEvent = new CustomEvent('weddingselected', {
            detail: this.wedding.name
        });
        this.dispatchEvent(selectEvent);
    }

    get upperCasedName() {
        return `${this.wedding.name} Wedding`.trim().toUpperCase();
    }
    
}