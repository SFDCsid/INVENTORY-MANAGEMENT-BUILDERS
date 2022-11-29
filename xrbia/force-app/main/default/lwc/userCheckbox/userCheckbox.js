import { LightningElement , track , api , wire } from 'lwc';
import userAPEX from '@salesforce/apex/checkBox.userAPEX';
import ID_FIELD from '@salesforce/schema/User.Id';
import CHECKBOX_FIELD from '@salesforce/schema/User.lwcActive__c';
import { updateRecord } from 'lightning/uiRecordApi';
export default class UserCheckbox extends LightningElement {
    idValue;
    checkBox;
    checked;


    handleToggle(event) {
       
       // this.idValue = '0055g00000H28FzAAJ';
        this.checkBox = event.target.checked;
       console.log('cb'+this.checkBox);

       

        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.idValue;
        fields[CHECKBOX_FIELD.fieldApiName] = this.checkBox;
        console.log('objfields' + JSON.stringify(fields));

       

        const recordInput = { fields };
        updateRecord(recordInput)
            .then(result => { console.log('result' + JSON.stringify(result)) })
            .catch(error => { console.log('error' + JSON.stringify(error)) })

           

    }


    userData;
    @wire(userAPEX)
    getuser({ error, data }) {


        if (data) {
           
            this.userData = data.lwcActive__c;
            this.idValue = data.Id;
            console.log('userdata' + JSON.stringify(this.idValue));

            if (this.userData == true) {
                console.log('true');
                this.checked = true;
             
            }
            if (this.userData == false) {
                console.log('false');
                this.checked = false;
               
            }
            
         

        }
        else if (error) {
            this.data = undefined;
        }


    }




}