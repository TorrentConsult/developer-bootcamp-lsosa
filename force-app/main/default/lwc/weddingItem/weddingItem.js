import { LightningElement } from 'lwc';
export default class WeddingItem extends LightningElement {

    wedding = {name: ''};

    get upperCasedName() {
        return `${this.wedding.name} Wedding`.trim().toUpperCase();
    }

}