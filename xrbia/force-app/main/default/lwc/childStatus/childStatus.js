import { LightningElement,api } from 'lwc';

export default class leadstatusColour extends LightningElement {
    @api leadstatus;
    @api color;
    @api FirstName;
    get getColor() { 
        if (this.leadstatus != undefined) {
             var leadstatusLowerCase = this.leadstatus.toLowerCase();
             var cOrange = 'VACANT';
             var cYellow = 'BLOCKED';
             var cPink = 'SOLD';
           
            
                if (cOrange.indexOf(leadstatusLowerCase) != -1) {
                    this.color='orange';
                  } 
                else if (cYellow.indexOf(leadstatusLowerCase) != -1) {
                     this.color='yellow';
              
                   }
                else if (cPink.indexOf(leadstatusLowerCase) != -1) {
                     this.color='pink';
              
                    }
             
           return this.color + 'slds-theme_success';
      

    }
    }
}