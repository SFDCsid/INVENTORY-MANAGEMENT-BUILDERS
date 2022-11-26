import { LightningElement , api , wire } from 'lwc';
import {getRecord , getFieldValue} from 'lightning/uiRecordApi';
import DRIVER_FIELD from '@salesforce/schema/Tracker__c.Driver__c';

const driverFields = [DRIVER_FIELD];

export default class DriverDetailForm extends LightningElement {

@api recordId

@wire(getRecord, { recordId: '$recordId' , fields:driverFields})
drivers;


get driverId(){
    return getFieldValue(this.drivers.data , DRIVER_FIELD)
}

}