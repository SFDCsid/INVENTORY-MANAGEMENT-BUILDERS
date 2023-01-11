import { LightningElement,api,wire,track} from 'lwc';
import getTowerlist from '@salesforce/apex/S_Inventory_Matrix.getTowerlist';
import getFloors from '@salesforce/apex/S_Inventory_Matrix.getFloorList';
import getFloorUnitsWrap from '@salesforce/apex/S_Inventory_Matrix.getFloorUnit';
import { NavigationMixin } from 'lightning/navigation';
import My_Resource from '@salesforce/resourceUrl/Legend_Codes';

let i=0;


   
export default class TestInventoryMatrics extends LightningElement {
    @api oppId;
    @api projectId;
    @track isLoading = false;
    @api towerid;
    @api OpportunityOBJ = 'Opportunity';
    @api ProjectField = 'Project__c';
    @api UnitID;
    @track ShowUnits = 'None';
    @track error;   //this holds errors

    @track itemst = []; //this holds the array for records with value & label
    @track itemsf = []; 
    @track value = '';  //this displays selected value of combo box
    @track floors = [];
    
    @track chosenValue = '';
    @track floorUnitsWrap = [];
    @track showUnitTable = false;
    @track showInventory = true;
    @track showUnholdUnitModal = false;
    @track unholdUnitCommment = '';
    @track unholdUnitId;s

    spring20Logo = My_Resource + '/images/Legend_Codes.png';
    
    ProjChange(event) {
        // Creates the event
        this.projectId = event.detail.value;
        const selectedEvent = new CustomEvent('valueselected', {
            detail: event.detail.value
        });
        //dispatching the custom event
        this.dispatchEvent(selectedEvent);
        this.projectId = event.target.value;
        this.itemst = '';
        this.itemsf = '';
    }
    
    @wire(getTowerlist,{Projid:'$projectId'})
    wiredTowers({ error, data }) {
        if (data) {
            for(i=0; i<data.length; i++) {
                console.log('id=' + data[i].Id);
                this.itemst = [...this.itemst ,{value: data[i].Id , label: data[i].Tower_Name__c}];                                   
            }                
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.itemst = undefined;
        }
    }
   
    get roleOptions() {
        console.log(this.itemst);
        return this.itemst;
    }
     handleChange(event) {
        // Get the string of the "value" attribute on the selected option
        const selectedOption = event.detail.value;
        console.log('selected value=' + selectedOption);
        this.chosenValue = selectedOption;
        this.itemsf = '';
        
        getFloorUnitsWrap({towerId: this.chosenValue})
            .then(result => {
                this.floorUnitsWrap = result;
                alert('length:: ' + result);
                if (this.floorUnitsWrap.length != 0) {
                    //this.showUnitTable = true;

                } else if (this.floorUnitsWrap.length === 0) {
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

    //this value will be shown as selected value of combobox item
    get selectedValue(){
        return this.chosenValue;
    }
     
    
    @wire(getFloors,{Towerid:'$chosenValue'}) Floors;
    wiredFloors({ error, data }) {
        if (data) {
            for(i=0; i<data.length; i++) {
                console.log('id=' + data.value);
                this.itemsf= [...this.itemsf ,{value: data[i].value , label: data[i].value}];                                   
            }                
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.itemsf = undefined;
        }
    }
    get Floors() {
        console.log(this.itemsf);
        return this.itemsf;
    }

    GenerateQuote(event){
        this.UnitID = event.target.dataset;
        var unitId = event.target.name;
       // alert('create quote:: ' + unitId + ' & opty: ' + this.recordId);
        window.location.replace('/apex/Quotation?oppId=' + this.oppId + '&unitId=' + unitId, ''); 
    }  
    
    BlockUnit(event){
        this.UnitID = event.target.dataset;
        var unitId = event.target.name;
       // alert('create quote:: ' + unitId + ' & opty: ' + this.recordId);
        window.open('/apex/BlockingPage?optyid=' + this.oppId + '&unitId=' + unitId +'&action=Blocked', ''); 
    }     
}