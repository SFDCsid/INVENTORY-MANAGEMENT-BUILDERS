import { LightningElement,api,wire,track } from 'lwc';
import getProject from '@salesforce/apex/callCenterData.getProject';
import Wrapper from '@salesforce/apex/callCenterData.Wrapper';

export default class CallCenterReport extends LightningElement {

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
    exportReportData(){
        // Prepare a html table
        let doc = '<table>';
        // Add styles for the table
        doc += '<style>';
        doc += 'table, th {';
        doc += '    border: 1px solid black;';
        doc += '    border-collapse: collapse;';
        doc += '}';  
        doc += 'table, td {';
        doc += '    border: 1px solid black;';
        doc += '    border-collapse: collapse;';
        doc += '}';          

        doc += '</style>';
        doc += '<th>Agent Name</th>'
        doc += '<th>Incoming Calls Generated</th>'
        doc += '<th>Incoming Calls Assigned</th>'
        doc += '<th>Incoming Calls forming Leads</th>'
        doc += '<th>Incoming Calls Not forming Leads</th>'
        doc += '<th>Call Answered less than 20s</th>'
        doc += '<th>Call Answered more than 20s</th>'
        doc += '<th>Total Missed Calls</th>'
        doc += '<th>Missed Calls from Unique Leads</th>'
        doc += '<th>Call back to Unique Leads</th>'
        doc += '<th>Call Received By Unique Leads</th>'
        doc += '<th>CNR more than 5</th>'
        doc += '<th>Unqualified due to CNR</th>'
        
        this.keyOptionList.forEach(record => {    
            doc += '<tr>';
            doc += '<th>'+record.key+'</th>'; 
            doc += '<td>'+record.value.incomingCalls+'</td>'; 
            doc += '<td>'+record.value.incomingAssignedCalls+'</td>';
            doc += '<td>'+record.value.incomingFormingLeads+'</td>';
            doc += '<td>'+record.value.incomingNotFormingLeads+'</td>';
            doc += '<td>'+record.value.moreThan20s+'</td>';
            doc += '<td>'+record.value.lessThan20s+'</td>';
            doc += '<td>'+record.value.totalMissCall+'</td>';
            doc += '<td>'+record.value.uniqueMissLead+'</td>';
            doc += '<td>'+record.value.callBackToUniqueLead+'</td>';
            doc += '<td>'+record.value.callReceivedByUnique+'</td>';
            doc += '<td>'+record.value.callNotReceived+'</td>';
            doc += '<td>'+record.value.unqualifiedDueToCNR+'</td>';
            doc += '</tr>';
        });
        doc += '</table>';
        var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
        let downloadElement = document.createElement('a');
        downloadElement.href = element;
        downloadElement.target = '_self';
        // use .csv as extension on below line if you want to export data as csv
        downloadElement.download = 'Call Center Report.xls';
        document.body.appendChild(downloadElement);
        downloadElement.click();
    }
}