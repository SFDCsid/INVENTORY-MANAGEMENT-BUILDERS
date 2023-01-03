import { LightningElement,api,track,wire } from 'lwc';
import getProject from '@salesforce/apex/salesReportsf.getProject';
import Wrapper from '@salesforce/apex/salesReportsf.Wrapper';

export default class SalesReportsf extends LightningElement {
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
    @wire(Wrapper,{pId:'$project',sdate:'$startdate',edate:'$enddate'}) getRecords({data}){
        let wrapperArrayList=[];
        if(data){	        
            for(let key in data){
                wrapperArrayList.push({key:key, value:data[key]});
                this.keyOptionList = wrapperArrayList;  
                console.log(this.keyOptionList);
            }
        }
    }
    
    /*exportReportData(){
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
        doc += '<th>Total Bank Loan bookings</th>'
        doc += '<th>cibil done</th>'
        doc += '<th>cibil not done</th>'
        doc += '<th>bac+ cibil: clear</th>'
        doc += '<th>bac + cibil : not clear in tat</th>'
        doc += '<th>bac + cibil : not clear in tat canc</th>'
        doc += '<th>bac + cibil : not clear in tat not canc</th>'
        doc += '<th>net booking after bac and cibil clear no</th>'
        doc += '<th>net booking after bac and cibil clear av</th>'
        
        this.keyOptionList.forEach(record => {    
            doc += '<tr>';
            doc += '<th>'+record.key+'</th>'; 
            doc += '<td>'+record.value.totalBankLoanBooking1+'</td>'; 
            doc += '<td>'+record.value.cibilDoneCount1+'</td>';
            doc += '<td>'+record.value.cibilNotDoneCount1+'</td>';
            doc += '<td>'+record.value.BacCibilClearCount1+'</td>';
            doc += '<td>'+record.value.BacCibilNotClearCount1+'</td>';
            doc += '<td>'+record.value.BacCibilNotClearCountInTatCanc1+'</td>';
            doc += '<td>'+record.value.BacCibilNotClearCountInTatNotCanc1+'</td>';
            doc += '<td>'+record.value.netBookingCount1+'</td>';
            doc += '<td>'+record.value.agreementValueSum1+'</td>';            
            doc += '</tr>';
        });
        doc += '</table>';
        var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
        let downloadElement = document.createElement('a');
        downloadElement.href = element;
        downloadElement.target = '_self';
        // use .csv as extension on below line if you want to export data as csv
        downloadElement.download = 'Sales Report (PD).xls';
        document.body.appendChild(downloadElement);
        downloadElement.click();
    }*/
}