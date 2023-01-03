import { LightningElement,wire,track,api } from 'lwc';
import getProject from '@salesforce/apex/fetchData.getProject';
import getSector from '@salesforce/apex/fetchData.getSector';
import getTower from '@salesforce/apex/fetchData.getTower';
import getUnits from '@salesforce/apex/fetchData.getUnits';
import getFloor from '@salesforce/apex/fetchData.getFloor';


export default class RealEstate1 extends LightningElement {
    @api project;
    @api sector;
    @api tower;
    @track data;
    @track keyOptionList = [];
    @track valueOptionList = [];
    @track totalFloor = [];

    unit;
    projectOptionList;
    sectorOptionList;
    towerOptionList;

    @wire (getProject) retrieveProject ({error,data}){
        let tempArray = [];
        if(data){
            for(let key in data){
                tempArray.push({label:data[key],value:key});
            }
            this.projectOptionList = tempArray;  
        }
        else if(error){
            this.result = undefined;
        }
    }
    handleChangeProject(event) {
        this.project = event.detail.value;
    }
    @wire (getSector,{Id:'$project'}) retriveSector ({error,data}){
        let array = [];
        if(data){
            for(let key in data){
                array.push({label:data[key],value:key});
            }
            this.sectorOptionList = array;  
        }
        else if(error){
            this.result = undefined;
        }
    }
    handleSectorChange(event) {
        this.sector = event.detail.value;
    }
    @wire (getTower,{Id:'$sector'}) retriveTower ({error,data}){
        let tempArray = [];
        if(data){
            for(let key in data){
                tempArray.push({label:data[key],value:key});
            }
            this.towerOptionList = tempArray;  
        }
        else if(error){
            this.result = undefined;
        }
    }    
    handleTowerChange(event) {
        this.tower = event.detail.value;
        //console.log(this.tower);
    } 

    /*@wire(getFloor,{Id:'$tower'}) retriveFloor({result}){
        let floorArray=[];
        
        if(result.data){
            alert('in getFloor1');
            for(let key in result){
                floorArray.push({key:key});
                this.totalFloor = floorArray;
            }
        }
    }*/
    /*@wire(getFloor,{Id:'$tower'}) retriveFloor({result}){
        if(result.data){
            this.data = result.data;
            alert(this.data);
        }else if(error){
            this.error = error;
        }
    }

    @wire (getUnits,{Id:'$tower'}) retriveUnits(result){
        let keyArray=[];
        //alert('key');
        if(result.data){ 
                for(let key in result.data){
                //alert(key);
                keyArray.push({key:key}); 
                this.keyOptionList = keyArray; 
            }
        }
    }
    @wire (getUnits,{Id:'$tower'}) retriveUnits(result){
        let valueArray=[];
        //alert('key');
        if(result.data){
            for(let key in result.data){
                
                valueArray.push({value:result.data[key]});
                console.log(valueArray);
                this.valueOptionList = valueArray;
                //console.log(this.valueOptionList);
            }
        }
    }*/
}