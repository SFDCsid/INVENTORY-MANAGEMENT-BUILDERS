import { LightningElement, wire, track, api } from 'lwc';
import updateTask from '@salesforce/apex/leadformRoswaltclass.updateTask';
export default class LeadFormroswalt extends LightningElement {

    @api recordId;

    value;
    visitdate;
    followupdate;
    description;



    Value

    newpicklistValue;



    areDetailsVisible = false;

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
            dateFoll.setCustomValidity("");
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

    onUpdateRecord() {
        updateTask({ activityId: this.recordId, callStage: this.newpicklistValue, visitdate: this.visitdate, followupdate: this.followupdate, description: this.description })
            .then(resultUpdate => {
                this.newtrial = resultUpdate;
                console.log('resultUpdate' + JSON.stringify(resultUpdate));
            })
            .catch(error => {
                console.log('error' + JSON.stringify(error));
            })






    }
}