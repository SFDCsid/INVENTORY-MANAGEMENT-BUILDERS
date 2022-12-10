import { LightningElement, wire, track, api } from 'lwc';
import updateTask from '@salesforce/apex/leadformClass.updateTask';
export default class LeadForm extends LightningElement {

@api recordId;

    value;
    visitdate;
    followupdate;
    description;

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
    }

    handleChange(event) {
        this.value = event.detail.value;
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

    onUpdateRecord(){
        updateTask({activityId:this.recordId , callStage:this.value ,  visitdate:this.visitdate , followupdate:this.followupdate , description:this.description})
        .then(resultUpdate => {
            this.newtrial = resultUpdate;
               console.log('resultUpdate'+JSON.stringify(resultUpdate));
        })
        .catch(error => {
            console.log('error'+JSON.stringify(error));
        })
    }


}



















