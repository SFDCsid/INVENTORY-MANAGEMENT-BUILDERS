import { LightningElement,api, wire, track } from 'lwc';
import isChecked from '@salesforce/apex/whetherCheck.isChecked';

export default class ShowLeadData extends LightningElement {

    @api recordId;
    @track isCheck = false;
    
    @wire (isChecked,{ID:'$recordId'}) retrieveCheck({data,error}){
        let checkArray = [];
        if(data){
            for(let key in data){
                checkArray.push({label:data[key],value:key})
            }
            if(checkArray.length>0)
                this.isCheck = checkArray[0].label.IsConverted__c;
            //console.log(this.isCheck);
        }else if(error){
            this.result = undefined;
        }
    }
}