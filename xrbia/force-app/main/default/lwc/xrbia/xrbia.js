import { LightningElement, track, wire } from 'lwc';
import getProject from '@salesforce/apex/xrbiadata.getProject';
import getTower from '@salesforce/apex/xrbiadata.getTower';
import getUnit from '@salesforce/apex/xrbiadata.getUnit';
import getSector from '@salesforce/apex/xrbiadata.getSector';

export default class Xrbia extends LightningElement {
    projectOptionList;
    error;

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

   /* @wire(getProject) 
    projectrecords({error , data}){
      let arr = [];
      if(data){
        for(let key in data){
            arr.push({ label: data[key], value:key });
        }
        this.projectOptionList = arr;
       
      }
      
      else if(error){
        this.error=undefined;
      }
      
   
    }

    
   
    
/* 
    @wire(getProject) 
    projectrecords({ error, data }) {
       
        if (data) {
           this.projectOptionList1 = data.Name;
           
            
        }
       else if (error) {
            console.log(error);
        }
        console.log('name'+projectOptionList1);
        
    }
   

    


   

   --------------
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

--------------------













 
      @track value ="";
      @track options = [];
      @track tower = [];
  
      get options() {
          return this.options;
          
      }
  
      connectedCallback(){
          getProject()
          .then(result => {
              let arr = [];
              for (var i=0 ; i<result.length ; i++){
                  arr.push({label: result[i].Name})
              }
              this.options=arr
          })
      }
  
      handleProject(event) {
          this.value = event.detail.value;
      }
  
      get tower() {
          return this.tower;
          
      }
  
      connectedCallback(){
          getTower()
          .then(result => {
              let arr = [];
              for (var i=0 ; i<result.length ; i++){
                  arr.push({label: result[i].Name})
              }
              this.tower=arr
          })
      }
  
     @track projectOptionList;
     @track value='';
     @track sectorOptionList;
  
     get projectOptionList(){
       return this.projectOptionList;
     }
  
     connectedCallback(){
      getProject()
      .then(result => {
          let arr = [];
          for (var i=0 ; i<result.length ; i++){
              arr.push({label: result[i].Name , value: result[i].Name})
              console.log(arr);
          }
          this.projectOptionList=arr;
          //console.log(this.projectOptionList);
      })
      handleChangeProject(event){
          this.value = event.target.value;
  
         console.log(this.value);
  
     }
  
     
       getSector()
       .then(result => {
           let arr = [];
           for (var i=0 ; i<result.length ; i++){
               arr.push({label: result[i].Name , value: result[i].Name})
           }
           this.sectorOptionList=arr;
       })
      
     }
  
  
  
     
     
  
     
     get projectOptionList(){
      return this.sectorOptionList;
    }
  
   
  
     handleSectorChange(event){
      this.value = event.target.value;
  }
  */
}