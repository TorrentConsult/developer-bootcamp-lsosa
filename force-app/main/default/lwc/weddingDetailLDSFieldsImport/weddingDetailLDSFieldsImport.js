import { LightningElement } from 'lwc';
import WEDDING_OBJECT from '@salesforce/schema/Wedding__c';
import NAME_FIELD from '@salesforce/schema/Wedding__c.Name';
import STARTDATE_FIELD from '@salesforce/schema/Wedding__c.Start_Date__c';
import STATUS_FIELD from '@salesforce/schema/Wedding__c.Status__c';
import BUDGET_FIELD from '@salesforce/schema/Wedding__c.Budget__c';
import TOTALCOST_FIELD from '@salesforce/schema/Wedding__c.Total_Cost__c';

export default class WeddingDetailLDSFieldsImport extends LightningElement {

    objectApiName = WEDDING_OBJECT;
    fields = [NAME_FIELD, STARTDATE_FIELD, STATUS_FIELD, BUDGET_FIELD, TOTALCOST_FIELD];

}