import { LightningElement ,wire,api,track} from 'lwc';
import projectData from '@salesforce/apex/projectController.projectData';

export default class Project extends LightningElement {
   
    @track record=[]
    @track datarecords=[]
    @track error
    @wire(projectData)
    projects({error,data}){
        if(data){
            this.record=data;
            console.log('this.record'+this.record);
            console.log('this.record'+JSON.stringify(data));
            for(var i=0;i<this.record.length;i++){
                console.log('Inside for loop!!');
                let obj={
                    "Id":this.record[i].Id,
                    "Name":this.record[i].Name,
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
            console.log('this.datarecords'+this.datarecords);
            console.log('this.datarecords'+JSON.stringify(this.datarecords));
        }
        else if(error){
            this.error=error;
            this.record=undefined;
            console.log('error!!');
        }

    }
    
}