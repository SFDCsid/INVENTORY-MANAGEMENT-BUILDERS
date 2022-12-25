import { LightningElement, track, wire, api} from 'lwc';
import bomRecords from '@salesforce/apex/Ex_createBOMController.bomRecords';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

const columns = [
    { label: 'BOM Name', fieldName: 'recordLink', type: 'url',
        typeAttributes: {label: { fieldName: 'Name' },  
        target: '_blank'},
        sortable: true },
    {
        label: 'Milestone Name', fieldName: 'milestoneLink', type: 'url',
        typeAttributes: {label: { fieldName: 'Milestone_Name__c' },  
        target: '_blank'},
        sortable: true  
    },  
    { label: 'Material', fieldName: 'MaterialLink', type: 'url',
        typeAttributes: {label: { fieldName: 'Material_Name__c' },  
        target: '_blank'},
        sortable: true 
    },
    { label: 'Important Specification', fieldName: 'Important_Specification__c'},
    { label: 'Description', fieldName: 'Description__c'},
    { label: 'Required Quantity', fieldName: 'Required_Quantity__c'},
    { label: 'UOM', fieldName: 'UOM__c'},
    { label: 'Lead Time Days', fieldName: 'Lead_Time_Days__c'},
    { label: 'Requisition Quantity', fieldName: 'Requisition_Quantity__c'},
    { label: 'Issued Quantity', fieldName: 'Issued_Quantity__c'}
];

export default class CreateBOM extends LightningElement {

    @track selectedMaster;
    @track contactDataWrp;
    columns = columns;
    @track itemList = [{ id: 0, Milestone__c: null}];
    @track blankRow = [];
    @track index = 0;
    keyIndex = 0;
    @wire(getRecord, { recordId: '$selectedMaster', fields: [ MASTER_NAME_FIELD] })
    savedRecordIdWire({error,data}) {
        if(data){
            this.masterName = data.fields.Name.value;
        }else if(error){
            window.alert(JSON.stringify(error));
        }
    }

    handleMasterId(event){
        let MasterId = event.detail.value[0];
        console.log('master id: '+ MasterId);
        
        if(MasterId !== undefined){
            this.selectedMaster = MasterId;
            this.contactDataWrp = [];
            bomRecords({mpId : this.selectedMaster}).then(data => {
                var templeadList = [];  
                for (var i = 0; i < data.length; i++) {  
                    let tempRecord = Object.assign({}, data[i]); //cloning object  
                    console.log(tempRecord);
                    tempRecord.recordLink = "/" + tempRecord.Id;  
                    tempRecord.MaterialLink = "/"+ tempRecord.Material__c;
                    tempRecord.milestoneLink = "/"+ tempRecord.Milestone__c;
                    templeadList.push(tempRecord);  
                }  
                this.contactDataWrp = templeadList;
            }).catch(error => {
                console.log(error);
            })
        }
    }
    
    addRow() {
        ++this.keyIndex;
        var newItem = [{ id: this.keyIndex, Milestone__c: this.selectedMaster}];//
        this.itemList = this.itemList.concat(newItem);
        console.log('item list size: '+ itemList.length);
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
                if(element.id != 'first-46' && element.id == ''){
                    console.log('element id: '+element.id);
                    element.submit();
                    
                 }
            });
            this.navigateToViewMilestonePage();
        //}
    }
    navigateToViewMilestonePage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.selectedMaster,
                objectApiName: 'Milestone__c',
                actionName: 'view'
            },
        });
    }
    /*handleMasterId(event){
        let MasterId = event.detail.value[0];
        if(MasterId !== undefined){
            this.selectedMaster = MasterId;
            this.contactDataWrp = [];
            bomRecords({mpId : MasterId}).then(result => {
                this.contactDataWrp = result;
                this.index = result.length;
            }).catch(error => {
                console.log(error);
            })
        }else{
           this.blankRow = []; 
           this.index = 0;
           this.contactDataWrp = [];
        }
    }*/
}