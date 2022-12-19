import { LightningElement,api,track,wire } from 'lwc';
import getProject from '@salesforce/apex/reportData.getProject';
import Wrapper from '@salesforce/apex/reportData.Wrapper';
import getCampaign from '@salesforce/apex/reportData.getCampaign';

export default class AgentReport extends LightningElement {

    @api campaign;
    @api project;
    @api startdate;
    @api enddate;
    @track projectOptionList;
    @api keyOptionList;
    @api campaignOptionList;

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
        alert(this.project);
    }

    @wire (getCampaign,{pId:'$project'}) retrieveCamapign({error,data}){
        let campArray = [];
        if(data){
            for(let key in data){
                campArray.push({label:data[key],value:key});
            }
            this.campaignOptionList = campArray;
        }
        else if(error){
            this.result = undefined;
        }
    }
    handleChangeCampaign(event) {
        this.campaign = event.detail.value;
        alert(this.campaign);
    }
    
    handleStartDate(event){
        this.startdate = event.target.value;
        alert(this.startdate);
    }
    handleEndDate(event){
        this.enddate = event.target.value;
        alert(this.enddate);
    }

    @wire(Wrapper,{pId:'$project',sdate:'$startdate',edate:'$enddate',cId:'campaign'}) getDataReports({data}){
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