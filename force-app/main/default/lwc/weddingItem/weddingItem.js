import { LightningElement, api } from 'lwc';
export default class WeddingItem extends LightningElement {

    @api wedding = {name: ''};

    get upperCasedName() {
        return `${this.wedding.name} Wedding`.trim().toUpperCase();
    }

}