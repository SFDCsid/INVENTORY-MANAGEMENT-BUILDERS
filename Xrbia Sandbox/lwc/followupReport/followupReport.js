import { LightningElement,api,wire,track } from 'lwc';
import getProject from '@salesforce/apex/followupReportData.getProject';
import Wrapper from '@salesforce/apex/followupReportData.Wrapper';

export default class FollowupReport extends LightningElement {

    @track project;
    @api startdate;
    @api enddate;
    @track projectOptionList;
    @api keyOptionList;
    @track error;
    @track data;
    @api All;
    @api totalValues;

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
    @wire(Wrapper,{pId:'$project',sdate:'$startdate',edate:'$enddate'}) getDataReports({data}){
        let wrapperArray=[];
        if(data){	
            for(let key in data){
                wrapperArray.push({key:key, value:data[key]});
                this.keyOptionList = wrapperArray;  
                console.log(this.keyOptionList);
            }
        }
    }
}