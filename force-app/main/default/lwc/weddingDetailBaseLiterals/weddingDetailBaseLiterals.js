import { LightningElement } from 'lwc';

export default class WeddingDetailBaseLiterals extends LightningElement {

    name = 'Connor-Young Wedding';
    weddingDate = 1617595200000;
    status = 'Initial Planning';
    budget = 25000;
    totalCost = 23700;
    pictureUrl = 'https://torrent-mom-config-dev-ed--c.visualforce.com/resource/1612796271000/wedding_icons/wedding-icons/png/050-camera.png';
    mealChoices = ['Chicken', 'Pasta', 'Salmon'];
    
    get upperCasedName() {
        return `${this.name} Wedding`.trim().toUpperCase();
    }
 
}