import { LightningElement,api,track,wire } from 'lwc';
import getProject from '@salesforce/apex/cancellationSalesReport.getProject';
import Wrapper from '@salesforce/apex/cancellationSalesReport.Wrapper';

export default class CancellationReport extends LightningElement {
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
        window.alert('cliced');
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
        doc += '<th>Total Cancel</th>'
        doc += '<th>Agreement Value</th>'
        doc += '<th>Cl Amount</th>'
        doc += '<th>ref amount requested</th>'
        doc += '<th>ref amount approved</th>'
        doc += '<th>ref amount paid</th>'        
        
        this.keyOptionList.forEach(record => {    
            doc += '<tr>';
            doc += '<th>'+record.key+'</th>'; 
            doc += '<td>'+record.value.totalCancelBooking+'</td>'; 
            doc += '<td>'+record.value.agreementCount+'</td>';
            doc += '<td>'+record.value.clAmountCount+'</td>';
            doc += '<td>'+record.value.refamountrequestedCount+'</td>';
            doc += '<td>'+record.value.refamountapprovedCount+'</td>';
            doc += '<td>'+record.value.refamountpaidCount+'</td>';                       
            doc += '</tr>';
        });
        doc += '</table>';
        var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
        let downloadElement = document.createElement('a');
        downloadElement.href = element;
        downloadElement.target = '_self';
        // use .csv as extension on below line if you want to export data as csv
        downloadElement.download = 'Cancel Report.xls';
        document.body.appendChild(downloadElement);
        downloadElement.click();
    }
}