import { LightningElement } from 'lwc';
export default class WeddingEdit extends LightningElement {

    name = 'Connor-Young';
    weddingDate = '2021-04-05';
    status = 'Initial Planning';
    budget = 25000;
    totalCost = 23700;
    pictureUrl = 'https://torrent-mom-config-dev-ed--c.visualforce.com/resource/1612796271000/wedding_icons/wedding-icons/png/050-camera.png';
    mealChoices = ['Chicken', 'Pasta', 'Salmon'];
    
    get upperCasedName() {
        return `${this.name} Wedding`.trim().toUpperCase();
    }

    get mealChoiceOptions() {
        return [
            { label: 'Chicken', value: 'Chicken' }, { label: 'Pasta', value: 'Pasta' }, { label: 'Pork', value: 'Pork' }, { label: 'Ratatouille', value: 'Ratatouille' },
            { label: 'Salmon', value: 'Salmon' }, { label: 'Steak', value: 'Steak' }, { label: 'Stir Fry', value: 'Stir Fry' }, { label: 'Tilapia', value: 'Tilapia' }
        ];
    }

    get statusOptions() {
        return [
            { label: 'Initial Planning', value: 'Initial Planning' }, { label: 'Vendor Selection & Invitations', value: 'Vendor Selection & Invitations' },
            { label: 'Finalized', value: 'Finalized' }, { label: 'Completed', value: 'Completed' }, { label: 'Cancelled', value: 'Cancelled' }
        ];
    }

}