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

import { NavigationMixin } from "lightning/navigation";



import loop from '@salesforce/apex/PRACTICECLASS.loop';

export default class PractiseLwc extends NavigationMixin(LightningElement) {
    @api project;
    @api sector;
    @api tower;
    @api recordId;


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


    




    renderedCallback() {

        var elements;
        elements = this.template.querySelectorAll('p');
        
        //console.log('ery' + (elements.getAttribute("p[BLOCKED]")));

        for (let i = 0; i < elements.length; i++) {

            
            console.log('query' + JSON.stringify((elements[i].innerHTML)));

            elements[i].style.backgroundColor = "white";
            console.log(elements[i]);

        }
    }


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








    @track objectList;
    @track staTus;
    @track datarecords=[];


    @wire(unitHtml2, { Id: '$tower' })
    retriveUnits({ error, data }) {
        let keyRay = [];
       
        if (data) {

            this.record=data;

            for(var i=0;i<this.record.length;i++){
                console.log('Inside for loop!!');
                let obj={
                    
                    "Status":this.record[i].Status__c
                    
               }
               if(this.record[i].Status__c=='Sold'){
                obj.className = 'sold'
            }
            else if(this.record[i].Status__c=='Available'){
                obj.className = 'avail'
            }
            else if(this.record[i].Status__c=='Booked'){
                obj.className = 'book'
            }
              this.datarecords.push(obj);
              console.log('Inside for loop!!'+JSON.stringify(obj));
            }
            
            for (let key in data) {

              


                // .sort(function(a, b){return a - b})
                keyRay.push({ FLOOR: key, Value: data[key]  });
                this.objectList = keyRay.sort(function (a, b) { return a.FLOOR - b.FLOOR }).reverse();


                var index = this.objectList.findIndex(item => item.id === this.Value);

                 console.log('colour'+JSON.stringify(this.index));

                 
                
            }

            
            // console.log(JSON.stringify(this.objectList));
            //  console.log('eyray'+JSON.stringify(this.objectList[0].Value[0].Status__c));



        }
        else if (error) {
            this.objectList = undefined;
        }
    }


    leadlist
    @wire(unt, { Id: '$tower' }) 
    lead({error,data}){
      if(data){
        this.leadlist = data;
       // console.log('this.leadlist'+JSON.stringify(this.leadlist));
      }
      else if(error){
        this.leadlist = undefined;
      }
    }
    


    @wire(temList, { Id: '$tower' })
    retriveFloor({ error, data }) {
        let valueray = [];
        if (data) {
            this.valueray = data;
          //  console.log('valueray' + JSON.stringify(this.valueray));
          // this.template.style.backgroundColor = "red";

        } else if (error) {
            this.data = undefined;
        }
        // let typ = this.template.querySelectorall("[Status__c='BLOCKED']");
        //console.log('typ'+JSON.stringify(this.typ));

        
    }



    //--------------------------------------------------------------------------

    @track options = [];
    @track textColorClass;

    handle_Green_Text_Click(event) {
        this.textColorClass = 'green';
    }






    //------------------------------------------------------------------------------------




    /*   changeColour(){
           this.template.querySelector('[data.id = "myDiv"]').classList.add('redColour');
       }  */

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


}