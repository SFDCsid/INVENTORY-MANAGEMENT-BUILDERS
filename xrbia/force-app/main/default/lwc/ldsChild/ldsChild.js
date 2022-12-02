import { LightningElement , api } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/QUOTATION__c';
import AGGREMENT_VALUE from '@salesforce/schema/QUOTATION__c.Aggrement_Value__c';
import GRAND_TOTAL from '@salesforce/schema/QUOTATION__c.Grand_Total__c';
import GST_AMOUNT from '@salesforce/schema/QUOTATION__c.Gst_Amount__c';
import GST_PERCENTAGE from '@salesforce/schema/QUOTATION__c.Gst_Percentage__c';
import OTHER_CHARGES from '@salesforce/schema/QUOTATION__c.Other_Charges__c';
import OTHERCHARGES_GST from '@salesforce/schema/QUOTATION__c.Other_Charges_Gst__c';
import REGISTERATION_CHARGES from '@salesforce/schema/QUOTATION__c.Registeration_Charges__c';
import STAMPDUTY_AMOUNT from '@salesforce/schema/QUOTATION__c.Stamp_Duty_Amount__c';
import STAMPDUTY_PERCENTAGE from '@salesforce/schema/QUOTATION__c.Stamp_Duty_Percentage__c';
import UNIT_QUT from '@salesforce/schema/QUOTATION__c.Unit__c';
import NAME_QUT from '@salesforce/schema/QUOTATION__c.Name';
export default class LdsChild extends LightningElement {
    @api recordId = 'a095g000004NtFgAAK';


    accountObject = ACCOUNT_OBJECT;
    myFields = [AGGREMENT_VALUE, GRAND_TOTAL, GST_AMOUNT, GST_PERCENTAGE, OTHER_CHARGES, OTHERCHARGES_GST ,REGISTERATION_CHARGES ,STAMPDUTY_AMOUNT, STAMPDUTY_PERCENTAGE ,UNIT_QUT , NAME_QUT];

    handleAccountCreated(){
        // Run code when account is created.
    }
}