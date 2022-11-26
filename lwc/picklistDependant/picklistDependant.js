import { LightningElement, track } from 'lwc';

export default class PicklistDependant extends LightningElement {
    @track cardVisible = false;
    
    handleClick() {
        this.cardVisible = true;
    }

}