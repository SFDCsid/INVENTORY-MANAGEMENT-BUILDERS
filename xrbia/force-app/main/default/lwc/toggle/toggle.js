import { LightningElement, wire, api } from 'lwc';
import userAPEX from '@salesforce/apex/TOOGLEAPEX.userAPEX';
import USERACTIVE_FIELD from '@salesforce/schema/User.lwcActive__c';

//import USER_OBJECT from "@salesforce/schema/User";
//import ID_FIELD from "@salesforce/schema/User.Id";
//import CHECKBOX_FIELD from "@salesforce/schema/User.lwcActive__c";
//import { updateRecord } from "lightning/uiRecordApi";

export default class Toggle extends LightningElement {

  
   // recordId = UserInfo.getUserId();
   // selectedFields = [USERACTIVE_FIELD];



/*
    checkUncheck;



    
       @api recordId;
        checKBox;
    
        handleChange(event) {
            // console.log('t'+event.target.checked);
            if (event.target.checked === true) {
                alert('t');
                this.checKBox = 'true';
                console.log('tf' + this.checKBox);
                const fields = {};
                fields[ID_FIELD.fieldApiName] = this.recordId;
                fields[CHECKBOX_FIELD.fieldApiName] = this.checKBox;
    
                const recordInput = {
                    fields: fields
                };
                updateRecord(recordInput).then((record) => {
                    console.log(record);
                });
            }
            if (event.target.checked === false) {
                alert('f');
                this.checKBox = 'false';
                console.log('tf' + this.checKBox);
                const fields = {};
                fields[ID_FIELD.fieldApiName] = this.recordId;
                fields[CHECKBOX_FIELD.fieldApiName] = this.checKBox;
    
                const recordInput = {
                    fields: fields
                };
                updateRecord(recordInput).then((record) => {
                    console.log(record);
                });
            }
    
        }*/


    /* ====================== TO GET CHECKBOX VALUE FRO SALESFORCE ======================= */
    
    userData;
    @wire(userAPEX)
    getuser({ error, data }) {


        if (data) {
           
            this.userData = data.lwcActive__c;
            console.log('userdata' + JSON.stringify(this.userData));

            if (this.userData == true) {
                console.log('true');
                this.checkUncheck = true;
             
            }
            if (this.userData == false) {
                console.log('false');
                this.checkUncheck = false;
               
            }
            
         

        }
        else if (error) {
            this.data = undefined;
        }


    }






}