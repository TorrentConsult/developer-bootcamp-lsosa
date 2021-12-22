import { LightningElement, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi'; /* Wire adapter to fetch record data */
import WEDDING_OBJECT from '@salesforce/schema/Wedding__c';
import MEALOPTION_FIELD from '@salesforce/schema/Wedding__c.Meal_Option__c';

export default class WeddingDetailLDS extends LightningElement {
    recordId = 'a003t00000mqTOZAA2';
    objectApiName = WEDDING_OBJECT;
    mealOption = false;
    @wire(getRecord, { recordId: '$recordId', fields: [MEALOPTION_FIELD] })
    wiredWedding({ error, data }) {
        if (data) {
            this.mealOption = data.fields.Meal_Option__c.value;
        } else if (error) {
            // Do something with the error
        }
    }
 }
 