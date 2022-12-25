import { LightningElement, wire, track, api } from 'lwc';
import MilestoneMethod from '@salesforce/apex/requisitionclass.MilestoneMethod';
import BillMethod from '@salesforce/apex/requisitionclass.BillMethod';

import NAME_FIELD from '@salesforce/schema/Milestone__c.Name';
import DURATION_FIELD from '@salesforce/schema/Milestone__c.Duration__c';
import STARTDATE_FIELD from '@salesforce/schema/Milestone__c.Start_Date__c';
import ENDDATE_FIELD from '@salesforce/schema/Milestone__c.End_Date__c';
import PROJECTMANAGER_FIELD from '@salesforce/schema/Milestone__c.Project_Manager__c';

import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import REQUISITION_OBJECT from '@salesforce/schema/Requisition_Entry__c';
import REQUISITION_BILL from '@salesforce/schema/Requisition_Entry__c.Bill_Of_Material__c';
import REQUISITION_MATERIAL from '@salesforce/schema/Requisition_Entry__c.Material__c';
import REQUISITION_STORE from '@salesforce/schema/Requisition_Entry__c.Store__c';
import REQUISITION_QUANTITY from '@salesforce/schema/Requisition_Entry__c.Requisition_Quantity__c';
import REQUISITION_ISSUED from '@salesforce/schema/Requisition_Entry__c.Issued_Quantity__c';


import { NavigationMixin } from 'lightning/navigation';

export default class RequisitionForm extends NavigationMixin(LightningElement) {



    fieldValue;
    billofMaterials;
    requisitionQuantity;
    issuedQuantity;
    storeVar;
    materialVar;
    contactId;


    handleChange(event) {

        this.fieldValue = event.target.value;
        if (event.target.label === "Bill Of Material" && this.fieldValue !== '' && this.fieldValue !== undefined)
            this.billofMaterials = this.fieldValue;
        else if (event.target.label === "Requisition Quantity" && this.fieldValue !== '' && this.fieldValue !== undefined)
            this.requisitionQuantity = this.fieldValue;
        else if (event.target.label === "Issued Quantity" && this.fieldValue !== '' && this.fieldValue !== undefined)
            this.issuedQuantity = this.fieldValue;
        else if (event.target.label === "Store" && this.fieldValue !== '' && this.fieldValue !== undefined)
            this.storeVar = this.fieldValue;
        else if (event.target.label === "Material" && this.fieldValue !== '' && this.fieldValue !== undefined)
            this.materialVar = this.fieldValue;

        console.log('bill' + this.billofMaterials);
    }

    createContact() {

        console.log('this.billofMaterials' + this.billofMaterials);
        const FIELDS = {};
        FIELDS[REQUISITION_BILL.fieldApiName] = this.billofMaterials;
        FIELDS[REQUISITION_MATERIAL.fieldApiName] = this.materialVar;
        FIELDS[REQUISITION_STORE.fieldApiName] = this.storeVar;
        FIELDS[REQUISITION_QUANTITY.fieldApiName] = this.requisitionQuantity;
        FIELDS[REQUISITION_ISSUED.fieldApiName] = this.issuedQuantity;

        const contactRecord = { apiName: REQUISITION_OBJECT.objectApiName, fields: FIELDS };
        createRecord(contactRecord)
            .then(contact => {
                this.contactId = contact.id;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'REQUISITION CREATED',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,//error.body.output.fieldErrors,
                        variant: 'error',
                    }),
                );
            });
    }


    ////////////////////////////////////////////////////////////////////////////
    rcId;
    @api recordId;

    //////////////////////////////////////////////////////////////////////////////////////////////////////


    billdata;

    handleClick() {
        this.areDetailsVisible = true;
        this.rcId = recordId;
        console.log('rccid' + JSON.stringify(this.rcId));
    }

    @track milestoneId = 'a0A2w00000gv1s0EAA';
    @track milestonedata;
    @track Namemile;
    @track StartDate;
    @track EndDate;
    @track ProjectManager;
    @track Duration;


    @wire(MilestoneMethod, { Id: '$milestoneId' })
    wiredContacts({ data, error }) {
        if (data) {
            this.milestonedata = data;
            this.Namemile = data[0].Name;
            this.StartDate = data[0].Start_Date__c;
            this.EndDate = data[0].End_Date__c;
            this.ProjectManager = data[0].Project_Manager__c;
            this.Duration = data[0].Duration__c;
            console.log(JSON.stringify(this.milestonedata));
            console.log(this.StartDate);
            console.log(this.EndDate);
            console.log(this.ProjectManager);
            console.log(this.Duration);
            console.log(this.Namemile);
            console.log('rid' + JSON.stringify(this.recordId));
            this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.milestonedata = undefined;
        }
    }


    @wire(BillMethod, { Id: '$recordId' })
    billDetails({ data, error }) {
        if (data) {
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
    fields = [NAME_FIELD, STARTDATE_FIELD, ENDDATE_FIELD, PROJECTMANAGER_FIELD];




}