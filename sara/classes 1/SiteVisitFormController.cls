public class SiteVisitFormController {
    public List<Account> accList1 {get;set;}
    public List<Opportunity> oppList1 {get;set;}
    public List<Lead> leadList1 {get;set;}
    public List<Lead> leadList2 {get;set;}
    public List<Project__c> pList {get;set;}
    public Site_Visit__c sv {get;set;}
    public boolean isAccount {get;set;}
    public boolean isLead {get;set;}
    public boolean isOpp {get;set;}
    public String project {get;set;}
    public String projectName {get;set;}
    public String clusterName {get;set;}
    public String mobile {get;set;}
    public String email {get;set;}
    public Boolean isRunError {get;set;}
    public Boolean isSuccess {get;set;}
    public Boolean valError {get;set;}
    public String message {get;set;}
    public String cpName {get;set;}
    public boolean isAccountFound {get;set;}
    public boolean isProjectLeadFound {get;set;}
    public boolean isClusterLeadFound {get;set;}
    public boolean isOppFound {get;set;}
    public Date birthDate {get;set;}
    public Date AnniversaryDate {get;set;}
    public boolean isSourceNotEditable {get;set;}
    public List<Team_Members__c> tmList {get;set;}
    
    public SiteVisitFormController() {
        accList1 = new List<Account>();
        oppList1 = new List<Opportunity>();
        leadList1 = new List<Lead>();
        leadList2 = new List<Lead>();
        pList = new List<Project__c>();
        sv = new Site_Visit__c();
        isSuccess = false;
        isRunError = false;
        isAccount = false;
        isLead = false;
        isOpp = false;
        isAccountFound = false;
        isProjectLeadFound = false;
        isClusterLeadFound = false;
        isOppFound = false;
        project = '';
        projectName = '';
        clusterName = '';
        mobile = '';
        email = '';
        message = '';
        cpName = '';
        birthDate = null;
        AnniversaryDate = null;
        isSourceNotEditable = false;
        tmList = new List<Team_Members__c>();
        
        project = ApexPages.currentPage().getParameters().get('project'); 
        mobile = ApexPages.currentPage().getParameters().get('mobile');
        email = ApexPages.currentPage().getParameters().get('email');
        system.debug('project: '+project+ ' mobile: '+mobile+ ' email: '+email);
        
        if(project != Null && !String.isBlank(project)) {
            pList = [Select Id, Name, Cluster__c from Project__c where Id =: project];
            system.debug('pList: '+pList);
            
            if(!pList.isEmpty()) {
                sv.Project__c = pList[0].Id;
                projectName = pList[0].Name;
                clusterName = pList[0].Cluster__c;
                
                tmList = [Select Id, User__c from Team_Members__c where Team__r.Team_Type__c = 'Site Head Team' AND Team__r.Project__c =: pList[0].Id
                          AND User_Active_Status__c = true];
                system.debug('tmList: '+tmList);
            }
        }
        
        if(mobile != Null && !String.isBlank(mobile)) {
            sv.Mobile__c = mobile;
        }
        if(email != Null && !String.isBlank(email)) {
            sv.Email__c = email;
        }
        
        List<Account> accList = new List<Account>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Lead> leadList = new List<Lead>();
        List<Site_Visit__c> svList = new List<Site_Visit__c>();
        
        if(mobile != Null && !String.isBlank(mobile)) {
            accList = [Select Id, Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, DOB__c, Anniversary_Date__c,
                       Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                       Citizenship__c, Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c, Industry, Company_Name__c
                       from Account 
                       where (PersonMobilePhone =: mobile OR Phone =: mobile) AND IsPersonAccount = true];
            system.debug('accList: '+accList);
            
            if(!accList.isEmpty()) {
                isAccount = true;
                
                oppList = [Select Id, Name, SV_Date_Time__c, Site_Visit_Count__c, Presales_Manager__c, Project__c, Purchase_Timeframe__c, Configuration_Required__c, 
                           Possession_Timeline_Requirement__c, Budget__c, Buying_Purpose__c, Location__c,
                           Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Channel_Partner_Name__c, Reference_Name__c, Other_Source_Details__c  
                           from Opportunity
                           where AccountId =: accList[0].Id AND Project__c =: pList[0].Id AND Is_Active__c = true];
                system.debug('oppList: '+oppList);
                
                if(!oppList.isEmpty()) {
                    isOpp = true;
                    
                    svList = [Select Id, Name from Site_Visit__c where Opportunity__c =: oppList[0].Id];
                    system.debug('svList: '+svList);
                    
                    if(!svList.isEmpty()) {
                        isSourceNotEditable = true;
                    }
                }
            } else {
                if(email != Null && !String.isBlank(email)) {
                    accList = [Select Id, Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, DOB__c, Anniversary_Date__c,
                               Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                               Citizenship__c, Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c, Industry, Company_Name__c
                               from Account
                               where (PersonEmail =: email OR Alternate_Email__c =: email) AND IsPersonAccount = true];
                    system.debug('accList: '+accList);
                    
                    if(!accList.isEmpty()) {
                        isAccount = true;
                        
                        oppList = [Select Id, Name, SV_Date_Time__c, Site_Visit_Count__c, Presales_Manager__c, Project__c, Purchase_Timeframe__c, Configuration_Required__c, 
                                   Possession_Timeline_Requirement__c, Budget__c, Buying_Purpose__c, Location__c,
                                   Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Channel_Partner_Name__c, Reference_Name__c, Other_Source_Details__c  
                                   from Opportunity
                                   where AccountId =: accList[0].Id AND Project__c =: pList[0].Id AND Is_Active__c = true];
                        system.debug('oppList: '+oppList);
                        
                        if(!oppList.isEmpty()) {
                            isOpp = true;
                            
                            svList = [Select Id, Name from Site_Visit__c where Opportunity__c =: oppList[0].Id];
                            system.debug('svList: '+svList);
                            
                            if(!svList.isEmpty()) {
                                isSourceNotEditable = true;
                            }
                        }
                    }
                }
            }
            
            if(oppList.isEmpty()) {
                leadList = [Select Id, Salutation, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email__c, DOB__c, Anniversary_Date__c,
                            Project__c, Purchase_Timeframe__c, Configuration_Required__c, Possession_Timeline_Requirement__c, Budget__c, Buying_Purpose__c, Location__c,
                            Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                            Citizenship__c, Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c, Industry, Company_Name__c,
                            Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Channel_Partner_Name__c, Reference_Name__c, Other_Source_Details__c, OwnerId,
                            Status, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c
                            from Lead
                            where (MobilePhone =: mobile OR Phone =: mobile) AND Project__c =: pList[0].Id AND isConverted = false AND Is_Active__c = true];
                system.debug('leadList: '+leadList);
                
                if(!leadList.isEmpty()) {
                    isLead = true;
                } else {
                    if(email != Null && !String.isBlank(email)) {
                        leadList = [Select Id, Salutation, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email__c, DOB__c, Anniversary_Date__c,
                                    Project__c, Purchase_Timeframe__c, Configuration_Required__c, Possession_Timeline_Requirement__c, Budget__c, Buying_Purpose__c, Location__c,
                                    Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                                    Citizenship__c, Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c, Industry, Company_Name__c,
                                    Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Channel_Partner_Name__c, Reference_Name__c, Other_Source_Details__c, OwnerId,
                                    Status, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c
                                    from Lead
                                    where (Email =: email OR Alternate_Email__c =: email) AND Project__c =: pList[0].Id AND isConverted = false AND Is_Active__c = true];
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
            if(sv.Email__c == '' && accList[0].PersonEmail != '' && accList[0].PersonEmail != null)
                sv.Email__c = accList[0].PersonEmail;
            if(accList[0].DOB__c != Null) {
                sv.Birth_Date__c = accList[0].DOB__c;
            	birthDate = accList[0].DOB__c;    
            }
            if(accList[0].Anniversary_Date__c != null) {
                sv.Anniversary_Date__c = accList[0].Anniversary_Date__c;
                AnniversaryDate = accList[0].Anniversary_Date__c;
            }
            if(accList[0].Age_Group__c != '' && accList[0].Age_Group__c != null)
            	sv.Age_Group__c = accList[0].Age_Group__c;
            if(accList[0].Gender__c != '' && accList[0].Gender__c != null)
            	sv.Gender__c = accList[0].Gender__c;
            if(accList[0].Designation__c != '' && accList[0].Designation__c != null)
            	sv.Designation__c = accList[0].Designation__c;
            if(accList[0].Marital_Status__c != '' && accList[0].Marital_Status__c != null)
            	sv.Marital_Status__c = accList[0].Marital_Status__c;
            if(accList[0].Occupation__c != '' && accList[0].Occupation__c != null)
            	sv.Occupation__c = accList[0].Occupation__c;
            if(accList[0].Family_Size__c != '' && accList[0].Family_Size__c != null)
            	sv.Family_Size__c = accList[0].Family_Size__c;
            if(accList[0].Highest_Education__c != '' && accList[0].Highest_Education__c != null)
            	sv.Highest_Education__c = accList[0].Highest_Education__c;
            if(accList[0].Current_Residence_Configuration__c != '' && accList[0].Current_Residence_Configuration__c != null)
            	sv.Current_Residence_Configuration__c = accList[0].Current_Residence_Configuration__c;
            if(accList[0].Citizenship__c != '' && accList[0].Citizenship__c != null)
            	sv.Citizenship__c = accList[0].Citizenship__c;
            if(accList[0].Current_Residence_Status__c != '' && accList[0].Current_Residence_Status__c != null)
            	sv.Current_Residence_Status__c = accList[0].Current_Residence_Status__c;
            if(accList[0].Ethinicity__c != '' && accList[0].Ethinicity__c != null)
            	sv.Ethinicity__c = accList[0].Ethinicity__c;
            if(accList[0].Household_Income_Annual__c != '' && accList[0].Household_Income_Annual__c != null)
            	sv.Household_Income_Annual__c = accList[0].Household_Income_Annual__c;
            if(accList[0].Household_Income_Annual__c != '' && accList[0].Household_Income_Annual__c != null)
            	sv.Household_Income_Annual__c = accList[0].Household_Income_Annual__c;
            if(accList[0].Industry != '' && accList[0].Industry != null)
            	sv.Industry__c = accList[0].Industry;
            if(accList[0].Company_Name__c != '' && accList[0].Company_Name__c != null)
            	sv.Company_Name__c = accList[0].Company_Name__c;
            
            if(isOpp) {
                if(oppList[0].Purchase_Timeframe__c != '' && oppList[0].Purchase_Timeframe__c != null)
                	sv.Purchase_Timeframe__c = oppList[0].Purchase_Timeframe__c;
                if(oppList[0].Configuration_Required__c != '' && oppList[0].Configuration_Required__c != null)
                	sv.Configuration_Required__c = oppList[0].Configuration_Required__c;
                if(oppList[0].Possession_Timeline_Requirement__c != '' && oppList[0].Possession_Timeline_Requirement__c != null)
                	sv.Possession_Timeline_Requirement__c = oppList[0].Possession_Timeline_Requirement__c;
                if(oppList[0].Budget__c != '' && oppList[0].Budget__c != null)
                	sv.Budget__c = oppList[0].Budget__c;
                if(oppList[0].Buying_Purpose__c != '' && oppList[0].Buying_Purpose__c != null)
                	sv.Buying_Purpose__c = oppList[0].Buying_Purpose__c;
                if(oppList[0].Location__c != '' && oppList[0].Location__c != null)
                	sv.Location__c = oppList[0].Location__c;
                if(oppList[0].Master_Source__c != '' && oppList[0].Master_Source__c != null)
                	sv.Master_Source__c = oppList[0].Master_Source__c;
                if(oppList[0].Lead_Source__c != '' && oppList[0].Lead_Source__c != null)
                	sv.Lead_Source__c = oppList[0].Lead_Source__c;
                if(oppList[0].Lead_Sub_Source__c != '' && oppList[0].Lead_Sub_Source__c != null)
                	sv.Lead_Sub_Source__c = oppList[0].Lead_Sub_Source__c;
                if(oppList[0].Lead_Sub_Source_Details__c != '' && oppList[0].Lead_Sub_Source_Details__c != null)
                    sv.Lead_Sub_Source_Details__c = oppList[0].Lead_Sub_Source_Details__c;
                if(oppList[0].Channel_Partner_Name__c != '' && oppList[0].Channel_Partner_Name__c != null)
                	sv.Channel_Partner_Name__c = oppList[0].Channel_Partner_Name__c;
                if(oppList[0].Reference_Name__c != '' && oppList[0].Reference_Name__c != null)
                    sv.Reference_Name__c = oppList[0].Reference_Name__c;
                if(oppList[0].Other_Source_Details__c != '' && oppList[0].Other_Source_Details__c != null)
                    sv.Other_Source_Details__c = oppList[0].Other_Source_Details__c;
                if(oppList[0].Presales_Manager__c != null)
                    sv.Presales_Manager__c = oppList[0].Presales_Manager__c;
            } else if(isLead) {
                if(leadList[0].Purchase_Timeframe__c != '' && leadList[0].Purchase_Timeframe__c != null)
                	sv.Purchase_Timeframe__c = leadList[0].Purchase_Timeframe__c;
                if(leadList[0].Configuration_Required__c != '' && leadList[0].Configuration_Required__c != null)
                	sv.Configuration_Required__c = leadList[0].Configuration_Required__c;
                if(leadList[0].Possession_Timeline_Requirement__c != '' && leadList[0].Possession_Timeline_Requirement__c != null)
                	sv.Possession_Timeline_Requirement__c = leadList[0].Possession_Timeline_Requirement__c;
                if(leadList[0].Budget__c != '' && leadList[0].Budget__c != null)
                	sv.Budget__c = leadList[0].Budget__c;
                if(leadList[0].Buying_Purpose__c != '' && leadList[0].Buying_Purpose__c != null)
                	sv.Buying_Purpose__c = leadList[0].Buying_Purpose__c;
                if(leadList[0].Location__c != '' && leadList[0].Location__c != null)
                	sv.Location__c = leadList[0].Location__c;
                if(leadList[0].Master_Source__c!= '' && leadList[0].Master_Source__c!= Null)
                    sv.Master_Source__c= leadList[0].Master_Source__c;   
                if(leadList[0].Lead_Source__c != '' && leadList[0].Lead_Source__c != Null)
                    sv.Lead_Source__c = leadList[0].Lead_Source__c;
                if(leadList[0].Lead_Sub_Source__c != '' && leadList[0].Lead_Sub_Source__c != Null)
                    sv.Lead_Sub_Source__c = leadList[0].Lead_Sub_Source__c;
                if(leadList[0].Lead_Sub_Source_Details__c != '' && leadList[0].Lead_Sub_Source_Details__c != null)
                    sv.Lead_Sub_Source_Details__c = leadList[0].Lead_Sub_Source_Details__c;
                if(leadList[0].Channel_Partner_Name__c != '' && leadList[0].Channel_Partner_Name__c != null)
                	sv.Channel_Partner_Name__c = leadList[0].Channel_Partner_Name__c;
                if(leadList[0].Reference_Name__c != '' && leadList[0].Reference_Name__c != null)
                    sv.Reference_Name__c = leadList[0].Reference_Name__c;
                if(leadList[0].Other_Source_Details__c != '' && leadList[0].Other_Source_Details__c != null)
                    sv.Other_Source_Details__c = leadList[0].Other_Source_Details__c;
                if(leadList[0].OwnerId != null)
            		sv.Presales_Manager__c = leadList[0].OwnerId;
            }
        } else if(isLead) {
            if(leadList[0].Salutation != '' && leadList[0].Salutation != Null)
                sv.Salutation__c = leadList[0].Salutation;
            if(leadList[0].FirstName != '' && leadList[0].FirstName != Null)
                sv.First_Name__c = leadList[0].FirstName;
            if(leadList[0].LastName != '' && leadList[0].LastName != Null)
                sv.Last_Name__c = leadList[0].LastName;
            if(sv.Email__c == '' && leadList[0].Email != '' && leadList[0].Email != null)
                sv.Email__c = leadList[0].Email;
            if(leadList[0].DOB__c != Null) {
                sv.Birth_Date__c = leadList[0].DOB__c;
                birthDate = leadList[0].DOB__c;
            }
            if(leadList[0].Anniversary_Date__c != null) {
                sv.Anniversary_Date__c = leadList[0].Anniversary_Date__c;
                AnniversaryDate = leadList[0].Anniversary_Date__c;
            }
            if(leadList[0].Age_Group__c != '' && leadList[0].Age_Group__c != null)
            	sv.Age_Group__c = leadList[0].Age_Group__c;
            if(leadList[0].Gender__c != '' && leadList[0].Gender__c != null)
            	sv.Gender__c = leadList[0].Gender__c;
            if(leadList[0].Designation__c != '' && leadList[0].Designation__c != null)
            	sv.Designation__c = leadList[0].Designation__c;
            if(leadList[0].Marital_Status__c != '' && leadList[0].Marital_Status__c != null)
            	sv.Marital_Status__c = leadList[0].Marital_Status__c;
            if(leadList[0].Occupation__c != '' && leadList[0].Occupation__c != null)
            	sv.Occupation__c = leadList[0].Occupation__c;
            if(leadList[0].Family_Size__c != '' && leadList[0].Family_Size__c != null)
            	sv.Family_Size__c = leadList[0].Family_Size__c;
            if(leadList[0].Highest_Education__c != '' && leadList[0].Highest_Education__c != null)
            	sv.Highest_Education__c = leadList[0].Highest_Education__c;
            if(leadList[0].Current_Residence_Configuration__c != '' && leadList[0].Current_Residence_Configuration__c != null)
            	sv.Current_Residence_Configuration__c = leadList[0].Current_Residence_Configuration__c;
            if(leadList[0].Citizenship__c != '' && leadList[0].Citizenship__c != null)
            	sv.Citizenship__c = leadList[0].Citizenship__c;
            if(leadList[0].Current_Residence_Status__c != '' && leadList[0].Current_Residence_Status__c != null)
            	sv.Current_Residence_Status__c = leadList[0].Current_Residence_Status__c;
            if(leadList[0].Ethinicity__c != '' && leadList[0].Ethinicity__c != null)
            	sv.Ethinicity__c = leadList[0].Ethinicity__c;
            if(leadList[0].Household_Income_Annual__c != '' && leadList[0].Household_Income_Annual__c != null)
            	sv.Household_Income_Annual__c = leadList[0].Household_Income_Annual__c;
            if(leadList[0].Household_Income_Annual__c != '' && leadList[0].Household_Income_Annual__c != null)
            	sv.Household_Income_Annual__c = leadList[0].Household_Income_Annual__c;
            if(leadList[0].Industry != '' && leadList[0].Industry != null)
            	sv.Industry__c = leadList[0].Industry;
            if(leadList[0].Company_Name__c != '' && leadList[0].Company_Name__c != null)
            	sv.Company_Name__c = leadList[0].Company_Name__c;
            if(leadList[0].Purchase_Timeframe__c != '' && leadList[0].Purchase_Timeframe__c != null)
                sv.Purchase_Timeframe__c = leadList[0].Purchase_Timeframe__c;
            if(leadList[0].Configuration_Required__c != '' && leadList[0].Configuration_Required__c != null)
                sv.Configuration_Required__c = leadList[0].Configuration_Required__c;
            if(leadList[0].Possession_Timeline_Requirement__c != '' && leadList[0].Possession_Timeline_Requirement__c != null)
                sv.Possession_Timeline_Requirement__c = leadList[0].Possession_Timeline_Requirement__c;
            if(leadList[0].Budget__c != '' && leadList[0].Budget__c != null)
                sv.Budget__c = leadList[0].Budget__c;
            if(leadList[0].Buying_Purpose__c != '' && leadList[0].Buying_Purpose__c != null)
                sv.Buying_Purpose__c = leadList[0].Buying_Purpose__c;
            if(leadList[0].Location__c != '' && leadList[0].Location__c != null)
                sv.Location__c = leadList[0].Location__c;
            if(leadList[0].Master_Source__c!= '' && leadList[0].Master_Source__c!= Null)
                sv.Master_Source__c= leadList[0].Master_Source__c;   
            if(leadList[0].Lead_Source__c != '' && leadList[0].Lead_Source__c != Null)
                sv.Lead_Source__c = leadList[0].Lead_Source__c;
            if(leadList[0].Lead_Sub_Source__c != '' && leadList[0].Lead_Sub_Source__c != Null)
                sv.Lead_Sub_Source__c = leadList[0].Lead_Sub_Source__c;
            if(leadList[0].Lead_Sub_Source_Details__c != '' && leadList[0].Lead_Sub_Source_Details__c != null)
                sv.Lead_Sub_Source_Details__c = leadList[0].Lead_Sub_Source_Details__c;
            if(leadList[0].Channel_Partner_Name__c != '' && leadList[0].Channel_Partner_Name__c != null)
                sv.Channel_Partner_Name__c = leadList[0].Channel_Partner_Name__c;
            if(leadList[0].Reference_Name__c != '' && leadList[0].Reference_Name__c != null)
                sv.Reference_Name__c = leadList[0].Reference_Name__c;
            if(leadList[0].Other_Source_Details__c != '' && leadList[0].Other_Source_Details__c != null)
                sv.Other_Source_Details__c = leadList[0].Other_Source_Details__c;
            if(leadList[0].OwnerId != null)
                sv.Presales_Manager__c = leadList[0].OwnerId;
        }
    }
    
    public PageReference validateInput() {
        valError = False;
        String p = Apexpages.currentPage().getParameters().get('currentTab');
        system.debug('Page: '+p);
        
        if(Integer.valueOf(p) == 0) {
            if(String.isBlank(sv.Occupation__c)) {
                valError = True;
                message = 'Please fill Occupation.';
            }
            if(String.isBlank(sv.Age_Group__c)) {
                valError = True;
                message = 'Please fill Age Group.';
            }
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
        	if(String.isBlank(sv.Salutation__c)) {
                valError = True;
                message = 'Please fill Salutation.'; 
            }
        }
        if(Integer.valueOf(p) == 1) {
            if(String.isBlank(sv.Master_Source__c)) {
                valError = True;
                message = 'Please fill Master Source.';
            } else if(String.isBlank(sv.Lead_Source__c)) {
                valError = True;
                message = 'Please fill Lead Source.';
            } else if(sv.Master_Source__c == 'Channel Partner') {          
                if(String.isBlank(sv.Channel_Partner_Name__c)) {
                    valError = True;
                    message = 'Please fill Channel Partner Name.';
                }
            } else if(sv.Master_Source__c == 'Reference' && sv.Lead_Source__c == 'Employees') {
                if(String.isBlank(sv.Reference_Name__c)) {
                    valError = True;
                    message = 'Please fill Employees Referrer Name.';
                }
            } else if(sv.Master_Source__c == 'Reference' && sv.Lead_Source__c == 'Customers') {
                if(String.isBlank(sv.Reference_Name__c)) {
                    valError = True;
                    message = 'Please fill Customer Referrer Name.';
                } 
            } else if(sv.Master_Source__c == 'Other') {
                if(String.isBlank(sv.Other_Source_Details__c)) {
                    valError = True;
                    message = 'Please fill Other Source Details.';
            	}
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
        return null;
    }
    
    public void submit() {
        isAccountFound = false;
        isProjectLeadFound = false;
        isClusterLeadFound = false;
        isOppFound = false;
        system.debug('DOB:: '+ birthDate);
        system.debug('DOA:: '+ AnniversaryDate);
        if(birthDate != Null)
            sv.Birth_Date__c = birthDate;
        if(AnniversaryDate != Null)
            sv.Anniversary_Date__c = AnniversaryDate;
        if(mobile != Null && !String.isBlank(mobile)) {
            accList1 = [Select Id, Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, PersonContactId, DOB__c, Anniversary_Date__c,
                        Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                        Citizenship__c, Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c, Industry, Company_Name__c
                        from Account
                        where (PersonMobilePhone =: mobile OR Phone =: mobile) AND IsPersonAccount = true];
            system.debug('accList1: '+accList1);
            
            if(!accList1.isEmpty()) {
                isAccountFound = true;
                
                oppList1 = [Select Id, Name, SV_Date_Time__c, Site_Visit_Count__c, Presales_Manager__c, Project__c, Purchase_Timeframe__c, Configuration_Required__c, 
                            Possession_Timeline_Requirement__c, Budget__c, Buying_Purpose__c, Location__c,
                            Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Channel_Partner_Name__c, Reference_Name__c, Other_Source_Details__c  
                            from Opportunity
                            where AccountId =: accList1[0].Id AND Project__c =: pList[0].Id AND Is_Active__c = true];
                system.debug('oppList1: '+oppList1);
                
                if(!oppList1.isEmpty()) {
                    isOppFound = true;
                }
            } else {
                if(email != Null && !String.isBlank(email)) {
                    accList1 = [Select Id, Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, PersonContactId, DOB__c, Anniversary_Date__c,
                                Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                                Citizenship__c, Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c, Industry, Company_Name__c
                                from Account
                                where (PersonEmail =: email OR Alternate_Email__c =: email) AND IsPersonAccount = true];
                    system.debug('accList1: '+accList1);
                    
                    if(!accList1.isEmpty()) {
                        isAccountFound = true;
                        
                        oppList1 = [Select Id, Name, SV_Date_Time__c, Site_Visit_Count__c, Presales_Manager__c, Project__c, Purchase_Timeframe__c, Configuration_Required__c, 
                                    Possession_Timeline_Requirement__c, Budget__c, Buying_Purpose__c, Location__c,
                                    Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Channel_Partner_Name__c, Reference_Name__c, Other_Source_Details__c  
                                    from Opportunity
                                    where AccountId =: accList1[0].Id AND Project__c =: pList[0].Id AND Is_Active__c = true];
                        system.debug('oppList1: '+oppList1);
                        
                        if(!oppList1.isEmpty()) {
                            isOppFound = true;
                        }
                    }
                }
            }
            
            if(oppList1.isEmpty()) {
                leadList1 = [Select Id, Salutation, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email__c, DOB__c, Anniversary_Date__c,
                             Project__c, Purchase_Timeframe__c, Configuration_Required__c, Possession_Timeline_Requirement__c, Budget__c, Buying_Purpose__c, Location__c,
                             Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                             Citizenship__c, Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c, Industry, Company_Name__c,
                             Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Channel_Partner_Name__c, Reference_Name__c, Other_Source_Details__c, OwnerId,
                             Status, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c
                             from Lead
                             where (MobilePhone =: mobile OR Phone =: mobile) AND Project__c =: pList[0].Id AND isConverted = false AND Is_Active__c = true];
                system.debug('leadList1: '+leadList1);
                
                if(!leadList1.isEmpty()) {
                    isProjectLeadFound = true;
                } else {
                    if(email != Null && !String.isBlank(email)) {
                        leadList1 = [Select Id, Salutation, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email__c, DOB__c, Anniversary_Date__c,
                                     Project__c, Purchase_Timeframe__c, Configuration_Required__c, Possession_Timeline_Requirement__c, Budget__c, Buying_Purpose__c, Location__c,
                                     Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                                     Citizenship__c, Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c, Industry, Company_Name__c,
                                     Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Channel_Partner_Name__c, Reference_Name__c, Other_Source_Details__c, OwnerId,
                                     Status, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c
                                     from Lead
                                     where (Email =: email OR Alternate_Email__c =: email) AND Project__c =: pList[0].Id AND isConverted = false AND Is_Active__c = true];
                        system.debug('leadList1: '+leadList1);
                        
                        if(!leadList1.isEmpty()) {
                            isProjectLeadFound = true;
                        } 
                    } 
                }
            } 
            
            if(leadList1.isEmpty() && !isProjectLeadFound) {
                leadList2 = [Select Id, Salutation, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email__c, DOB__c, Anniversary_Date__c,
                             Project__c, Purchase_Timeframe__c, Configuration_Required__c, Possession_Timeline_Requirement__c, Budget__c, Buying_Purpose__c, Location__c,
                             Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                             Citizenship__c, Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c, Industry, Company_Name__c,
                             Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Channel_Partner_Name__c, Reference_Name__c, Other_Source_Details__c, OwnerId,
                             Status, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c
                             from Lead
                             where (MobilePhone =: mobile OR Phone =: mobile) AND Cluster__c =: clusterName AND isConverted = false AND Is_Active__c = true];
                system.debug('leadList2: '+leadList2);
                
                if(!leadList2.isEmpty()) {
                    isClusterLeadFound = true;
                } else {
                    if(email != Null && !String.isBlank(email)) {
                        leadList2 = [Select Id, Salutation, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email__c, DOB__c, Anniversary_Date__c,
                                     Project__c, Purchase_Timeframe__c, Configuration_Required__c, Possession_Timeline_Requirement__c, Budget__c, Buying_Purpose__c, Location__c,
                                     Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Highest_Education__c, Current_Residence_Configuration__c,
                                     Citizenship__c, Current_Residence_Status__c, Ethinicity__c, Household_Income_Annual__c, Industry, Company_Name__c,
                                     Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Channel_Partner_Name__c, Reference_Name__c, Other_Source_Details__c, OwnerId,
                                     Status, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c
                                     from Lead
                                     where (Email =: email OR Alternate_Email__c =: email) AND Cluster__c =: clusterName AND isConverted = false AND Is_Active__c = true];
                        system.debug('leadList2: '+leadList2);
                        
                        if(!leadList2.isEmpty()) {
                            isClusterLeadFound = true;
                        }
                    }
                }
            }
        }
        
        if(isAccountFound) {
            if(isOppFound && !isProjectLeadFound && !isClusterLeadFound) {
                try {
                    //Create Site Visit
                    sv.Opportunity__c = oppList1[0].Id;
                    sv.SV_Date_Time__c = system.now();
                    if(oppList1[0].Site_Visit_Count__c == Null || oppList1[0].Site_Visit_Count__c == 0) {
                        sv.SV_Count__c = 1;
                        if(oppList1[0].Master_Source__c != sv.Master_Source__c || oppList1[0].Lead_Source__c != sv.Lead_Source__c) {
                            sv.Is_Source_Conflict__c = 'Yes';
                            if(!tmList.isEmpty() && tmList != null)
                                sv.Approver_1__c = tmList[0].User__c;
                        }
                    } else
                        sv.SV_Count__c = oppList1[0].Site_Visit_Count__c + 1;
                    insert sv;
                    
                    //Update Opportunity
                    oppList1[0].Site_Visit_Count__c = oppList1[0].Site_Visit_Count__c + 1;
                    oppList1[0].SV_Date_Time__c = system.now();
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
            } else if(!isOppFound && isProjectLeadFound && !isClusterLeadFound) {
                try {
                    //Update Lead
                    leadList1[0].Status = 'Visit Done';
                    leadList1[0].Lead_Sub_Stage__c = 'Visit Done';
                    leadList1[0].Lead_Sub_Stage_Reason__c = '';
                    update leadList1[0];
                    
                    //Convert Lead & Tag to Existing Account
                    Database.LeadConvert lc = new database.LeadConvert();
                    lc.setLeadId(leadList1[0].Id);
                    lc.setAccountId(accList1[0].Id);
                    lc.setContactId(accList1[0].PersonContactId);
                    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    Lead convertedLead = [SELECT ConvertedAccountId, ConvertedOpportunityId from Lead where Id =: leadList1[0].Id];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    Opportunity convertedOpp =  [SELECT Id, Name, Site_Visit_Count__c, SV_Date_Time__c, Master_Source__c, Lead_Source__c from Opportunity where Id =: convertedLead.ConvertedOpportunityId];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                    if(convertedOpp.Master_Source__c != sv.Master_Source__c || convertedOpp.Lead_Source__c != sv.Lead_Source__c) {
                        sv.Is_Source_Conflict__c = 'Yes';
                        if(!tmList.isEmpty() && tmList != null)
                            sv.Approver_1__c = tmList[0].User__c;
                    }
                    //Tag Site Visit Against Opportunity
                    sv.Opportunity__c = convertedLead.ConvertedOpportunityId;
                    sv.SV_Date_Time__c = system.now();
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.SV_Date_Time__c = system.now();
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
            } else if(!isOppFound && !isProjectLeadFound && isClusterLeadFound) {
                try {
                    //Update Lead
                    leadList2[0].Status = 'Visit Done';
                    leadList2[0].Lead_Sub_Stage__c = 'Visit Done';
                    leadList2[0].Lead_Sub_Stage_Reason__c = '';
                    update leadList2[0];
                    
                    //Convert Lead & Tag to Existing Account
                    Database.LeadConvert lc = new database.LeadConvert();
                    lc.setLeadId(leadList2[0].Id);
                    lc.setAccountId(accList1[0].Id);
                    lc.setContactId(accList1[0].PersonContactId);
                    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    Lead convertedLead = [SELECT ConvertedAccountId, ConvertedOpportunityId from Lead where Id =: leadList2[0].Id];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    //Create New Opportunity with Project
                    Opportunity op = new Opportunity();
                    op.Name = sv.First_Name__c+' '+sv.Last_Name__c;
                    op.AccountId = convertedLead.ConvertedAccountId;
                    op.CloseDate = system.today().addDays(60);
                    op.Project__c = sv.Project__c;
                    op.StageName = 'In Follow-up';
                    op.Configuration_Required__c = sv.Configuration_Required__c;
                    op.Budget__c = sv.Budget__c;
                    op.Master_Source__c = sv.Master_Source__c;
                    op.Lead_Source__c = sv.Lead_Source__c;
                    op.Lead_Sub_Source__c = sv.Lead_Sub_Source__c;
                    op.Lead_Sub_Source_Details__c = sv.Lead_Sub_Source_Details__c;
                    
                    if(sv.Master_Source__c == 'Reference' && (sv.Lead_Source__c == 'Employees' || sv.Lead_Source__c == 'Customers')) {
                        op.Reference_Name__c = sv.Reference_Name__c;
                    } else if(sv.Master_Source__c == 'Other' && sv.Lead_Source__c == 'Other') {
                        op.Other_Source_Details__c = sv.Other_Source_Details__c;
                    } else if(sv.Master_Source__c == 'Channel Partner' && sv.Lead_Source__c == 'Channel Partner') {
                        op.Channel_Partner_Name__c = sv.Channel_Partner_Name__c;
                    }
                    op.Site_Visit_Count__c = 1;
                    op.SV_Date_Time__c = system.now();
                    insert op;
                    
                    //Tag Site Visit Against Opportunity
                    sv.Opportunity__c = op.Id;
                    sv.SV_Date_Time__c = system.now();
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    List<Site_Visit__c> lstSV = [Select Id, Name from Site_Visit__c where Id =: sv.Id];
                    isSuccess = true;
                    message = 'Thank You! Site visit number is '+ lstSV[0].Name;
                    system.debug('Success Message: '+message);
                } catch(Exception ex) {
                    system.debug('Error: '+ex);
                    isRunError = true;
                   	message = 'Error ' +ex.getMessage();  
                }
            } else if(!isOppFound && !isProjectLeadFound && !isClusterLeadFound) {
                try {
                	Opportunity op = new Opportunity();
                    op.Name = sv.First_Name__c+' '+sv.Last_Name__c;
                    op.AccountId = accList1[0].Id;
                    op.CloseDate = system.today().addDays(60);
                    op.Project__c = sv.Project__c;
                    op.StageName = 'In Follow-up';
                    op.Configuration_Required__c = sv.Configuration_Required__c;
                    op.Budget__c = sv.Budget__c;
                    op.Master_Source__c = sv.Master_Source__c;
                    op.Lead_Source__c = sv.Lead_Source__c;
                    op.Lead_Sub_Source__c = sv.Lead_Sub_Source__c;
                    op.Lead_Sub_Source_Details__c = sv.Lead_Sub_Source_Details__c;
                    
                    if(sv.Master_Source__c == 'Reference' && (sv.Lead_Source__c == 'Employees' || sv.Lead_Source__c == 'Customers')) {
                        op.Reference_Name__c = sv.Reference_Name__c;
                    } else if(sv.Master_Source__c == 'Other' && sv.Lead_Source__c == 'Other') {
                        op.Other_Source_Details__c = sv.Other_Source_Details__c;
                    } else if(sv.Master_Source__c == 'Channel Partner' && sv.Lead_Source__c == 'Channel Partner') {
                        op.Channel_Partner_Name__c = sv.Channel_Partner_Name__c;
                    }
                    op.Site_Visit_Count__c = 1;
                    op.SV_Date_Time__c = system.now();
                    insert op;
                    
                    //Tag Site Visit Against Opportunity
                    sv.Opportunity__c = op.Id;
                    sv.SV_Date_Time__c = system.now();
                    sv.SV_Count__c = 1;
                    insert sv;
                    
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
        } else {
            if(isProjectLeadFound && !isClusterLeadFound) {
                try {
                    //Update Lead
                    leadList1[0].Status = 'Visit Done';
                    leadList1[0].Lead_Sub_Stage__c = 'Visit Done';
                    leadList1[0].Lead_Sub_Stage_Reason__c = '';
                    update leadList1[0];
                    
                    //Convert Lead
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.setLeadId(leadList1[0].id);
                    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus where IsConverted = true LIMIT 1];
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    Lead convertedLead = [SELECT ConvertedAccountId, ConvertedOpportunityId from Lead where Id =: leadList1[0].Id];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    Opportunity convertedOpp =  [SELECT Id, Name, Site_Visit_Count__c, SV_Date_Time__c, Master_Source__c, Lead_Source__c from Opportunity where Id =: convertedLead.ConvertedOpportunityId];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                    if(convertedOpp.Master_Source__c != sv.Master_Source__c || convertedOpp.Lead_Source__c != sv.Lead_Source__c) {
                        sv.Is_Source_Conflict__c = 'Yes';
                        if(!tmList.isEmpty() && tmList != null)
                            sv.Approver_1__c = tmList[0].User__c;
                    }
                    //Tag Site Visit Against Opportunity
                    sv.Opportunity__c = convertedOpp.Id;
                    sv.SV_Date_Time__c = system.now();
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.SV_Date_Time__c = system.now();
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
            } else if(!isProjectLeadFound && isClusterLeadFound) {
                try {
                    //Update Lead
                    leadList2[0].Status = 'Visit Done';
                    leadList2[0].Lead_Sub_Stage__c = 'Visit Done';
                    leadList2[0].Lead_Sub_Stage_Reason__c = '';
                    update leadList2[0];
                    
                    //Convert Lead & Tag to Existing Account
                    Database.LeadConvert lc = new database.LeadConvert();
                    lc.setLeadId(leadList2[0].Id);
                    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    Lead convertedLead = [SELECT ConvertedAccountId, ConvertedOpportunityId from Lead where Id =: leadList2[0].Id];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    //Create New Opportunity with Project
                    Opportunity op = new Opportunity();
                    op.Name = sv.First_Name__c+' '+sv.Last_Name__c;
                    op.AccountId = convertedLead.ConvertedAccountId;
                    op.CloseDate = system.today().addDays(60);
                    op.Project__c = sv.Project__c;
                    op.StageName = 'In Follow-up';
                    op.Configuration_Required__c = sv.Configuration_Required__c;
                    op.Budget__c = sv.Budget__c;
                    op.Master_Source__c = sv.Master_Source__c;
                    op.Lead_Source__c = sv.Lead_Source__c;
                    op.Lead_Sub_Source__c = sv.Lead_Sub_Source__c;
                    op.Lead_Sub_Source_Details__c = sv.Lead_Sub_Source_Details__c;
                    
                    if(sv.Master_Source__c == 'Reference' && (sv.Lead_Source__c == 'Employees' || sv.Lead_Source__c == 'Customers')) {
                        op.Reference_Name__c = sv.Reference_Name__c;
                    } else if(sv.Master_Source__c == 'Other' && sv.Lead_Source__c == 'Other') {
                        op.Other_Source_Details__c = sv.Other_Source_Details__c;
                    } else if(sv.Master_Source__c == 'Channel Partner' && sv.Lead_Source__c == 'Channel Partner') {
                        op.Channel_Partner_Name__c = sv.Channel_Partner_Name__c;
                    }
                    op.Site_Visit_Count__c = 1;
                    op.SV_Date_Time__c = system.now();
                    insert op;
                    
                    //Tag Site Visit Against Opportunity
                    sv.Opportunity__c = op.Id;
                    sv.SV_Date_Time__c = system.now();
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    List<Site_Visit__c> lstSV = [Select Id, Name from Site_Visit__c where Id =: sv.Id];
                    isSuccess = true;
                    message = 'Thank You! Site visit number is '+ lstSV[0].Name;
                    system.debug('Success Message: '+message);
                } catch(Exception ex) {
                    system.debug('Error: '+ex);
                    isRunError = true;
                   	message = 'Error ' +ex.getMessage();  
                }
            } else if(!isProjectLeadFound && !isClusterLeadFound) {
                Lead l = new Lead();
                l.Salutation = sv.Salutation__c;
                l.FirstName = sv.First_Name__c;
                l.LastName = sv.Last_Name__c;
                l.MobilePhone = sv.Mobile__c;
                l.Email = sv.Email__c;
                l.Project__c = pList[0].Id;
                l.DOB__c = sv.Birth_Date__c;
                l.Anniversary_Date__c = sv.Anniversary_Date__c;
                l.Age_Group__c = sv.Age_Group__c;
                l.Company_Name__c = sv.Company_Name__c;
                l.Occupation__c = sv.Occupation__c;
                l.Designation__c = sv.Designation__c;
                l.Configuration_Required__c = sv.Configuration_Required__c;
                l.Budget__c = sv.Budget__c;
                l.Household_Income_Annual__c = sv.Household_Income_Annual__c;
                l.Master_Source__c = sv.Master_Source__c;
                l.Lead_Source__c = sv.Lead_Source__c;
                l.Lead_Sub_Source__c = sv.Lead_Sub_Source__c;
                l.Lead_Sub_Source_Details__c = sv.Lead_Sub_Source_Details__c;
                
                if(sv.Master_Source__c == 'Reference' && (sv.Lead_Source__c == 'Employees' || sv.Lead_Source__c == 'Customers')) {
                    l.Reference_Name__c = sv.Reference_Name__c;
                } else if(sv.Master_Source__c == 'Other' && sv.Lead_Source__c == 'Other') {
                    l.Other_Source_Details__c = sv.Other_Source_Details__c;
                } else if(sv.Master_Source__c == 'Channel Partner' && sv.Lead_Source__c == 'Channel Partner') {
                    l.Channel_Partner_Name__c = sv.Channel_Partner_Name__c;
                } 
                l.Status = 'Visit Done';
                l.Lead_Sub_Stage__c = 'Visit Done';
                l.Lead_Sub_Stage_Reason__c = '';
                
                try {
                    Database.DMLOptions dml = new Database.DMLOptions();
                    dml.DuplicateRuleHeader.AllowSave = true;
                    Database.SaveResult sr = Database.insert(l, dml);
                    
                    // Converting Lead to Account & Opportunity
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.setLeadId(sr.getId());
                    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus where IsConverted = true LIMIT 1];
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    Lead convertedLead = [SELECT ConvertedAccountId, ConvertedOpportunityId from Lead where Id = :l.id];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    Opportunity convertedOpp =  [SELECT Id, Name, Site_Visit_Count__c, SV_Date_Time__c from Opportunity 
                                                 where Id =: convertedLead.ConvertedOpportunityId];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                    //Tag Site Visit Against Converted Opportunity
                    sv.Opportunity__c = convertedOpp.Id;
                    sv.SV_Date_Time__c = system.now();
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.SV_Date_Time__c = system.now();
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
    
    public Pagereference closeForm() {
        Pagereference pg = new Pagereference('/'+sv.id);
        pg.setredirect(true);
        return pg;
    }
}