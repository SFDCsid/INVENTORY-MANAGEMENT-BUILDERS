
import { LightningElement, wire, track, api } from 'lwc';
import projectMethod from '@salesforce/apex/PRACTICECLASS.projectMethod';
import sectorMethod from '@salesforce/apex/PRACTICECLASS.sectorMethod';
import towerMethod from '@salesforce/apex/PRACTICECLASS.towerMethod';
import unitMethod from '@salesforce/apex/PRACTICECLASS.unitMethod';
import unitDisplay from '@salesforce/apex/PRACTICECLASS.unitDisplay';
import dataTable from '@salesforce/apex/PRACTICECLASS.dataTable';
import unitHtml from '@salesforce/apex/PRACTICECLASS.unitHtml';
import getFloor from '@salesforce/apex/PRACTICECLASS.getFloor';
import unt from '@salesforce/apex/PRACTICECLASS.unt';
import getUnits from '@salesforce/apex/PRACTICECLASS.getUnits';
import keyvalueMap from '@salesforce/apex/PRACTICECLASS.keyvalueMap';
import valuekeyMap from '@salesforce/apex/PRACTICECLASS.valuekeyMap';
import listSort from '@salesforce/apex/PRACTICECLASS.listSort';
import temList from '@salesforce/apex/PRACTICECLASS.temList';
import carpetHtml from '@salesforce/apex/PRACTICECLASS.carpetHtml';
import unitHtml2 from '@salesforce/apex/PRACTICECLASS.unitHtml2';
///////////////////////
import ACCOUNT_OBJECT from '@salesforce/schema/QUOTATION__c';
import AGGREMENT_VALUE from '@salesforce/schema/QUOTATION__c.Aggrement_Value__c';
import GRAND_TOTAL from '@salesforce/schema/QUOTATION__c.GrandTotal__c';
import GST_AMOUNT from '@salesforce/schema/QUOTATION__c.Gst__c';
import GST_PERCENTAGE from '@salesforce/schema/QUOTATION__c.Gst_Percentage__c';
import OTHER_CHARGES from '@salesforce/schema/QUOTATION__c.Other__c';
import OTHERCHARGES_GST from '@salesforce/schema/QUOTATION__c.Other_Charges_Gst__c';
import REGISTERATION_CHARGES from '@salesforce/schema/QUOTATION__c.Registeration_Charges__c';
import STAMPDUTY_AMOUNT from '@salesforce/schema/QUOTATION__c.StampDuty__c';
import STAMPDUTY_PERCENTAGE from '@salesforce/schema/QUOTATION__c.Stamp_Duty_Percentage__c';
import UNIT_QUT from '@salesforce/schema/QUOTATION__c.Unit__c';
import NAME_QUT from '@salesforce/schema/QUOTATION__c.Name';
import TOTAL_OC from '@salesforce/schema/QUOTATION__c.Other_Charges_Total__c';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { NavigationMixin } from "lightning/navigation";



import loop from '@salesforce/apex/PRACTICECLASS.loop';

export default class TestComp extends NavigationMixin(LightningElement) {

  
    totalothercharges;
    otherchargesOnchangeval;
    otherchargesgstOnchangeval;

    gstamountOutput;
    gstpercentval;
    agrementval;

    receivestampdutyEv;
    stampdutyamountFieldOutput;

    @api grandtotalFieldOutput;

    registerationchargesAmount;

    otherchargesOnchange(event) {
        this.otherchargesOnchangeval = event.target.value;
        this.totalotherchargesOutput();
        this.grandTotalCalculation();
    }

    otherchargesgstOnchange(event) {
        this.otherchargesgstOnchangeval = event.target.value;
        this.totalotherchargesOutput();
        this.grandTotalCalculation();
    }

    totalotherchargesOutput() {
        this.totalothercharges = Number(this.otherchargesOnchangeval * this.otherchargesgstOnchangeval / 100) + Number(this.otherchargesOnchangeval);
        this.grandTotalCalculation();
    }

    gstpercentOnchange(event) {
        this.gstpercentval = event.target.value;
        this.gstamountOutputmethod(); //call other funtion 
        this.grandTotalCalculation();
    }


    agrementOnchange(event) {
        this.agrementval = event.target.value;
        this.gstamountOutputmethod();
        this.stampdutyCalculation();
        this.grandTotalCalculation();
    }

    gstamountOutputmethod() {
        this.gstamountOutput = this.agrementval * this.gstpercentval / 100;
        this.grandTotalCalculation();
    }

    stampdutypercentageFieldOnchange(event) {
        this.receivestampdutyEv = event.target.value;
        this.stampdutyCalculation();
        this.grandTotalCalculation();
    }

    stampdutyCalculation() {
        this.stampdutyamountFieldOutput = this.agrementval * this.receivestampdutyEv / 100;
        this.grandTotalCalculation();
    }

    grandTotalCalculation() {
        this.grandtotalFieldOutput = `${Number(this.stampdutyamountFieldOutput) + Number(this.gstamountOutput) + Number(this.totalothercharges) + Number(this.registerationchargesAmount) + Number(this.agrementval)}`;
    }

    registerationchargesFieldOnchange(event) {
        this.registerationchargesAmount = event.target.value;
        this.grandTotalCalculation();
    }

    


    //////////////////////////////////////////////
    @api recordId;
    towerProject = true;
    //areDetailsVisible=false;



    handleClick(event) {
        var rdValue = event.target.value;
        this.recordId = rdValue;
        this.areDetailsVisible = true;
        console.log(this.recordId);
        this.towerProject = false;
        // console.log('work'+event.target.value);
        // console.log('wk'+rdValue);
        //console.log('wk'+this.storeIdfornav);


        /*
             this[NavigationMixin.Navigate]({
                type: "standard__recordPage",
                attributes: {
                    recordId: this.storeIdfornav,
        
                    objectApiName: "Unit__c",
                    actionName: "view"
        
                }
            });*/
    }

    accountObject = ACCOUNT_OBJECT;
    aggrementvalueField = AGGREMENT_VALUE;
    grandtotalField = GRAND_TOTAL;
    gstamountField = GST_AMOUNT;
    gstpercentageField = GST_PERCENTAGE;
    otherchargesField = OTHER_CHARGES;
    otherchargesgstField = OTHERCHARGES_GST;
    registerationchargesField = REGISTERATION_CHARGES;
    stampdutyamountField = STAMPDUTY_AMOUNT;
    stampdutypercentageField = STAMPDUTY_PERCENTAGE;
    unitqutField = UNIT_QUT;
    namequtField = NAME_QUT;
    totalotherchargesField = TOTAL_OC;



    _title = 'Sample Title';
    message = 'Sample Message';
    variant = 'error';

    handleAccountCreated() {
        const toast = new ShowToastEvent({
            title: 'Quotation Created',
            message: 'success',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(toast);
        this.areDetailsVisible = false;
    }

    /////////////////////////////////////////////////////
    @api project;
    @api sector;
    @api tower;
    // @api recordId;


    sectorOptionList;
    towerOptionList;
    projectOptionList;
    unitOptionList;
    unitDisplay;
    @track keyOptionList;
    @track ValueOptionList;
    @track sot;
    @track OnlyUnits;
    nextList;
    unitsonly;
    @track ValueList;





    error;









    @wire(projectMethod)
    getProject({ error, data }) {
        let arr = [];
        //console.log(arr);
        if (data) {

            //alert('data');
            //console.log(data);
            //  var len=Reflect.ownKeys(data).length //to get size of map
            // console.log('len'+ len);

            /* for(var i=1 ;i<len; i++){
                  alert('In fo loop');
                 console.log('i'+ i);
                
                 
              } */
            for (let key in data) {
                arr.push({ label: data[key], value: key });


            }
            this.projectOptionList = arr;
            //console.log('PRO'+this.projectOptionList);
        }
        else if (error) {
            this.error = undefined;
        }
    }
    handleChangeProject(event) {
        this.project = event.detail.value;
        //  console.log(this.project);

    }


    @wire(sectorMethod, { Id: '$project' })
    getsector({ error, data }) {
        //alert('hi');
        let secarray = [];
        if (data) {
            // alert('hi');
            for (let key in data) {

                secarray.push({ label: data[key], value: key });

            }
            this.sectorOptionList = secarray;
        }
        else if (error) {
            this.error = undefined;
        }


    }
    handleChangeSector(event) {
        this.sector = event.detail.value;
    }

    @wire(towerMethod, { Id: '$sector' })
    gettower({ error, data }) {

        let towarray = [];
        if (data) {

            for (let key in data) {

                towarray.push({ label: data[key], value: key });

            }
            this.towerOptionList = towarray;
        }
        else if (error) {
            this.error = undefined;
        }


    }
    handleTowerChange(event) {
        this.tower = event.detail.value;

    }

    @wire(unitMethod, { Id: '$tower' })
    getunit({ error, data }) {

        let unitarray = [];
        if (data) {

            for (let key in data) {

                unitarray.push({ label: data[key], value: key });

            }
            this.unitOptionList = unitarray;


        }
        else if (error) {
            this.error = undefined;
        }


    }

    @wire(unitDisplay, { Id: '$tower' })
    unitHtml;









    @track classHandler;

    @track objectList;
    @track staTus;
    @track datarecords = [];


    @wire(unitHtml2, { Id: '$tower' })
    retriveUnits({ error, data }) {
        let colourRay = [];
        let keyRay = [];

        if (data) {



            for (let key in data) {




                // .sort(function(a, b){return a - b})
                keyRay.push({ FLOOR: key, Value: data[key] });

                for (var i = 0; i < data[key].length; i++) {
                    console.log('data[key]' + JSON.stringify(data[key][i].Status__c));
                    if (data[key][i].Status__c == 'BLOCKED') {
                        //     console.log('data[key][i].Status__c'+JSON.stringify(data[key][i].Status__c)); 


                    }
                    if (data[key][i].Status__c == 'SOLD') {
                        //     console.log('data[key][i].Status__c'+JSON.stringify(data[key][i].Status__c)); 

                    }
                }



                this.objectList = keyRay.sort(function (a, b) { return a.FLOOR - b.FLOOR }).reverse();


                var index = this.objectList.findIndex(item => item.id === this.Value);

                console.log('colour' + JSON.stringify(this.index));





            }


            console.log('OBJLIST' + JSON.stringify(this.objectList));
            //  console.log('eyray'+JSON.stringify(this.objectList[0].Value[0].Status__c));

            // console.log('objvalue'+JSON.stringify(this.objectList[0].Value[0].Status__c));


        }
        else if (error) {
            this.objectList = undefined;
        }
    }

    //  @track datarecords=[];
    leadlist = [];
    @wire(unitDisplay, { Id: '$tower' })
    lead({ error, data }) {
        if (data) {
            this.leadlist = data;
            //   console.log('this.leadlist'+JSON.stringify(this.leadlist));

            for (var i = 0; i < this.leadlist.length; i++) {
                let obj = {
                    "Id": this.leadlist[i].Id,
                    "Name": this.leadlist[i].Name,
                    "Status": this.leadlist[i].Status__c,
                    "Floor": this.leadlist[i].Floor__c,
                    "Tower": this.leadlist[i].Tower__c
                }
                if (this.leadlist[i].Status__c == 'sold') {
                    obj.className = 'unavai'
                }
                else if (this.leadlist[i].Status__c == 'blocked') {
                    obj.className = 'booked'
                }
                else if (this.leadlist[i].Status__c == 'vacant') {
                    obj.className = 'open'
                }
                //        this.datarecords.push(obj);

            }
        }
        else if (error) {
            this.leadlist = undefined;
        }

        //  console.log('datarecords'+JSON.stringify(this.datarecords));
    }


    @track allRecord = [];
    @wire(unt, { Id: '$tower' })
    retriveFloor({ error, data }) {
        let valueray = [];
        if (data) {
            this.valueray = data;
            console.log('valueray' + JSON.stringify(this.valueray));
            for (var i = 0; i < this.valueray.length; i++) {
                let obj = {
                    "Id": this.valueray[i].Id,
                    "Name": this.valueray[i].Name,
                    "Status": this.valueray[i].Status__c,
                    "Floor": this.valueray[i].Floor__c,
                    "Tower": this.valueray[i].Tower__c,
                    "configuration__c": this.valueray[i].configuration__c,
                    "Type__c": this.valueray[i].Type__c,
                    "Salable_Area__c": this.valueray[i].Salable_Area__c
                }
                if (this.valueray[i].Status__c == 'sold') {
                    obj.className = 'sold'
                }
                else if (this.valueray[i].Status__c == 'blocked') {
                    obj.className = 'blocked'
                }
                else if (this.valueray[i].Status__c == 'vacant') {
                    obj.className = 'vacant'
                }
                this.allRecord.push(obj.Floor, obj);

            }
            console.log('ALLRECORDS' + JSON.stringify(this.allRecord));



        } else if (error) {
            this.valueray = undefined;
        }


    }

    /*
        navButton;
        handlerecordClick(event) {
           
            //  alert('inside event');
            //   console.log('event'+Json.stringify(event.detail.FLOOR));
            this.navButton = event.currentTarget.value;
            console.log('event'+Json.stringify( this.navButton ));
            
    
    
    
    
    
    
            this[NavigationMixin.Navigate]({
                type: "standard__recordPage",
                attributes: {
                    recordId: this.navButton,
    
                    objectApiName: "Unit__c",
                    actionName: "view"
    
                }
            });
    
        }*/

    //------------------------------------------------------------------------------------




    /*   changeColour(){
           this.template.querySelector('[data.id = "myDiv"]').classList.add('redColour');
       }  */
    /*
        navButton;
        colourHtml;
    
    
    
    
    
    
    
        handlerecordClick(event) {
            //  alert('inside event');
            //   console.log('event'+Json.stringify(event.detail.FLOOR));
            this.navButton = event.currentTarget.value;
            this.colourHtml = event.target.status;
            console.log('nav' + this.colourHtml);
    
    
    
    
    
    
            this[NavigationMixin.Navigate]({
                type: "standard__recordPage",
                attributes: {
                    recordId: this.navButton,
    
                    objectApiName: "Unit__c",
                    actionName: "view"
    
                }
            });
    
        }*/

    @track record = []
    @wire(unitHtml2, { Id: '$tower' })
    getunit({ error, data }) {

        let unitarray = [];
        if (data) {
            this.record = data;
            for (var i = 0; i < this.record.length; i++) {
                let obj = {
                    "Id": this.record[i].Id,
                    "Name": this.record[i].Name,
                    "Status": this.record[i].Status__c,
                    "Floor__c": this.record[i].Floor__c,
                    "Carpet_Area__c": this.record[i].Carpet_Area__c,
                }
                if (this.record[i].Status__c == 'SOLD') {
                    obj.className = 'sold'
                }
                else if (this.record[i].Status__c == 'VACANT') {
                    obj.className = 'avail'
                }
                else if (this.record[i].Status__c == 'BOOKED') {
                    obj.className = 'book'
                }
                //  { FLOOR: key, Value: data[key] }
                this.datarecords.push({ FLOOR: obj.Floor__c, obj });



            }
            console.log('this.datarecords' + this.datarecords);
            console.log('this.datarecords' + JSON.stringify(this.datarecords));




        }
        else if (error) {
            this.error = undefined;
        }


    }








}

/*
   @wire(loop, { Id: '$tower' })
   filteredLoop;*/
/*
    @wire(keyvalueMap, { Id: '$tower' }) 
    retriveFloor({ error, data }) {
        let valueray = [];
        if (data) {
            for (let key in data) {
                valueray.push({ key: key, Value: data[key] });
                this.ValueList = valueray;
                console.log('ValueList' + JSON.stringify(this.ValueList));
            }
        } else if (error) {
            this.data = undefined;
        }
        
    }
*/
/*
    @wire(valuekeyMap, { Id: '$tower' })
    retriveFloor({ error, data }) {
        let valueray = [];
        if (data) {
            for (let key in data) {
                valueray.push({ key: key, Value: data[key] });
                this.ValueList = valueray;
 
            }
            console.log('Vt' + JSON.stringify(this.ValueList));
        } else if (error) {
            this.data = undefined;
        }
 
    }
 
 
   @track valay;
    @wire(temList, { Id: '$tower' })
    retriveFloor({ error, data }) {
        if (data) {
            this.valay = data;
            console.log('valay' + JSON.stringify(this.valay));
        } else if (error) {
            this.valay = undefined;
        }
 
    }
 
    @wire(dataTable, { Id: '$tower' })
    dataLoop;
 
   
 
    /*
    reverseListfloor;
        @wire(listSort, { Id: '$tower' }) 
        retriveFloor({ error, data }) {
            let rf = [];
            if (data) {
              /*  for(var i=1 ; i>data.length ; i++){
                    data[i];
                    rf.push( data[i] );
                }*/

/*
            for (let key in data) {
                rf.push({ key: key[data] });
                this.reverseListfloor = rf;
               
            } 
            console.log('Vt' + this.reverseListfloor);
        } else if (error) {
            this.data = undefined;
        }
        
    }
*/



/*
    @AuraEnabled (cacheable=true)
    public static map<string , Decimal> unitMap(string Id){
    map<string , Decimal> finalmap = new map<string , Decimal>(); 
    system.debug(finalmap) ; 
    list<Unit__c> unitList = [SELECT Id,Name ,Floor__c  FROM Unit__c  WHERE Tower__r.Id =: Id ORDER BY Floor__c DESC ];
    for(Unit__c m:unitList){
       finalmap.put(m.Name , m.Floor__c);
    }
         return   finalmap; 
    }  */
/*
    @wire(unt, { Id: '$tower' }) 
    retriveFloor({ error, data }) {
        if (data) {
            
            this.unitsonly = data;
           console.log('uo1'+JSON.stringify(this.unitsonly));
            //alert(data);
        } else if (error) {
            this.error = error;
        }
    }
 
     temploop;
 
    @wire(unitMap, { Id: '$tower' }) 
    Floor({ error, data }) {
        if (data) {
        this.temploop = data;
        console.log('uo'+JSON.stringify(this.temploop));
           
        } else if (error) {
            this.error = error;
        }
    }
 
 
/*
    @wire(getUnits, { Id: '$tower' }) retriveUnits( data) {
        let valueArray = [];
 
        if (data) {
            for (let key in data) {
                //alert(key);
                valueArray.push({value: data[key] });
                //console.log(valueArray);
                this.nextList = valueArray;
                console.log('NEXT'+JSON.stringify(this.nextList));
            }
        }
      
        
    }
 
 
  
 
/*
    @wire(getFloor, { Id: '$tower' }) retriveFloor({ error, data }) {
        if (data) {
            this.data = data;
            console.log('FLOOR'+ JSON.stringify(this.data));
        } else if (error) {
            this.error = error;
        }
    }
 
*/

/*employeeColumns = [
    { label: 'FLOOR ', fieldName: 'floor' },
    { label: 'UNIT 1', fieldName: 'unit1' },
    { label: 'UNIT 2', fieldName: 'unit2' },
    { label: 'UNIT 3', fieldName: 'unit3' },
    { label: 'UNIT 4', fieldName: 'unit4' }
];
 
employeeData = [
    {
        floor: '1',
        unit1: '101,102,103,104'
        
    },
    {
        floor: '2',
        unit1: '201',
        unit2: '202',
        unit3: '203',
        unit4: '204'
    },
    {
        floor: '3',
        unit1: '301',
        unit2: '302',
        unit3: '303',
        unit4: '304'
    },
    {
        floor: '4',
        unit1: '401',
        unit2: '402',
        unit3: '403',
        unit4: '404'
    }
];*/



/*
    @track htmldata;
    @track columns = [{ label: 'Floor', fieldName: 'Floor__c', type: 'text' },
    { label: 'Name', fieldName: 'Name', type: 'text' }];
 
    @wire(unitHtml, { Id: '$tower' })
    unrecords({ error, data }) {
        if (data) {
            this.htmldata = data;
            console.log(this.htmldata);
            // console.log('htmltable'+JSON.stringify(this.htmldata));
        }
        if (error) {
            this.data = undefined;
        }
    }
*/

/*
renderedCallback() {

var elements;
elements = this.template.querySelectorAll('p');
 
//console.log('ery' + (elements.getAttribute("p[BLOCKED]")));

for (let i = 0; i < elements.length; i++) {

    
    console.log('query' + JSON.stringify((elements[i].innerHTML)));

    elements[i].style.backgroundColor = "white";
    console.log(elements[i]);

}
}*/

/* ------------------------ important------------------
 
 @wire(unitHtml, { Id: '$tower' })
 retriveUnits({ error, data }) {
    
     let keyArray = [];
     let valueArray = [];
     if (data) {
         for (let key in data) {
             keyArray.push(data[key]);
             valueArray.push({ key: key, Value: data[key]  });
             this.ValueOptionList = valueArray
             //[0].Value;
             //console.log( this.ValueOptionList);
             //  console.log('new'+this.ValueOptionList);
             this.OnlyUnits = keyArray.sort(function(a, b){return a - b});
           //  console.log( 'sort'+this.OnlyUnits);
         }
     //    console.log('valoptions' + JSON.stringify(this.ValueOptionList));
      //   console.log('OnlyUnits' + JSON.stringify(this.OnlyUnits));
      //   console.log('valarray' + this.ValueOptionList[0].Value);
         this.ValueOptionList = this.ValueOptionList.reverse();
         //console.log('key' + JSON.stringify(this.OnlyUnits));
         console.log('ValueOptionList' + JSON.stringify(this.ValueOptionList));
     }
     else if (error) {
         this.data = undefined;
     }
 
 }
 ----------------------------------------------------------------------------------*/

