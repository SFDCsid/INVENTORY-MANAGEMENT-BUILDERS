import { LightningElement,api,track,wire } from 'lwc';
import getNumber from '@salesforce/apex/leadDetails.getNumber'; 

export default class CallActionForLead extends LightningElement {

    @api recordId = '00Q9D000004F2fvUAC';
    @api mobile;
    @api phone;
    @track getNumber;


    @wire (getNumber,{Id:'$recordId'}) retriveNumber ({data,error}){
        if(data){
            this.mobile = data[0].MobilePhone;
            this.phone = data[0].Phone;
            console.log(this.mobile);
        }else if(error){
            this.data = error;
        }
    }  

    callMobileNumber(){
        alert('in callMobileNumber');
    }
}