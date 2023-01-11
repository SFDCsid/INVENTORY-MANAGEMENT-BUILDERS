import { LightningElement,api } from 'lwc';

export default class Matrix extends LightningElement {
    @api

    lwcCompMethodDescription(messageFromAura){

        alert('messageFromAura :'+ messageFromAura);

        

    }
}