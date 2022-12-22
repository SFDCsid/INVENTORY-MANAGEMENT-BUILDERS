import { LightningElement, wire, track, api } from 'lwc';
import MilestoneMethod from '@salesforce/apex/requisitionclass.MilestoneMethod';
import BillMethod from '@salesforce/apex/requisitionclass.BillMethod';

import NAME_FIELD from '@salesforce/schema/Milestone__c.Name';
import DURATION_FIELD from '@salesforce/schema/Milestone__c.Duration__c';
import STARTDATE_FIELD from '@salesforce/schema/Milestone__c.Start_Date__c';
import ENDDATE_FIELD from '@salesforce/schema/Milestone__c.End_Date__c';
import PROJECTMANAGER_FIELD from '@salesforce/schema/Milestone__c.Project_Manager__c';



import { NavigationMixin } from 'lightning/navigation';

export default class RequisitionForm extends NavigationMixin(LightningElement) {

    rcId;
    @api recordId;

    //////////////////////////////////////////////////////////////////////////////////////////////////////

    areDetailsVisible = false;
    billdata;

    handleClick(){
        this.areDetailsVisible = true;
        this.rcId = recordId;
        console.log('rccid'+JSON.stringify(this.rcId));
    }

    @track milestoneId = 'a0A2w00000gv1s0EAA';
    @track milestonedata;
    @track Namemile;
    @track StartDate;
    @track EndDate;
    @track ProjectManager;
    @track Duration;


    @wire(MilestoneMethod, {Id:'$milestoneId'})
    wiredContacts({data, error}){
        if(data){
            this.milestonedata = data;
            this.Namemile = data[0].Name;
            this.StartDate = data[0].Start_Date__c;
            this.EndDate = data[0].End_Date__c;
            this.ProjectManager = data[0].Project_Manager__c;
            this.Duration =  data[0].Duration__c;
            console.log(JSON.stringify(this.milestonedata));
            console.log(this.StartDate);
            console.log(this.EndDate);
            console.log(this.ProjectManager);
            console.log(this.Duration);
            console.log(this.Namemile);
            console.log('rid'+JSON.stringify(this.recordId));
            this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.milestonedata = undefined;
        }
    }


    @wire(BillMethod, {Id:'$recordId'})
    billDetails({data, error}){
        if(data){
            this.billdata = data;
          console.log(JSON.stringify(this.billdata));
            this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.billdata = undefined;
        }
    }

   // @api recordId = 'a0A2w00000gv1s0EAA';
   // @api objectApiName = Milestone__c;
    fields = [NAME_FIELD,  STARTDATE_FIELD , ENDDATE_FIELD, PROJECTMANAGER_FIELD];

    navigateToNewAccountPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Requisition_Entry__c',
                actionName: 'new'
            },
        });
    }

    handleSuccess() {

        alert('Requisition Created');

    }
}