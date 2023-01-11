public class IssueManagementService_Pack {
    
    public String oName {get;set;}
    public String oId {get;set;}
    public String otype{get;set;}
    public String oStatus {get;set;}
    public String oRaised {get;set;}
    public String oprio{get;set;}
    public String oDept {get;set;}
    public String oSub {get;set;}
    public String oDesc {get;set;}
    public String oModule {get;set;}
    public String oStream {get;set;}
    public String oPriResource{get;set;}
    public String nName {get;set;}
    public String ntype{get;set;}
    public String nStatus {get;set;}
    public String nRaised {get;set;}
    public String nprio{get;set;}
    public String nDept {get;set;}
    public String nSub {get;set;}
    public String nDesc{get;set;}
    public String nModule {get;set;}
    public String nStream {get;set;}
    public String nPriResource{get;set;}
    
    public String oPrioDate{get;set;}
    public String nPrioDate{get;set;}
    
    public String nAnaDesc{get;set;}
    //public String nAnaDet{get;set;}
    public String nAnaSubDate{get;set;}
    public String nEstEfrt{get;set;}
    //public String nEstDate{get;set;}
    public String nCloseDate{get;set;}
    public String nDevStartDate{get;set;}
    public String nGdrd{get;set;}
    public String nGprd{get;set;}
    public String nReOpenD{get;set;}
    public String nUat{get;set;}
    
    public String oAnaDesc{get;set;}
    //public String oAnaDet{get;set;}
    public String oAnaSubDate{get;set;}
    public String oEstEfrt{get;set;}
    //public String oEstDate{get;set;}
    public String oCloseDate{get;set;}
    public String oDevStartDate{get;set;}
    public String oGdrd{get;set;}
    public String oGprd{get;set;}
    public String oReOpenD{get;set;}
    public String oUat{get;set;}
    
    public String nLastUpdateBy{get;set;}
    public String nLastUpdateDate{get;set;}
    public String nLastUpdateDesc{get;set;}
    
    public String oLastUpdateBy{get;set;}
    public String oLastUpdateDate{get;set;}
    public String oLastUpdateDesc{get;set;}
    
    public IssueManagementService_Pack() {}
    
    public void sendIssueUpdateEmail(List<Issue__c> newIssue, List<Issue__c> oldIssue)
    {  
        System.debug('In method ::');
        Issue_UpdateServices__c emailDetails = Issue_UpdateServices__c.getValues('issueUpdateReceivers');
        System.debug(newIssue);
        System.debug(oldIssue);
        
        
        if(newIssue != null)
        {
            Messaging.Email[] mails = new Messaging.Email[0];
            
            oName = String.valueOf(oldIssue[0].Name);
            oId = String.valueOf(oldIssue[0].Id);        
            oType = String.valueOf(oldIssue[0].Type__c);
            oStatus = String.valueOf(oldIssue[0].Status__c);
            oRaised = String.valueOf(oldIssue[0].Raised_By__c);   
            oPrio = String.valueOf(oldIssue[0].Priority__c); 
            oDept = String.valueOf(oldIssue[0].Department__c);
            oSub = String.valueOf(oldIssue[0].Subject__c);
            oDesc = String.valueOf(oldIssue[0].Description__c);
            oModule = String.valueOf(oldIssue[0].Module__c);
            oStream = String.valueOf(oldIssue[0].Stream__c);
            oPriResource = String.valueOf(oldIssue[0].Primary_Resource__c);
            
            nName = String.valueOf(newIssue[0].Name);
            //nId = String.valueOf(newIssue[0].Id);
            nType = String.valueOf(newIssue[0].Type__c);
            nStatus = String.valueOf(newIssue[0].Status__c);
            nRaised = String.valueOf(newIssue[0].Raised_By__c);
            nPrio = String.valueOf(newIssue[0].Priority__c);
            nDept = String.valueOf(newIssue[0].Department__c);
            nSub = String.valueOf(newIssue[0].Subject__c);
            nDesc = String.valueOf(newIssue[0].Description__c);
            nModule = String.valueOf(newIssue[0].Module__c);
            nStream = String.valueOf(newIssue[0].Stream__c);
            nPriResource = String.valueOf(newIssue[0].Primary_Resource__c);
            
            nPrioDate = String.valueOf(newIssue[0].Prioritized_Date__c);
            oPrioDate = String.valueOf(oldIssue[0].Prioritized_Date__c);
            
            nLastUpdateBy = String.valueOf(newIssue[0].Last_Updated_By__c);
            nLastUpdateDate = String.valueOf(newIssue[0].Last_Updated_Date_TIme__c);
            nLastUpdateDesc = String.valueOf(newIssue[0].Last_Updated_Description__c);
            
            oLastUpdateBy = String.valueOf(oldIssue[0].Last_Updated_By__c);
            oLastUpdateDate = String.valueOf(oldIssue[0].Last_Updated_Date_TIme__c);
            oLastUpdateDesc = String.valueOf(oldIssue[0].Last_Updated_Description__c);
            nAnaDesc = String.valueOf(newIssue[0].Analysis_Description__c);
            //nAnaDet = String.valueOf(newIssue[0].Analysis_Details__c);
            nAnaSubDate = String.valueOf(newIssue[0].Analysis_Submitted_Date_Time__c);
            nEstEfrt = String.valueOf(newIssue[0].Estimated_Effort_Person_Days__c);
            //nEstDate = String.valueOf(newIssue[0].Estimated_Date__c);
            nCloseDate = String.valueOf(newIssue[0].Closed_Date__c);
            nDevStartDate = String.valueOf(newIssue[0].Development_Start_Date__c);
            nGdrd = String.valueOf(newIssue[0].Go_Ahead_for_development_received_Date__c);
            nGprd = String.valueOf(newIssue[0].Go_ahead_for_production_received_date__c);
            nReOpenD = String.valueOf(newIssue[0].ReOpen_Date__c);
            nUat = String.valueOf(newIssue[0].UAT_Start_Date__c);
            
            oAnaDesc = String.valueOf(oldIssue[0].Analysis_Description__c);
            //oAnaDet = String.valueOf(oldIssue[0].Analysis_Details__c);
            oAnaSubDate = String.valueOf(oldIssue[0].Analysis_Submitted_Date_Time__c);
            oEstEfrt = String.valueOf(oldIssue[0].Estimated_Effort_Person_Days__c);
            //oEstDate = String.valueOf(oldIssue[0].Estimated_Date__c);
            oCloseDate = String.valueOf(oldIssue[0].Closed_Date__c);
            oDevStartDate = String.valueOf(oldIssue[0].Development_Start_Date__c);
            oGdrd = String.valueOf(oldIssue[0].Go_Ahead_for_development_received_Date__c);
            oGprd = String.valueOf(oldIssue[0].Go_ahead_for_production_received_date__c);
            oReOpenD = String.valueOf(oldIssue[0].ReOpen_Date__c);
            oUat = String.valueOf(oldIssue[0].UAT_Start_Date__c);
            
            oSub = oSub == null ? '':oSub;
            nSub = nSub == null ? '':nSub;
            nPrioDate = nPrioDate == null ? '':nPrioDate;
            oPrioDate = oPrioDate == null ? '':oPrioDate;
            nDesc = nDesc == null ? '':nDesc;    
            oDesc = oDesc == null ? '':oDesc;
            oStream = oStream == Null ? '':oStream;
            nStream = nStream == Null ? '':nStream;
            oModule = oModule == null ? '':oModule;
            nModule = nModule == null ? '':nModule;
            oDesc = oDesc == null ? '':oDesc;
            nDesc = nDesc == null ? '':nDesc;
            
            nLastUpdateBy = nLastUpdateBy == null ? '':nLastUpdateBy;
            oLastUpdateBy = oLastUpdateBy == null ? '':oLastUpdateBy;
            oLastUpdateDate = oLastUpdateDate == null ? '':oLastUpdateDate;
            nLastUpdateDate = nLastUpdateDate == null ? '':nLastUpdateDate;
            oPriResource = oPriResource == null ? '':oPriResource;
            nPriResource = nPriResource == null ? '':nPriResource;
            oLastUpdateDesc = oLastUpdateDesc == null ? '':oLastUpdateDesc;
            nLastUpdateDesc = nLastUpdateDesc == null ? '':nLastUpdateDesc;
            oAnaDesc = oAnaDesc == null ? '':oAnaDesc;
            nAnaDesc = nAnaDesc == null ? '':nAnaDesc;    
            
            String oLastUpdateDates = '';
            String nLastUpdateDates = '';
            String oDevStartDateS = '';
            String nDevStartDateS = '';            
            String oReOpenDs = '';
            String nReOpenDs ='';
            String oGdrdS = '';    
            String nGdrdS = '' ;                
            String nGprdS = '';
            String oGprdS = '';
            String oUatS= '';
            String nUatS = '';
            String oPrioDateS = '';
            String nPrioDateS = '';
            String oAnaSubDateS = '';
            String nAnaSubDateS = '';
            String oCloseDateS = '';
            String nCloseDateS ='';            
            
            System.debug('--Isseue Date--'+oLastUpdateDate);
            if(oLastUpdateDate != Null && string.isNotBlank(oLastUpdateDate))
            {
                DateTime odt = DateTime.valueOf(oLastUpdateDate);
                oLastUpdateDateS = odt.format();
            }
            if(nLastUpdateDate != Null && string.isNotBlank(nLastUpdateDate))
            {
                DateTime ndt = DateTime.valueOf(nLastUpdateDate);
                nLastUpdateDateS = ndt.format();
            }
            if(oDevStartDate != Null && string.isNotBlank(oDevStartDate))
            {
                Date dt1 = Date.valueOf(oDevStartDate);
                oDevStartDateS = dt1.format();       
            }
            if(nDevStartDate != Null && string.isNotBlank(nDevStartDate)){
                Date dt2 = Date.valueOf(nDevStartDate);
                nDevStartDateS = dt2.format();      
            }
            if(nDevStartDate != Null && string.isNotBlank(nDevStartDate)){
                Date dt3 = Date.valueOf(nDevStartDate);
                nDevStartDateS = dt3.format();  
            }
            if(nReOpenD != Null && String.isNotBlank(nReOpenD))
            {
                Date dt4 = Date.valueOf(nReOpenD);
                nReOpenDs = dt4.format();
            }    
            if(oGdrd !=Null && string.isNotBlank(oGdrd))
            {
                Date dt5 = Date.valueOf(oGdrd);
                oGdrdS = dt5.format();
            }
            if(nGdrd !=Null && string.isNotBlank(nGdrd))
            {
                Date dt6= Date.valueOf(nGdrd);
                nGdrdS = dt6.format();
            }    
            if( nGprd !=Null && string.isNotBlank(nGprd))
            {
                Date dt7 = Date.valueOf(nGprd);
                nGprdS = dt7.format();
            }
            if(oGprd !=Null && string.isNotBlank(oGprd))
            {
                Date dt8 = Date.valueOf(oGprd);
                oGprdS = dt8.format();
            }    
            if(oUat !=Null && string.isNotBlank(oUat))
            {
                Date dt9 = Date.valueOf(oUat);
                oUatS = dt9.format();
            }    
            if( nUat !=Null && string.isNotBlank(nUat))
            {
                Date dt10 = Date.valueOf(nUat);
                nUatS = dt10.format();
            }
            if(oPrioDate !=Null && string.isNotBlank(oPrioDate))
            {
                Date dt11 = Date.valueOf(oPrioDate);
                oPrioDateS = dt11.format();
            }
            if( nPrioDate !=Null && string.isNotBlank(nPrioDate))
            {
                Date dt12 = Date.valueOf(nPrioDate);
                nPrioDateS = dt12.format();
            }
            if( oAnaSubDate !=Null && string.isNotBlank(oAnaSubDate))
            {
                Date dt13 = Date.valueOf(oAnaSubDate);
                oAnaSubDateS = dt13.format();
            }
            if(nAnaSubDate !=Null && string.isNotBlank(nAnaSubDate))
            {
                Date dt14 = Date.valueOf(nAnaSubDate);
                nAnaSubDateS = dt14.format();
            }
            if(oCloseDate !=Null && string.isNotBlank(oCloseDate))
            {
                Date dt15 = Date.valueOf(oCloseDate);
                oCloseDateS = dt15.format();
            }     
            if(nCloseDate !=Null && string.isNotBlank(nCloseDate))
            {
                Date dt16 = Date.valueOf(nCloseDate);
                nCloseDateS = dt16.format();
            }     
            
            System.debug(oLastUpdateDates);
            
            mails = new Messaging.Email[0];
            
            for (Issue__c issueMail :(List<Issue__c>) Trigger.new)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();
                List<String> ccTo1 = new List<String>();
                
                List<String> replyTo = new List<String>();
                
                system.debug(emailDetails.ccTo2__c); 
                
                if(emailDetails.Primary_Receiver__c != null){
                    sendTo.add(emailDetails.Primary_Receiver__c);
                }
                if(emailDetails.Primary_Receiver1__c != null){
                    sendTo.add(emailDetails.Primary_Receiver1__c);
                }
                if(emailDetails.Primary_Receiver2__c != null){
                    sendTo.add(emailDetails.Primary_Receiver2__c);
                }
                if(emailDetails.Primary_Receiver3__c != null){
                    sendTo.add(emailDetails.Primary_Receiver3__c);
                }
                if(emailDetails.ccTo1__c != null){
                    ccTo1.add(emailDetails.ccTo1__c);
                }
                if(emailDetails.ccTo2__c != null){
                    ccTo1.add(emailDetails.ccTo2__c);
                }
                ccTo1.add('ashwin.k@stetig.in');
                ccTo1.add('shivam.wankhede@stetig.in');

                system.debug(ccTo1);
                
                if(emailDetails.replyTo__c != null){
                    replyTo.add(emailDetails.replyTo__c);    
                }
                
                mail.setToAddresses(sendTo);
                mail.setCcAddresses(ccTo1);
                system.debug(ccTo1);
                mail.setSenderDisplayName(emailDetails.sender__c);
                
                if(oName != nName)
                    mail.setSubject('Issue - ' +nName+ ', is updated');
                else
                    mail.setSubject('Issue - ' +oName+ ', is updated');
                
                  
                
                String body = '';
                
                body += '<b><span style="margin-right:09px;">Hello </span>' +oRaised+'</b><br><br>';
                body += 'Your Issue has been updated<br><br><br>';
                //body += '<b><p style="padding:6px;"><span style="margin-right:34px;">Issue -</span>' +oName+'</b><br>';
                if(oName != nName)
                    body += '<b><span style="margin-right:20px;">Subject - </span>' +nName+'</b><br><br></p>';
                else
                    body += '<b><span style="margin-right:20px;">Subject - </span>'+oName+'</b><br><br>';
                
                body += '<table border="1" style="border: 1px solid;border-collapse:collapse;"><tr style="background-color:#90EE90;padding:6px;text-align:center;"><th colspan="3" style="border: 1px solid;">Last Update Details</th></tr>';
                
                body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Issue Name</td><td colspan="2" style="border: 1px solid;">'+oName+'</td></tr>';
                if(oStatus != nStatus)
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Current Status</td><td colspan="2" style="border: 1px solid;">'+nStatus+'</td></tr>'; 
                else
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Current Status</td><td colspan="2" style="border: 1px solid;">'+oStatus+'</td></tr>';
                
                if(nStatus == 'Analysis Done & Submitted'){
                    if(oAnaDesc != nAnaDesc)
                        body += '<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Analysis Description</td><td colspan="2" style="border: 1px solid;">'+nAnaDesc+'</td> </tr>';          
                    else
                        body += '<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Analysis Description</td><td colspan="2" style="border: 1px solid;">'+oAnaDesc+'</td> </tr>';          
                    
                    if(oAnaSubDate != nAnaSubDate)
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Analysis Submitted Date</td><td colspan="2" style="border: 1px solid;">'+nAnaSubDateS+'</td></tr>';          
                    else
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Analysis Submitted Date</td><td colspan="2" style="border: 1px solid;">'+oAnaSubDateS+'</td></tr>';          
                    
                    if(oEstEfrt != nEstEfrt)
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Estimated Effort (Person Days)</td><td colspan="2" style="border: 1px solid;">'+nEstEfrt+'</td></tr>';          
                    else
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Estimated Effort (Person Days)</td><td colspan="2" style="border: 1px solid;">'+oEstEfrt+'</td></tr>';          
                }
                
                if(nStatus == 'Under Development'){
                    if(oDevStartDate != nDevStartDate)
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Development Start Date</td><td colspan="2" style="border: 1px solid;">'+nDevStartDateS+'</td></tr>';          
                    else
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Development Start Date</td><td colspan="2" style="border: 1px solid;">'+oDevStartDateS+'</td></tr>';          
                }
                
                if(nStatus == 'UAT'){
                    if(oUat != nUat)
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">UAT Date</td><td colspan="2" style="border: 1px solid;">'+nUatS+'</td></tr>';
                    else
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">UAT Date</td><td colspan="2" style="border: 1px solid;">'+oUatS+'</td></tr>';          
                } 
                
                if(nStatus == 'ReOpen'){
                    if(oReOpenD != nReOpenD)
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">ReOpen Date</td><td colspan="2" style="border: 1px solid;">'+nReOpenDs+'</td></tr>';    
                    else
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">ReOpen Date</td><td colspan="2" style="border: 1px solid;">'+oReOpenDs+'</td></tr>';                 
                }
                
                if(nStatus == 'Closed'){
                    if(oCloseDate != nCloseDate)
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Closed Date</td><td colspan="2" style="border: 1px solid;">'+nCloseDateS+'</td></tr>';    
                    else
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Closed Date</td><td colspan="2" style="border: 1px solid;">'+oCloseDateS+'</td></tr>';          
                }
                
                if(nStatus == 'Go-ahead start of dev'){
                    if(oGdrd != nGdrd)
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Go-Ahead for Development Received Date</td><td colspan="2" style="border: 1px solid;">'+nGdrdS+'</td></tr>';          
                    else
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Go-Ahead for Development Received Date</td><td colspan="2" style="border: 1px solid;">'+oGdrdS+'</td></tr>';            
                }
                
                if(nStatus == 'Go-ahead migration to prod'){
                    if(oGprd != nGprd)
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Go Ahead for Production Received Date</td><td colspan="2" style="border: 1px solid;">'+nGprdS+'</td></tr>';          
                    else
                        body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Go Ahead for Production Received Date</td><td colspan="2" style="border: 1px solid;">'+oGprdS+'</td></tr>';          
                }    
                /*if(oSub != nSub)
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Subject</td><td colspan="2" style="border: 1px solid;">'+nSub+'</td></tr>';    
                else
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Subject</td><td colspan="2" style="border: 1px solid;">'+oSub+'</td></tr>';
                */
                if(oPrio != nPrio)
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Priority</td><td colspan="2" style="border: 1px solid;">'+nPrio+'</td></tr>'; 
                else
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Priority</td><td colspan="2" style="border: 1px solid;">'+oPrio+'</td></tr>'; 
                
                if(oPrioDate != nPrioDate)
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Prioritized Date</td><td colspan="2" style="border: 1px solid;">'+nPrioDateS+'</td></tr>';                
                else
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Prioritized Date</td><td colspan="2" style="border: 1px solid;">'+oPrioDateS+'</td></tr>';                
                
                if(nType != oType)
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Type</td><td colspan="2" style="border: 1px solid;">'+nType+'</td></tr>';        
                else
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Type</td><td colspan="2" style="border: 1px solid;">'+oType+'</td></tr>';
                
                if(nDesc != oDesc)
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Description</td><td colspan="2" style="border: 1px solid;">'+nDesc+'</td></tr>';        
                else
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Description</td><td colspan="2" style="border: 1px solid;">'+oDesc+'</td></tr>';
                
                if(oDept != nDept)
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Department</td><td colspan="2" style="border: 1px solid;">'+nDept+'</td></tr>';         
                else
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Department</td><td colspan="2" style="border: 1px solid;">'+oDept+'</td></tr>'; 
                
                /*if(oPriResource != nPriResource)
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Primary Resource</td><td colspan="2" style="border: 1px solid;">'+nPriResource+'</td></tr>';                
                else
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Primary Resource</td><td colspan="2" style="border: 1px solid;">'+oPriResource+'</td></tr>';                
                */
                if(oLastUpdateDate != nLastUpdateDate)
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Last Updated Date  & Time</td><td colspan="2" style="border: 1px solid;">'+nLastUpdateDateS+'</td></tr>';                
                else
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Last Updated Date  & Time</td><td colspan="2" style="border: 1px solid;">'+oLastUpdateDateS+'</td></tr>';    
                
                
                if(oLastUpdateDesc != nLastUpdateDesc)
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Last Updated Description</td><td colspan="2" style="border: 1px solid;">'+nLastUpdateDesc+'</td></tr>';                
                else
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Last Updated Description</td><td colspan="2" style="border: 1px solid;">'+oLastUpdateDesc+'</td></tr>';                
                
                if(oLastUpdateBy != nLastUpdateBy)
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Last Updated by</td><td colspan="2" style="border: 1px solid;">'+nLastUpdateBy+'</td></tr>';                 
                else
                    body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Last Updated by</td><td colspan="2" style="border: 1px solid;">'+oLastUpdateBy+'</td></tr>';                 
                
                if(oStream != nStream || oDept != nDept || oModule != nModule || oSub != nSub || oDesc != nDesc || oprio != nprio ||
                   otype != ntype || oStatus != nStatus)
                {
                    body += '<tr style="background-color:#00FA9A;padding:6px;text-align:center;"><th style="border: 1px solid;">Field Names</th><th style="border: 1px solid;">From this</th><th style="border: 1px solid;">Changed To</th></tr>';
                    if(oStream != nStream)
                        body += '<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Stream</td><td style="border: 1px solid;">'+oStream+'</td><td style="border: 1px solid;">'+nStream+'</td></tr>';
                    
                    if(oDept != nDept)
                        body += '<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Department</td><td style="border: 1px solid;">'+oDept+'</td><td style="border: 1px solid;">'+nDept+'</td></tr>';
                    
                    if(oModule != nModule)
                        body += '<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Module</td><td style="border: 1px solid;">'+oModule+'</td><td style="border: 1px solid;">'+nModule+'</td></tr>';
                    
                    /*if(oSub != nSub)
                        body += '<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Subject</td><td style="border: 1px solid;">'+oSub+'</td><td style="border: 1px solid;">'+nSub+'</td></tr>';
                    */
                    if(oDesc != nDesc)
                        body += '<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Description</td><td style="border: 1px solid;">'+oDesc+'</td><td style="border: 1px solid;">'+nDesc+'</td></tr>';
                    
                    if(oPrio != nPrio)
                        body += '<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Priority</td><td style="border: 1px solid;">'+oPrio+'</td><td style="border: 1px solid;">'+nPrio+'</td></tr>';
                    
                    if(oType != nType)
                        body += '<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Type</td><td style="border: 1px solid;">'+oType+'</td><td style="border: 1px solid;">'+nType+'</td></tr>';
                    
                    if(oStatus != nStatus){
                        body += '<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Status</td><td style="border: 1px solid;">'+oStatus+'</td><td style="border: 1px solid;">'+nStatus+'</td></tr>';
                        
                        if(oStatus == 'Analysis Done & Submitted'){
                            body += '<tr style="background-color:#90EE90;padding:6px;text-align:center;"><th colspan="3" style="border: 1px solid;">Previous Status Related Details</th></tr>';
                            body += '<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Analysis Description</td><td colspan="2" style="border: 1px solid;">'+oAnaDesc+'</td> </tr>';          
                            
                            body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Analysis Submitted Date & Time</td><td colspan="2" style="border: 1px solid;">'+oAnaSubDateS+'</td></tr>';          
                            
                            body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Estimated Effort (Person Days)</td><td colspan="2" style="border: 1px solid;">'+oEstEfrt+'</td></tr>';          
                        }
                        
                        if(oStatus == 'Under Development'){
                            body += '<tr style="background-color:#90EE90;padding:6px;text-align:center;"><th colspan="3" style="border: 1px solid;">Previous Status Related Details</th></tr>';
                            body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Development Start Date</td><td colspan="2" style="border: 1px solid;">'+oDevStartDateS+'</td></tr>';          
                        }
                        
                        if(oStatus == 'UAT'){
                            body += '<tr style="background-color:#90EE90;padding:6px;text-align:center;"><th colspan="3" style="border: 1px solid;">previous Status Related Details</th></tr>'; 
                            body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">UAT Date</td><td colspan="2" style="border: 1px solid;">'+oUatS+'</td></tr>';          
                        } 
                        
                        if(oStatus == 'ReOpen'){
                            body += '<tr style="background-color:#90EE90;padding:6px;text-align:center;"><th colspan="3" style="border: 1px solid;">Previous Status Related Details</th></tr>';
                            body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">ReOpen Date</td><td colspan="2" style="border: 1px solid;">'+oReOpenDs+'</td></tr>';                 
                        }
                        
                        if(oStatus == 'Closed'){
                            body += '<tr style="background-color:#90EE90;padding:6px;text-align:center;"><th colspan="3" style="border: 1px solid;">Previous Status Related Details</th></tr>';
                            body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Closed Date</td><td colspan="2" style="border: 1px solid;">'+oCloseDateS+'</td></tr>';          
                        }
                        
                        if(oStatus == 'Go-ahead start of dev'){
                            body += '<tr style="background-color:#90EE90;padding:6px;text-align:center;"><th colspan="3" style="border: 1px solid;">Previous Status Related Details</th></tr>';
                            body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Go-Ahead for Development Received Date</td><td colspan="2" style="border: 1px solid;">'+oGdrdS+'</td></tr>';            
                        }
                        
                        if(oStatus == 'Go-ahead migration to prod'){
                            body += '<tr style="background-color:#90EE90;padding:6px;text-align:center;"><th colspan="3" style="border: 1px solid;">Previous Status Related Details</th></tr>';
                            body +='<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">Go Ahead for Production Received Date</td><td colspan="2" style="border: 1px solid;">'+oGprdS+'</td></tr>';          
                        }           
                    }
                }
                body += '</table><br>';
                
                if(newIssue[0].Id != null){
                    Organization orgObj = [SELECT Id, IsSandbox FROM Organization WHERE Id=:UserInfo.getOrganizationId()];
                    if(orgObj.IsSandbox){
                        body += '<b><a href=\'https://oberoirealty--oberoidev.my.salesforce.com/'+newIssue[0].Id+'\' style="text-decoration-line: NONE;color:#008B8B;"><span style="margin-right:01px;"></span>click here to view</a><br><br>\n';
                    }
                    else{
                        body += '<b><a href=\'https://oberoirealty.my.salesforce.com//'+newIssue[0].Id+'\' style="text-decoration-line: NONE;color:#008B8B;"><span style="margin-right:01px;"></span>click here to view</a><br><br>\n';
                        
                    }
                }
                    body += '<b>Thanks & Regards,<br>';                              
                body += '<b>Team ORL\n';
                
                mail.setHtmlBody(body);
                mails.add(mail);
            }
            if(emailDetails.Send_Updates__c == true)
                Messaging.sendEmail(mails);
        }
    }
    
    public void sendIssueCommentEmail(List<Issue_Comment__c> commId){
        Set<id> idSet = new Set<id>();
        for(Issue_Comment__c ic:commId){
            idSet.add(ic.Id);
        }
        
        List<Issue_Comment__c> comm = [SELECT Id,Name,Comment__c,Issue__c,Issue__r.Issue__c,Issue__r.Priority__c,
                                       Issue__r.Type__c,Issue__r.Status__c,Issue__r.Raised_By__c
                                       FROM Issue_Comment__c WHERE Id IN :idSet];
        
        Issue_UpdateServices__c emailDetails = Issue_UpdateServices__c.getValues('issueUpdateReceivers');
        
        if(comm != null)
        {
            Messaging.Email[] mails = new Messaging.Email[0];
            
            mails = new Messaging.Email[0];
            
            for (Issue_Comment__c commMail :comm)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();
                List<String> ccTo1 = new List<String>();
                
                List<String> replyTo = new List<String>();
                
                system.debug(emailDetails.ccTo2__c); 
                
                if(emailDetails.Primary_Receiver__c != null){
                    sendTo.add(emailDetails.Primary_Receiver__c);
                }
                if(emailDetails.Primary_Receiver1__c != null){
                    sendTo.add(emailDetails.Primary_Receiver1__c);
                }
                if(emailDetails.Primary_Receiver2__c != null){
                    sendTo.add(emailDetails.Primary_Receiver2__c);
                }
                if(emailDetails.Primary_Receiver3__c != null){
                    sendTo.add(emailDetails.Primary_Receiver3__c);
                }
                if(emailDetails.ccTo1__c != null){
                    ccTo1.add(emailDetails.ccTo1__c);
                }
                if(emailDetails.ccTo2__c != null){
                    ccTo1.add(emailDetails.ccTo2__c);
                }
                
                system.debug(ccTo1);
                
                if(emailDetails.replyTo__c != null){
                    replyTo.add(emailDetails.replyTo__c);    
                }
                
                mail.setToAddresses(sendTo);
                mail.setCcAddresses(ccTo1);
                system.debug(ccTo1);
                mail.setSenderDisplayName(emailDetails.sender__c);
                
                mail.setSubject('You have a new comment on Issue: '+commMail.Issue__r.Issue__c);  
                
                String body = '';
                body += '<table border="1" style="border: 1px solid;border-collapse:collapse;width:100%;">';
                body += '<tr><th style="background-color:#90EE90;padding:6px;text-align:center;border: 1px solid;">Issue</th><th style="background-color:#90EE90;padding:6px;text-align:center;border: 1px solid;">Priority</th><th style="background-color:#90EE90;padding:6px;text-align:center;border: 1px solid;">Type</th><th style="background-color:#90EE90;padding:6px;text-align:center;border: 1px solid;">Status</th><th style="background-color:#90EE90;padding:6px;text-align:center;border: 1px solid;">Raised By</th></tr>';
                body += '<tr style="text-align:center;padding:6px;"><td style="border: 1px solid;">'+commMail.Issue__r.Issue__c+'</td><td style="border: 1px solid;">'+commMail.Issue__r.Priority__c+'</td><td style="border: 1px solid;">'+commMail.Issue__r.Type__c+'</td><td style="border: 1px solid;">'+commMail.Issue__r.Status__c+'</td><td style="border: 1px solid;">'+commMail.Issue__r.Raised_By__c+'</td></tr>';
                body += '</table>';
                body += '<B><br/><br/>New Comment:</B><br/><br/>'+commMail.Comment__c;
                mail.setHtmlBody(body);
                mails.add(mail);
        }
            if(emailDetails.Send_Updates__c == true)
                Messaging.sendEmail(mails);
    }
}
}