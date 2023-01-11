import { LightningElement,api,track,wire } from 'lwc';
import getProperty from '@salesforce/apex/Quotation.getProperty';
//import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCarParkingList from '@salesforce/apex/Quotation.getCarParkingList';
//import { getRecord } from 'lightning/uiRecordApi';
import getOpportunity from '@salesforce/apex/Quotation.getOpportunity';
import getDiscountList from '@salesforce/apex/Quotation.getDiscountList';
import getBillingPlanList from '@salesforce/apex/Quotation.getBillingPlanList';
import getSAPPricingList from '@salesforce/apex/Quotation.getSAPPricingList';
import getAdditionChargsList from '@salesforce/apex/Quotation.getAdditionChargsList';
import applyCarParking from '@salesforce/apex/Quotation.applyCarParking';
import applyDiscount from '@salesforce/apex/Quotation.applyDiscount';
import removeDiscount from '@salesforce/apex/Quotation.removeDiscount';
import getAppliedDiscounts from '@salesforce/apex/Quotation.getAppliedDiscounts';
import getPlanDetail from '@salesforce/apex/Quotation.getPlanDetail';
import addPlanRow from '@salesforce/apex/Quotation.addPlanRow';
import updatedPlanDetails from '@salesforce/apex/Quotation.updatePlanDetails';
//import getNPV from '@salesforce/apex/Quotation.getNPV';
import saveQuotation from '@salesforce/apex/Quotation.saveQuotation';
//import { NavigationMixin } from 'lightning/navigation';
import getEarmarkedParkingDetails from '@salesforce/apex/Quotation.getEarmarkedParkingDetails';
import getParkingCharges from '@salesforce/apex/Quotation.getParkingCharges';
//import getChargesName from '@salesforce/apex/Quotation.getChargesName';
import { refreshApex } from '@salesforce/apex';
let i=0, carparkMapCount,carparkMapAmount,editScheduleMap,parkingMap;

export default class Basic extends LightningElement {
    @api oppId;
    @api unitId;
    @api QuotationAPI = 'Quotation__c'; 
    @api OpportunityField = 'Opportunity__c';
    @api sourceField = 'Revised_Booking_Source__c';
    @api CPField = 'Channel_Partner__c';
    //@track newIdc =false;
    @api disabled = false;
    @api selectedPlanId;
    @api required = false; 
    @api proprtyField = 'Property__c';
    activeSections = ['CarPark', 'discount'];
    @track parkingList = [];
    @track Property;
    @track ProjectName;
    @track towerId;
    @track discountList = [];
    @track PropertyType;
    @track additionChargsList = [];
    @track SAPPricingList = [];
   // @track selectedPlan;
    @track items = [];
   // @track originalCarkPark = [];
    @track appliedDiscounts = [];
    @track planDetailList = [];
    @track editSchedule = false;
    @track customizeSchedule = false;
    @track unitNo;
    @track Project;
    @track tower;
    @track carpetArea;
    @track configuration;
    @track floorNo;
    @track quotationValidity;
    @track NPVDetails;
    //@track originalNPV;
    //@track originalNPVpsf;
    //@track modifiedNPV;
    //@track modifiedNPVpsf;
    @track quotationId;
    @track additionalComments;
    @track changeInSource= false;
    @track revBookingSorce=null;
    @track revisedCPName = null;
    //@track revisedBrokrgPercentage = null;
    @track Opportunity;
    @track bookingSource;
    @track channelPartner;
    @track brokeragePercentage;
    @track isPlanEditable;
    @track earmarkedParking;
    @track generateQuote = false;
    @track showplanDetails = false;
    @track selectedPlanName = '';
    @track isSubventionPlan = false;
    @track hidebutton = false;
    @track hideCarParkbutton = false;
    @track totalParkingAmount = 0;
    @track marketValue;
    @track isSourcePartner = false;
    @track isSourceExistingCustomer = false;
    @track referredBy = null;
    @track referProject = null;
    @track referTower = null;
    @track referFlat = null;
    @track referEmpCode = null;
    
    @track isLoading = false;
   // @track NPVdiscountLumpsum;
   // @track NPVdiscountPsf;

    OptyChange(event) {
        // Creates the event
        this.oppId = event.detail.value;
        const selectedEvent = new CustomEvent('valueselected', {
            detail: event.detail.value
        });
        //dispatching the custom event
        this.dispatchEvent(selectedEvent);
    }

   /* newcheckChange(event) {
        // Creates the event
        this.newIdc = event.target.checked;
        const selectedEvent = new CustomEvent('valueselected2', {
            detail: event.target.checked
        });
        //dispatching the custom event
        this.dispatchEvent(selectedEvent);
    }*/

    @api isValid() {
        if (this.required) {
            this.template.querySelector('lightning-input-field').reportValidity();
        }
    }
    selectPlan(event) {
        const selectedOption = event.detail.value;
        this.selectedPlanId = selectedOption;
            
    }
    generateQuoteMethod(event){
        console.log('inside generateQuoteMethod');
        var op = this.template.querySelector('lightning-input-field').value;
        //alert('op::'+op);
        if(op != null && op !=undefined && op!=''){
           // alert('this.selectedPlanId:: '+this.selectedPlanId);
            if(this.selectedPlanId != null && this.selectedPlanId != undefined){
                this.isPlanEditable = false;
                if(editScheduleMap.has(this.selectedPlanId)){
                    console.log('ispayment plan editable::'+editScheduleMap.get(this.selectedPlanId).Is_Editable__c);
                    console.log('is Subvention::'+editScheduleMap.get(this.selectedPlanId).Is_Subvention_Plan__c);
                    console.log('Subvention Base Rate::'+editScheduleMap.get(this.selectedPlanId).Subvention_Base_Rate__c);
                    this.isSubventionPlan = editScheduleMap.get(this.selectedPlanId).Is_Subvention_Plan__c;
                    this.isPlanEditable = editScheduleMap.get(this.selectedPlanId).Is_Editable__c;
                    this.selectedPlanName = editScheduleMap.get(this.selectedPlanId).Payment_Plan_Type__c + ' - ' + editScheduleMap.get(this.selectedPlanId).Billing_Plan_Name__c;
                }
                console.log('inside generate Quote method');   
                console.log('this.isPlanEditable =' + this.isPlanEditable);
                console.log('selectedOption=' + this.selectedPlanId);  

      ////////////// Fetch Agreement value details          
                getSAPPricingList({uId:this.unitId,isSubventionPlan:editScheduleMap.get(this.selectedPlanId).Is_Subvention_Plan__c,subventionRate:editScheduleMap.get(this.selectedPlanId).Subvention_Base_Rate__c})
                    .then(result => {
                            this.SAPPricingList = JSON.stringify(result);
                            this.SAPPricingList = JSON.parse(this.SAPPricingList);
                    })
                    .catch(error => {
                        console.log('Errorured in SAP:- '+ error);
                    });

    ///////////// Fetch Additional charges details
                getAdditionChargsList({pId:this.PropertyType})
                    .then(result => {
                            this.additionChargsList = JSON.stringify(result);
                            this.additionChargsList = JSON.parse(this.additionChargsList);
                    })
                    .catch(error => {
                        console.log('Errorured in Additional charge:- '+error);
                    });

    ///////////// Fetch Opportunity details
                getOpportunity({oppId:this.oppId})
                    .then(result => {
                            this.Opportunity = JSON.stringify(result);
                            this.Opportunity = JSON.parse(this.Opportunity);
                            this.bookingSource = this.Opportunity.Enquiry_Type__c;
                            this.channelPartner = this.Opportunity.Broker_Account__r.Name;
                            this.brokeragePercentage = this.Opportunity.Brokerage_Percentage__c;
                    })
                    .catch(error => {
                        console.log('Errorured in getOpportunity:- '+error);
                    });

                this.generateQuote = true;   
            }else{
                alert('Please select Billing plan to generate quote');
            }
            
        }else{
            alert('Please select Opportunity to generate quote');
        }
    }    

/////////// Get Property details
    @wire(getProperty, {uId:'$unitId'})
    wiredproperty({data, error}){
        if(data){
            this.property = JSON.stringify(data);
           // this.property = data;
            this.property = JSON.parse(this.property);
            this.ProjectName = this.property.Project_Name__c;
            this.PropertyType = this.property.Property_Type__c;
            this.towerId = this.property.Tower__c;
            this.unitNo = this.property.Material_No__c;
            this.Project = this.property.Project_Name__r.Name;
            this.tower = this.property.Tower__r.Tower_Name__c;
            this.carpetArea = this.property.Carpet_Area__c;
            this.configuration = this.property.Property_Type_Name__c;
            this.floorNo = this.property.Floor_No__c;
            this.quotationValidity = this.property.Project_Name__r.Quotation_Validity__c;
            this.marketValue = this.property.Market_Value__c;
            this.earmarkedParking = '';
            let pRecord = JSON.stringify(this.property);
            getEarmarkedParkingDetails({pRecord:pRecord})
            .then(result => {
                    this.earmarkedParking = result;
            })
            .catch(error => {
                console.log('Errorured:- ');
            });
            console.log('this.earmarkedParking:: '+this.earmarkedParking);
            this.error = undefined;
            
        }
        else if (error) {
            this.error = error;
            this.property = undefined;
        }
    } 
    ////////////////////// get Opportunity details /////////////////////////
   /* @wire(getOpportunity, {oppId:'$oppId' })
    wiredOpportunity({data, error}){
        if(data){
            this.Opportunity = JSON.stringify(data);
            this.Opportunity = JSON.parse(this.Opportunity);
            this.bookingSource = this.Opportunity.Enquiry_Type__c;
            this.channelPartner = this.Opportunity.Partner_s_Name__c;
            this.brokeragePercentage = this.Opportunity.Brokerage_Percentage__c;
        }else if (error) {
            this.error = error;
            this.Opportunity = undefined;
        }
    } */

///////// Get Car parking details
    @wire(getCarParkingList, {pId:'$ProjectName'})
    wiredparkingList({data, error}){
        if(data){
            this.parkingList = data;
            this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.parkingList = undefined;
        }
    }

///////// Get Car parking Charges
@wire(getParkingCharges, {pId:'$ProjectName'})
wiredparkingMap({data, error}){
    if(data){
        parkingMap = new Map();
        var conts = data;
        for(var key in conts){
          //  alert(conts[key]);
          //  alert(key);
            parkingMap.set(key, conts[key]); 
        }
       
        this.error = undefined;
    }
    else if (error) {
        this.error = error;
        parkingMap = undefined;
    }
    console.log('parkingMap:::'+parkingMap);
}

//////// get discount details
    @wire(getDiscountList, {pId:'$ProjectName'})
    wireddiscountList({data, error}){
        if(data){
            this.discountList = data;
            this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.discountList = undefined;
        }
    }
//////// get Billing plan list details
 
    @wire(getBillingPlanList, { tId: '$towerId'})
    wiredContacts({ error, data }) {
        if (data) {
            editScheduleMap = new Map();
            for(i=0; i<data.length; i++) {
                console.log('id=' + data[i].Id);
                this.items = [...this.items ,{value: data[i].Id , label: data[i].Payment_Plan_Type__c + ' - ' + data[i].Billing_Plan_Name__c}];                                   
                editScheduleMap.set(data[i].Id,data[i]);
            }                
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.items = undefined;
        }
    }
    get statusOptions() {
        console.log(this.items);
        return this.items;
    }
    showSchedule(event) {
        // Get the string of the "value" attribute on the selected option   
        this.showplanDetails = true;     
        this.isLoading = true;
        console.log('this.isPlanEditable =' + this.isPlanEditable);
        console.log('this.selectedPlanId=' + this.selectedPlanId);        
       /* const filterChangeEvent = new CustomEvent('filterchange', {
            detail: { this.selectedPlanId },
        });*/
        // Fire the custom event
        //this.dispatchEvent(filterChangeEvent);
        let tempAllRecords = JSON.stringify(this.SAPPricingList);
        getPlanDetail({AVList:tempAllRecords, planId:this.selectedPlanId, uId:this.unitId})
        .then(result => {
                this.planDetailList = JSON.stringify(result);
                this.planDetailList = JSON.parse(this.planDetailList);
                console.log('planDetails::: '+this.planDetailList);
                /*let tempPlanRecords = JSON.stringify(this.planDetailList);
                getNPV({planDetails:tempPlanRecords, pId:this.ProjectName, uId:this.unitId})
                .then(result => {
                        this.NPVDetails = JSON.stringify(result);
                        this.NPVDetails = JSON.parse(this.NPVDetails);
                        console.log('NPVDetails::: '+this.NPVDetails);
                        this.originalNPV = this.NPVDetails.NPVAmountSTR;
                        this.originalNPVpsf = this.NPVDetails.NPVAmountPSFSTR;
                })
                .catch(error => {
                    console.log('NPV error Errorured:- ');
                });*/
                this.isLoading = false;
        })
        .catch(error => {
            console.log('Errorured:- ');
        });

    }
  /*  NpvCalc(event){
        alert('hi');
        let tempPlanRecords = JSON.stringify(this.planDetailList);
        getNPV({planDetails:tempPlanRecords, pId:this.ProjectName, uId:this.unitId})
        .then(result => {
                this.NPVDetails = JSON.stringify(result);
                this.NPVDetails = JSON.parse(this.NPVDetails);
                console.log('NPVDetails::: '+this.NPVDetails);
                this.originalNPV = this.NPVDetails.NPVAmountSTR;
                this.originalNPVpsf = this.NPVDetails.NPVAmountPSFSTR;
        })
        .catch(error => {
            console.log('NPV error Errorured:- ');
        });
    }*/
//////// get All charges names here
  /*  @wire(getChargesName, {unitId:'$unitId',propertyTypeId:'$PropertyType'})
    wiredallchargesNames({data, error}){
        if(data){
            this.allchargesNames = data;
            this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.allchargesNames = undefined;
        }
    }
//////// get AV charges Map details
@wire(getAVCharges, {unitId:'$unitId'})
wiredAVChargesMap({data, error}){
    if(data){
        var conts = data;
        for(var key in conts){
            this.AVchargesMap.push({value:conts[key], key:key}); 
        }
    }
    else if (error) {
        this.error = error;
        this.AVchargesMap = undefined;
    }
}
//////// get Other charges Map details
@wire(getOtherCharges, {propertyTypeId:'$PropertyType'})
wiredOCChargesMap({data, error}){
    if(data){
        var conts = data;
        for(var key in conts){
            this.OCchargesMap.push({value:conts[key], key:key}); 
        }
    }
    else if (error) {
        this.error = error;
        this.OCchargesMap = undefined;
    }
} */
//////// get Agreement value details
/*@wire(getSAPPricingList, {uId:'$unitId'})
wiredSAPPricingList({data,error}){
    if(data){
        this.SAPPricingList = data;
        this.error = undefined;
    }
    else if (error) {
        this.error = error;
        this.SAPPricingList = undefined;
    }
}    
//////// get Additional charges details
@wire(getAdditionChargsList, {pId:'$PropertyType'})
wiredadditionChargsList({data, error}){
    if(data){
        this.additionChargsList = data;
        this.error = undefined;
    }
    else if (error) {
        this.error = error;
        this.additionChargsList = undefined;
    }
}    */

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
       carparkMapAmount = new Map();
      let tempAllRecords = JSON.stringify(this.SAPPricingList);
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if (element.name === 'countInput') {
                /*if(element.value != null){
                    parkingAmount += Number(element.value);
                    carparkMapAmount.set(element.dataset.id,Number(element.value));
                }  */
                if(parkingMap.has(String(element.dataset.id))){
                    if(element.value != null && element.value != undefined){
                        parkingAmount += Number(element.value) * Number(parkingMap.get(String(element.dataset.id)));
                        carparkMapAmount.set(element.dataset.id,Number(parkingMap.get(String(element.dataset.id))));
                    }else{
                        parkingAmount += Number(0);
                        carparkMapAmount.set(element.dataset.id,Number(0));
                    }
                }    
                if(element.value != null){
                    carparkMapCount.set(element.dataset.id,Number(element.value));
                }else{
                    carparkMapCount.set(element.dataset.id,Number(0));
                } 
            }
          /*  if (element.name === 'countInput') {
                if(element.value != null){
                    carparkMapCount.set(element.dataset.id,Number(element.value));
                }  
            }*/
        });
        console.log('parkingAmount:: '+parkingAmount);
        this.totalParkingAmount = parkingAmount;
       /* if(carparkMapCount != null){
            carparkMapCount.forEach(function(value, key) {
                if(carparkMapAmount.has(String(key))){
                    if(carparkMapAmount.get(String(key)) > 0 && value === 0){
                        alert('Please enter count of parking');
                        isError = 1;
                    }
                }
            })
        } */
        if(isError === 0){
            var discountedAmount = 0;
            for(var d=0;d<this.appliedDiscounts.length;d++){
                if(this.appliedDiscounts[d].Applied__c){
                    //alert('hii');
                    discountedAmount += Number(this.appliedDiscounts[d].Total__c);
                }
            }
            console.log('discountedAmount::'+discountedAmount);
            applyCarParking({AVList:tempAllRecords, carParkAmount:parkingAmount, uId:this.unitId,discountedAmount:discountedAmount,isSubventionPlan:editScheduleMap.get(this.selectedPlanId).Is_Subvention_Plan__c,subventionRate:editScheduleMap.get(this.selectedPlanId).Subvention_Base_Rate__c})
            .then(result => {
                    this.SAPPricingList = JSON.stringify(result);
                    this.SAPPricingList = JSON.parse(this.SAPPricingList);
                 //this.isLoading = false;
                 this.hideCarParkbutton = true;
                 this.isLoading = false;
            })
            .catch(error => {
             //this.isLoading = false;
                console.log('Errorured in car parking apply:- '+error);
                this.isLoading = false;
            });
        }  
        
   }
    
}
handleDiscountCheck(event) {
    
    var isApply = event.target.checked;
   // this.selectedPlan = null;
    //this.selectedPlanId = null;
    this.showplanDetails = false;
    this.planDetailList = null;
    if(isApply){ 
       // this.isLoading = true;
        let tempRecord = JSON.stringify(event.target.name);
        var tem = event.target.dataset.id;
        var dummy = '[data-id=' + '\'' + tem + '\'' + ']';
        var discountAmount = this.template.querySelector(dummy).value;
        let tempAllRecords = JSON.stringify(this.SAPPricingList);
        let tempDiscountRecord;
        

        getAppliedDiscounts({AVList:tempAllRecords, discountRecord:tempRecord, unitID:this.unitId,discountAmount:discountAmount, isApply})
        .then(result => {
                tempDiscountRecord = JSON.stringify(result);
                tempDiscountRecord = JSON.parse(tempDiscountRecord);
                this.appliedDiscounts.push(tempDiscountRecord);
                //this.isLoading = false;
        })
        .catch(error => {
            console.log('Errorured in discount apply:- '+error);
            //this.isLoading = false;
        });
        
        applyDiscount({AVList:tempAllRecords, discountRecord:tempRecord, unitID:this.unitId, discountAmount:discountAmount, isApply,carparkAmount:this.totalParkingAmount})
        .then(result => {
                this.SAPPricingList = JSON.stringify(result);
                this.SAPPricingList = JSON.parse(this.SAPPricingList);
               // this.isLoading = false;
        })
        .catch(error => {
            console.log('Errorured:- ');
          //  this.isLoading = false;
        }); 
    }else{
      //  this.isLoading = true;
        let tempAllRecords = JSON.stringify(this.SAPPricingList);
        let newArray = [];
        let dummyRecord;
        var tem = event.target.dataset.id;
        this.appliedDiscounts.forEach(function(item, index, object){
            if (item.Id != tem) {
                newArray.push(item);
            }else{
                dummyRecord = item;
              //  item.Total__c = 0;
            }
        }, this);

        let tempRecord = JSON.stringify(dummyRecord);   
        removeDiscount({AVList:tempAllRecords, discountRecord:tempRecord, uId:this.unitId,carparkAmount:this.totalParkingAmount})
        .then(result => {
            this.SAPPricingList = JSON.stringify(result);
            this.SAPPricingList = JSON.parse(this.SAPPricingList);
           // this.isLoading = false;
        })
        .catch(error => {
            console.log('Errorured in remove discount:- '+error);
           // this.isLoading = false;
        });
        console.log('newArray:'+newArray);
        this.appliedDiscounts = newArray;
        console.log('appliedDiscounts:'+this.appliedDiscounts);
    }
}

editplanDetails(event){
    this.editSchedule = true;
    //alert(this.editSchedule);
}
removeRow(event){
    let newArray = [];
   // this.isLoading = true;
    //alert('val::'+event.target.name);
    var mNo = event.target.name;
    var cc = 1;
    this.planDetailList.forEach(function(item, index, object){
        //alert('index::'+index);
        if (item.milestone_no != mNo) {
            item.milestone_no = cc;
            newArray.push(item);
            cc++;
        }
    }, this);
    console.log('newArray:'+newArray);
    this.planDetailList = newArray;
    //this.isLoading = false;
}
addRow(event){
    var divs = this.template.querySelectorAll('.ABCD'), r;
    let newArray = [];
    let nameMap = new Map();
    let dueDayMap = new Map();
    let percentageMap = new Map();
    for (var r = 0; r < divs.length; r++) {
        if(divs[r].name === 'mName'){
            nameMap.set(divs[r].dataset.id,divs[r].value);
        }else if(divs[r].name === 'dueDays'){
            dueDayMap.set(divs[r].dataset.id,divs[r].value);
        }else if(divs[r].name === 'mPercentage'){
            percentageMap.set(divs[r].dataset.id,divs[r].value);
        }    
    }    
    console.log(nameMap.keys());
    this.planDetailList.forEach(function(item, index, object){
        // alert(nameMap.has(String(item.milestone_no)));
        item.milestone_Name = nameMap.get(String(item.milestone_no));
        item.days_after_due = dueDayMap.get(String(item.milestone_no));
        item.milestone_Percentage = percentageMap.get(String(item.milestone_no));
        newArray.push(item);
    }, this);
    console.log(newArray);
    this.planDetailList = newArray;

    var mNo = event.target.name;
    //mNo = mNo - 1;
    console.log('mNo:: '+mNo);
    let newItem;
    this.planDetailList.forEach(function(item, index, object){
        if (item.milestone_no != mNo) {
        }else{
            newItem = JSON.stringify(item);
        }
    }, this);
    let tempAllRecords = JSON.stringify(this.planDetailList);
    addPlanRow({planDetails:tempAllRecords, planRecord:newItem, milestoneNo:mNo})
        .then(result => {
                this.planDetailList = JSON.stringify(result);
                this.planDetailList = JSON.parse(this.planDetailList);
                console.log('planDetailList:- '+this.planDetailList);
               // this.isLoading = false;
        })
        .catch(error => {
          //  this.isLoading = false;
            console.log('Errorured in adding new Row:- '+error);
        });

}
cancelplanDetails(event){
  //  this.isLoading = true;
    this.editSchedule = false;
    let tempAllRecords = JSON.stringify(this.SAPPricingList);
        getPlanDetail({AVList:tempAllRecords, planId:this.selectedPlanId, uId:this.unitId})
        .then(result => {
                this.planDetailList = JSON.stringify(result);
                this.planDetailList = JSON.parse(this.planDetailList);
                console.log('planDetails::: '+this.planDetailList);
               // this.isLoading = false;
        })
        .catch(error => {
            console.log('Errorured in cancel billing edit:- '+error);
           // this.isLoading = false;
        });
}
updateplanDetails(event){
   
    this.customizeSchedule = true;
    var divs = this.template.querySelectorAll('.ABCD'), k;
    var milestoneTotalPercentage = 0;
    var isValidated = 0;
    //alert('divs::'+divs.length);
    for (k = 0; k < divs.length; k++) {
        //alert('name::'+divs[i].name);
        if (divs[k].name === 'mName'){
            if(divs[k].value != null && divs[k].value != '') {
            }else{
                alert('Milestone Name is blank at Row # '+ divs[k].dataset.id);
                isValidated = 1; 
                break;
            }
        }else if(divs[k].name === 'dueDays'){
            if(divs[k].value != null) {
            }else{
                alert('Milestone Due Days is blank at Row # '+ divs[k].dataset.id); 
                isValidated = 1;
                break;
            }
        }else if(divs[k].name === 'mPercentage'){
            if(divs[k].value != null && divs[k].value > 0) {
                var per = Number(divs[k].value);
                //alert('per::: '+ per);
                milestoneTotalPercentage = Number(milestoneTotalPercentage) + Number(per); //Number(divs[k].value);
                milestoneTotalPercentage = milestoneTotalPercentage.toFixed(2);
                //alert('milestoneTotalPercentage:: '+milestoneTotalPercentage);
                console.log('milestoneTotalPercentage::'+milestoneTotalPercentage);
            }else{
                alert('Milestone Percentage is blank at Row # '+ divs[k].dataset.id); 
                isValidated = 1;
                break;
            }
        }
    }
    console.log('milestoneTotalPercentage::'+milestoneTotalPercentage);
    
    if(milestoneTotalPercentage != 100 && isValidated === 0){
        alert('Milestones total percentage should be 100%');
        isValidated = 1;
    }
    if(isValidated === 0){
       // this.isLoading = true;
        let newArray = [];
        let nameMap = new Map();
        let dueDayMap = new Map();
        let percentageMap = new Map();
        for (var r = 0; r < divs.length; r++) {
            if(divs[r].name === 'mName'){
                nameMap.set(divs[r].dataset.id,divs[r].value);
            }else if(divs[r].name === 'dueDays'){
                dueDayMap.set(divs[r].dataset.id,divs[r].value);
            }else if(divs[r].name === 'mPercentage'){
                percentageMap.set(divs[r].dataset.id,divs[r].value);
            }    
        }    
        console.log(nameMap.keys());
        this.planDetailList.forEach(function(item, index, object){
           // alert(nameMap.has(String(item.milestone_no)));
            item.milestone_Name = nameMap.get(String(item.milestone_no));
            item.days_after_due = dueDayMap.get(String(item.milestone_no));
            item.milestone_Percentage = percentageMap.get(String(item.milestone_no));
            newArray.push(item);
        }, this);
        console.log(newArray);
        this.planDetailList = newArray;
        let tempAllRecords = JSON.stringify(this.SAPPricingList);
        let allplanrecords = JSON.stringify(this.planDetailList);
        updatedPlanDetails({planDetails:allplanrecords, AVList:tempAllRecords})
        .then(result => {
                this.planDetailList = JSON.stringify(result);
                this.planDetailList = JSON.parse(this.planDetailList);
                console.log('planDetails::: '+this.planDetailList);
                this.editSchedule = false;
                /*let tempPlanRecords = JSON.stringify(this.planDetailList);
                getNPV({planDetails:tempPlanRecords, pId:this.ProjectName, uId:this.unitId})
                .then(result => {
                        this.NPVDetails = JSON.stringify(result);
                        this.NPVDetails = JSON.parse(this.NPVDetails);
                        console.log('NPVDetails::: '+this.NPVDetails);
                        this.modifiedNPV = this.NPVDetails.NPVAmountSTR;
                        this.modifiedNPVpsf = this.NPVDetails.NPVAmountPSFSTR;
                       // this.isLoading = false;
                })
                .catch(error => {
                    console.log('NPV error Errorured:- ');
                  //  this.isLoading = false;
                });*/
        })
        .catch(error => {
            console.log('Errorured:- ');
          //  this.isLoading = false;
        });
    }
}
saveQuote(event){
    this.isLoading = true;
    //alert('save method:: '+window.location.origin);
    var op = this.template.querySelector('lightning-input-field').value;
    //c/newLWCComponentalert('op:'+op);
    if(op != null && op !=undefined && op!=''){
      if(this.selectedPlanId != null && this.selectedPlanId != undefined){
       // this.isLoading = true;
        let SAPCharges = JSON.stringify(this.SAPPricingList);
        let othercharges = JSON.stringify(this.additionChargsList);
        let appliedDiscount = JSON.stringify(this.appliedDiscounts);
        let billingPlanList = JSON.stringify(this.planDetailList);
        var selectedBillingPlanId = this.selectedPlanId;
        let mapStringParam = [];
        if(carparkMapCount != null){
            carparkMapCount.forEach(function(value, key) {
            // console.log(key + ' = ' + value)
                if(carparkMapAmount.has(String(key))){
                    mapStringParam.push(key, value,carparkMapAmount.get(String(key)));
                }
            })
        }
    /* carparkMapAmount.forEach(function(value, key) {
            console.log(key + ' = ' + value)
        })*/
        
        //alert('op::'+op);
        console.log('mapStringParam::'+JSON.stringify(mapStringParam));
        mapStringParam = JSON.stringify(mapStringParam);     
       let fieldList = [];
       fieldList.push({label: 'unitId', value:this.unitId});
       fieldList.push({label: 'editschedule', value:this.customizeSchedule});
       fieldList.push({label: 'oppId', value:op});
       //fieldList.push({label: 'isMilestoneUpdated', value:this.newIdc});
       if(this.additionalComments != null)
        fieldList.push({label: 'additionalComments', value:this.additionalComments});
       else
        fieldList.push({label: 'additionalComments', value:''}); 
       fieldList.push({label: 'selectedPlan', value:selectedBillingPlanId});
       fieldList.push({label: 'changeInSource', value:this.changeInSource});
       fieldList.push({label: 'revisedBookingSource', value:this.revBookingSorce});
      // console.log('tt:'+this.template.querySelector('.revisedCP'));
       /*if(this.template.querySelector('.revisedCP') != null){
        this.revisedCPName = this.template.querySelector('.revisedCP').value; 
       }*/
       /*if(this.template.querySelector('.revisedBrokrgPercentage') != null){
        this.revisedBrokrgPercentage = this.template.querySelector('.revisedBrokrgPercentage').value; 
       }*/
       if(this.template.querySelector('.referredBy') != null){
        this.referredBy = this.template.querySelector('.referredBy').value; 
       }
       if(this.template.querySelector('.referProject') != null){
        this.referProject = this.template.querySelector('.referProject').value; 
       }
       if(this.template.querySelector('.referTower') != null){
        this.referTower = this.template.querySelector('.referTower').value; 
       }
       if(this.template.querySelector('.referFlat') != null){
        this.referFlat = this.template.querySelector('.referFlat').value; 
       }
       if(this.template.querySelector('.referEmpCode') != null){
        this.referEmpCode = this.template.querySelector('.referEmpCode').value; 
       }
       
       //alert('this.revisedCPName:: '+this.revisedCPName);
       console.log('this.revisedCPName:: '+this.revisedCPName);
       var cpN; 
       if(this.revisedCPName != null){
        cpN = String(this.revisedCPName); 
        fieldList.push({label: 'revisedCP', value:cpN});
        //alert('hiiii');
       }
       //fieldList.push({label: 'revisedBrokeragePercentage', value:this.revisedBrokrgPercentage});
       fieldList.push({label: 'referredBy', value:this.referredBy});
       fieldList.push({label: 'referProject', value:this.referProject});
       fieldList.push({label: 'referTower', value:this.referTower});
       fieldList.push({label: 'referFlat', value:this.referFlat});
       fieldList.push({label: 'referEmpCode', value:this.referEmpCode});
       fieldList = JSON.stringify(fieldList);
        //saveQuotation({AVList:SAPCharges, otherChrges:othercharges, discountList:appliedDiscount, planDetails:billingPlanList, selectedPlan:selectedBillingPlanId,carparkList:mapStringParam, uId:this.unitId,editschedule:this.customizeSchedule,opId:op,isMilestoneUpdated:this.newIdc,additionalComments:this.additionalComments,fieldList:fieldList})
        saveQuotation({AVList:SAPCharges, otherChrges:othercharges, discountList:appliedDiscount, planDetails:billingPlanList, carparkList:mapStringParam,fieldList:fieldList})
            .then(result => {
                    //alert('Success',result);
                    let [qid,jodiflatname] = result.split(",");
                    this.quotationId = JSON.stringify(qid);
                    this.quotationId = JSON.parse(this.quotationId);
                    this.jodiname = jodiflatname;
                    console.log('quotationId::: '+this.quotationId);
                    console.log('jodiflatname::: '+this.jodiname);
                    if(this.jodiname != 'null'){
                        alert('!! Please create another quotation on '+this.jodiname+' this jodi Property.!!');
                    }
                    window.open('/'+this.quotationId,'_parent');
                    this.isLoading = false;
                    this.hidebutton = true;
                    
            })
            .catch(error => {
                this.isLoading = false;
                console.log('quotation save error Errorured:- ');
            });
        // alert('quotation Id::'+this.quotationId);
         
      }else{
        alert('Please select Billing plan to Save the Quotation');
        this.isLoading = false;
      }
    }else{
        alert('Please select Opportunity to Save the Quotation');
        this.isLoading = false;
    }  
        
}    
changeInSourceCheck(event){
   // alert('hi:::'+this.Opportunity.Id);
    this.changeInSource = event.target.checked;
    if(!this.changeInSource){
        this.revBookingSorce = null;
        this.revisedCPName = null;
        //this.revisedBrokrgPercentage = null;
        this.referredBy = null;
        this.referProject = null;
        this.referTower = null;
        this.referFlat = null;
        this.referEmpCode = null;
    }
    const selectedEvent = new CustomEvent('valueselected2', {
        detail: event.target.checked
    });
    //dispatching the custom event
    this.dispatchEvent(selectedEvent);
}
sourceChange(event) {
    // Creates the event
    this.revBookingSorce = event.detail.value;
    if(this.revBookingSorce == 'Partner'){
        this.isSourcePartner = true;
    }else{
        this.isSourcePartner = false;
    }
    if(this.revBookingSorce == 'Existing Customer'){
        this.isSourceExistingCustomer = true;
    }else{
        this.isSourceExistingCustomer = false;
    }
    
    const selectedEvent = new CustomEvent('valueselected', {
        detail: event.detail.value
    });
    //dispatching the custom event
    this.dispatchEvent(selectedEvent);
}
CPSelect(event) {
    // Creates the event
    this.revisedCPName = event.detail.value;
    const selectedEvent = new CustomEvent('valueselected', {
        detail: event.detail.value
    });
    //dispatching the custom event
    this.dispatchEvent(selectedEvent);
}
additionalCommentsChange(event) {
    // Creates the event
    this.additionalComments = event.detail.value;
    const selectedEvent = new CustomEvent('valueselected', {
        detail: event.detail.value
    });
    //dispatching the custom event
    this.dispatchEvent(selectedEvent);
}
resetMethod(event) {
    window.open('/apex/quotation?unitId='+this.unitId + '&oppId='+this.oppId,'_parent');
    this.hidebutton = true;
    
}
}