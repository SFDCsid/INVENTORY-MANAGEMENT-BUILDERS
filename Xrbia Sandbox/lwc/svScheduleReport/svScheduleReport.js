import { LightningElement,wire,api,track } from 'lwc';
import getProject from '@salesforce/apex/svScheduleReport.getProject';
import Wrapper from '@salesforce/apex/svScheduleReport.Wrapper';

export default class SvScheduleReport extends LightningElement {

    @track project;
    @api startdate;
    @api enddate;
    @track projectOptionList;
    @api keyOptionList;

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
        //alert(this.project);
    }
    handleStartDate(event){
        this.startdate = event.target.value;
        //alert(this.startdate);
    }
    handleEndDate(event){
        this.enddate = event.target.value;
        //alert(this.enddate);
    }
    @wire(Wrapper,{pId:'$project',sdate:'$startdate',edate:'$enddate'}) wrapperData({data}){
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
        doc += '<th>SV Scheduled in Followup</th>'
        doc += '<th>SV Scheduled in Followup Conducted</th>'
        doc += '<th>SV Scheduled in Followup Not Conducted</th>'
        doc += '<th>Call Answered</th>'
        doc += '<th>Call Not Answered</th>'
        doc += '<th>CNR > 5</th>'
        doc += '<th>Unqualified Due to CNR > 5</th>'
        
        this.keyOptionList.forEach(record => {    
            doc += '<tr>';
            doc += '<th>'+record.key+'</th>'; 
            doc += '<td>'+record.value.leadCount+'</td>'; 
            doc += '<td>'+record.value.totalFollowupConducted+'</td>';
            doc += '<td>'+record.value.totalFollowupNotConducted+'</td>';
            doc += '<td>'+record.value.callAnswered+'</td>';
            doc += '<td>'+record.value.callUnanswered+'</td>';
            doc += '<td>'+record.value.cnrCounter+'</td>';
            doc += '<td>'+record.value.unqualifiedCount+'</td>';
            doc += '</tr>';
        });
        doc += '</table>';
        var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
        let downloadElement = document.createElement('a');
        downloadElement.href = element;
        downloadElement.target = '_self';
        // use .csv as extension on below line if you want to export data as csv
        downloadElement.download = 'Site Visit Schedule Report.xls';
        document.body.appendChild(downloadElement);
        downloadElement.click();
    }
}