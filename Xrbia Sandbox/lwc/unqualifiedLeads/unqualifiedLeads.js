import { LightningElement,api,wire,track } from 'lwc';
import getProject from '@salesforce/apex/unqualifiedData.getProject';
import Wrapper from '@salesforce/apex/unqualifiedData.Wrapper';

export default class TerminationReport extends LightningElement {

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
        doc += '<th>All Leads</th>'
        doc += '<th>Unqualified Leads</th>'
        doc += '<th>Unqualified Leads %</th>'
        
        this.keyOptionList.forEach(record => {    
            doc += '<tr>';
            doc += '<th>'+record.key+'</th>'; 
            doc += '<td>'+record.value.totalLeads+'</td>'; 
            doc += '<td>'+record.value.unqualifiedLeads+'</td>';
            doc += '<td>'+record.value.unqualifiedPercent+'</td>';
            /*doc += '<td>'+record.value.ringingCount+'</td>';
            doc += '<td>'+record.value.unqualifiedCount+'</td>';
            doc += '<td style= "background-color:yellow;">'+record.value.svpCount+'%</td>';
            doc += '<td style= "background-color:yellow;">'+record.value.ringingpercentCount+'%</td>';
            doc += '<td style= "background-color:yellow;">'+record.value.unqualifiedPercentCount+'%</td>';
            doc += '<td>'+record.value.totalConnectedCount+'</td>';
            doc += '<td>'+record.value.dailyConnectedCount+'</td>';
            doc += '<td>'+record.value.talkTimeCount+'</td>';*/
            doc += '</tr>';
        });
        doc += '</table>';
        var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
        let downloadElement = document.createElement('a');
        downloadElement.href = element;
        downloadElement.target = '_self';
        // use .csv as extension on below line if you want to export data as csv
        downloadElement.download = 'Unqualified Leads Report.xls';
        document.body.appendChild(downloadElement);
        downloadElement.click();
    }
}