import { LightningElement, track, wire, api } from 'lwc';
import recRecords from '@salesforce/apex/storeFormClass.recRecords';
import materialMethod from '@salesforce/apex/storeFormClass.materialMethod';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns = [
    { label: 'Material', fieldName: 'materialName__c' },
    { label: 'Available Stock', fieldName: 'Available_Stock__c' },
    { label: 'Booked Quantity', fieldName: 'Booked_Quantity__c' },
    { label: 'Issued Quantity', fieldName: 'Issued_Quantity__c' }];
export default class StoreForm extends NavigationMixin(LightningElement) {

    @api materialId;
    @api searchKey;
    @track MasterId2;
    @track contactDataWrp;
    columns = columns;
    @track selectedMaster;
    @track itemList = [{ id: 0, Milestone__c: null }];
    @track blankRow = [];
    @track index = 0;
    keyIndex = 0;

    materialchange(event) {
        this.materialId = event.detail.value;
        this.searchKey = event.target.value;
        console.log('this.materialId' + this.searchKey);

    }


    speciVar;
    leadVar;
    uomVar;
    materialDetails;
    @wire(materialMethod, { accountName: '$searchKey' })
    wiredContacts({ data, error }) {
        if (data) {
            this.materialDetails = data;
            if (this.materialDetails.length !== 0) {
                console.log("sr");

                console.log('this.materialDetails' + JSON.stringify(this.materialDetails));
                if (this.materialDetails[0].UOM__c !== undefined) { this.uomVar = this.materialDetails[0].UOM__c; }
                else { this.uomVar = '' }

                if (this.materialDetails[0].Specifications__c !== undefined) 
                {  
                    this.speciVar = this.materialDetails[0].Specifications__c; }
                else { 
                this.speciVar = '' }

                if (this.materialDetails[0].Lead_Time_Days__c !== undefined) 
                {  
                    this.leadVar = this.materialDetails[0].Lead_Time_Days__c; }
                else { 
                this.leadVar = '' }
                
                
                console.log('this.uomVar' + this.uomVar);
            }


        }
        else if (error) {
            this.error = error;
            //  this.contacts = undefined;
        }
    }

    handleMasterId(event) {

        console.log('this.itemList' + JSON.stringify(this.itemList));
        let MasterId = event.detail.value[0];
        this.MasterId2 = event.detail.value[0];
        console.log('master id: ' + MasterId);

        if (MasterId !== undefined) {
            this.selectedMaster = MasterId;
            this.contactDataWrp = [];
            recRecords({ mpId: this.selectedMaster }).then(data => {
                var templeadList = [];
                for (var i = 0; i < data.length; i++) {
                    let tempRecord = Object.assign({}, data[i]); //cloning object  
                    console.log(tempRecord);
                    tempRecord.recordLink = "/" + tempRecord.Id;
                    tempRecord.MaterialLink = "/" + tempRecord.Material__c;
                    tempRecord.milestoneLink = "/" + tempRecord.Milestone__c;
                    templeadList.push(tempRecord);
                }
                this.contactDataWrp = templeadList;
                console.log('contactDataWrp: ' + JSON.stringify(this.contactDataWrp));


            }).catch(error => {
                console.log(error);
            })
        }
    }


    addRow() {
        ++this.keyIndex;
        var newItem = [{ id: this.keyIndex, Store__c: this.selectedMaster }];//
        this.itemList = this.itemList.concat(newItem);
        console.log('item list size: ' + itemList.length);
    }

    removeRow(event) {
        if (this.itemList.length >= 2) {
            this.itemList = this.itemList.filter(function (element) {
                return parseInt(element.id) !== parseInt(event.target.accessKey);
            });
        }
    }

    handleSubmit() {


        /*var isVal = true;
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            isVal = isVal && element.reportValidity();
        });
        if (isVal) {*/
        this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
            if (element.id != 'first-46' && element.id == '') {
                console.log('element id: ' + element.id);
                element.submit();

            }
        });



        //   this.navigateToViewMilestonePage();

        //}
    }
    intendId;
    handleSuccess(event) {
        console.log('intendid' + event.detail.id);
        this.intendId = event.detail.id;
        this.navigateToViewMilestonePage();
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'INDENT CREATED',
                variant: 'success',
            }),
        );

        setTimeout(() => {
            this.handleSubmit();
        }, 1000);

    }


    navigateToViewMilestonePage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Indent__c',
                actionName: 'home'
            },
        });
    }

    /*
    material;
    handlechange(event){
        this.material = event.target.value;
        console.log(  'this.material'  +this.material);
    }

    @wire(materialMethod, { ma: '$material' , value: '$value' })
    getsector({ error, data }) {
        let secarray = [];
        if (data) {
        
           
            this.sectorOptionList = secarray;
        }
        else if (error) {
            this.error = undefined;
        }


    }*/


}