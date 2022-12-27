import { LightningElement, track, wire, api } from 'lwc';
import recRecords from '@salesforce/apex/storeFormClass.recRecords';
import { getRecord } from 'lightning/uiRecordApi';
const columns = [
    { label: 'Material', fieldName: 'materialName__c'},
    { label: 'Available Stock', fieldName: 'Available_Stock__c'},
    { label: 'Booked Quantity', fieldName: 'Booked_Quantity__c'},
    { label: 'Issued Quantity', fieldName: 'Issued_Quantity__c'}];
export default class StoreForm extends LightningElement {

    @track contactDataWrp;
    columns = columns;
    @track selectedMaster;
    @track itemList = [{ id: 0, Milestone__c: null }];
    @track blankRow = [];
    @track index = 0;
    keyIndex = 0;
    

    handleMasterId(event) {

        let MasterId = event.detail.value[0];
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
    handleSuccess(event){
        console.log('intendid'+event.detail.id);
        this.intendId = event.detail.id;
        
      setTimeout(() => {
         this.handleSubmit();
        }, 1000);
       
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


