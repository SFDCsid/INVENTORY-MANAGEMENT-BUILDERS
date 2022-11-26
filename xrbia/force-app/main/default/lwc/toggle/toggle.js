import { LightningElement,wire } from 'lwc';
import userAPEX from '@salesforce/apex/TOOGLEAPEX.userAPEX';
export default class Toggle extends LightningElement {


    handleChange(event){
       console.log(event.target.checked);
       if(event.target.checked == true){
        UserInfo.getUserId = true;
       }
    
    }

@wire(userAPEX)
toggle({ error, data}){
    var usertoggle=[];
    if(data){
        alert('tog');
        this.usertoggle = data;
        console.log('usertoggle'+JSON.stringify(this.usertoggle.lwcActive__c));
    }
    
    else if (error) {
        this.data = undefined;
    }
   
}

}