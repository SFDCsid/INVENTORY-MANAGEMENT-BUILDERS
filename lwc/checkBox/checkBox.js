import { LightningElement } from 'lwc';

export default class PricingInformation extends LightningElement {




    bTon = true;
    bbTon = true;
    bdTon = true;
    inField = true;
    outField = true;
    nextTon = true;
    neTon = true;
    capAmo = true;
    textField = true;
    teField = true;
    tField = true;
    addAmo = true;
    tddField = true;
    addAmo = true;
    


    inOut() {
var checkboxes = document.getElementById('cb1');
console.log('checkboxcheck',checkboxes.checked);
    }

/* buttonHandler() {

     var selectedCheck =  this.template.querySelector("text-input-id-46");

     console.log('sel'+selectedCheck);

     const arr = selectedCheck.getSelectedRows()
     console.log('arr'+arr);

     var len = arr.length;
     console.log('length' + len);

 }*/

ePrice() {
    this.bTon = false;
    this.bbTon = false;
    this.bdTon = false;


}

inOut() {
    this.inField = false;
}


/*seCond() {
    this.outField = false;
}*/

newPrice() {
    this.nextTon = false;
    this.neTon = false;
    this.capAmo = false;
    this.addAmo = false;
}

nextOut() {
    this.textField = false;
}

sCond() {
    this.teField = false;
}

tCon() {
    this.tField = false;

}

tddCon() {

    this.tddField = false;

}

    




}
