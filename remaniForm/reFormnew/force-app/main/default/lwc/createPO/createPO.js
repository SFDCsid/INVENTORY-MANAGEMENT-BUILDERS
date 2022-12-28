import { LightningElement, track, wire, api } from 'lwc';
import indentLineItem from "@salesforce/apex/Ex_POController.returnIndentLineItem";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

const columns = [
    { label: 'Indent Line Item Number', fieldName: 'indentItemLink', type: 'url',
        typeAttributes: {label: { fieldName: 'Name' },  
        target: '_blank'},
        sortable: true },
    {
        label: 'Material Name', fieldName: 'materialLink', type: 'url',
        typeAttributes: {label: { fieldName: 'Material_Name__c' },  
        target: '_blank'},
        sortable: true  
    },  
    { label: 'Store', fieldName: 'storeLink', type: 'url',
        typeAttributes: {label: { fieldName: 'Store_Name__c' },  
        target: '_blank'},
        sortable: true 
    },
    { label: 'Requested Quantity', fieldName: 'Requested_Quantity__c'},
    { label: 'UOM', fieldName: 'UOM__c'},
    { label: 'Specification', fieldName: 'Specification__c'},
    { label: 'Lead Time Days', fieldName: 'Lead_Time_Days__c'},
];

export default class CreatePO extends NavigationMixin(LightningElement) {
    @track contactDataWrp;
    columns = columns;

    connectedCallback()
    {
        this.getIndetItemDetails();
    }

    getIndetItemDetails()
    {
        this.contactDataWrp = [];
        indentLineItem({}).then(data => {
                var templeadList = [];  
                for (var i = 0; i < data.length; i++) {  
                    let tempRecord = Object.assign({}, data[i]); //cloning object  
                    console.log(tempRecord);
                    tempRecord.indentItemLink = "/" + tempRecord.Id;  
                    tempRecord.materialLink = "/"+ tempRecord.Material__c;
                    tempRecord.storeLink = "/"+ tempRecord.Store__c;
                    templeadList.push(tempRecord);  
                }  
                this.contactDataWrp = templeadList;
            }).catch(error => {
                console.log(error);
            })
    }

///////////////////////////////////////////////////////////////////////////////////////////////////////////
@track itemList = [{ id: 0, Milestone__c: null }];
@track blankRow = [];
@track index = 0;
keyIndex = 0;

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

//////////////////////////////////////////////////////////////////////////////////////////////////
intendId;
handleSuccess(event) {
    console.log('intendid' + event.detail.id);
    this.intendId = event.detail.id;
    this.navigateToViewMilestonePage();
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Success',
            message: 'PO CREATED',
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
            objectApiName: 'Purchase_Order__c',
            actionName: 'home'
        },
    });
}
    
}