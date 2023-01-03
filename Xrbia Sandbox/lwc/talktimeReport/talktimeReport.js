import { LightningElement,api,track,wire } from 'lwc';
import getProject from '@salesforce/apex/talktimeReport.getProject';
import Wrapper from '@salesforce/apex/talktimeReport.Wrapper';

export default class TalktimeReport extends LightningElement {
    @track project;
    @api startdate;
    @api enddate;
    @track projectOptionList;
    @api keyOptionList;
    @track isSpinner = false;
    @track isLoading = false;

    @wire (getProject) retrieveProject ({error,data}){
        let tempArray = [];
        if(data){
            tempArray.push({label:'All',value:'All'});
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
    handleStartDate(event){
        this.startdate = event.target.value;
    }
    handleEndDate(event){
        this.enddate = event.target.value;
    }
    
    @wire(Wrapper,{pId:'$project',sdate:'$startdate',edate:'$enddate'}) getData({data}){
        let wrapperArray=[];
        if(data){	
            for(let key in data){
                wrapperArray.push({key:key, value:data[key]});
                this.keyOptionList = wrapperArray;  
                console.log(this.keyOptionList);
            }
        }
    }
    /*refreshComponent(){
        eval("$A.get('e.force:refreshView').fire();");
    }*/
    refreshComponent(event){
        this.handleIsLoading(true);
        this.updateRecordView();
        this.handleIsLoading(false);

    }
    handleIsLoading(isLoading) {
        this.isLoading = isLoading;
    }
    updateRecordView() {
        setTimeout(() => {
             eval("$A.get('e.force:refreshView').fire();");
        }, 500); 
    }

}