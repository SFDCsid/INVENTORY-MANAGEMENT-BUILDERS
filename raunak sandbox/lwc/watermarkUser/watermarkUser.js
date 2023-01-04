import { LightningElement, wire, api } from 'lwc';
import getCurrentUser from '@salesforce/apex/getUser.getCurrentUser';

export default class WatermarkUser extends LightningElement {
    @api userData;
    
    @wire(getCurrentUser) getUser({data}){
        if(data){
            this.userData = data.repeat(10000);
            //console.log('userData:'+userData);
        }else{
            this.userData = undefined;
        }
    }   
}