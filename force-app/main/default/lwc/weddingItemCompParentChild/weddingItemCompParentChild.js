import { LightningElement, api } from 'lwc';

export default class WeddingItemCompParentChild extends LightningElement {

    @api wedding = {name: ''};

    get upperCasedName() {
        return `${this.wedding.name} Wedding`.trim().toUpperCase();
    }

}