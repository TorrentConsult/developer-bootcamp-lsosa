import { LightningElement, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi'; /* Wire adapter to fetch record data */
import WEDDING_OBJECT from '@salesforce/schema/Wedding__c';
import MEALOPTION_FIELD from '@salesforce/schema/Wedding__c.Meal_Option__c';

export default class WeddingDetailLDSFieldsImportWire extends LightningElement {

    recordId = 'a003t00000mqTOZAA2';
    objectApiName = WEDDING_OBJECT;
    
    @wire(getRecord, { recordId: '$recordId', fields: [MEALOPTION_FIELD] })
    record;

    get mealOption() {
        return this.record.data ? getFieldValue(this.record.data, MEALOPTION_FIELD) : false;
    }
  
}