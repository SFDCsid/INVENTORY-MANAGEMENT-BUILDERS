import { LightningElement,api,track,wire } from 'lwc';
import getProject from '@salesforce/apex/salesReportpd.getProject';
import Wrapper from '@salesforce/apex/salesReportpd.Wrapper';

export default class SalesReportpd extends LightningElement {
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
            doc += '<td>'+record.value.totalBankLoanBooking+'</td>'; 
            doc += '<td>'+record.value.cibilDoneCount+'</td>';
            doc += '<td>'+record.value.cibilNotDoneCount+'</td>';
            doc += '<td>'+record.value.BacCibilClearCount+'</td>';
            doc += '<td>'+record.value.BacCibilNotClearCount+'</td>';
            doc += '<td>'+record.value.BacCibilNotClearCountInTatCanc+'</td>';
            doc += '<td>'+record.value.BacCibilNotClearCountInTatNotCanc+'</td>';
            doc += '<td>'+record.value.netBookingCount+'</td>';
            doc += '<td>'+record.value.agreementValueSum+'</td>';
            /*doc += '<td>'+record.value.dailyConnectedCount+'</td>';
            doc += '<td>'+record.value.talkTimeCount+'</td>';*/
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
    }

}