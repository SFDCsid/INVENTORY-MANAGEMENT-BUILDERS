import { LightningElement, track, wire, api } from 'lwc';
import recRecords from '@salesforce/apex/storeFormClass.recRecords';
const columns = [
    { label: 'Material', fieldName: 'Material_Name__c'},
    { label: 'Requisition Quantity', fieldName: 'Requisition_Quantity__c'}];
export default class StoreForm extends LightningElement {

    @track contactDataWrp;
    columns = columns;
    @track selectedMaster;
    

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

}


