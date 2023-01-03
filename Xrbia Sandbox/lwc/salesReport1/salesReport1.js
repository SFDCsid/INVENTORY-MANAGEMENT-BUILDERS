import { LightningElement,api,track,wire } from 'lwc';
import getProject from '@salesforce/apex/SalesReport1Data.getProject';
import Wrapper from '@salesforce/apex/SalesReport1Data.Wrapper';

export default class SalesReport1 extends LightningElement {
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
        doc += '<th>No. Of Leads in f up from SVC</th>'
        doc += '<th>No. Of Leads in uq from SVC</th>'
        doc += '<th>No. Of Bookings from SVC</th>'
        doc += '<th>Booking Agr Value </th>'
        doc += '<th>total Canc</th>'
        doc += '<th>net bookings</th>'
        doc += '<th>Bookings in BL</th>'
        doc += '<th>Bookings in SF</th>'
        
        this.keyOptionList.forEach(record => {    
            doc += '<tr>';
            doc += '<th>'+record.key+'</th>'; 
            doc += '<td>'+record.value.totalOpportunities+'</td>'; 
            doc += '<td>'+record.value.UnqualifiedOpportunities+'</td>';
            doc += '<td>'+record.value.BookingOpportunity+'</td>';
            doc += '<td>'+record.value.totalAgrValue+'</td>';
            doc += '<td>'+record.value.totalCancel+'</td>';
            doc += '<td>'+record.value.totalNetBooking+'</td>';
            doc += '<td>'+record.value.bankBookings+'</td>';
            doc += '<td>'+record.value.selfFundingBooking+'</td>';
            /*doc += '<td>'+record.value.totalConnectedCount+'</td>';
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
        downloadElement.download = 'Sales Report.xls';
        document.body.appendChild(downloadElement);
        downloadElement.click();
    }
}