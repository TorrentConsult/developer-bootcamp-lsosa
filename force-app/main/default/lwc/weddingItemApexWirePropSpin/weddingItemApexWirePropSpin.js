import { LightningElement, api } from 'lwc';

export default class WeddingItemApexWirePropSpin extends LightningElement {

    @api wedding = {Name: ''};
    spinner = true;

    handleLoad() {
        this.spinner = false;
    }

    handleSelection() {
        const selectEvent = new CustomEvent('weddingselected', {
            detail: this.wedding.Name
        });
        this.dispatchEvent(selectEvent);
    }

    get upperCasedName() {
        return this.truncate(`${this.wedding.Name}`.trim().toUpperCase(), 32);
    }

    get mealOption() {
        return this.wedding.Meal_Option__c;
    }

    get mealChoices() {
        return (this.wedding.Meal_Choices__c ? this.wedding.Meal_Choices__c.split(',') : '');
    }
    
    truncate(str, maxlength) {
        return (str.length > maxlength) ? str.slice(0, maxlength - 1) + '…' : str;
    }

}