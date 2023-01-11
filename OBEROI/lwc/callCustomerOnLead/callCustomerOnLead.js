import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import makeCalls from '@salesforce/apex/CallCustomerController.callAPI';
import mobileupdate from '@salesforce/apex/CallCustomerController.UpdateMobileOnLead';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const FIELDS = [
    'Lead.MobilePhone',
    'Lead.Other_Mobile_Number__c',
    'Lead.Country_Name_by_Code__c',
    'Lead.Country_Code__c'
];

export default class CallCustomerOnLead extends LightningElement {
    @api recordId;
    @track mobile1error = false;
    @track mobile2error = false;
    @track leadData;
    @track pos = null;
    @track showupdate = false;
    @track isLoaded = false;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    leadData;
    
    /* Display Mobile 1 on UI */
    get mobile1() {     
        if (this.leadData.data.fields.MobilePhone.value != null){
            window.console.log('mobileno'+this.leadData.data.fields.MobilePhone.value);
            return this.leadData.data.fields.Country_Code__c.value + ' ' + this.leadData.data.fields.MobilePhone.value.replace(this.leadData.data.fields.MobilePhone.value.substring(0, 5), 'XXXXX');
        }else{
        alert('mobile1:'+this.leadData.data.fields.MobilePhone.value);
            return null;
        }
    }

    /* Display Mobile 2 on UI */
    get mobile2() {
        // var actualmobile2 = this.leadData.data.fields.Phone.value;
        if (this.leadData.data.fields.Other_Mobile_Number__c.value != null)
            return this.leadData.data.fields.Other_Mobile_Number__c.value.replace(this.leadData.data.fields.Other_Mobile_Number__c.value.substring(0, 5), 'XXXXX')
        else
            return null;
    }
    handlemobChange(event) {
        this.mob = event.detail.value;
    }
    handleshowupdate(event) {
        this.showupdate = true;
    }
    handleUpdate(event) {
        this.isLoaded = true;
        if(this.mob != null && this.mob.length == 10){
            mobileupdate({
                RecId: this.recordId,
                Mobile: this.mob
            }).then(result => {
                refreshApex(this.leadData);
                const event = new ShowToastEvent({
                    title: 'Sucess',
                    variant: 'Success',
                    mode: 'dismissable', // Remains visible until the user clicks the close button or 3 seconds has elapsed, whichever comes first.
                    message: 'Mobile No Updated Sucessfully',
                });
                this.dispatchEvent(event);
                this.showupdate = false;
                this.mob = null;
                this.isLoaded = false;
            }).catch(error => {
                //    this.errorMsg = error;
                this.isLoaded = false;
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    mode: 'dismissable', // Remains visible until the user clicks the close button or 3 seconds has elapsed, whichever comes first.
                    message: 'Error occurred while calling:: ' + error,
                });
                this.dispatchEvent(event);
            })
        }else{
            this.isLoaded = false;
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                mode: 'dismissable', // Remains visible until the user clicks the close button or 3 seconds has elapsed, whichever comes first.
                message: 'Please Enter Valid Mobile Number',
            });
            this.dispatchEvent(event);
        }
        
    }
    /* Make call on Mobile 1 */
    callmobile1() {
        //  alert('mobile 1 method called');
        this.mobile1error = false;
        //  alert('dialing country 1: ' + this.leadData.data.fields.Dialing_Country_1__c.value);
        /* Validations */
       /* if (this.leadData.data.fields.Is_DND__c.value == true) {
            this.mobile1error = true;
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'Error',
                mode: 'sticky',
                message: 'Customer opted for DND',
            });
            this.dispatchEvent(event);
        }*/
        if (this.leadData.data.fields.Country_Name_by_Code__c.value == null) {
            this.mobile1error = true;
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'Error',
                mode: 'sticky',
                message: 'Dialing Country 1 is blank',
            });
            this.dispatchEvent(event);
        }
        if (this.leadData.data.fields.Country_Code__c.value == null) {
            this.mobile1error = true;
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'Error',
                mode: 'sticky',
                message: 'Country Code 1 is blank',
            });
            this.dispatchEvent(event);
        }
        if (this.leadData.data.fields.MobilePhone.value == null) {
            this.mobile1error = true;
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'Error',
                mode: 'sticky',
                message: 'Mobile 1 is blank',
            });
            this.dispatchEvent(event);
        }

        if (this.leadData.data.fields.Country_Name_by_Code__c.value != null && this.leadData.data.fields.Country_Name_by_Code__c.value == 'India') {
            if (this.leadData.data.fields.Country_Code__c.value != null && this.leadData.data.fields.Country_Code__c.value != '+91') {
                this.mobile1error = true;
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'Error',
                    mode: 'sticky',
                    message: 'For India, Country Code should be +91',
                });
                this.dispatchEvent(event);
            }
            if (this.leadData.data.fields.MobilePhone.value != null && this.leadData.data.fields.MobilePhone.value.length != 10) {
                this.mobile1error = true;
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'Error',
                    mode: 'sticky',
                    message: 'For India, Mobile 1 should be of 10 digit',
                });
                this.dispatchEvent(event);
            }
        }
          
        if (this.mobile1error == false) {
         //   alert('Calling API');
            makeCalls({
                customerPh: this.leadData.data.fields.MobilePhone.value,
                countryCode: this.leadData.data.fields.Country_Code__c.value
            })
                .then(result => {
                    //  this.status = result;
                    const event = new ShowToastEvent({
                        title: 'Information',
                        variant: 'info',
                        mode: 'dismissable', // Remains visible until the user clicks the close button or 3 seconds has elapsed, whichever comes first.
                        message: result,
                    });
                    this.dispatchEvent(event);
                })
                .catch(error => {
                    //    this.errorMsg = error;
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        mode: 'dismissable', // Remains visible until the user clicks the close button or 3 seconds has elapsed, whichever comes first.
                        message: 'Error occurred while calling:: ' + error,
                    });
                    this.dispatchEvent(event);
                })
        }
    }

    /* Make call on Mobile 2 */
    callmobile2() {
        this.mobile2error = false;
      //  alert('method 2 called');
      /*if (this.leadData.data.fields.Is_DND__c.value == true) {
        this.mobile1error = true;
        const event = new ShowToastEvent({
            title: 'Error',
            variant: 'Error',
            mode: 'sticky',
            message: 'Customer opted for DND',
        });
        this.dispatchEvent(event);
    }*/
        if (this.leadData.data.fields.Other_Mobile_Number__c.value != null) {
            if (this.leadData.data.fields.Country_Code__c.value == null) {
                this.mobile2error = true;
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'Error',
                    mode: 'sticky',
                    message: 'Dialing Country is blank',
                });
                this.dispatchEvent(event);
            }
            if (this.leadData.data.fields.Country_Code__c.value == null) {
                this.mobile2error = true;
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'Error',
                    mode: 'sticky',
                    message: 'Country Code is blank',
                });
                this.dispatchEvent(event);
            }

            if (this.leadData.data.fields.Country_Name_by_Code__c.value != null && this.leadData.data.fields.Country_Name_by_Code__c.value == 'India') {
                if (this.leadData.data.fields.Country_Code__c.value != null && this.leadData.data.fields.Country_Code__c!= '+91') {
                    this.mobile2error = true;
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'Error',
                        mode: 'sticky',
                        message: 'For India, Country Code 2 should be +91',
                    });
                    this.dispatchEvent(event);
                }
                if (this.leadData.data.fields.Other_Mobile_Number__c.value != null && this.leadData.data.fields.Other_Mobile_Number__c.value.length != 10) {
                    this.mobile2error = true;
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'Error',
                        mode: 'sticky',
                        message: 'For India, Mobile 2 should be of 10 digit',
                    });
                    this.dispatchEvent(event);
                }
            }
        }
     //   alert('calling API for mobile 2');
        if (this.mobile2error == false) {
          //  alert('calling API');
            makeCalls({
                customerPh: this.leadData.data.fields.Other_Mobile_Number__c.value,
                countryCode: this.leadData.data.fields.Country_Code__c.value
            })
                .then(result => {
                    //  this.status = result;
                    const event = new ShowToastEvent({
                        title: 'Information',
                        variant: 'info',
                        mode: 'dismissable', // Remains visible until the user clicks the close button or 3 seconds has elapsed, whichever comes first.
                        message: result,
                    });
                    this.dispatchEvent(event);
                })
                .catch(error => {
                    //    this.errorMsg = error;
                  //  alert('Inside mobile 2 error');
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        mode: 'dismissable', // Remains visible until the user clicks the close button or 3 seconds has elapsed, whichever comes first.
                        message: 'Error occurred while calling: ' + error,
                    });
                    this.dispatchEvent(event);
                })
        }
    }
}