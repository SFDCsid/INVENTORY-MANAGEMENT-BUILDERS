public class EX_SiteVisitFormController {
    public List<Account> accList1 {get;set;}
    public List<Opportunity_c__c> oppList1 {get;set;}
    public List<Lead_c__c> leadList1 {get;set;}
    public List<Project__c> pList {get;set;}
    public Site_Visit__c sv {get;set;}
    public boolean isAccount {get;set;}
    public boolean isLead {get;set;}
    public boolean isOpp {get;set;}
    public String project {get;set;}
    public String projectName {get;set;}
    public String mobile {get;set;}
    public String email {get;set;}
    public Boolean isRunError {get;set;}
    public Boolean isSuccess {get;set;}
    public Boolean valError {get;set;}
    public String message {get;set;}
    public String cpName {get;set;}
    public String refName {get;set;}
    public boolean isAccountFound {get;set;}
    public boolean isLeadFound {get;set;}
    public boolean isOppFound {get;set;}
    public Date birthDate {get;set;}
    public Date AnniversaryDate {get;set;}
    public boolean isSourceNotEditable {get;set;}
    
    public EX_SiteVisitFormController() {
        
        accList1 = new List<Account>();
        oppList1 = new List<Opportunity_c__c>();
        leadList1 = new List<Lead_c__c>();
        pList = new List<Project__c>();
        sv = new Site_Visit__c();
        isSuccess = false;
        isRunError = false;
        isAccount = false;
        isLead = false;
        isOpp = false;
        isAccountFound = false;
        isLeadFound = false;
        isOppFound = false;
        project = '';
        projectName = '';
        mobile = '';
        email = '';
        message = '';
        cpName = '';
        refName = '';
        
        birthDate = null;
        AnniversaryDate = null;
        isSourceNotEditable = false;
        
        project = ApexPages.currentPage().getParameters().get('project'); 
        mobile = ApexPages.currentPage().getParameters().get('mobile');
        email = ApexPages.currentPage().getParameters().get('email');
        system.debug('project: '+project+ ' mobile: '+mobile+ ' email: '+email);
        
        if(project != Null && !String.isBlank(project)) {
            pList = [Select Id, Name, current_residence_status__c, range_of_Possession__c,
                        Ethnicity__c, Occupation__c
                     from Project__c where Id =: project];
            system.debug('pList: '+pList);
            
            if(!pList.isEmpty()) {
                sv.Project__c = pList[0].Id;
                projectName = pList[0].Name;
            }
        }
        
        if(mobile != Null && !String.isBlank(mobile)) {
            sv.Mobile__c = mobile;
        }
        if(email != Null && !String.isBlank(email)) {
            sv.Email__c = email;
        }
        
        List<Account> accList = new List<Account>();
        List<Opportunity_c__c> oppList = new List<Opportunity_c__c>();
        List<Lead_c__c> leadList = new List<Lead_c__c>();
        List<Site_Visit__c> svList = new List<Site_Visit__c>();
        
        if(mobile != Null && !String.isBlank(mobile)) {
            accList = [Select Id, Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email_Id__c, 
                       Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                       Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c,Industry,DOB__c,
                       BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode,House_No__c,Locality__c,Residential_Location__c,Residential_Zone__c,Office_Location__c,Office_Zone__c
                       from Account 
                       where (PersonMobilePhone =: mobile OR Phone =: mobile) AND IsPersonAccount = true];
            system.debug('accList: '+accList);
            
            if(!accList.isEmpty()) {
                isAccount = true;
                
                oppList = [Select Id, Name,Site_Visit_Count__c, Project__c, Purchase_Timeframe__c, Configuration_Required__c,Is_Active__c, 
                           Possession_Timeframe_Required__c, Budget__c,Current_Residence_Status__c, Buying_Purpose__c, Presales_Manager__c,Master_Source__c,
                           Opportunity_Source__c, Opportunity_Sub_Source__c,Other_Source_Details__c, Opportunity_Sub_Source_Details__c, Employee_Referrer_Name__c,
                           DOB__c,Anniversary_Date__c,Referrer_Name__c,Exact_Budget__c,Source_Remarks__c,Account_Name__c, Referrer_Name__r.PersonMobilePhone,Channel_Partner_Account__c, Referrer_Name__r.Name,
                           CP_Project__r.Name from Opportunity_c__c
                           where Account_Name__c =: accList[0].Id AND Project__c =: pList[0].Id AND Is_Active__c = true];
                system.debug('oppList: '+oppList);
                
                if(!oppList.isEmpty()) {
                    isOpp = true;
                    
                    svList = [Select Id, Name from Site_Visit__c where Opportunity_c__c =: oppList[0].Id];
                    system.debug('svList: '+svList);
                    
                    if(!svList.isEmpty()) {
                        isSourceNotEditable = true;
                    }
                }
            } else {
                if(email != Null && !String.isBlank(email)) {
                    accList = [Select Id, Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email_Id__c,
                               Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                               Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c,Industry,DOB__c,
                               BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode,House_No__c,Locality__c,Residential_Location__c,Residential_Zone__c,Office_Location__c,Office_Zone__c
                               from Account
                               where (PersonEmail =: email OR Alternate_Email_Id__c =: email) AND IsPersonAccount = true];
                    system.debug('accList: '+accList);
                    
                    if(!accList.isEmpty()) {
                        isAccount = true;
                        
                        oppList = [Select Id, Name,Site_Visit_Count__c, Project__c, Purchase_Timeframe__c, Configuration_Required__c, 
                                   Possession_Timeframe_Required__c, Budget__c,Current_Residence_Status__c, Buying_Purpose__c, Presales_Manager__c,Master_Source__c,
                                   Opportunity_Source__c, Opportunity_Sub_Source__c,Other_Source_Details__c,Opportunity_Sub_Source_Details__c, Employee_Referrer_Name__c,
                                   DOB__c,Anniversary_Date__c,Referrer_Name__c,Exact_Budget__c,Source_Remarks__c,Account_Name__c,Is_Active__c, Referrer_Name__r.PersonMobilePhone,Channel_Partner_Account__c, Referrer_Name__r.Name,
                                   CP_Project__c,CP_Project__r.Name from Opportunity_c__c
                                   where Account_Name__c =: accList[0].Id AND Project__c =: pList[0].Id AND Is_Active__c = true];
                        system.debug('oppList: '+oppList);
                        
                        if(!oppList.isEmpty()) {
                            isOpp = true;
                            
                            svList = [Select Id, Name from Site_Visit__c where Opportunity_c__c =: oppList[0].Id];
                            system.debug('svList: '+svList);
                            
                            if(!svList.isEmpty()) {
                                isSourceNotEditable = true;
                            }
                        }
                    }
                }
            }
            
            if(oppList.isEmpty()) {
                leadList = [Select Id, First_Name__c, Last_Name__c, Mobile__c, Alternate_Mobile_No__c, Email__c, Alternate_Email_Id__c,
                            Project_Name__c, Purchase_Timeframe__c, Campaign_Custom__c, Configuration_Required__c, Possession_Timeframe_Required__c, Budget__c, Buying_Purpose__c, 
                            Age_Group__c, Gender__c, Designation__c, Martial_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                            Current_Residence_Status__c,Current_Residence_City__c,Current_Residence_Area_Locality__c, Ethinicity__c, Household_Income_Annual__c, Industry__c, 	
                            Master_Source_Category__c, Lead_Source__c, Lead_Sub_Source__c,Referrer_Name__c,  OwnerId, Employee_Referrer_Name__c,
                            Lead_Stage__c, Lead_Sub_Stage__c,Other_Source_Details__c,Lead_Sub_Stage_Reason__c,Sub_Source_Details__c,Channel_Partner_Account__c,
                            Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,Account__c,Opportunity_c__c,isConverted__c,Is_Active__c, 
                            Follow_up_Date__c,Proposed_Visit_Date__c,CP_Project__c,CP_Project__r.Name,Presales_Call_Count__c,Last_Comment__c,First_Call_Date__c,Call_Not_Answered__c,Comment_History__c
                            from Lead_c__c
                            where (Mobile__c =: mobile OR Alternate_Mobile_No__c =: mobile) /*AND Project_Name__c =: pList[0].Id*/ AND isConverted__c = false  AND Is_Active__c = true];
                system.debug('leadList: '+leadList);
                
                if(!leadList.isEmpty()) {
                    isLead = true;
                    isSourceNotEditable = true;
                    
                } else {
                    if(email != Null && !String.isBlank(email)) {
                        leadList = [Select Id,First_Name__c, Last_Name__c, Mobile__c, Alternate_Mobile_No__c, Email__c, Alternate_Email_Id__c,
                                    Project_Name__c, Purchase_Timeframe__c,Campaign_Custom__c, Configuration_Required__c, Possession_Timeframe_Required__c, Budget__c, Buying_Purpose__c, 
                                    Age_Group__c, Gender__c, Designation__c, Martial_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                                    Current_Residence_Status__c,Current_Residence_City__c,Current_Residence_Area_Locality__c, Ethinicity__c, Household_Income_Annual__c, Industry__c, 	
                                    Master_Source_Category__c, Lead_Source__c,Other_Source_Details__c, Lead_Sub_Source__c,Referrer_Name__c,  OwnerId, Employee_Referrer_Name__c,
                                    Lead_Stage__c, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c,Sub_Source_Details__c,Channel_Partner_Account__c,
                                    Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,Account__c,Opportunity_c__c,isConverted__c,Is_Active__c,
                                    Follow_up_Date__c,Proposed_Visit_Date__c,Presales_Call_Count__c,CP_Project__c,CP_Project__r.Name,Last_Comment__c,First_Call_Date__c,Call_Not_Answered__c,Comment_History__c
                                    from Lead_c__c
                                    where (Email__c =: email OR Alternate_Email_Id__c =: email) /*AND Project_Name__c =: pList[0].Id*/ AND isConverted__c = false AND Is_Active__c = true];
                        system.debug('leadList: '+leadList);
                        
                        if(!leadList.isEmpty()) {
                            isLead = true;	
                        }
                    }
                }
            }
        }
        
        if(isAccount) {
            if(accList[0].Salutation != '' && accList[0].Salutation != Null)
                sv.Salutation__c = accList[0].Salutation;
            if(accList[0].FirstName != '' && accList[0].FirstName != Null)
                sv.First_Name__c = accList[0].FirstName;
            if(accList[0].LastName != '' && accList[0].LastName != Null)
                sv.Last_Name__c = accList[0].LastName;
            if(sv.Email__c == null && accList[0].PersonEmail != '' && accList[0].PersonEmail != null)
                sv.Email__c = accList[0].PersonEmail;
            if(accList[0].Occupation__c != '' && accList[0].Occupation__c != null)
            	sv.Occupation__c = accList[0].Occupation__c;
          	
            if(accList[0].Current_Residence_Configuration__c != '' && accList[0].Current_Residence_Configuration__c != null)
            	sv.Current_Residence_Configuration__c = accList[0].Current_Residence_Configuration__c;
            if(accList[0].Current_Residence_Status__c != '' && accList[0].Current_Residence_Status__c != null)
            	sv.Current_Residence_Status__c = accList[0].Current_Residence_Status__c;
            if(accList[0].Ethinicity__c != '' && accList[0].Ethinicity__c != null)
            	sv.Ethnicity__c = accList[0].Ethinicity__c;
           	
            if(accList[0].House_No__c != '' && accList[0].House_No__c != null)
            	sv.House_No__c = accList[0].House_No__c;
            if(accList[0].Locality__c != '' && accList[0].Locality__c != null)
            	sv.Locality__c = accList[0].Locality__c;
            if(accList[0].BillingStreet != '' && accList[0].BillingStreet != null)
            	sv.Street_1__c = accList[0].BillingStreet;
            if(accList[0].BillingCity != '' && accList[0].BillingCity != null)
            	sv.City__c = accList[0].BillingCity;
            if(accList[0].BillingState != '' && accList[0].BillingState != null)
            	sv.State__c = accList[0].BillingState;
            if(accList[0].Residential_Location__c !='' && accList[0].Residential_Location__c !=null) //PP
                sv.Residential_Location__c=accList[0].Residential_Location__c;
            if(accList[0].Residential_Zone__c !='' && accList[0].Residential_Zone__c !=null)
                sv.Residential_Zone__c=accList[0].Residential_Zone__c;
            if(accList[0].Office_Location__c !='' && accList[0].Office_Location__c !=null)
                sv.Office_Location__c=accList[0].Office_Location__c;
            if(accList[0].Office_Zone__c !='' && accList[0].Office_Zone__c !=null)
                sv.Office_Zone__c=accList[0].Office_Zone__c;                        //PP
          	
            if(accList[0].BillingPostalCode != '' && accList[0].BillingPostalCode != null)
                sv.Pincode__c = Decimal.valueOf(accList[0].BillingPostalCode);
            if(isOpp) {
             	
                if(oppList[0].Current_Residence_Status__c != '' && oppList[0].Current_Residence_Status__c != null)
                	sv.Current_Residence_Status__c = oppList[0].Current_Residence_Status__c;
                if(oppList[0].Configuration_Required__c != '' && oppList[0].Configuration_Required__c != null)
                	sv.Configuration_Required__c = oppList[0].Configuration_Required__c;
                if(oppList[0].Possession_Timeframe_Required__c != '' && oppList[0].Possession_Timeframe_Required__c != null)
                	sv.Possession_Timeframe_Required__c = oppList[0].Possession_Timeframe_Required__c;
                if(oppList[0].Budget__c != '' && oppList[0].Budget__c != null)
                	sv.Budget__c = oppList[0].Budget__c;
                if(oppList[0].Buying_Purpose__c != '' && oppList[0].Buying_Purpose__c != null)
                	sv.Buying_Purpose__c = oppList[0].Buying_Purpose__c;
                if(oppList[0].Master_Source__c != '' && oppList[0].Master_Source__c != null)
                	sv.Master_Source__c = oppList[0].Master_Source__c;
                if(oppList[0].Opportunity_Source__c != '' && oppList[0].Opportunity_Source__c != null)
                	sv.Lead_Source__c = oppList[0].Opportunity_Source__c;
                if(oppList[0].Opportunity_Sub_Source__c != '' && oppList[0].Opportunity_Sub_Source__c != null)
                	sv.Lead_Sub_Source__c = oppList[0].Opportunity_Sub_Source__c;
                if(oppList[0].Source_Remarks__c != '' && oppList[0].Source_Remarks__c != null)
                	sv.Source_Remarks__c = oppList[0].Source_Remarks__c; 
                  if(oppList[0].Exact_Budget__c != '' && oppList[0].Exact_Budget__c != null)
                	sv.Exact_Budget__c = oppList[0].Exact_Budget__c; 
                 if(oppList[0].CP_Project__c != null) {
                	sv.CP_Project__c = oppList[0].CP_Project__c;
                  	cpName = oppList[0].CP_Project__r.Name;
                }
                if(oppList[0].Referrer_Name__c != null) {
                   	sv.Referrer_Name__c = oppList[0].Referrer_Name__c;
                    refName = oppList[0].Referrer_Name__r.Name +'-'+oppList[0].Referrer_Name__r.PersonMobilePhone;
                }
             	if(oppList[0].Other_Source_Details__c != '' && oppList[0].Other_Source_Details__c != null)
                    sv.Other_Source_Details__c = oppList[0].Other_Source_Details__c; 
                if(oppList[0].Employee_Referrer_Name__c != '' && oppList[0].Employee_Referrer_Name__c != null)
                    sv.Employee_Referrer_Name__c = oppList[0].Employee_Referrer_Name__c;
                system.debug('CP Id: '+ oppList[0].Channel_Partner_Account__c);
                if(oppList[0].Channel_Partner_Account__c != null)
                    sv.Channel_Partner_Account__c = oppList[0].Channel_Partner_Account__c;
                
            } else if(isLead) {
               
                if(leadList[0].Configuration_Required__c != '' && leadList[0].Configuration_Required__c != null)
                	sv.Configuration_Required__c = leadList[0].Configuration_Required__c;
                if(leadList[0].Possession_Timeframe_Required__c != '' && leadList[0].Possession_Timeframe_Required__c != null)
                	sv.Possession_Timeframe_Required__c = leadList[0].Possession_Timeframe_Required__c;
                if(leadList[0].Budget__c != '' && leadList[0].Budget__c != null)
                	sv.Budget__c = leadList[0].Budget__c;
                if(leadList[0].Buying_Purpose__c != '' && leadList[0].Buying_Purpose__c != null)
                	sv.Buying_Purpose__c = leadList[0].Buying_Purpose__c;
                if(leadList[0].Master_Source_Category__c!= '' && leadList[0].Master_Source_Category__c!= Null)
                    sv.Master_Source__c= leadList[0].Master_Source_Category__c;   
                if(leadList[0].Lead_Source__c != '' && leadList[0].Lead_Source__c != Null)
                    sv.Lead_Source__c = leadList[0].Lead_Source__c;
                if(leadList[0].Lead_Sub_Source__c != '' && leadList[0].Lead_Sub_Source__c != Null)
                    sv.Lead_Sub_Source__c = leadList[0].Lead_Sub_Source__c;
                if(leadList[0]. CP_Project__c != null) {
                	sv.CP_Project__c = leadList[0].CP_Project__c;
                 cpName = leadList[0].CP_Project__r.Name ;
                }
                
               if(leadList[0].Channel_Partner_Account__c != null){
                    sv.Channel_Partner_Account__c = leadList[0].Channel_Partner_Account__c;
                } 
                if(leadList[0].Referrer_Name__c != null) {
                    sv.Referrer_Name__c = leadList[0].Referrer_Name__c;
                	refName = leadList[0].Referrer_Name__r.Name +'-'+leadList[0].Referrer_Name__r.PersonMobilePhone;
                }
                if(leadList[0].Other_Source_Details__c != '' && leadList[0].Other_Source_Details__c != null)
                    sv.Other_Source_Details__c = leadList[0].Other_Source_Details__c; 
                if(leadList[0].Employee_Referrer_Name__c != '' && leadList[0].Employee_Referrer_Name__c != null)
                    sv.Employee_Referrer_Name__c = leadList[0].Employee_Referrer_Name__c;
                if(leadList[0].OwnerId != null) {
            		//sv.Presales_Manager__c = leadList[0].OwnerId;
                    sv.Sourcing_Manager_Name__c = leadList[0].OwnerId;
                }	
            }
        } else if(isLead) {
            if(leadList[0].First_Name__c != '' && leadList[0].First_Name__c != Null)
                sv.First_Name__c = leadList[0].First_Name__c;
            if(leadList[0].Last_Name__c != '' && leadList[0].Last_Name__c != Null)
                sv.Last_Name__c = leadList[0].Last_Name__c;
            if(sv.Email__c == null && leadList[0].Email__c != '' && leadList[0].Email__c != null)
                sv.Email__c = leadList[0].Email__c;
            if(leadList[0].Occupation__c != '' && leadList[0].Occupation__c != null)
            	sv.Occupation__c = leadList[0].Occupation__c;
            if(leadList[0].Current_Residence_Configuration__c != '' && leadList[0].Current_Residence_Configuration__c != null)
            	sv.Current_Residence_Configuration__c = leadList[0].Current_Residence_Configuration__c;
            if(leadList[0].Current_Residence_Status__c != '' && leadList[0].Current_Residence_Status__c != null)
            	sv.Current_Residence_Status__c = leadList[0].Current_Residence_Status__c;
            if(leadList[0].Ethinicity__c != '' && leadList[0].Ethinicity__c != null)
            	sv.Ethnicity__c = leadList[0].Ethinicity__c;
           
            if(leadList[0].Configuration_Required__c != '' && leadList[0].Configuration_Required__c != null)
                sv.Configuration_Required__c = leadList[0].Configuration_Required__c;
            if(leadList[0].Possession_Timeframe_Required__c != '' && leadList[0].Possession_Timeframe_Required__c != null)
                sv.Possession_Timeframe_Required__c = leadList[0].Possession_Timeframe_Required__c;
            if(leadList[0].Budget__c != '' && leadList[0].Budget__c != null)
                sv.Budget__c = leadList[0].Budget__c;
            if(leadList[0].Buying_Purpose__c != '' && leadList[0].Buying_Purpose__c != null)
                sv.Buying_Purpose__c = leadList[0].Buying_Purpose__c;
            if(leadList[0].Master_Source_Category__c!= '' && leadList[0].Master_Source_Category__c!= Null)
                sv.Master_Source__c= leadList[0].Master_Source_Category__c;   
            if(leadList[0].Lead_Source__c != '' && leadList[0].Lead_Source__c != Null)
                sv.Lead_Source__c = leadList[0].Lead_Source__c;
            if(leadList[0].Lead_Sub_Source__c != '' && leadList[0].Lead_Sub_Source__c != Null)
                sv.Lead_Sub_Source__c = leadList[0].Lead_Sub_Source__c; 
            if(leadList[0].CP_Project__c != null) {
                sv.CP_Project__c = leadList[0].CP_Project__c;
            	cpName = leadList[0].CP_Project__r.Name ;    
            }
            
            if( leadList[0].Channel_Partner_Account__c != null)
                    sv.Channel_Partner_Account__c = leadList[0].Channel_Partner_Account__c;
            
            
            if(leadList[0].Referrer_Name__c != null) {
                sv.Referrer_Name__c = leadList[0].Referrer_Name__c;
            	refName = leadList[0].Referrer_Name__r.Name +'-'+leadList[0].Referrer_Name__r.PersonMobilePhone;
            }
             if(leadList[0].Other_Source_Details__c != '' && leadList[0].Other_Source_Details__c != null)
                sv.Other_Source_Details__c = leadList[0].Other_Source_Details__c; 
            if(leadList[0].Employee_Referrer_Name__c != '' && leadList[0].Employee_Referrer_Name__c != null)
                sv.Employee_Referrer_Name__c = leadList[0].Employee_Referrer_Name__c;
            if(leadList[0].OwnerId != null) {
               // sv.Presales_Manager__c = leadList[0].OwnerId;
            	sv.Sourcing_Manager_Name__c = leadList[0].OwnerId;    
            }
        }
    }
    
    public PageReference validateInput() {
        valError = False;
        String p = Apexpages.currentPage().getParameters().get('currentTab');
        system.debug('Page: '+p);
        
        if(Integer.valueOf(p) == 0) {
            if(String.isBlank(sv.Mobile__c)) {
                valError = True;
                message = 'Please fill Mobile.';
            }
            if(sv.Mobile__c.Length() != 10) {
                valError = True;
                message = 'Please enter valid mobile number';
            }
            if(String.isBlank(sv.Last_Name__c)) {
                valError = True;
                message = 'Please fill Last Name.';
            }
            if(String.isBlank(sv.First_Name__c)) {
                valError = True;
                message = 'Please fill First Name.';
            }
        	/* if(String.isBlank(sv.Salutation__c)) {
                valError = True;
                message = 'Please fill Salutation.'; 
            } */
        }
        
        
        if(Integer.valueOf(p) == 1){
            
            if(String.isBlank(sv.Residential_Location__c)) {
                valError = True;
                message = 'Please fill Residential Location.'; 
            }
            
            if(String.isBlank(sv.Residential_Zone__c)) {
                valError = True;
                message = 'Please fill Residential Zone.'; 
            }
        } 
        
        
         if(Integer.valueOf(p) == 2){
             
             if(sv.Lead_Source__c == 'Channel Partner'){
              if(String.isBlank(cpName)) {
                valError = True;
                message = 'Please fill Channel Partner.'; 
            }
          }
        } 
            
        if(Integer.valueOf(p) == 3) {
            
            if(String.isBlank(sv.Exact_Budget__c)) {
                valError = True;
                message = ' Please fill Exact Budget.';
            }
            
            if(String.isBlank(sv.Budget__c)) {
                valError = True;
                message = ' Please fill Budget.';
            }
            if(String.isBlank(sv.Configuration_Required__c)) {
                valError = True;
                message = ' Please state the configuration you are interested in.';
            }
        }
        
         if(Integer.valueOf(p) == 4) {
            
            if(String.isBlank(sv.Occupation__c)) {
                valError = True;
                message = ' Please fill Occupation.';
            }
         }
        return null;
    }
    
    public void submit() {
        isAccountFound = false;
        isLeadFound = false;
        isOppFound = false;
        system.debug('DOB:: '+ birthDate);
        system.debug('DOA:: '+ AnniversaryDate);

        if(String.isNotBlank(cpName) && cpName != '') {
        	List<CP_Project__c> cpList = new List<CP_Project__c>();
            system.debug('cpName: '+cpName);
            string[] arrCPName = cpName.split('-');
            string cpAcc = arrCPName[0];
            string cpProject = arrCPName[1];
            system.debug('cpAcc: '+ cpAcc);
            system.debug('cpProject: '+ cpProject);
            //Id cpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
            cpList = [Select Id, Name, CP_Account__r.Name, CP_Account__r.Id, CP_Project_Name__c 
                      from CP_Project__c 
                      where CP_Account__r.Name =: cpAcc and CP_Project_Name__r.Name =: cpProject];
            system.debug('cpList: '+cpList);
            
            if(!cpList.isEmpty() && cpList != null) {
                sv.Channel_Partner_Account__c = cpList[0].CP_Account__r.Id;
                sv.CP_Project__c = cpList[0].Id;
              //  sv.Sourcing_Manager__c = cpList[0].OwnerId;
            }
        }
        if(String.isNotBlank(refName) && refName != '') {
        	List<Account> refList = new List<Account>();
            String[] tokens = refName.split('-');
            Integer tokenCount = tokens.size();
            for (Integer j = 0; j < tokenCount; j++) {
                System.debug('tokens-'+j+': '+tokens[j]);
            }
            refList = [Select Id, Name, PersonMobilePhone, OwnerId from Account where IsPersonAccount = true AND Name =: tokens[0] AND PersonMobilePhone =: tokens[1]];
            system.debug('refList: '+refList);
            
            if(!refList.isEmpty() && refList != null) {
                sv.Referrer_Name__c = refList[0].Id;
            }
        }
        
        if(mobile != Null && !String.isBlank(mobile)) {
            accList1 = [Select Id, Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email_Id__c,
                               Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                               Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c,Industry,DOB__c,
                               BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode,House_No__c,Locality__c,Residential_Location__c,Residential_Zone__c,Office_Location__c,Office_Zone__c
                        from Account
                        where (PersonMobilePhone =: mobile OR Phone =: mobile) AND IsPersonAccount = true];
            system.debug('accList1: '+accList1);
            
            if(!accList1.isEmpty()) {
                isAccountFound = true;
                
                oppList1 = [Select Id, Name,Site_Visit_Count__c, Project__c, Purchase_Timeframe__c, Configuration_Required__c, 
                            Possession_Timeframe_Required__c, Budget__c,Current_Residence_Status__c, Buying_Purpose__c, Presales_Manager__c,Master_Source__c,
                            Opportunity_Source__c, Opportunity_Sub_Source__c,Opportunity_Sub_Source_Details__c, Employee_Referrer_Name__c,
                            DOB__c,Anniversary_Date__c,Source_Remarks__c,Referrer_Name__c,Account_Name__c,Is_Active__c, Referrer_Name__r.PersonMobilePhone,Channel_Partner_Account__c, Referrer_Name__r.Name
                            from Opportunity_c__c
                            where Account_Name__c =: accList1[0].Id AND Project__c =: pList[0].Id AND Is_Active__c = true];
                system.debug('oppList1: '+oppList1);
                
                if(!oppList1.isEmpty()) {
                    isOppFound = true;
                }
            } else {
                if(email != Null && !String.isBlank(email)) {
                    accList1 = [Select Id, Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email_Id__c,
                                Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                                Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c,Industry,DOB__c,
                                BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode,House_No__c,Locality__c,Residential_Location__c,Residential_Zone__c,Office_Location__c,Office_Zone__c
                                from Account
                                where (PersonEmail =: email OR Alternate_Email_Id__c =: email) AND IsPersonAccount = true];
                    system.debug('accList1: '+accList1);
                    
                    if(!accList1.isEmpty()) {
                        isAccountFound = true;
                        
                        oppList1 = [Select Id, Name,Site_Visit_Count__c, Project__c, Purchase_Timeframe__c, Configuration_Required__c, 
                                    Possession_Timeframe_Required__c,Current_Residence_Status__c, Budget__c, Buying_Purpose__c, Presales_Manager__c,Master_Source__c,
                                    Opportunity_Source__c, Opportunity_Sub_Source__c,Opportunity_Sub_Source_Details__c, Employee_Referrer_Name__c,
                                    DOB__c,Anniversary_Date__c,Source_Remarks__c,Referrer_Name__c,Account_Name__c,Is_Active__c, Referrer_Name__r.PersonMobilePhone,Channel_Partner_Account__c, Referrer_Name__r.Name
                                    from Opportunity_c__c
                                    where Account_Name__c =: accList1[0].Id AND Project__c =: pList[0].Id AND Is_Active__c = true];
                        system.debug('oppList1: '+oppList1);
                        
                        if(!oppList1.isEmpty()) {
                            isOppFound = true;
                        }
                    }
                }
            }
            
            if(oppList1.isEmpty()) {
                leadList1 = [Select Id, First_Name__c, Last_Name__c, Mobile__c,Alternate_Mobile_No__c, Email__c, Alternate_Email_Id__c,Last_Call_Date__c,
                             Project_Name__c, Purchase_Timeframe__c,Campaign_Custom__c, Configuration_Required__c, Possession_Timeframe_Required__c, Budget__c, Buying_Purpose__c, 
                             Age_Group__c, Gender__c, Designation__c, Martial_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                             Current_Residence_Status__c,Current_Residence_City__c,Current_Residence_Area_Locality__c, Ethinicity__c, Household_Income_Annual__c, Industry__c, 	
                             Master_Source_Category__c, Lead_Source__c,Other_Source_Details__c, Lead_Sub_Source__c,Referrer_Name__c,  OwnerId, Employee_Referrer_Name__c,
                             Lead_Stage__c, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c,Sub_Source_Details__c,Channel_Partner_Account__c,
                             Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,Account__c,Opportunity_c__c,isConverted__c,CP_Project__r.Name,
                             Is_Active__c,Follow_up_Date__c,Proposed_Visit_Date__c,Presales_Call_Count__c,Last_Comment__c,First_Call_Date__c,Call_Not_Answered__c,Comment_History__c
                             from Lead_c__c
                             where (Mobile__c =: mobile OR Alternate_Mobile_No__c =: mobile) /*AND Project_Name__c =: pList[0].Id*/ AND isConverted__c = false AND Is_Active__c = true];
                system.debug('leadList1: '+leadList1);
                
                if(!leadList1.isEmpty()) {
                    isLeadFound = true;
                } else {
                    if(email != Null && !String.isBlank(email)) {
                        leadList1 = [Select Id, First_Name__c, Last_Name__c, Mobile__c,Alternate_Mobile_No__c, Email__c, Alternate_Email_Id__c,Last_Call_Date__c,
                                     Project_Name__c, Purchase_Timeframe__c,Campaign_Custom__c, Configuration_Required__c, Possession_Timeframe_Required__c, Budget__c, Buying_Purpose__c, 
                                     Age_Group__c, Gender__c, Designation__c, Martial_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                                     Current_Residence_Status__c,Current_Residence_City__c,Current_Residence_Area_Locality__c, Ethinicity__c, Household_Income_Annual__c, Industry__c, 	
                                     Master_Source_Category__c, Lead_Source__c,Other_Source_Details__c, Lead_Sub_Source__c,Referrer_Name__c,  OwnerId, Employee_Referrer_Name__c,
                                     Lead_Stage__c, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c,Sub_Source_Details__c,Channel_Partner_Account__c,
                                     Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,Account__c,Opportunity_c__c,isConverted__c,Is_Active__c,CP_Project__r.Name,
                                     Follow_up_Date__c,Proposed_Visit_Date__c,Presales_Call_Count__c,Last_Comment__c,First_Call_Date__c,Call_Not_Answered__c,Comment_History__c
                                     from Lead_c__c
                                     where (Email__c =: email OR Alternate_Email_Id__c =: email) /*AND Project_Name__c =: pList[0].Id*/ AND isConverted__c = false AND Is_Active__c = true];
                        system.debug('leadList1: '+leadList1);
                        
                        if(!leadList1.isEmpty()) {
                            isLeadFound = true;
                        }
                    }
                }
            }
        }
        
        if(isAccountFound) {
            if(isOppFound && !isLeadFound) {
                try {
                    //Create Site Visit
                    sv.Opportunity_c__c = oppList1[0].Id;
                    //sv.SV_Date_Time__c = system.now();
                    if(oppList1[0].Site_Visit_Count__c == Null || oppList1[0].Site_Visit_Count__c == 0) {
                        sv.SV_Count__c = 1;
                        if(oppList1[0].Master_Source__c != sv.Master_Source__c || oppList1[0].Opportunity_Source__c != sv.Lead_Source__c) {
                           /* sv.Is_Source_Conflict__c = 'Yes';
                            if(!tmList.isEmpty() && tmList != null)
                                sv.Approver_1__c = tmList[0].Id; */
                        }
                    } else{
                        sv.SV_Count__c = oppList1[0].Site_Visit_Count__c + 1;
                        sv.Visit_Date__c = System.today();
                    }
                        
                    insert sv;
                    
                    //Update Opportunity
                    if(oppList1[0].Site_Visit_Count__c == Null)
                        oppList1[0].Site_Visit_Count__c = 0;
                    oppList1[0].Site_Visit_Count__c = oppList1[0].Site_Visit_Count__c + 1;
                    oppList1[0].Last_SV_Date__c = system.now();
                    update oppList1[0];
                    
                    List<Site_Visit__c> lstSV = [Select Id, Name from Site_Visit__c where Id =: sv.Id];
                    isSuccess = true;
                    message = 'Thank You! Site visit number is '+ lstSV[0].Name;
                    system.debug('Success Message: '+message);
               } catch(Exception ex) {
                   system.debug('Error: '+ex);
                   isRunError = true;
                   message = 'Error ' +ex.getMessage(); 
               }
            } else if(!isOppFound && isLeadFound) {
               // try {$
                    //Update Lead
                    leadList1[0].Lead_Stage__c = 'Visit Done';
                    leadList1[0].Lead_Sub_Stage__c = 'Visit Done';
                    leadList1[0].Lead_Sub_Stage_Reason__c = '';
                    //leadList1[0].is
                    update leadList1[0];
                  
                	System.debug('leadList :' +leadList1);
                    LeadConversionServices.convertLead(leadList1);  
                    
                    Lead_c__c convertedLead = [SELECT Id,Account__c, Opportunity_c__c from Lead_c__c where Id =: leadList1[0].Id];
                    system.debug('Converted Lead: '+convertedLead); 
                   
                    Opportunity_c__c convertedOpp =  [SELECT Id, Name,Site_Visit_Count__c, Master_Source__c, Opportunity_Source__c from Opportunity_c__c where Id =: convertedLead.Opportunity_c__c];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                    //Tag Site Visit Against Opportunity
                    sv.Opportunity_c__c = convertedLead.Opportunity_c__c;
                    sv.Visit_Date__c = system.today();  //PP
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.Proposed_Visit_Date__c = system.now();
                    convertedOpp.Last_SV_Date__c = system.now();//PP
                    update convertedOpp;
                    
                    List<Site_Visit__c> lstSV = [Select Id, Name from Site_Visit__c where Id =: sv.Id];
                    isSuccess = true;
                    message = 'Thank You! Site visit number is '+ lstSV[0].Name;
                    system.debug('Success Message: '+message);
               /* } catch(Exception ex) {
                    system.debug('Error: '+ex);
                    isRunError = true;
                   	message = 'Error ' +ex.getMessage();  
                } */
            } else if(!isOppFound && !isLeadFound && !isAccountFound) {
                Lead_c__c l = new Lead_c__c();
               // l.Salutation = sv.Salutation__c;
                l.First_Name__c = sv.First_Name__c;
                l.Last_Name__c = sv.Last_Name__c;
                l.Mobile__c = sv.Mobile__c;
                l.Email__c = sv.Email__c;
                l.Project_Name__c = pList[0].Id;
                l.Occupation__c = sv.Occupation__c;
                l.Current_Residence_Configuration__c = sv.Current_Residence_Configuration__c;
                l.Current_Residence_Status__c = sv.Current_Residence_Status__c;
                l.Ethinicity__c = sv.Ethnicity__c;
                l.Configuration_Required__c = sv.Configuration_Required__c;
                l.Budget__c = sv.Budget__c;
                l.Master_Source_Category__c = sv.Master_Source__c;
                l.Lead_Source__c = sv.Lead_Source__c;
                l.Lead_Sub_Source__c = sv.Lead_Sub_Source__c;
                l.Other_Source_Details__c = sv.Other_Source_Details__c;
                l.Channel_Partner_Account__c = sv.Channel_Partner_Account__c;
                if(sv.Master_Source__c == 'Recommended by Friends/Relatives' && sv.Lead_Source__c == 'Customers') {
                    l.Referrer_Name__c = sv.Referrer_Name__c;
                } else if(sv.Master_Source__c == 'Recommended by Friends/Relatives' && sv.Lead_Source__c == 'Employees') {
                    l.Employee_Referrer_Name__c = sv.Employee_Referrer_Name__c;
                } else if(sv.Master_Source__c == 'Other' && sv.Lead_Source__c == 'Others') {
                    l.Other_Source_Details__c = sv.Other_Source_Details__c;
                }
                
                if(sv.Master_Source__c == 'Channel Partner' && sv.Lead_Source__c == 'Channel Partner') {
                    l.CP_Project__c = sv.CP_Project__c;
                } 
                
                l.Lead_Stage__c = 'Visit Done';
                l.Lead_Sub_Stage__c = 'Visit Done';
                l.Lead_Sub_Stage_Reason__c = '';
                
                try {
                    insert l;
                    
                    List<Lead_c__c> lList2 = new List<Lead_c__c>();
                    lList2 = [Select Id,First_Name__c, Last_Name__c, Mobile__c, Alternate_Mobile_No__c, Email__c, Alternate_Email_Id__c,Last_Call_Date__c,
                              Project_Name__c, Purchase_Timeframe__c,Campaign_Custom__c, Configuration_Required__c, Possession_Timeframe_Required__c, Budget__c, Buying_Purpose__c, 
                              Age_Group__c, Gender__c, Designation__c, Martial_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                              Current_Residence_Status__c,Current_Residence_City__c,Current_Residence_Area_Locality__c, Ethinicity__c, Household_Income_Annual__c, Industry__c, 	
                              Master_Source_Category__c, Lead_Source__c,Other_Source_Details__c, Lead_Sub_Source__c,Referrer_Name__c,  OwnerId, Employee_Referrer_Name__c,
                              Lead_Stage__c, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c,Sub_Source_Details__c,Channel_Partner_Account__c,
                              Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,Opportunity_c__c,Account__c,CP_Project__c,CP_Project__r.Name,
                              Follow_up_Date__c,Proposed_Visit_Date__c,Presales_Call_Count__c,Last_Comment__c,First_Call_Date__c,Call_Not_Answered__c,Comment_History__c
                              from Lead_c__c Where Id =: L.Id ];
                      
                    LeadConversionServices.convertLead(lList2);
                    
                    Lead_c__c convertedLead = [SELECT Account__c, Opportunity_c__c from Lead_c__c where Id = :l.Id];
                    system.debug('Converted Lead: '+convertedLead);
                                      
                    Opportunity_c__c convertedOpp =  [SELECT Id, Name, Site_Visit_Count__c from Opportunity_c__c 
                                                 where Id =: convertedLead.Opportunity_c__c];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                    
                    //Tag Site Visit Against Converted Opportunity
                    sv.Opportunity_c__c = convertedOpp.Id;
                    sv.Visit_Date__c = system.Today(); //PP
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                   // convertedOpp.Visit_Date__c = system.Now();
                    update convertedOpp;
                    
                    List<Site_Visit__c> lstSV = [Select Id, Name from Site_Visit__c where Id =: sv.Id];
                    isSuccess = true;
                    message = 'Thank You! Site visit number is '+ lstSV[0].Name;
                    system.debug('Success Message: '+message);
                } catch(Exception ex) {
                    system.debug('Exception: '+ex);
                    isRunError = true;
                    message = 'Error ' +ex.getMessage();    
                }
            }
            else if(!isOppFound && isAccountFound)
			{
				Opportunity_c__c op = new Opportunity_c__c();
				system.debug('In side diff proj opp');
				if(!accList1.isEmpty()){
						op.Account_Name__c = accList1[0].Id;

					if(sv.First_Name__c != Null)
						op.First_Name__c = sv.First_Name__c;
					else 
						op.First_Name__c = '';
					if(sv.Last_Name__c!= Null)
						op.Last_Name__c = sv.Last_Name__c;
					else
						op.Last_Name__c='';
                    op.CloseDate__c = system.today().addDays(60);
					op.Mobile__c = sv.Mobile__c;
					op.Email__c = sv.Email__c;
					op.Project__c = pList[0].Id;
					op.Opportunity_Stage__c = 'In Follow-up';
					op.Master_Source__c = sv.Master_Source__c;
					op.Opportunity_Source__c = sv.Lead_Source__c;
					op.Opportunity_Sub_Source__c = sv.Lead_Sub_Source__c;
					op.Opportunity_Sub_Source_Details__c = sv.Other_Source_Details__c;
					op.Channel_Partner_Account__c = sv.Channel_Partner_Account__c;
                    if(sv.Master_Source__c == 'Recommended by Friends/Relatives' && sv.Lead_Source__c == 'Customers') {
						op.Referrer_Name__c = sv.Referrer_Name__c;
                    }
                    else if(sv.Master_Source__c == 'Recommended by Friends/Relatives' && sv.Lead_Source__c == 'Employees') {
						op.Employee_Referrer_Name__c = sv.Employee_Referrer_Name__c;
                    }
                    else if(sv.Master_Source__c == 'Channel Partner' && sv.Lead_Source__c == 'Channel Partner') {
                    	op.CP_Project__c = sv.CP_Project__c;
                	}
                    else if(sv.Master_Source__c == 'Other' && sv.Lead_Source__c == 'Others') {
						op.Other_Source_Details__c = sv.Other_Source_Details__c;
                    }
					op.Budget__c = sv.Budget__c;
					op.Buying_Purpose__c = sv.Buying_Purpose__c;

					op.Configuration_Required__c = sv.Configuration_Required__c;
					op.Possession_Timeframe_Required__c = sv.Possession_Timeframe_Required__c;
					op.Current_Residence_Configuration__c= sv.Current_Residence_Configuration__c;
					op.Current_Residence_Status__c= sv.Current_Residence_Status__c;

					insert op;
                    
                    sv.Opportunity_c__c = op.id;
                    sv.Visit_Date__c = system.Today(); //PP
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    List<Opportunity_c__c> updtOpp = [Select Id, Name, Site_Visit_Count__c, Last_SV_Date__c
                                                       	from Opportunity_c__c 
                                                        where Id =: op.Id];
                    if(!updtOpp.isEmpty())
                    {
                        if(updtOpp[0].Site_Visit_Count__c == Null)
                        	updtOpp[0].Site_Visit_Count__c = 0;
                        updtOpp[0].Site_Visit_Count__c = updtOpp[0].Site_Visit_Count__c + 1;
                    	updtOpp[0].Last_SV_Date__c = system.now();
                    	update updtOpp[0];
                    }
                    List<Site_Visit__c> lstSV = [Select Id, Name from Site_Visit__c where Id =: sv.Id];
                    isSuccess = true;
                    message = 'Thank You! Site visit number is '+ lstSV[0].Name;
                    system.debug('Success Message: '+message);
				}
			}
        } else {
            if(isLeadFound) {
                try {
                    //Update Lead
                    leadList1[0].Lead_Stage__c = 'Visit Done';
                    leadList1[0].Lead_Sub_Stage__c = 'Visit Done';
                    leadList1[0].Lead_Sub_Stage_Reason__c = '';
                    update leadList1[0];
                    
                    LeadConversionServices.convertLead(leadList1);
                    
                    Lead_c__c convertedLead = [SELECT Account__c, Opportunity_c__c from Lead_c__c where Id =: leadList1[0].Id];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    Opportunity_c__c convertedOpp =  [SELECT Id, Name, Site_Visit_Count__c, Master_Source__c, Opportunity_Source__c from Opportunity_c__c where Id =: convertedLead.Opportunity_c__c];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                    
                    if(convertedOpp.Master_Source__c != sv.Master_Source__c || convertedOpp.Opportunity_Source__c != sv.Source__c) {
                       /* sv.Is_Source_Conflict__c = 'Yes';
                        if(!tmList.isEmpty() && tmList != null)
                            sv.Approver_1__c = tmList[0].Id; */
                    }
                    //Tag Site Visit Against Opportunity
                    sv.Opportunity_c__c = convertedOpp.Id;
                    sv.Visit_Date__c = system.Today(); //PP
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.Proposed_Visit_Date__c = system.now();
                    convertedOpp.Last_SV_Date__c = system.now(); //PP
                    update convertedOpp;
                    
                    List<Site_Visit__c> lstSV = [Select Id, Name from Site_Visit__c where Id =: sv.Id];
                    isSuccess = true;
                    message = 'Thank You! Site visit number is '+ lstSV[0].Name;
                    system.debug('Success Message: '+message);
                } catch(Exception ex) {
                    system.debug('Error: '+ex);
                    isRunError = true;
                    message = 'Error ' +ex.getMessage();    
                }
            } else {
                Lead_c__c l = new Lead_c__c();
                l.First_Name__c = sv.First_Name__c;
                l.Last_Name__c = sv.Last_Name__c;
                l.Mobile__c = sv.Mobile__c;
                l.Email__c = sv.Email__c;
                l.Project_Name__c = pList[0].Id;
                l.Occupation__c = sv.Occupation__c;
                l.Configuration_Required__c = sv.Configuration_Required__c;
                l.Budget__c = sv.Budget__c;
                l.Master_Source_Category__c = sv.Master_Source__c;
                l.Lead_Source__c = sv.Lead_Source__c;
                l.Lead_Sub_Source__c = sv.Lead_Sub_Source__c;
                l.Other_Source_Details__c = sv.Other_Source_Details__c;
                l.Channel_Partner_Account__c=sv.Channel_Partner_Account__c;
                if(sv.Master_Source__c == 'Recommended by Friends/Relatives' && sv.Lead_Source__c == 'Customers') {
                    l.Referrer_Name__c = sv.Referrer_Name__c;
                } else if(sv.Master_Source__c == 'Recommended by Friends/Relatives' && sv.Lead_Source__c == 'Employees') {
                    l.Employee_Referrer_Name__c = sv.Employee_Referrer_Name__c;
                } else if(sv.Master_Source__c == 'Other' && sv.Lead_Source__c == 'Others') {
                    l.Other_Source_Details__c = sv.Other_Source_Details__c;
                } 
                else if(sv.Master_Source__c == 'Channel Partner' && sv.Lead_Source__c == 'Channel Partner') {
                    l.CP_Project__c = sv.CP_Project__c;
                }
                
                l.Lead_Stage__c = 'Visit Done';
                l.Lead_Sub_Stage__c = 'Visit Done';
                l.Lead_Sub_Stage_Reason__c = '';
                
                try {
                    insert l;
                    
                    List<Lead_c__c> lList4 = new List<Lead_c__c>();
                    lList4 = [Select Id, Name,First_Name__c, Last_Name__c, Mobile__c, Alternate_Mobile_No__c, Email__c, Alternate_Email_Id__c,Last_Call_Date__c,
                              Project_Name__c, Purchase_Timeframe__c,Campaign_Custom__c, Configuration_Required__c, Possession_Timeframe_Required__c, Budget__c, Buying_Purpose__c, 
                              Age_Group__c, Gender__c, Designation__c, Martial_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                              Current_Residence_Status__c,Current_Residence_City__c,Current_Residence_Area_Locality__c, Ethinicity__c, Household_Income_Annual__c, Industry__c, 	
                              Master_Source_Category__c, Lead_Source__c,Other_Source_Details__c, Lead_Sub_Source__c,Referrer_Name__c,  OwnerId, Employee_Referrer_Name__c,
                              Lead_Stage__c, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c,Sub_Source_Details__c,CP_Project__c,Channel_Partner_Account__c,
                              Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,Account__c,Opportunity_c__c,CP_Project__r.Name,
                              Follow_up_Date__c,Proposed_Visit_Date__c,Presales_Call_Count__c,Last_Comment__c,First_Call_Date__c,Call_Not_Answered__c,Comment_History__c
                              from Lead_c__c Where Id =: L.Id ];
                    
                    LeadConversionServices.convertLead(lList4);
                    
                    Lead_c__c convertedLead = [SELECT Account__c, Opportunity_c__c from Lead_c__c where Id = :l.Id];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    Opportunity_c__c convertedOpp =  [SELECT Id, Name, Site_Visit_Count__c from Opportunity_c__c 
                                                 where Id =: convertedLead.Opportunity_c__c];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                    //Tag Site Visit Against Converted Opportunity
                    sv.Opportunity_c__c = convertedOpp.Id;
                    sv.Visit_Date__c = system.Today(); //PP
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.Proposed_Visit_Date__c = system.now();
                    convertedOpp.Last_SV_Date__c = system.now(); //PP
                    update convertedOpp;
                    
                    List<Site_Visit__c> lstSV = [Select Id, Name from Site_Visit__c where Id =: sv.Id];
                    isSuccess = true;
                    message = 'Thank You! Site visit number is '+ lstSV[0].Name;
                    system.debug('Success Message: '+message);
                } catch(Exception ex) {
                    system.debug('Exception: '+ex);
                    isRunError = true;
                    message = 'Error ' +ex.getMessage();    
                } 
            }
        }
    }
    
    @RemoteAction
    public static List<String> getChannelPartner(String cpName) {
        List<String> cpNameList = new List<String>();
        List<CP_Project__c> cpList = new List<CP_Project__c>();
       // Id cpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        String QueryString =  'Select Id, Name, CP_Account__r.Name,CP_Account__r.RG_Code__c, CP_Project_Name__r.Name from CP_Project__c where (CP_Account__r.Name LIKE \'' + cpName + '%\') OR (CP_Account__r.RG_Code__c LIKE \'' + cpName + '%\')';
        cpList = Database.query(QueryString);
        system.debug('cpList: '+cpList);
        
        if(!cpList.isEmpty() && cpList != null){
            for(CP_Project__c cp : cpList){
                cpNameList.add(cp.CP_Account__r.Name+'-'+cp.CP_Project_Name__r.Name+'-'+cp.CP_Account__r.RG_Code__c);
            }
        }
        return cpNameList;
    }
    
    
   
    
    @RemoteAction
    public static List<String> getReferrerName(String refName) {
        List<String> refNameList = new List<String>();
        List<Account> refList = new List<Account>();
        String QueryString =  'Select Id, Name, FirstName, LastName, PersonMobilePhone, Phone from Account where IsPersonAccount = true AND (FirstName LIKE \'' + refName + '%\' OR LastName LIKE \'' + refName + '%\' OR PersonMobilePhone LIKE \'' + refName + '%\' OR Phone LIKE \'' + refName + '%\')';
        refList = Database.query(QueryString);
        system.debug('refList: '+refList);
        
        if(!refList.isEmpty() && refList != null){
            for(Account a : refList){
                refNameList.add(a.Name+'-'+a.PersonMobilePhone);
            }
        }
        return refNameList;
    }
    
    public Pagereference closeForm() {
        Pagereference pg = new Pagereference('/'+sv.id);
        pg.setredirect(true);
        return pg;
    }
}