import { LightningElement, track, wire, api } from 'lwc';
import indentLineItem from "@salesforce/apex/Ex_POController.returnIndentLineItem";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

const columns = [
    {
        label: 'Indent Line Item Number', fieldName: 'indentItemLink', type: 'url',
        typeAttributes: {
            label: { fieldName: 'Name' },
            target: '_blank'
        },
        sortable: true
    },
    {
        label: 'Material Name', fieldName: 'materialLink', type: 'url',
        typeAttributes: {
            label: { fieldName: 'Material_Name__c' },
            target: '_blank'
        },
        sortable: true
    },
    {
        label: 'Store', fieldName: 'storeLink', type: 'url',
        typeAttributes: {
            label: { fieldName: 'Store_Name__c' },
            target: '_blank'
        },
        sortable: true
    },
    { label: 'Requested Quantity', fieldName: 'Requested_Quantity__c' },
    { label: 'UOM', fieldName: 'UOM__c' },
    { label: 'Specification', fieldName: 'Specification__c' },
    { label: 'Lead Time Days', fieldName: 'Lead_Time_Days__c' },
];

export default class CreatePO extends NavigationMixin(LightningElement) {
    @track contactDataWrp;
    columns = columns;

    connectedCallback() {
        this.getIndetItemDetails();
    }

    getIndetItemDetails() {
        this.contactDataWrp = [];
        indentLineItem({}).then(data => {
            var templeadList = [];
            for (var i = 0; i < data.length; i++) {
                let tempRecord = Object.assign({}, data[i]); //cloning object  
                console.log(tempRecord);
                tempRecord.indentItemLink = "/" + tempRecord.Id;
                tempRecord.materialLink = "/" + tempRecord.Material__c;
                tempRecord.storeLink = "/" + tempRecord.Store__c;
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
//,[data-type="user-input3"],[data-type="user-input4"],[data-type="user-input5"],[data-type="user-input6"],[data-type="user-input7"]

    inputValue2;
    inputValue3;
    inputValue4;
    inputValue5;

    inputValue6;
    inputValue7;

    forrLop = [];
    handleCk() {
        const userInputs2 = this.template.querySelectorAll('[data-type="user-input2"] ');
        userInputs2.forEach(input => {
            this.inputValue2 = input.value;
            
        })
        const userInputs3 = this.template.querySelectorAll('[data-type="user-input3"] ');
        userInputs3.forEach(input => {
            this.inputValue3 = input.value;
            
        })
        const userInputs4 = this.template.querySelectorAll('[data-type="user-input4"] ');
        userInputs4.forEach(input => {
            this.inputValue4 = input.value;
            
        })
        const userInputs5 = this.template.querySelectorAll('[data-type="user-input5"] ');
        userInputs5.forEach(input => {
            this.inputValue5 = input.value;
            
        })
        const userInputs6 = this.template.querySelectorAll('[data-type="user-input6"] ');
        userInputs6.forEach(input => {
            this.inputValue6 = input.value;
            
        })
        const userInputs7 = this.template.querySelectorAll('[data-type="user-input7"] ');
        userInputs7.forEach(input => {
            this.inputValue7 = input.value;
            
        })

        console.log(this.inputValue2);
        console.log(this.inputValue3);
        console.log(this.inputValue4);
        console.log(this.inputValue5);
        console.log(this.inputValue6);
        console.log(this.inputValue7);
////////////////////////////////////////////////////////////////////////// 

        if(this.inputValue2 == null || this.inputValue3 == null || this.inputValue4 == null|| this.inputValue5 == null){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: 'Please enter all the required fields',
                    variant: 'error',
                    }),
                );
        }
        else if (this.inputValue6 == null || this.inputValue6 == 0 ) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: 'Please enter all the required fields',
                    variant: 'error',
                    }),
                );
        }
        else if (this.inputValue7 == null || this.inputValue7 == 0 ) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: 'Please enter all the required fields',
                    variant: 'error',
                    }),
                );
        }
        else{ 
            this.template.querySelector('[data-id="Green_Button"]').click();
        }

          
        
    }


}