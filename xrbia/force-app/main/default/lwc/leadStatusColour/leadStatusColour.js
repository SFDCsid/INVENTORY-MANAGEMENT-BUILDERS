import { LightningElement,api } from 'lwc';

export default class leadstatusColour extends LightningElement {
   @api leadstatus;
   @api objectList;
    @api color;
    @api FirstName;
    get getColor() { 

            
          
      
        if (this.leadstatus != undefined) {
          
          console.log('leadus'+this.leadstatus);
             var leadstatusLowerCase = this.leadstatus.toUpperCase();
             var cOrange = 'BLOCKED';
             var cYellow = 'SOLD';
             var cPink = 'VACANT';
             
            
                if (cOrange.indexOf(leadstatusLowerCase) != -1) {
                    this.color='orange';
                  } 
                else if (cYellow.indexOf(leadstatusLowerCase) != -1) {
                     this.color='yellow';
              
                   }
                else if (cPink.indexOf(leadstatusLowerCase) != -1) {
                     this.color='pink';
              
                    }
               
           return this.color + ' slds-theme_success';
      

    }


    }

    
}