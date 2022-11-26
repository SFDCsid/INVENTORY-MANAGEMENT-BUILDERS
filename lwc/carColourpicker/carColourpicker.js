/* eslint-disable no-console */
import { LightningElement, track, wire,api } from 'lwc';
import getLatestProperty from '@salesforce/apex/PropertyDetails.getLatestProperty';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { NavigationMixin} from 'lightning/navigation';
 
export default class MyPropertyResult extends NavigationMixin (LightningElement) {
    @track properties;
    @track propertiesFound;
    @track propid;
      
   
    @wire(getLatestProperty)
    wiredProperties({data,error}){
        if(data){
            this.properties = data;
            //this.propertiesFound = true;
        }
        else if(error){
            this.showToast('Error',error.body.message,'error');
           // this.propertiesFound = false;
        }
    }
    get propertiesFound() {
        if (this.properties) {
            return true;
        }
        return false;
    }
    showToast(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message:message,
            variant:variant,
        });  
        this.dispatchEvent(evt);  
    }
}