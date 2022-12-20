import { LightningElement, wire, track, api } from 'lwc';
import getData from '@salesforce/apex/leadformRoswaltclass.getData';

import updateTask from '@salesforce/apex/leadformRoswaltclass.updateTask';
import getStage from '@salesforce/apex/leadformRoswaltclass.getStage';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import Stage__c from '@salesforce/schema/Task.Stage__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class LeadFormroswalt extends LightningElement {

     visiblepicklist;

    @wire (getData ,{ activity: '$recordId' } ) 
    wiredgetData({data,error}){
        if (data) {
           
         this.visiblepicklist = data;
         
          console.log('visible'+JSON.stringify(this.visiblepicklist)); 
         
        } else if (error) {
            alert('nodata');
        console.log(error);
        }
   }


    @wire(getPicklistValues,{
        recordTypeId : '0129D000001ZNCxQAO',
        fieldApiName : Stage__c
    })
    PicklistValues;
    

    @api recordId;

    value;
    visitdate;
    followupdate;
    description;



    Value

    newpicklistValue;



    areDetailsVisible = false;
    picklistVisible = true;

    latestLabelvalues;

    handleClic(event){
        this.areDetailsVisible = true;
        this.latestLabelvalues = event.target.value;
        console.log(this.latestLabelvalues);
        
        const tast = new ShowToastEvent({
            title: 'Toast message',
            message: 'Toast Message',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    openClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();

        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();

        this.template.querySelector('.yesBtn').classList.add('dynamicCSS'); this.template.querySelector('.noBtn').classList.remove('dynamicCSS');

    }


    followClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("Date value is required");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();
        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();
    }


    callClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("Date value is required");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();
        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();

    }

    visitClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("Date value is required");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("Date value is required");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();
    }


    doneClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("Date value is required");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();
    }


    bookedClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();

        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();

    }


    switchoffClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();

        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();

    }


    notreachableClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();

        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();

    }
    busyClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();

        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();

    }
    ringingClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();

        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();

    }
    ofnClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();

        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();

    }
    niClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();

        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();

    }
    avClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();

        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();

    }
    lostClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();

        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();

    }
    othersClick(event) {
        this.newpicklistValue = event.target.label;
        this.areDetailsVisible = true;

        let dateFoll = this.template.querySelector(".dateFoll");
        let dfValue = dateFoll.value;

        if (!dfValue) {
            dateFoll.setCustomValidity("");
        } else {
            dateFoll.setCustomValidity("");
        }
        dateFoll.reportValidity();

        let dateCmp = this.template.querySelector(".dateCmp");
        let dtValue = dateCmp.value;

        if (!dtValue) {
            dateCmp.setCustomValidity("");
        } else {
            dateCmp.setCustomValidity("");
        }
        dateCmp.reportValidity();
    }



    cancelRecord() {
        this.areDetailsVisible = false;
    }

    handleClick(event) {
        this.areDetailsVisible = true;
    }


    /*
    get options() {
        return [

           

            
             { label: 'Open', value: 'Open' },
             { label: 'Follow-up	', value: 'Follow-up' },
             { label: 'Call Back', value: 'Call Back' },
             { label: 'Visit Scheduled', value: 'Visit Scheduled' },
             { label: 'Visit Done', value: 'Visit Done' },
             { label: 'Booked', value: 'Booked' },
             { label: 'Switched Off', value: 'Switched Off' },
             { label: 'Not Reachable', value: 'Not Reachable' },
             { label: 'Busy', value: 'Busy' },
             { label: 'Out of Network', value: 'Out of Network' },
             { label: 'Not Interested', value: 'Not Interested' },
             { label: 'Already Visited', value: 'Already Visited' },
             { label: 'Lost', value: 'Lost' },
             { label: 'Others', value: 'Others' },
             { label: 'DND', value: 'DND' },
             { label: 'Prospect', value: 'Prospect' },
             { label: 'Tentative Hold', value: 'Tentative Hold' },
             { label: 'Booking Done', value: 'Booking Done' },
             { label: 'Booking Cancelled', value: 'Booking Cancelled' },
             { label: 'Low Budget', value: 'Low Budget' },
 
        ];
    }*/

    handleChange(event) {
        // this.value = event.detail.value;
    }
    visitdateChange(event) {
        this.visitdate = event.detail.value;
    }
    followupdateChange(event) {
        this.followupdate = event.detail.value;
    }
    descriptionChange(event) {
        this.description = event.detail.value;
    }


    newtrial;

    stringtaskStage=JSON.stringify(this.taskStage);

    onUpdateRecord() {
        updateTask({ activityId: this.recordId, callStage: this.latestLabelvalues, visitdate: this.visitdate, followupdate: this.followupdate, description: this.description })
            .then(resultUpdate => {
                this.newtrial = resultUpdate;
                console.log('resultUpdate' + JSON.stringify(resultUpdate));
                console.log('stringtaskStage' + this.latestLabelvalues);
            })
            .catch(error => {
                console.log('error' + JSON.stringify(error));
            })
            const event = new ShowToastEvent({
                title: 'Task Created',
                message: 'Task Created',
                variant: 'success',
                mode: 'dismissable'
                
            });
            this.dispatchEvent(event);
            this.areDetailsVisible = false;
            this.picklistVisible = false;

    }

    @track occStage = [];
    @track value = '';
    @track taskStage = [];

    get options() {
        return this.taskStage;
    }


    connectedCallback() {
        getStage({activityId: this.recordId})
        
            .then(result => {
                let arr = [];
               let newarr = [];

                for (var i = 0; i < result.length; i++) {
                    arr.push({ label: result[i].Stage__c, value: result[i].Id })
                }
                this.occStage = arr;
                console.log('occ' + JSON.stringify(this.occStage));
                console.log('picl'+JSON.stringify(this.PicklistValues.data.values[0].label));

                for(var i=0 ; i<this.PicklistValues.data.values.length ; i++){
                    console.log(this.PicklistValues.data.values[i].label);
                    newarr.push({ label: this.PicklistValues.data.values[i].label })
                }
               this.taskStage = newarr;
               console.log('taskStage' + JSON.stringify(this.taskStage));

            })
    }

    

}