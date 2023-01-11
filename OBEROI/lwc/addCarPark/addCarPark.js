import { LightningElement,api,track,wire } from 'lwc';
import getBooking from '@salesforce/apex/CarPark.getBooking';
//import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCarParkingList from '@salesforce/apex/CarPark.getCarParkingList';
//import { getRecord } from 'lightning/uiRecordApi';
import saveQuotation from '@salesforce/apex/CarPark.saveQuotation';
import getOpportunity from '@salesforce/apex/CarPark.getOpportunity';

let i=0, carparkMapCount,parkingMap;
export default class AddCarPark extends LightningElement {
    @track parkingList = [];
    @api oppId;
    @api bookId;
    @track Booking;
    @track Project;
    @track Quotation;
    @track QuotationName;
    @track ProjectName;
    @track towerId;
    OptyChange(event) {
        // Creates the event
        this.oppId = event.detail.value;
        const selectedEvent = new CustomEvent('valueselected', {
            detail: event.detail.value
        });
        //dispatching the custom event
        this.dispatchEvent(selectedEvent);
    }

    @wire(getBooking, {bId:'$bookId'})
    wiredBooking({data, error}){
        if(data){
            this.Booking = JSON.stringify(data);
           // this.property = data;
            this.Booking = JSON.parse(this.Booking);
            this.ProjectName = this.Booking.Project__c;
            //this.PropertyType = this.property.Property_Type__c;
            this.towerId = this.Booking.Tower__c;
            this.Quotation = this.Booking.Quotation__c;
            this.QuotationName = this.Booking.Quotation__r.Name;
            //this.unitNo = this.Booking.Material_No__c;
            this.Project = this.Booking.Project__r.Name;
            this.tower = this.Booking.Tower__r.Tower_Name__c;
            //this.carpetArea = this.property.Carpet_Area__c;
            //this.configuration = this.property.Property_Type_Name__c;
            //this.floorNo = this.property.Floor_No__c;
            //this.quotationValidity = this.property.Project_Name__r.Quotation_Validity__c;
            //this.marketValue = this.property.Market_Value__c;
            /*this.earmarkedParking = '';
            let pRecord = JSON.stringify(this.property);
            getEarmarkedParkingDetails({pRecord:pRecord})
            .then(result => {
                    this.earmarkedParking = result;
            })
            .catch(error => {
                console.log('Errorured:- ');
            });
            console.log('this.earmarkedParking:: '+this.earmarkedParking);*/
            this.error = undefined;
            
        }
        else if (error) {
            this.error = error;
            //this.property = undefined;
        }
    } 

    @wire(getCarParkingList, {pId:'$ProjectName'})
    wiredparkingList({data, error}){
        if(data){
            this.parkingList = data;
            this.error = undefined;
            //alert('parkingList',this.parkingList);
        }
        else if (error) {
            this.error = error;
            this.parkingList = undefined;
        }
    }
    handleClick(event) {
        var count = 0;
        var isError = 0;
        //this.selectedPlan = null;
        //this.selectedPlanId = null;
        this.showplanDetails = false;
        this.planDetailList = null;
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if (element.name === 'countInput') {
                    if(this.parkingList[count].originalCount < element.value){
                        alert(this.parkingList[count].carParkName + ' car parking is exceeded. Please enter valid number');
                        isError = 1;
                    }
                    count++;    
            }
       });

       if(isError === 0){
       this.isLoading = true;
       var parkingAmount = 0.00;
       carparkMapCount = new Map();
       //carparkMapAmount = new Map();
      let tempAllRecords = JSON.stringify(this.SAPPricingList);
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if (element.name === 'countInput') {
                /*if(element.value != null){
                    parkingAmount += Number(element.value);
                    carparkMapAmount.set(element.dataset.id,Number(element.value));
                }  
                if(parkingMap.has(String(element.dataset.id))){
                    if(element.value != null && element.value != undefined){
                        parkingAmount += Number(element.value) * Number(parkingMap.get(String(element.dataset.id)));
                        carparkMapAmount.set(element.dataset.id,Number(parkingMap.get(String(element.dataset.id))));
                    }else{
                        parkingAmount += Number(0);
                        carparkMapAmount.set(element.dataset.id,Number(0));
                    }
                }   */ 
                if(element.value != null){
                    carparkMapCount.set(element.dataset.id,Number(element.value));
                }else{
                    carparkMapCount.set(element.dataset.id,Number(0));
                } 
            }
            });
            let mapStringParam = [];
            if(carparkMapCount != null){
                carparkMapCount.forEach(function(value, key) {
                // console.log(key + ' = ' + value)
                    if(carparkMapCount.has(String(key))){
                        mapStringParam.push(key, value,carparkMapCount.get(String(key)));
                    }
                })
            }

            console.log('mapStringParam::'+JSON.stringify(mapStringParam));
            mapStringParam = JSON.stringify(mapStringParam);  
            //alert('mapStringParam:'+mapStringParam);
            //alert('qId:'+this.Quotation);
            saveQuotation({carparkList:mapStringParam, qId:this.Quotation, pId:this.ProjectName})
            .then(result => {
                    //alert('Success',result);
                    //if(this.jodiname != 'null'){
                    alert('Car park added successfully on '+this.QuotationName+' this Quotation');
                    //}
                    window.open('/'+this.Quotation,'_parent');
                    this.isLoading = false;
                    this.hidebutton = true;
                    
            })
            
          /*  if (element.name === 'countInput') {
                if(element.value != null){
                    carparkMapCount.set(element.dataset.id,Number(element.value));
                }  
            }*/
        
    }
    }
}