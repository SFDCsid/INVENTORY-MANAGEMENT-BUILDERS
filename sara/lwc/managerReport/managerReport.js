import { LightningElement,api,wire,track } from 'lwc';
import getProject from '@salesforce/apex/reportData.getProject';
import Wrapper from '@salesforce/apex/reportData.Wrapper';
//import getTotals from '@salesforce/apex/reportData.getTotals';

export default class ManagerReport extends LightningElement {
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
        doc += '<th>Total Lead</th>'
        doc += '<th>Site Visit</th>'
        doc += '<th>Bookings</th>'
        doc += '<th>Ringing</th>'
        doc += '<th>Unqualified</th>'
        doc += '<th>SiteVisit %</th>'
        doc += '<th>Ringing %</th>'
        doc += '<th>Unqualified %</th>'
        doc += '<th>Total Connected</th>'
        doc += '<th>Daily Connected Call</th>'
        doc += '<th>Talk-Time</th>'
        doc += '<center> Presale Agent Report </center>'
        
        this.keyOptionList.forEach(record => {    
            doc += '<tr>';
            doc += '<th>'+record.key+'</th>'; 
            doc += '<td>'+record.value.lCount+'</td>'; 
            doc += '<td>'+record.value.svCount+'</td>';
            doc += '<td>'+record.value.bkCount+'</td>';
            doc += '<td>'+record.value.ringingCount+'</td>';
            doc += '<td>'+record.value.unqualifiedCount+'</td>';
            doc += '<td style= "background-color:yellow;">'+record.value.svpCount+'%</td>';
            doc += '<td style= "background-color:yellow;">'+record.value.ringingpercentCount+'%</td>';
            doc += '<td style= "background-color:yellow;">'+record.value.unqualifiedPercentCount+'%</td>';
            doc += '<td>'+record.value.totalConnectedCount+'</td>';
            doc += '<td>'+record.value.dailyConnectedCount+'</td>';
            doc += '<td>'+record.value.talkTimeCount+'</td>';
            doc += '</tr>';
        });
        doc += '</table>';
        var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
        let downloadElement = document.createElement('a');
        downloadElement.href = element;
        downloadElement.target = '_self';
        // use .csv as extension on below line if you want to export data as csv
        downloadElement.download = 'Presale Agent Report.xls';
        document.body.appendChild(downloadElement);
        downloadElement.click();
    }
}
    /*handleClick(){ 
        Wrapper({pId:'$project' , sdate:'$startdate' , edate:'$enddate'}) 
        .then((result) => {
            console.log('result', result);
            this.wrapperArray = [];
            for (var key in result) {
                this.wrapperArray.push({ key: key, value: result[key] });
                console.log('key', key, result[key]);
            }
        })
        .catch((error) => {
            console.log(error);
        });
    }*/