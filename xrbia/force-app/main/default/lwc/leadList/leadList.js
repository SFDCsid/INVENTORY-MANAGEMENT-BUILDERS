import { LightningElement, track, wire, api } from 'lwc';

import unt from '@salesforce/apex/PRACTICECLASS.unt';
export default class LeadList extends LightningElement {

    leadlist
    @wire(unt, { Id: '$tower' }) 
    lead({error,data}){
      if(data){
        this.leadlist = data;
        console.log('this.leadlist'+JSON.stringify(this.leadlist));
      }
      else if(error){
        this.leadlist = undefined;
      }
    }
    
}