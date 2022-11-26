import { LightningElement,api } from 'lwc';

export default class leadstatusColour extends LightningElement {
    @api leadstatus;
    @api color;
    @api FirstName;
    get getColor() { 



      
        if (this.leadstatus != undefined) {
             var leadstatusLowerCase = this.leadstatus.toLowerCase();
             var cOrange = 'open - not contacted';
             var cYellow = 'working - contacted';
             var cPink = 'closed - converted';
             var cLightGreen = 'closed - not converted';
            
                if (cOrange.indexOf(leadstatusLowerCase) != -1) {
                    this.color='orange';
                  } 
                else if (cYellow.indexOf(leadstatusLowerCase) != -1) {
                     this.color='yellow';
              
                   }
                else if (cPink.indexOf(leadstatusLowerCase) != -1) {
                     this.color='pink';
              
                    }
                else if (cLightGreen.indexOf(leadstatusLowerCase) != -1) {
              
                     this.color='LightGreen';
                    }
           return this.color + ' slds-badge';
      

    }
    }
}