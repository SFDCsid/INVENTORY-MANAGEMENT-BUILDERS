//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class SiteVisitFormController {
    public List<Account> accList1 {get;set;}
    public List<Opportunity__c> oppList1 {get;set;}
    public List<Lead__c> leadList1 {get;set;}
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
    public boolean isSourceNotEditable {get;set;}
    
    public SiteVisitFormController() {
        accList1 = new List<Account>();
        oppList1 = new List<Opportunity__c>();
        leadList1 = new List<Lead__c>();
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
        isSourceNotEditable = false;
        
        project = ApexPages.currentPage().getParameters().get('project'); 
        mobile = ApexPages.currentPage().getParameters().get('mobile');
        email = ApexPages.currentPage().getParameters().get('email');
        system.debug('project: '+project+ ' mobile: '+mobile+ ' email: '+email);
        
        if(project != Null && !String.isBlank(project)) {
            pList = [Select Id, Name from Project__c where Id =: project];
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
        List<Opportunity__c> oppList = new List<Opportunity__c>();
        List<Lead__c> leadList = new List<Lead__c>();
        List<Site_Visit__c> svList = new List<Site_Visit__c>();
        
        if(mobile != Null && !String.isBlank(mobile)) {
            accList = [Select Id, Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, 
                       Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Ethinicity__c, Current_Residence_Configuration__c,
                       Highest_Education__c, Current_Residence_Status__c, Industry, Household_Income_Annual__c, Citizenship__c, Company_Name__c,
                       House_No__c, Locality__c, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode
                       from Account
                       where (PersonMobilePhone =: mobile OR Phone =: mobile) AND IsPersonAccount = true];
            system.debug('accList: '+accList);
            
            if(!accList.isEmpty()) {
                isAccount = true;
                
                oppList = [Select Id, Name, Project__c, Purchase_Timeframe__c, Project_Type__c, Possession_Timeframe_Required__c, 
                           Buying_Purpose__c, Configuration_Required__c, Budget__c,
                           Media__c, Channel_Partner__c, Referrer_Name__c, Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,
                           Channel_Partner__r.Name, Channel_Partner__r.Mobile__c,
                           Last_SV_Date__c, Site_Visit_Count__c, Presales_Manager__c
                           from Opportunity__c
                           where AccountId__c =: accList[0].Id AND Project__c =: pList[0].Id AND IsActive__c = true];
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
                    accList = [Select Id, Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, 
                               Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Ethinicity__c, Current_Residence_Configuration__c,
                               Highest_Education__c, Current_Residence_Status__c, Industry, Household_Income_Annual__c, Citizenship__c, Company_Name__c,
                               House_No__c, Locality__c, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode
                               from Account
                               where (PersonEmail =: email OR Alternate_Email__c =: email) AND IsPersonAccount = true];
                    system.debug('accList: '+accList);
                    
                    if(!accList.isEmpty()) {
                        
                        system.debug('accountlist' +accList);
                        isAccount = true;
                        
                        oppList = [Select Id, Name, Project__c, Purchase_Timeframe__c, Project_Type__c, Possession_Timeframe_Required__c, 
                                   Buying_Purpose__c, Configuration_Required__c, Budget__c,
                                   Media__c, Channel_Partner__c, Referrer_Name__c, Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,
                                   Channel_Partner__r.Name, Channel_Partner__r.Mobile__c,
                                   Last_SV_Date__c, Site_Visit_Count__c, Presales_Manager__c
                                   from Opportunity__c
                                   where AccountId__c =: accList[0].Id AND Project__c =: pList[0].Id AND IsActive__c = true];
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
                leadList = [Select Id, Salutation__c, First_Name__c, Last_Name__c, MobilePhone__c, Phone__c, Email__c, Alternate_Email__c,
                            Project__c, Purchase_Timeframe__c, Project_Type__c, Possession_Timeframe_Required__c,
                            Buying_Purpose__c, Configuration_Required__c, Budget__c, 
                            Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c,
                            Ethinicity__c, Current_Residence_Configuration__c, Highest_Education__c, Current_Residence_Status__c,
                            Industry__c, Household_Income_Annual__c, Citizenship__c, Company_Name__c,
                            House_No__c, Street__c, Locality__c, City__c, State__c, Country__c, PostalCode__c,
                            Media__c, Channel_Partner__c, Referrer_Name__c, Channel_Partner__r.Name, Channel_Partner__r.Mobile__c,
                            Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,
                            OwnerId, Status__c, Lead_Sub_Stage__c
                            from Lead__c
                            where (MobilePhone__c =: mobile OR Phone__c =: mobile) AND Project__c =: pList[0].Id AND isConverted__c = false];
                system.debug('leadList: '+leadList);
                
                if(!leadList.isEmpty()) {
                    isLead = true;
                } else {
                    if(email != Null && !String.isBlank(email)) {
                        leadList = [Select Id, Salutation__c, First_Name__c, Last_Name__c, MobilePhone__c, Phone__c, Email__c, Alternate_Email__c,
                                    Project__c, Purchase_Timeframe__c, Project_Type__c, Possession_Timeframe_Required__c,
                                    Buying_Purpose__c, Configuration_Required__c, Budget__c, 
                                    Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c,
                                    Ethinicity__c, Current_Residence_Configuration__c, Highest_Education__c, Current_Residence_Status__c,
                                    Industry__c, Household_Income_Annual__c, Citizenship__c, Company_Name__c,
                                    House_No__c, Street__c, Locality__c, City__c, State__c, Country__c, PostalCode__c,
                                    Media__c, Channel_Partner__c, Referrer_Name__c, Channel_Partner__r.Name, Channel_Partner__r.Mobile__c,
                                    Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,
                                    OwnerId, Status__c, Lead_Sub_Stage__c
                                    from Lead__c
                                    where (Email__c =: email OR Alternate_Email__c =: email) AND Project__c =: pList[0].Id AND isConverted__c = false];
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
            if(accList[0].Ethinicity__c != '' && accList[0].Ethinicity__c != null)
                sv.Ethinicity__c = accList[0].Ethinicity__c;
            if(accList[0].Current_Residence_Configuration__c != '' && accList[0].Current_Residence_Configuration__c != null)
                sv.Current_Residence_Configuration__c = accList[0].Current_Residence_Configuration__c;
            if(accList[0].Highest_Education__c != '' && accList[0].Highest_Education__c != null)
                sv.Highest_Education__c = accList[0].Highest_Education__c;
            if(accList[0].Current_Residence_Status__c != '' && accList[0].Current_Residence_Status__c != null)
                sv.Current_Residence_Status__c = accList[0].Current_Residence_Status__c;
            if(accList[0].Industry != '' && accList[0].Industry != null)
                sv.Industry__c = accList[0].Industry;
            if(accList[0].Household_Income_Annual__c != '' && accList[0].Household_Income_Annual__c != null)
                sv.Household_Income_Annual__c = accList[0].Household_Income_Annual__c;
            if(accList[0].Citizenship__c != '' && accList[0].Citizenship__c != null)
                sv.Citizenship__c = accList[0].Citizenship__c;
            if(accList[0].Company_Name__c != '' && accList[0].Company_Name__c != null)
                sv.Company_Name__c = accList[0].Company_Name__c;
            if(accList[0].House_No__c != '' && accList[0].House_No__c != null)
                sv.House_No__c = accList[0].House_No__c;
            if(accList[0].BillingStreet != '' && accList[0].BillingStreet != null)
                sv.Street_1__c = accList[0].BillingStreet;
            if(accList[0].Locality__c != '' && accList[0].Locality__c != null)
                sv.Locality__c = accList[0].Locality__c;
            if(accList[0].BillingCity != '' && accList[0].BillingCity != null)
                sv.City__c = accList[0].BillingCity;
            if(accList[0].BillingState != '' && accList[0].BillingState != null)
                sv.State__c = accList[0].BillingState;
            if(accList[0].BillingCountry != '' && accList[0].BillingCountry != null)
                sv.Country__c = accList[0].BillingCountry;
            if(accList[0].BillingPostalCode != '' && accList[0].BillingPostalCode != null)
                sv.Pincode__c = accList[0].BillingPostalCode;
            if(isOpp) {
                if(oppList[0].Purchase_Timeframe__c != '' && oppList[0].Purchase_Timeframe__c != null)
                    sv.Purchase_Timeframe__c = oppList[0].Purchase_Timeframe__c;
                if(oppList[0].Project_Type__c != '' && oppList[0].Project_Type__c != null)
                    sv.Project_Type__c = oppList[0].Project_Type__c;
                if(oppList[0].Possession_Timeframe_Required__c != '' && oppList[0].Possession_Timeframe_Required__c != null)
                    sv.Possession_Timeframe_Required__c = oppList[0].Possession_Timeframe_Required__c;
                if(oppList[0].Buying_Purpose__c != '' && oppList[0].Buying_Purpose__c != null)
                    sv.Buying_Purpose__c = oppList[0].Buying_Purpose__c;
                if(oppList[0].Configuration_Required__c != '' && oppList[0].Configuration_Required__c != null)
                    sv.Configuration_Required__c = oppList[0].Configuration_Required__c;
                if(oppList[0].Budget__c != '' && oppList[0].Budget__c != null)
                    sv.Budget__c = oppList[0].Budget__c;
                if(oppList[0].Media__c != '' && oppList[0].Media__c != null)
                    sv.Media__c = oppList[0].Media__c;
                if(oppList[0].Channel_Partner__c != null) {
                    sv.Channel_Partner__c = oppList[0].Channel_Partner__c;
                    cpName = oppList[0].Channel_Partner__r.Name +'-'+oppList[0].Channel_Partner__r.Mobile__c;
                }
                if(oppList[0].Referrer_Name__c != null) {
                    sv.Referrer_Name__c = oppList[0].Referrer_Name__c;
                    refName = oppList[0].Referrer_Name__r.Name +'-'+oppList[0].Referrer_Name__r.PersonMobilePhone;
                }
                if(oppList[0].Presales_Manager__c != null) {
                    sv.Presales_Manager__c = oppList[0].Presales_Manager__c;
                    sv.Sourcing_Manager__c = oppList[0].Presales_Manager__c;    
                }
            } else if(isLead) {
                if(leadList[0].Purchase_Timeframe__c != '' && leadList[0].Purchase_Timeframe__c != null)
                    sv.Purchase_Timeframe__c = leadList[0].Purchase_Timeframe__c;
                if(leadList[0].Project_Type__c != '' && leadList[0].Project_Type__c != null)
                    sv.Project_Type__c = leadList[0].Project_Type__c;
                if(leadList[0].Possession_Timeframe_Required__c != '' && leadList[0].Possession_Timeframe_Required__c != null)
                    sv.Possession_Timeframe_Required__c = leadList[0].Possession_Timeframe_Required__c;
                if(leadList[0].Buying_Purpose__c != '' && leadList[0].Buying_Purpose__c != null)
                    sv.Buying_Purpose__c = leadList[0].Buying_Purpose__c;
                if(leadList[0].Configuration_Required__c != '' && leadList[0].Configuration_Required__c != null)
                    sv.Configuration_Required__c = leadList[0].Configuration_Required__c;
                if(leadList[0].Budget__c != '' && leadList[0].Budget__c != null)
                    sv.Budget__c = leadList[0].Budget__c;
                if(leadList[0].Media__c != '' && leadList[0].Media__c != Null)
                    sv.Media__c = leadList[0].Media__c;
                if(leadList[0].Channel_Partner__c != null) {
                    sv.Channel_Partner__c = leadList[0].Channel_Partner__c;
                    cpName = leadList[0].Channel_Partner__r.Name +'-'+leadList[0].Channel_Partner__r.Mobile__c;
                }
                if(leadList[0].Referrer_Name__c != null) {
                    sv.Referrer_Name__c = leadList[0].Referrer_Name__c;
                    refName = leadList[0].Referrer_Name__r.Name +'-'+leadList[0].Referrer_Name__r.PersonMobilePhone;
                }
                if(leadList[0].OwnerId != null) {
                    sv.Presales_Manager__c = leadList[0].OwnerId;
                    sv.Sourcing_Manager__c = leadList[0].OwnerId;
                }
            }
        } else if(isLead) {
            if(leadList[0].Salutation__c != '' && leadList[0].Salutation__c != Null)
                sv.Salutation__c = leadList[0].Salutation__c;
            if(leadList[0].First_Name__c != '' && leadList[0].First_Name__c != Null)
                sv.First_Name__c = leadList[0].First_Name__c;
            if(leadList[0].Last_Name__c != '' && leadList[0].Last_Name__c != Null)
                sv.Last_Name__c = leadList[0].Last_Name__c;
            if(sv.Email__c == null && leadList[0].Email__c != '' && leadList[0].Email__c != null)
                sv.Email__c = leadList[0].Email__c;
            if(leadList[0].Purchase_Timeframe__c != '' && leadList[0].Purchase_Timeframe__c != null)
                sv.Purchase_Timeframe__c = leadList[0].Purchase_Timeframe__c;
            if(leadList[0].Project_Type__c != '' && leadList[0].Project_Type__c != null)
                sv.Project_Type__c = leadList[0].Project_Type__c;
            if(leadList[0].Possession_Timeframe_Required__c != '' && leadList[0].Possession_Timeframe_Required__c != null)
                sv.Possession_Timeframe_Required__c = leadList[0].Possession_Timeframe_Required__c;
            if(leadList[0].Buying_Purpose__c != '' && leadList[0].Buying_Purpose__c != null)
                sv.Buying_Purpose__c = leadList[0].Buying_Purpose__c;
            if(leadList[0].Configuration_Required__c != '' && leadList[0].Configuration_Required__c != null)
                sv.Configuration_Required__c = leadList[0].Configuration_Required__c;
            if(leadList[0].Budget__c != '' && leadList[0].Budget__c != null)
                sv.Budget__c = leadList[0].Budget__c;
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
            if(leadList[0].Ethinicity__c != '' && leadList[0].Ethinicity__c != null)
                sv.Ethinicity__c = leadList[0].Ethinicity__c;
            if(leadList[0].Current_Residence_Configuration__c != '' && leadList[0].Current_Residence_Configuration__c != null)
                sv.Current_Residence_Configuration__c = leadList[0].Current_Residence_Configuration__c;
            if(leadList[0].Highest_Education__c != '' && leadList[0].Highest_Education__c != null)
                sv.Highest_Education__c = leadList[0].Highest_Education__c;
            if(leadList[0].Current_Residence_Status__c != '' && leadList[0].Current_Residence_Status__c != null)
                sv.Current_Residence_Status__c = leadList[0].Current_Residence_Status__c;
            if(leadList[0].Industry__c != '' && leadList[0].Industry__c != null)
                sv.Industry__c = leadList[0].Industry__c;
            if(leadList[0].Household_Income_Annual__c != '' && leadList[0].Household_Income_Annual__c != null)
                sv.Household_Income_Annual__c = leadList[0].Household_Income_Annual__c;
            if(leadList[0].Citizenship__c != '' && leadList[0].Citizenship__c != null)
                sv.Citizenship__c = leadList[0].Citizenship__c;
            if(leadList[0].Company_Name__c != '' && leadList[0].Company_Name__c != null)
                sv.Company_Name__c = leadList[0].Company_Name__c;
            if(leadList[0].House_No__c != '' && leadList[0].House_No__c != null)
                sv.House_No__c = leadList[0].House_No__c;
            if(leadList[0].Street__c != '' && leadList[0].Street__c != null)
                sv.Street_1__c = leadList[0].Street__c;
            if(leadList[0].Locality__c != '' && leadList[0].Locality__c != null)
                sv.Locality__c = leadList[0].Locality__c;
            if(leadList[0].City__c != '' && leadList[0].City__c != null)
                sv.City__c = leadList[0].City__c;
            if(leadList[0].State__c != '' && leadList[0].State__c != null)
                sv.State__c = leadList[0].State__c;
            if(leadList[0].Country__c != '' && leadList[0].Country__c != null)
                sv.Country__c = leadList[0].Country__c;
            if(leadList[0].PostalCode__c != '' && leadList[0].PostalCode__c != null)
                sv.Pincode__c = leadList[0].PostalCode__c;
            if(leadList[0].Media__c != '' && leadList[0].Media__c != Null)
                sv.Media__c = leadList[0].Media__c;
            if(leadList[0].Channel_Partner__c != null) {
                sv.Channel_Partner__c = leadList[0].Channel_Partner__c;
                cpName = leadList[0].Channel_Partner__r.Name +'-'+leadList[0].Channel_Partner__r.Mobile__c;    
            }
            if(leadList[0].Referrer_Name__c != null) {
                sv.Referrer_Name__c = leadList[0].Referrer_Name__c;
                refName = leadList[0].Referrer_Name__r.Name +'-'+leadList[0].Referrer_Name__r.PersonMobilePhone;
            }
            if(leadList[0].OwnerId != null) {
                sv.Presales_Manager__c = leadList[0].OwnerId;
                sv.Sourcing_Manager__c = leadList[0].OwnerId;    
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
          if(String.isBlank(sv.Salutation__c)) {
                valError = True;
                message = 'Please fill Salutation.'; 
            }
        }
        
        if(Integer.valueOf(p) == 1) {
            
            if(String.isBlank(sv.Locality__c)) {
                valError = True;
                message = 'Please Enter Locality.'; 
            }
        if(String.isBlank(sv.City__c)) {
                valError = True;
                message = 'Please Enter City.'; 
            }
        }
            /*if(sv.Pincode__c == null) {
                valError = True;
                message = 'Please fill Pincode.';
            } else {
                if(sv.Pincode__c.length() != 6) {
                    valError = True;
                    message = 'Please enter valid Pincode.';
                }
            }
        }*/
        
        
        if(Integer.valueOf(p) == 2) {
            if(String.isBlank(sv.Media__c)) {
                valError = True;
                message = 'Please fill where did you hear about us?';
            } else if(sv.Media__c == 'Channel Partner') {          
                if(String.isBlank(cpName)) {
                    valError = True;
                    message = 'Please fill Channel Partner.';
                } 
            } else if(sv.Media__c == 'Reference') {
               if(String.isBlank(refName)) {
                    valError = True;
                    message = 'Please fill Customer Referrer Name.';
                } 
            }
        }
            
        if(Integer.valueOf(p) == 3) {
            if(String.isBlank(sv.Budget__c)) {
                valError = True;
                message = 'Please state the budget for purchasing a house?';
            }
            if(String.isBlank(sv.Configuration_Required__c)) {
                valError = True;
                message = 'Please state the configuration you are interested in ?';
            }
        }
        return null;
    }
    
    public void submit() {
        isAccountFound = false;
        isLeadFound = false;
        isOppFound = false;
        
        if(String.isNotBlank(cpName) && cpName != '') {
          	List<Channel_Partner__c> cpList = new List<Channel_Partner__c>();
            String[] tokens = cpName.split('-');
            Integer tokenCount = tokens.size();
            for (Integer j = 0; j < tokenCount; j++) {
                System.debug('tokens-'+j+': '+tokens[j]);
            }
            cpList = [Select Id, Name, Mobile__c, OwnerId from Channel_Partner__c where Name =: tokens[0] AND Mobile__c =: tokens[1]];
            system.debug('cpList: '+cpList);
            
            if(!cpList.isEmpty() && cpList != null) {
                sv.Channel_Partner__c = cpList[0].Id;
                sv.Sourcing_Manager__c = cpList[0].OwnerId;
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
            accList1 = [Select Id, Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, 
                       	Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Ethinicity__c, Current_Residence_Configuration__c,
                       	Highest_Education__c, Current_Residence_Status__c, Industry, Household_Income_Annual__c, Citizenship__c, Company_Name__c,
                       	House_No__c, Locality__c, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode
                       	from Account
                        where (PersonMobilePhone =: mobile OR Phone =: mobile) AND IsPersonAccount = true];
            system.debug('accList1: '+accList1);
            
            if(!accList1.isEmpty()) {
                isAccountFound = true;
                
                oppList1 = [Select Id, Name, Project__c, Purchase_Timeframe__c, Project_Type__c, Possession_Timeframe_Required__c, 
                            Buying_Purpose__c, Configuration_Required__c, Budget__c,
                            Media__c, Channel_Partner__c, Referrer_Name__c, Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,
                            Channel_Partner__r.Name, Channel_Partner__r.Mobile__c,
                            Last_SV_Date__c, Site_Visit_Count__c, Presales_Manager__c
                            from Opportunity__c
                            where AccountId__c =: accList1[0].Id AND Project__c =: pList[0].Id AND IsActive__c = true];
                system.debug('oppList1: '+oppList1);
                
                if(!oppList1.isEmpty()) {
                    isOppFound = true;
                }
            } else {
                if(email != Null && !String.isBlank(email)) {
                    accList1 = [Select Id, Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, 
                                Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c, Ethinicity__c, Current_Residence_Configuration__c,
                                Highest_Education__c, Current_Residence_Status__c, Industry, Household_Income_Annual__c, Citizenship__c, Company_Name__c,
                                House_No__c, Locality__c, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode
                                from Account
                                where (PersonEmail =: email OR Alternate_Email__c =: email) AND IsPersonAccount = true];
                    system.debug('accList1: '+accList1);
                    
                    if(!accList1.isEmpty()) {
                        isAccountFound = true;
                        
                        oppList1 = [Select Id, Name, Project__c, Purchase_Timeframe__c, Project_Type__c, Possession_Timeframe_Required__c, 
                                    Buying_Purpose__c, Configuration_Required__c, Budget__c,
                                    Media__c, Channel_Partner__c, Referrer_Name__c, Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,
                                    Channel_Partner__r.Name, Channel_Partner__r.Mobile__c,
                                    Last_SV_Date__c, Site_Visit_Count__c, Presales_Manager__c
                                    from Opportunity__c
                                    where AccountId__c =: accList1[0].Id AND Project__c =: pList[0].Id AND IsActive__c = true];
                        system.debug('oppList1: '+oppList1);
                        
                        if(!oppList1.isEmpty()) {
                            isOppFound = true;
                        }
                    }
                }
            }
            
            if(oppList1.isEmpty()) {
                leadList1 = [Select Id, Salutation__c, First_Name__c, Last_Name__c, MobilePhone__c, Phone__c, Email__c, Alternate_Email__c,
                             Project__c, Purchase_Timeframe__c, Project_Type__c, Possession_Timeframe_Required__c,
                             Buying_Purpose__c, Configuration_Required__c, Budget__c, 
                             Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c,
                             Ethinicity__c, Current_Residence_Configuration__c, Highest_Education__c, Current_Residence_Status__c,
                             Industry__c, Household_Income_Annual__c, Citizenship__c, Company_Name__c,
                             House_No__c, Street__c, Locality__c, City__c, State__c, Country__c, PostalCode__c,
                             Media__c, Channel_Partner__c, Referrer_Name__c, Channel_Partner__r.Name, Channel_Partner__r.Mobile__c,
                             Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,
                             OwnerId, Status__c, Lead_Sub_Stage__c, Address__c, Campaign_Custom__c, Campaign_Code__c, Campaign_Type__c,
                             Last_Presale_Call_Date__c, Last_Presale_Call_Comment__c, Presales_Comment_History__c, Last_Presales_Call_Status__c,
                             Presale_Next_Follow_up_Date__c, Presale_Date_of_Visit__c, Presales_Call_Count__c, Lead_Created_From__c,
                             UTM_Medium__c, UTM_Source__c
                             from Lead__c
                             where (MobilePhone__c =: mobile OR Phone__c =: mobile) AND Project__c =: pList[0].Id AND isConverted__c = false];
                system.debug('leadList1: '+leadList1);
                
                if(!leadList1.isEmpty()) {
                    isLeadFound = true;
                } else {
                    if(email != Null && !String.isBlank(email)) {
                        leadList1 = [Select Id, Salutation__c, First_Name__c, Last_Name__c, MobilePhone__c, Phone__c, Email__c, Alternate_Email__c,
                                     Project__c, Purchase_Timeframe__c, Project_Type__c, Possession_Timeframe_Required__c,
                                     Buying_Purpose__c, Configuration_Required__c, Budget__c, 
                                     Age_Group__c, Gender__c, Designation__c, Marital_Status__c, Occupation__c, Family_Size__c,
                                     Ethinicity__c, Current_Residence_Configuration__c, Highest_Education__c, Current_Residence_Status__c,
                                     Industry__c, Household_Income_Annual__c, Citizenship__c, Company_Name__c,
                                     House_No__c, Street__c, Locality__c, City__c, State__c, Country__c, PostalCode__c,
                                     Media__c, Channel_Partner__c, Referrer_Name__c, Channel_Partner__r.Name, Channel_Partner__r.Mobile__c,
                                     Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,
                                     OwnerId, Status__c, Lead_Sub_Stage__c, Address__c, Campaign_Custom__c, Campaign_Code__c, Campaign_Type__c,
                                     Last_Presale_Call_Date__c, Last_Presale_Call_Comment__c, Presales_Comment_History__c, Last_Presales_Call_Status__c,
                                     Presale_Next_Follow_up_Date__c, Presale_Date_of_Visit__c, Presales_Call_Count__c, Lead_Created_From__c,
                                     UTM_Medium__c, UTM_Source__c
                                     from Lead__c
                                     where (Email__c =: email OR Alternate_Email__c =: email) AND Project__c =: pList[0].Id AND isConverted__c = false];
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
                    sv.Opportunity__c = oppList1[0].Id;
                    sv.SV_Date_Time__c = system.now();
                    if(oppList1[0].Site_Visit_Count__c == Null || oppList1[0].Site_Visit_Count__c == 0) {
                        sv.SV_Count__c = 1;
                        if(oppList1[0].Media__c != sv.Media__c) {
                            sv.Is_Source_Conflict__c = 'Yes';
                        }
                    } else {
                        sv.SV_Count__c = oppList1[0].Site_Visit_Count__c + 1;
                    }
                    insert sv;
                    
                    //Update Opportunity
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
                try {
                    //Update Lead
                    leadList1[0].Salutation__c = sv.Salutation__c;
                    leadList1[0].First_Name__c = sv.First_Name__c;
                    leadList1[0].Last_Name__c = sv.Last_Name__c;
                    leadList1[0].Status__c = 'Site Visit Conducted';
                    update leadList1[0];
                    
                    //Convert Lead & Tag to Existing Account
                    List<Lead__c> lList = new List<Lead__c>();
                    lList.add(leadList1[0]);
                    LeadConversionServices.convertLead(lList);
                    
                    Lead__c convertedLead = [Select ConvertedAccountId__c, ConvertedOpportunityId__c from Lead__c where Id =: leadList1[0].Id AND IsConverted__c = true];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    Opportunity__c convertedOpp =  [SELECT Id, Name, Site_Visit_Count__c, Media__c from Opportunity__c where Id =: convertedLead.ConvertedOpportunityId__c];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                    if(convertedOpp.Media__c != sv.Media__c) {
                        sv.Is_Source_Conflict__c = 'Yes';
                    }
                    //Tag Site Visit Against Opportunity
                    sv.Opportunity__c = convertedLead.ConvertedOpportunityId__c;
                    sv.SV_Date_Time__c = system.now();
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.Last_SV_Date__c = system.now();
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
            } else if(!isOppFound && !isLeadFound) {
                Lead__c l = new Lead__c();
                l.Salutation__c = sv.Salutation__c;
                l.First_Name__c = sv.First_Name__c;
                l.Last_Name__c = sv.Last_Name__c;
                l.MobilePhone__c = sv.Mobile__c;
                l.Email__c = sv.Email__c;
                l.Project__c = pList[0].Id;
                l.Purchase_Timeframe__c = sv.Purchase_Timeframe__c;
                l.Project_Type__c = sv.Project_Type__c;
                l.Possession_Timeframe_Required__c = sv.Possession_Timeframe_Required__c;
                l.Buying_Purpose__c = sv.Buying_Purpose__c;
                l.Configuration_Required__c = sv.Configuration_Required__c;
                l.Budget__c = sv.Budget__c;
                l.Age_Group__c = sv.Age_Group__c;
                l.Gender__c = sv.Gender__c;
                l.Designation__c = sv.Designation__c;
                l.Marital_Status__c = sv.Marital_Status__c;
                l.Occupation__c = sv.Occupation__c;
                l.Family_Size__c = sv.Family_Size__c;
                l.Ethinicity__c = sv.Ethinicity__c;
                l.Current_Residence_Configuration__c = sv.Current_Residence_Configuration__c;
                l.Highest_Education__c = sv.Highest_Education__c;
                l.Current_Residence_Status__c = sv.Current_Residence_Status__c;
                l.Industry__c = sv.Industry__c;
                l.Household_Income_Annual__c = sv.Household_Income_Annual__c;
                l.Citizenship__c = sv.Citizenship__c;
                l.Company_Name__c = sv.Company_Name__c;
                l.House_No__c = sv.House_No__c;
                l.Street__c = sv.Street_1__c;
                l.Locality__c = sv.Locality__c;
                l.City__c = sv.City__c;
                l.State__c = sv.State__c;
                l.Country__c = sv.Country__c;
                l.PostalCode__c = sv.Pincode__c;
                l.Media__c = sv.Media__c;
                
                if(sv.Media__c == 'Reference') {
                    l.Referrer_Name__c = sv.Referrer_Name__c;
                } else if(sv.Media__c == 'Channel Partner') {
                    l.Channel_Partner__c = sv.Channel_Partner__c;
                } 
                l.Status__c = 'Site Visit Conducted';
                l.OwnerId = UserInfo.getUserId();
                
                try {
                    insert l;
                    
                    //Convert Lead & Tag to Existing Account
                    List<Lead__c> lList = new List<Lead__c>();
                    lList.add(l);
                    LeadConversionServices.convertLead(lList);
                    
                    Lead__c convertedLead = [Select ConvertedAccountId__c, ConvertedOpportunityId__c from Lead__c where Id = :l.Id AND IsConverted__c = true];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    Opportunity__c convertedOpp = [Select Id, Name, Site_Visit_Count__c from Opportunity__c where Id =: convertedLead.ConvertedOpportunityId__c];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                    //Tag Site Visit Against Converted Opportunity
                    sv.Opportunity__c = convertedOpp.Id;
                    sv.SV_Date_Time__c = system.now();
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.Last_SV_Date__c = system.now();
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
        } else {
            if(isLeadFound) {
                try {
                    //Update Lead
                    leadList1[0].Status__c = 'Site Visit Conducted';
                    update leadList1[0];
                    
                    //Convert Lead
                    List<Lead__c> lList = new List<Lead__c>();
                    lList.add(leadList1[0]);
                    LeadConversionServices.convertLead(lList);
                    
                    Lead__c convertedLead = [Select ConvertedAccountId__c, ConvertedOpportunityId__c from Lead__c where Id =: leadList1[0].Id AND IsConverted__c = true];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    Opportunity__c convertedOpp =  [SELECT Id, Name, Site_Visit_Count__c, Media__c from Opportunity__c where Id =: convertedLead.ConvertedOpportunityId__c];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                    if(convertedOpp.Media__c != sv.Media__c) {
                        sv.Is_Source_Conflict__c = 'Yes';
                    }
                    //Tag Site Visit Against Opportunity
                    sv.Opportunity__c = convertedOpp.Id;
                    sv.SV_Date_Time__c = system.now();
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.Last_SV_Date__c = system.now();
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
                Lead__c l = new Lead__c();
                l.Salutation__c = sv.Salutation__c;
                l.First_Name__c = sv.First_Name__c;
                l.Last_Name__c = sv.Last_Name__c;
                l.MobilePhone__c = sv.Mobile__c;
                l.Email__c = sv.Email__c;
                l.Project__c = pList[0].Id;
                l.Purchase_Timeframe__c = sv.Purchase_Timeframe__c;
                l.Project_Type__c = sv.Project_Type__c;
                l.Possession_Timeframe_Required__c = sv.Possession_Timeframe_Required__c;
                l.Buying_Purpose__c = sv.Buying_Purpose__c;
                l.Configuration_Required__c = sv.Configuration_Required__c;
                l.Budget__c = sv.Budget__c;
                l.Age_Group__c = sv.Age_Group__c;
                l.Gender__c = sv.Gender__c;
                l.Designation__c = sv.Designation__c;
                l.Marital_Status__c = sv.Marital_Status__c;
                l.Occupation__c = sv.Occupation__c;
                l.Family_Size__c = sv.Family_Size__c;
                l.Ethinicity__c = sv.Ethinicity__c;
                l.Current_Residence_Configuration__c = sv.Current_Residence_Configuration__c;
                l.Highest_Education__c = sv.Highest_Education__c;
                l.Current_Residence_Status__c = sv.Current_Residence_Status__c;
                l.Industry__c = sv.Industry__c;
                l.Household_Income_Annual__c = sv.Household_Income_Annual__c;
                l.Citizenship__c = sv.Citizenship__c;
                l.Company_Name__c = sv.Company_Name__c;
                l.House_No__c = sv.House_No__c;
                l.Street__c = sv.Street_1__c;
                l.Locality__c = sv.Locality__c;
                l.City__c = sv.City__c;
                l.State__c = sv.State__c;
                l.Country__c = sv.Country__c;
                l.PostalCode__c = sv.Pincode__c;
                l.Media__c = sv.Media__c;
                
                if(sv.Media__c == 'Reference') {
                    l.Referrer_Name__c = sv.Referrer_Name__c;
                } else if(sv.Media__c == 'Channel Partner') {
                    l.Channel_Partner__c = sv.Channel_Partner__c;
                } 
                l.Status__c = 'Site Visit Conducted';
                l.OwnerId = UserInfo.getUserId();
                
                try {
                    insert l;
                    
                    //Convert Lead & Tag to Existing Account
                    List<Lead__c> lList = new List<Lead__c>();
                    lList.add(l);
                    LeadConversionServices.convertLead(lList);
                    
                    Lead__c convertedLead = [Select ConvertedAccountId__c, ConvertedOpportunityId__c from Lead__c where Id = :l.Id AND IsConverted__c = true];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    Opportunity__c convertedOpp = [SELECT Id, Name, Site_Visit_Count__c from Opportunity__c where Id =: convertedLead.ConvertedOpportunityId__c];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                    //Tag Site Visit Against Converted Opportunity
                    sv.Opportunity__c = convertedOpp.Id;
                    sv.SV_Date_Time__c = system.now();
                    sv.SV_Count__c = 1;
                    insert sv;
                    
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.Last_SV_Date__c = system.now();
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
        List<Channel_Partner__c> cpList = new List<Channel_Partner__c>();
        String QueryString =  'Select Id, Name, Mobile__c from Channel_Partner__c where (Name LIKE \'' + cpName + '%\' OR  Mobile__c LIKE \'' + cpName + '%\') ';
        cpList = Database.query(QueryString);
        system.debug('cpList: '+cpList);
        
        if(!cpList.isEmpty() && cpList != null){
            for(Channel_Partner__c cp : cpList){
                cpNameList.add(cp.Name+'-'+cp.Mobile__c);
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