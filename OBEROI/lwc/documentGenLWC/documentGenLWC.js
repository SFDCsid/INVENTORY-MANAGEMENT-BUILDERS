import { LightningElement,api,wire,track} from 'lwc';
import getObjectList from '@salesforce/apex/Aura_DocumentUpload.getObjectList';
import GetFieldList from '@salesforce/apex/Aura_DocumentUpload.GetFieldList';

var i=0;
export default class DocumentGenLWC extends LightningElement {
    @track isLoading = false;
    @api OpportunityOBJ = 'Document_Template__c';
    @api DoctypeField = 'Document_Type__c';
    @api DocType = '';
    @track itemsOBJ = [];
    @track itemsFld = [];
    @track jitem = [];
    @track FildListWrap = []; 
    @track valueObj = '';  //this displays selected value of combo box
    @track chosenObject ='';

    @wire(getObjectList,{})
    getObjectList({ error, data }){
        if (data) {
            for(i=0; i<data.length; i++) {

                console.log('id=' + data[i]);
                this.itemsOBJ = [...this.itemsOBJ ,{value: data[i], label: data[i]}];                                   
            }                
            this.error = undefined;
            //alert('Return done');
        } else if (error) {
            this.error = error;
            this.itemsOBJ = undefined;
        }
    }
    get Objectlist() {
        console.log(this.itemsOBJ);
        //alert('Return done');
        return this.itemsOBJ;
    }
    GetFields(event) {
        // Get the string of the "value" attribute on the selected option
        const selectedObject = event.detail.value;
        console.log('selected value=' + selectedObject);
        this.chosenObject = selectedObject;
        this.itemsFld ='';
        alert('length:: ' + this.chosenObject);
        
        /*GetFieldList({selectedObject:'$chosenObject'})
        
            .then(result => {
                alert('length2:: ' + this.chosenObject);
                this.FildListWrap = result;
                alert('length:: ' + this.FildListWrap);
                if (this.FildListWrap.length != 0) {
                    for(i=0; i< this.FildListWrap.length; i++) {
                        console.log('id=' + this.FildListWrap[i].fValue);
                        this.itemsFld = [...this.itemsFld ,{value: this.FildListWrap[i].fName, Label: this.FildListWrap[i].fValue}];                                   
                        //alert('Return done-'+ i +'-'+this.FildListWrap[i].fValue);
                    }                
                    
                } else if (this.FildListWrap.length === 0) {
                    const event = new ShowToastEvent({
                        title: 'Warning',
                        message: 'No Unit found',
                        variant: 'warning',
                        mode: 'sticky'
                    });
                    this.dispatchEvent(event);
                }
            })
            .catch(error => {
                alert('Error Occurred while getting Unit result: ' + error);
            });
    }
    get Fldlist() {
        console.log(this.itemsFld);
        //alert('Return itemsFld done '+this.itemsFld);
        return this.itemsFld;*/
    }
        @wire(GetFieldList,{selectedObject:'$chosenObject'})
        GetFieldList({ error, data }){
            if (data) {
                this.jitem = JSON.stringify(data);
                 alert('data done -- ' + data[0].Selectlist);
                 alert('data done11 -- ' + JSON.stringify(data));
                for(i=0; i<this.jitem.length; i++) {

                    console.log('id=' + this.jitem[i]);
                    this.itemsFld = [...this.itemsFld ,{value: this.jitem[i], label: this.jitem[i]}];                                   
                }                
                this.error = undefined;
               
            } else if (error) {
                this.error = error;
                this.itemsFld = undefined;
            }
        }
        get Fldlist() {
            console.log(this.itemsFld);
            alert('Return itemsFld done '+this.itemsFld);
            alert('Return itemsFld done 2-----'+JSON.stringify(this.itemsFld));
            
            return this.itemsFld;

        }
    
}