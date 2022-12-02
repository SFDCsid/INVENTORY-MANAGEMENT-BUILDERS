import { LightningElement } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/QUOTATION__c';
import NAME_FIELD from '@salesforce/schema/QUOTATION__c.Other_Charges_Gst__c';
import WEBSITE_FIELD from '@salesforce/schema/QUOTATION__c.Gst_Percentage__c';
import REGISTERATION_FIELD from '@salesforce/schema/QUOTATION__c.Gst_Percentage__c';
import STAMP_FIELD from '@salesforce/schema/QUOTATION__c.Stamp_Duty_Percentage__c';
import UNIT_FIELD from '@salesforce/schema/QUOTATION__c.Unit__c';
import REGISTERATIONCH_FIELD from '@salesforce/schema/QUOTATION__c.Registeration_Charges__c';
import AGGREE_FIELD from '@salesforce/schema/QUOTATION__c.Aggrement_Value__c';
	
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ChildRecord extends LightningElement {
    

    accountObject = ACCOUNT_OBJECT;
    nameField = NAME_FIELD;
    websiteField = WEBSITE_FIELD;
    registerationField = REGISTERATION_FIELD;
    stampField = STAMP_FIELD;
    unitField = UNIT_FIELD;
    regField = REGISTERATIONCH_FIELD;
    regimpField = AGGREE_FIELD;




    _title = 'Sample Title';
    message = 'Sample Message';
    variant = 'error';

    handleAccountCreated(event){
        const toast = new ShowToastEvent({
            title: 'Toast message',
            message: 'Toast Message',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(toast);
    }

   
}