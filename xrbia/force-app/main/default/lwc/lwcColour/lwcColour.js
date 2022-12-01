import { LightningElement , track } from 'lwc';

export default class LwcColour extends LightningElement {

    handleClick1(){
        var divblock = this.template.querySelector('[data-id="divblock"]');
        if(divblock){
            this.template.querySelector('[data-id="divblock"]').className='class1';
        }        
    }
    handleClick2(){
        var divblock = this.template.querySelector('[data-id="divblock"]');
        if(divblock){
            this.template.querySelector('[data-id="divblock"]').className='class2';
        }
    }
}