public class SiteVisitFormController {
    public List<Account> accList1 {get;set;}
    public List<Opportunity> oppList1 {get;set;}
    public List<Lead> leadList1 {get;set;}
    public List<Project__c> pList {get;set;}
    public Site_Visit__c sv {get;set;}
    public boolean isAccount {get;set;}
    public boolean isLead {get;set;}
    public boolean isOpp {get;set;}
    public String project {get;set;}
    public String projectName {get;set;}
    public List<SelectOption> objectOptions {get;set;}
    Public List<SelectOption> objectSourcing {get;set;}
    public Id selectedObject{get;set;}
    Public Id selectedSourceManager {get;set;}
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
    public String validFor{get;set;}
    public List<Team_Members__c> tmList {get;set;}
    
    public List<SelectOption> getTypes2() {
        Schema.sObjectType sobject_type = Site_Visit__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Age_Group__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getTypes3() {
        Schema.sObjectType sobject_type = Site_Visit__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Occupation__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getTypes4() {
        Schema.sObjectType sobject_type = Site_Visit__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Gender__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getTypes5() {
        Schema.sObjectType sobject_type = Site_Visit__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Martial_Status__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }

    public List<SelectOption> getTypes6() {
        Schema.sObjectType sobject_type = Site_Visit__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Configuration_Required__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
        
    public List<SelectOption> getTypes7() {
        Schema.sObjectType sobject_type = Site_Visit__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Current_Residence_Status__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getTypes8() {
        List<selectOption> options = new List<selectOption>();
        options = getDependentPicklistValues(Site_Visit__c.Budget__c, sv.Configuration_Required__c);
        return options;
    }
    
    public List<SelectOption> getTypes9() {
        Schema.sObjectType sobject_type = Site_Visit__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Buying_Purpose__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getTypes10() {
        Schema.sObjectType sobject_type = Site_Visit__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Purchase_Timeframe__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getTypes11() {
        Schema.sObjectType sobject_type = Site_Visit__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Possession_Timeframe_Required__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getTypes12() {
        Schema.sObjectType sobject_type = Site_Visit__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Salutation__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }

    
    public List<SelectOption> getTypes13() {
        Schema.sObjectType sobject_type = Site_Visit__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Current_Residence_Configuration__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    
    public List<SelectOption> getTypes14() {
        Schema.sObjectType sobject_type = Site_Visit__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Master_Source__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    
    public List<SelectOption> getTypes15() {
        List<selectOption> options = new List<selectOption>();
        options = getDependentPicklistValues(Site_Visit__c.Lead_Source__c, sv.Master_Source__c);
        return options;
    }
    
    
    
    
    public SiteVisitFormController() {
        accList1 = new List<Account>();
        oppList1 = new List<Opportunity>();
        leadList1 = new List<Lead>();
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
        tmList = new List<Team_Members__c>();
        
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
                
                /*tmList = [Select Id, User__c from Team_Members__c where Team__r.Team_Type__c = 'Sales Team' AND Team__r.Project__c =: pList[0].Id
                            AND IsActive__c = true];*/
                tmList = [Select Id, User__c from Team_Members__c where Team__r.Team_Type__c = 'Sales Team' AND Team__r.Project__c =: pList[0].Id];
          
                
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
            accList = [Select Id, Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c,PersonContactId, 
                       Age_Group__c, Configuration_Required__c,Current_Residence_Status__c,Gender__c, Designation__c, Martial_Status__c, Occupation__c,
                       Industry, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode
                       from Account 
                       where (PersonMobilePhone =: mobile OR Phone =: mobile) AND IsPersonAccount = true];
            system.debug('accList: '+accList);
            
            if(!accList.isEmpty()) {
                isAccount = true;
                
                oppList = [Select Id, Name,Site_Visit_Count__c, Project__c, Configuration_Required__c,
                           Possession_Timeframe_Required__c, Budget__c, Buying_Purpose__c, Presales_Manager__c,Master_Source__c,
                           Lead_Source__c,Other_Source_Details__c,Sourcing_Manager__c,Lead_Sub_Source__c,Lead_Sub_source_Details__c, Employee_Referrer_Name__c,
                           Channel_Partner__c,Referrer_Name__c, Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,
                           Channel_Partner__r.Name,Purchase_Timeframe__c,Current_Residence_Configuration__c, Channel_Partner__r.Phone from Opportunity
                           where AccountId =: accList[0].Id AND Project__c =: pList[0].Id ];    //Is Active 
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
                               Age_Group__c, Configuration_Required__c,Current_Residence_Status__c,Gender__c, Designation__c, Martial_Status__c, Occupation__c,
                               Industry, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode
                               from Account
                               where (PersonEmail =: email OR Alternate_Email__c =: email) AND IsPersonAccount = true];
                    system.debug('accList: '+accList);
                    
                    if(!accList.isEmpty()) {
                        isAccount = true;
                        
                        oppList = [Select Id, Name,Site_Visit_Count__c, Project__c, Configuration_Required__c, 
                                   Possession_Timeframe_Required__c, Budget__c, Buying_Purpose__c, Presales_Manager__c,Master_Source__c,
                                   Lead_Source__c,Other_Source_Details__c,Sourcing_Manager__c,Lead_Sub_Source__c,Lead_Sub_source_Details__c, Employee_Referrer_Name__c,
                                   Channel_Partner__c,Referrer_Name__c,Current_Residence_Configuration__c, Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,
                                   Channel_Partner__r.Name,Purchase_Timeframe__c, Channel_Partner__r.Phone from Opportunity
                                  where AccountId =: accList[0].Id AND Project__c =: pList[0].Id ];  // is Active
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
                leadList = [Select Id, Salutation, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email_Id__c,
                            Age_Group__c,Current_Residence_Status__c,Possession_Timeframe_Required__c,Gender__c, Martial_Status__c, Occupation__c,
                            Project__c, Configuration_Required__c, Budget__c, Buying_Purpose__c, Designation__c,
                            Industry,Master_Source__c, Lead_Source__c,Current_Residence_Configuration__c, Lead_Sub_Source__c,Referrer_Name__c,  OwnerId, Employee_Referrer_Name__c,
                            Status, Lead_Stage__c,Lead_Sub_Source_Details__c,Channel_Partner__c, Channel_Partner__r.Name, Channel_Partner__r.Phone,
                            Street, City, Purchase_Timeframe__c,State,Other_Source_Details__c, Country, PostalCode, Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name
                            from Lead
                            where (MobilePhone =: mobile OR Phone =: mobile) AND Project__c =: pList[0].Id AND isConverted = false AND Is_Active__c = true];  
                system.debug('leadList: '+leadList);
                
                if(!leadList.isEmpty()) {
                    isLead = true;
                } else {
                    if(email != Null && !String.isBlank(email)) {
                        leadList = [Select Id,  Salutation, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email_Id__c,
                                    Age_Group__c,Current_Residence_Status__c,Possession_Timeframe_Required__c,Gender__c, Martial_Status__c, Occupation__c,
                                    Project__c, Configuration_Required__c, Budget__c, Buying_Purpose__c, Designation__c,
                                    Industry,Master_Source__c, Lead_Source__c,Current_Residence_Configuration__c, Lead_Sub_Source__c,Referrer_Name__c,  OwnerId, Employee_Referrer_Name__c,
                                    Status, Lead_Stage__c,Lead_Sub_Source_Details__c,Channel_Partner__c, Channel_Partner__r.Name, Channel_Partner__r.Phone,
                                    Street, City,Purchase_Timeframe__c, State,Other_Source_Details__c, Country, PostalCode, Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name
                                    from Lead
                                    where (Email =: email OR Alternate_Email_Id__c =: email) AND Project__c =: pList[0].Id AND isConverted = false AND Is_Active__c = true];
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
        	/*if(accList[0].DOB__c != Null) {
                sv.Birth_Date__c = accList[0].DOB__c;
                birthDate = accList[0].DOB__c;    
            }*/
         	/*if(accList[0].Anniversary_Date__c != null) {
                sv.Anniversary_Date__c = accList[0].Anniversary_Date__c;
                AnniversaryDate = accList[0].Anniversary_Date__c;
            }*/
            if(accList[0].Age_Group__c != '' && accList[0].Age_Group__c != null)
                sv.Age_Group__c = accList[0].Age_Group__c; 
            if(accList[0].Gender__c != '' && accList[0].Gender__c != null)
                sv.Gender__c = accList[0].Gender__c;
            if(accList[0].Designation__c != '' && accList[0].Designation__c != null)
                sv.Designation__c = accList[0].Designation__c;
            if(accList[0].Martial_Status__c != '' && accList[0].Martial_Status__c != null)
                sv.Martial_Status__c = accList[0].Martial_Status__c;
            if(accList[0].Occupation__c != '' && accList[0].Occupation__c != null)
                sv.Occupation__c = accList[0].Occupation__c;
          	/*if(accList[0].Family_Size__c != '' && accList[0].Family_Size__c != null)
                sv.Family_Size__c = accList[0].Family_Size__c; */
          	/*if(accList[0].Highest_Education__c != '' && accList[0].Highest_Education__c != null)
                sv.Highest_Education__c = accList[0].Highest_Education__c; */
            if(accList[0].Configuration_Required__c != '' && accList[0].Configuration_Required__c != null)
                sv.Configuration_Required__c = accList[0].Configuration_Required__c;
           	if(accList[0].Current_Residence_Status__c != '' && accList[0].Current_Residence_Status__c != null)
                sv.Current_Residence_Status__c = accList[0].Current_Residence_Status__c;
            /*if(accList[0].Ethinicity__c != '' && accList[0].Ethinicity__c != null)
                sv.Ethinicity__c = accList[0].Ethinicity__c;
            if(accList[0].Household_Income_Annual__c != '' && accList[0].Household_Income_Annual__c != null)
                sv.Household_Income_Annual__c = accList[0].Household_Income_Annual__c;
            if(accList[0].Household_Income_Annual__c != '' && accList[0].Household_Income_Annual__c != null)
                sv.Household_Income_Annual__c = accList[0].Household_Income_Annual__c; 
           	if(accList[0].Industry != '' && accList[0].Industry != null)
                sv.Industry__c = accList[0].Industry; 
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
            if(accList[0].BillingCountry != '' && accList[0].BillingCountry != null)
                sv.Country__c = accList[0].BillingCountry;
            if(accList[0].BillingPostalCode != '' && accList[0].BillingPostalCode != null)
                sv.Pincode__c = Decimal.valueOf(accList[0].BillingPostalCode);  */
            if(isOpp) {
                if(oppList[0].Purchase_Timeframe__c != '' && oppList[0].Purchase_Timeframe__c != null)
                    sv.Purchase_Timeframe__c = oppList[0].Purchase_Timeframe__c;   
                if(oppList[0].Configuration_Required__c != '' && oppList[0].Configuration_Required__c != null)
                    sv.Configuration_Required__c = oppList[0].Configuration_Required__c;
                if(oppList[0].Current_Residence_Configuration__c != '' && oppList[0].Current_Residence_Configuration__c != null)
                    sv.Current_Residence_Configuration__c = oppList[0].Current_Residence_Configuration__c;
                if(oppList[0].Possession_Timeframe_Required__c != '' && oppList[0].Possession_Timeframe_Required__c != null)
                    sv.Possession_Timeframe_Required__c = oppList[0].Possession_Timeframe_Required__c;
                if(oppList[0].Budget__c != '' && oppList[0].Budget__c != null)
                    sv.Budget__c = oppList[0].Budget__c;
                if(oppList[0].Buying_Purpose__c != '' && oppList[0].Buying_Purpose__c != null)
                    sv.Buying_Purpose__c = oppList[0].Buying_Purpose__c;
                if(oppList[0].Master_Source__c != '' && oppList[0].Master_Source__c != null)
                    sv.Master_Source__c = oppList[0].Master_Source__c;
                if(oppList[0].Lead_Source__c != '' && oppList[0].Lead_Source__c != null)
                    sv.Lead_Source__c = oppList[0].Lead_Source__c;
                if(oppList[0].Lead_Sub_Source__c != '' && oppList[0].Lead_Sub_Source__c != null)
                    sv.Lead_Sub_Source__c = oppList[0].Lead_Sub_Source__c;
                if(oppList[0].Lead_Sub_source_Details__c != '' && oppList[0].Lead_Sub_source_Details__c != null)
                    sv.Lead_Sub_source_Details__c = oppList[0].Lead_Sub_source_Details__c; 
                 if(oppList[0].Other_Source_Details__c != '' && oppList[0].Other_Source_Details__c != null)
                   sv.Other_Source_Details__c = oppList[0].Other_Source_Details__c;
                if(oppList[0].Channel_Partner__c != null) {
                    sv.Channel_Partner__c = oppList[0].Channel_Partner__c;
                    cpName = oppList[0].Channel_Partner__r.Name +'-'+oppList[0].Channel_Partner__r.Phone;
                }
                if(oppList[0].Referrer_Name__c != null) {
                    sv.Referrer_Name__c = oppList[0].Referrer_Name__c;
                    refName = oppList[0].Referrer_Name__r.Name +'-'+oppList[0].Referrer_Name__r.PersonMobilePhone;
                } 
              	if(oppList[0].Employee_Referrer_Name__c != '' && oppList[0].Employee_Referrer_Name__c != null)
                    sv.Employee_Referrer_Name__c = oppList[0].Employee_Referrer_Name__c;
                if(oppList[0].Presales_Manager__c != null) {
                    sv.Presales_Manager__c = oppList[0].Presales_Manager__c;
                    sv.Sourcing_Manager__c = oppList[0].Sourcing_Manager__c;    
                }
            } else if(isLead) {
                if(leadList[0].Purchase_Timeframe__c != '' && leadList[0].Purchase_Timeframe__c != null)
                    sv.Purchase_Timeframe__c = leadList[0].Purchase_Timeframe__c;  
                if(leadList[0].Configuration_Required__c != '' && leadList[0].Configuration_Required__c != null)
                    sv.Configuration_Required__c = leadList[0].Configuration_Required__c;
                if(leadList[0].Current_Residence_Configuration__c != '' && leadList[0].Current_Residence_Configuration__c != null)
                    sv.Current_Residence_Configuration__c = leadList[0].Current_Residence_Configuration__c;
                if(leadList[0].Possession_Timeframe_Required__c != '' && leadList[0].Possession_Timeframe_Required__c != null)
                    sv.Possession_Timeframe_Required__c = leadList[0].Possession_Timeframe_Required__c; 
                if(leadList[0].Budget__c != '' && leadList[0].Budget__c != null)
                    sv.Budget__c = leadList[0].Budget__c;
                if(leadList[0].Buying_Purpose__c != '' && leadList[0].Buying_Purpose__c != null)
                    sv.Buying_Purpose__c = leadList[0].Buying_Purpose__c;
                if(leadList[0].Master_Source__c!= '' && leadList[0].Master_Source__c!= Null)
                    sv.Master_Source__c= leadList[0].Master_Source__c;   
                if(leadList[0].Lead_Source__c != '' && leadList[0].Lead_Source__c != Null)
                    sv.Lead_Source__c = leadList[0].Lead_Source__c;
                if(leadList[0].Lead_Sub_Source__c != '' && leadList[0].Lead_Sub_Source__c != Null)
                    sv.Lead_Sub_Source__c = leadList[0].Lead_Sub_Source__c;
                if(leadList[0].Lead_Sub_source_Details__c != '' && leadList[0].Lead_Sub_source_Details__c != Null)
                    sv.Lead_Sub_source_Details__c = leadList[0].Lead_Sub_source_Details__c;
                if(leadList[0].Channel_Partner__c != null) {
                    sv.Channel_Partner__c = leadList[0].Channel_Partner__c;
                    cpName = leadList[0].Channel_Partner__r.Name +'-'+leadList[0].Channel_Partner__r.Phone;
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
                    sv.Presales_Manager__c = leadList[0].OwnerId;
                    sv.Sourcing_Manager__c = leadList[0].OwnerId;
                }   
            }
        } else if(isLead) {
            if(leadList[0].Salutation != '' && leadList[0].Salutation != Null)
                sv.Salutation__c = leadList[0].Salutation;
            if(leadList[0].FirstName != '' && leadList[0].FirstName != Null)
                sv.First_Name__c = leadList[0].FirstName;
            if(leadList[0].LastName != '' && leadList[0].LastName != Null)
                sv.Last_Name__c = leadList[0].LastName;
            if(sv.Email__c == null && leadList[0].Email != '' && leadList[0].Email != null)
                sv.Email__c = leadList[0].Email;
            /*if(leadList[0].DOB__c != Null) {
                sv.Birth_Date__c = leadList[0].DOB__c;
                birthDate = leadList[0].DOB__c;
            } 
            if(leadList[0].Anniversary_Date__c != null) {
                sv.Anniversary_Date__c = leadList[0].Anniversary_Date__c;
                AnniversaryDate = leadList[0].Anniversary_Date__c; 
            }*/
            if(leadList[0].Age_Group__c != '' && leadList[0].Age_Group__c != null)
                sv.Age_Group__c = leadList[0].Age_Group__c;
            if(leadList[0].Gender__c != '' && leadList[0].Gender__c != null)
                sv.Gender__c = leadList[0].Gender__c;
            if(leadList[0].Martial_Status__c != '' && leadList[0].Martial_Status__c != null)
                sv.Martial_Status__c = leadList[0].Martial_Status__c;
            if(leadList[0].Occupation__c != '' && leadList[0].Occupation__c != null)
                sv.Occupation__c = leadList[0].Occupation__c; 
            if(leadList[0].Configuration_Required__c != '' && leadList[0].Configuration_Required__c != null)
                sv.Configuration_Required__c = leadList[0].Configuration_Required__c;
             if(leadList[0].Current_Residence_Configuration__c != '' && leadList[0].Current_Residence_Configuration__c != null)
                sv.Current_Residence_Configuration__c = leadList[0].Current_Residence_Configuration__c;
             if(leadList[0].Current_Residence_Status__c != '' && leadList[0].Current_Residence_Status__c != null)
                sv.Current_Residence_Status__c = leadList[0].Current_Residence_Status__c;
            if(leadList[0].Designation__c != '' && leadList[0].Designation__c != null)
                sv.Designation__c = leadList[0].Designation__c; 
            /*if(leadList[0].Family_Size__c != '' && leadList[0].Family_Size__c != null)
                sv.Family_Size__c = leadList[0].Family_Size__c;
			if(leadList[0].Highest_Education__c != '' && leadList[0].Highest_Education__c != null)
                sv.Highest_Education__c = leadList[0].Highest_Education__c;
			if(leadList[0].Ethinicity__c != '' && leadList[0].Ethinicity__c != null)
                sv.Ethinicity__c = leadList[0].Ethinicity__c;
            if(leadList[0].Household_Income_Annual__c != '' && leadList[0].Household_Income_Annual__c != null)
                sv.Household_Income_Annual__c = leadList[0].Household_Income_Annual__c;
            if(leadList[0].Household_Income_Annual__c != '' && leadList[0].Household_Income_Annual__c != null)
                sv.Household_Income_Annual__c = leadList[0].Household_Income_Annual__c;
            if(leadList[0].Industry != '' && leadList[0].Industry != null)
                sv.Industry__c = leadList[0].Industry; */
            if(leadList[0].Purchase_Timeframe__c != '' && leadList[0].Purchase_Timeframe__c != null)
                sv.Purchase_Timeframe__c = leadList[0].Purchase_Timeframe__c; 
            if(leadList[0].Configuration_Required__c != '' && leadList[0].Configuration_Required__c != null)
                sv.Configuration_Required__c = leadList[0].Configuration_Required__c;
             if(leadList[0].Current_Residence_Configuration__c != '' && leadList[0].Current_Residence_Configuration__c != null)
                sv.Current_Residence_Configuration__c = leadList[0].Current_Residence_Configuration__c;
            if(leadList[0].Possession_Timeframe_Required__c != '' && leadList[0].Possession_Timeframe_Required__c != null)
                sv.Possession_Timeframe_Required__c = leadList[0].Possession_Timeframe_Required__c; 
            if(leadList[0].Budget__c != '' && leadList[0].Budget__c != null)
                sv.Budget__c = leadList[0].Budget__c;
            if(leadList[0].Buying_Purpose__c != '' && leadList[0].Buying_Purpose__c != null)
                sv.Buying_Purpose__c = leadList[0].Buying_Purpose__c;
            if(leadList[0].Master_Source__c!= '' && leadList[0].Master_Source__c!= Null)
                sv.Master_Source__c= leadList[0].Master_Source__c;   
            if(leadList[0].Lead_Source__c != '' && leadList[0].Lead_Source__c != Null)
                sv.Lead_Source__c = leadList[0].Lead_Source__c;
            if(leadList[0].Lead_Sub_Source__c != '' && leadList[0].Lead_Sub_Source__c != Null)
                sv.Lead_Sub_Source__c = leadList[0].Lead_Sub_Source__c;
            if(leadList[0].Lead_Sub_source_Details__c != '' && leadList[0].Lead_Sub_source_Details__c != Null)
                sv.Lead_Sub_source_Details__c = leadList[0].Lead_Sub_source_Details__c;
            
            if(leadList[0].Channel_Partner__c != null) {
                sv.Channel_Partner__c = leadList[0].Channel_Partner__c;
                cpName = leadList[0].Channel_Partner__r.Name +'-'+leadList[0].Channel_Partner__r.Phone;    
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
                sv.Presales_Manager__c = leadList[0].OwnerId;
                sv.Sourcing_Manager__c = leadList[0].OwnerId;    
            }
            /*if(leadList[0].House_No__c != '' && leadList[0].House_No__c != null)
                sv.House_No__c = leadList[0].House_No__c;
            if(leadList[0].Locality__c != '' && leadList[0].Locality__c != null)
                sv.Locality__c = leadList[0].Locality__c;
            if(leadList[0].Street != '' && leadList[0].Street != null)
                sv.Street_1__c = leadList[0].Street;
            if(leadList[0].City != '' && leadList[0].City != null)
                sv.City__c = leadList[0].City;
            if(leadList[0].State != '' && leadList[0].State != null)
                sv.State__c = leadList[0].State;
            if(leadList[0].Country != '' && leadList[0].Country != null)
                sv.Country__c = leadList[0].Country;
            if(leadList[0].PostalCode != '' && leadList[0].PostalCode != null)
                sv.Pincode__c = Decimal.valueOf(leadList[0].PostalCode);   */
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
        
     	/*if(Integer.valueOf(p) == 1){
            if(sv.Pincode__c == null) {
                valError = True;
                message = 'Please fill Pincode.';
            } else {
                if(String.valueOf(sv.Pincode__c).length()!= 6) {
                    valError = True;
                    message = 'Please enter valid Pincode.';
                }
            }
        }*/
        
        if(Integer.valueOf(p) == 1) {
            if(String.isBlank(sv.Master_Source__c)) {
                valError = True;
                message = 'Please fill Master Source.';
            } else if(String.isBlank(sv.Lead_Source__c)) {
                valError = True;
                message = 'Please fill Lead Source.';
            } else if(sv.Master_Source__c == 'Channel Partner' && sv.Lead_Source__c == 'Channel Partner') {          
                if(String.isBlank(cpName)) {
                    valError = True;
                    message = 'Please fill Channel Partner Name.';
                } 
            } else if(sv.Master_Source__c == 'Recommended by Friends/Relatives' && sv.Lead_Source__c == 'Employees') {
                if(String.isBlank(sv.Employee_Referrer_Name__c)) {
                    valError = True;
                    message = 'Please fill Employees Referrer Name.';
                } 
            } else if(sv.Master_Source__c == 'Recommended by Friends/Relatives' && sv.Lead_Source__c == 'Customers') {
                if(String.isBlank(refName)) {
                    valError = True;
                    message = 'Please fill Customer Referrer Name.';
                } 
            } else if(sv.Master_Source__c == 'Other') {
                if(String.isBlank(sv.Other_Source_Details__c)) {
                    valError = True;
                    message = 'Please fill Other Source Details.';
                }
            }
        }
            
        if(Integer.valueOf(p) == 3) {
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
        isLeadFound = false;
        isOppFound = false;
        system.debug('DOB:: '+ birthDate);
        system.debug('DOA:: '+ AnniversaryDate);
      	/*if(birthDate != Null)
            sv.Birth_Date__c = birthDate;
        if(AnniversaryDate != Null)
            sv.Anniversary_Date__c = AnniversaryDate; */
        
        if(String.isNotBlank(cpName) && cpName != '') {
            List<Account> cpList = new List<Account>();
            String[] tokens = cpName.split('-');
            Integer tokenCount = tokens.size();
            for (Integer j = 0; j < tokenCount; j++) {
                System.debug('tokens-'+j+': '+tokens[j]);
            }
            Id cpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
            cpList = [Select Id, Name, Phone, OwnerId from Account where RecordTypeId =: cpRecordTypeId AND Name =: tokens[0] AND Phone =: tokens[1]];
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
            accList1 = [Select Id,  Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, PersonContactId,
                        Age_Group__c, Configuration_Required__c,Current_Residence_Status__c,Gender__c, Designation__c, Martial_Status__c, Occupation__c,
                        Industry, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode
                        from Account
                        where (PersonMobilePhone =: mobile OR Phone =: mobile) AND IsPersonAccount = true];
            system.debug('accList1: '+accList1);
            
            if(!accList1.isEmpty()) {
                isAccountFound = true;
                
                oppList1 = [Select Id,Name,Site_Visit_Count__c, Project__c, Configuration_Required__c,Current_Residence_Configuration__c, 
                            Possession_Timeframe_Required__c, Budget__c, Buying_Purpose__c, Presales_Manager__c,Master_Source__c,
                            Lead_Source__c,Other_Source_Details__c,Sourcing_Manager__c, Lead_Sub_Source__c,Lead_Sub_source_Details__c, Employee_Referrer_Name__c,Purchase_Timeframe__c,
                            Channel_Partner__c,Referrer_Name__c, Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,
                            Channel_Partner__r.Name, Channel_Partner__r.Phone  from Opportunity
                            where AccountId =: accList1[0].Id AND Project__c =: pList[0].Id ];  // is Active
                system.debug('oppList1: '+oppList1);
                
                if(!oppList1.isEmpty()) {
                    isOppFound = true;
                }
            } else {
                if(email != Null && !String.isBlank(email)) {
                    accList1 = [Select Id,  Salutation, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, PersonContactId,
                                Age_Group__c, Configuration_Required__c,Current_Residence_Status__c,Gender__c, Designation__c, Martial_Status__c, Occupation__c,
                                Industry, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode                                from Account
                                where (PersonEmail =: email OR Alternate_Email__c =: email) AND IsPersonAccount = true];
                    system.debug('accList1: '+accList1);
                    
                    if(!accList1.isEmpty()) {
                        isAccountFound = true;
                        
                        oppList1 = [Select Id,Name,Site_Visit_Count__c, Project__c, Configuration_Required__c,Current_Residence_Configuration__c, 
                                    Possession_Timeframe_Required__c, Budget__c, Buying_Purpose__c, Presales_Manager__c,Master_Source__c,
                                    Lead_Source__c,Other_Source_Details__c,Sourcing_Manager__c, Lead_Sub_Source__c,Lead_Sub_source_Details__c, Employee_Referrer_Name__c,Purchase_Timeframe__c,
                                    Channel_Partner__c,Referrer_Name__c, Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name,
                                    Channel_Partner__r.Name, Channel_Partner__r.Phone from Opportunity
                                   where AccountId =: accList1[0].Id AND Project__c =: pList[0].Id ];  // is Active
                        system.debug('oppList1: '+oppList1);
                        
                        if(!oppList1.isEmpty()) {
                            isOppFound = true;
                        }
                    }
                }
            }
            
            if(oppList1.isEmpty()) {
                leadList1 = [Select Id,  Salutation, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email_Id__c,
                             Age_Group__c,Current_Residence_Status__c,Gender__c, Martial_Status__c, Occupation__c,Purchase_Timeframe__c,
                             Project__c, Configuration_Required__c,Current_Residence_Configuration__c, Budget__c, Buying_Purpose__c,Designation__c,Possession_Timeframe_Required__c, 
                             Industry,Master_Source__c, Lead_Source__c, Lead_Sub_Source__c,Referrer_Name__c,  OwnerId, Employee_Referrer_Name__c,
                             Status, Lead_Stage__c,Lead_Sub_Source_Details__c,Channel_Partner__c, Channel_Partner__r.Name, Channel_Partner__r.Phone,
                             Street, City, State,Other_Source_Details__c, Country, PostalCode, Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name
                             from Lead
                             where (MobilePhone =: mobile OR Phone =: mobile) AND Project__c =: pList[0].Id AND isConverted = false AND Is_Active__c = true];
                system.debug('leadList1: '+leadList1);
                
                if(!leadList1.isEmpty()) {
                    isLeadFound = true;
                } else {
                    if(email != Null && !String.isBlank(email)) {
                        leadList1 = [Select Id, Salutation, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email_Id__c,
                                     Age_Group__c,Current_Residence_Status__c,Gender__c, Martial_Status__c, Occupation__c,
                                     Project__c, Configuration_Required__c, Current_Residence_Configuration__c,Budget__c, Buying_Purpose__c,Designation__c,Purchase_Timeframe__c,Possession_Timeframe_Required__c,  
                                     Industry,Master_Source__c, Lead_Source__c, Lead_Sub_Source__c,Referrer_Name__c,  OwnerId, Employee_Referrer_Name__c,
                                     Status, Lead_Stage__c,Lead_Sub_Source_Details__c,Channel_Partner__c, Channel_Partner__r.Name, Channel_Partner__r.Phone,
                                     Street, City, State,Other_Source_Details__c, Country, PostalCode, Referrer_Name__r.PersonMobilePhone, Referrer_Name__r.Name
                                     from Lead
                                     where (Email =: email OR Alternate_Email_Id__c =: email) AND Project__c =: pList[0].Id AND isConverted = false AND Is_Active__c = true];
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
                    //Update Opportunity
                    oppList1[0].Site_Visit_Count__c = oppList1[0].Site_Visit_Count__c + 1;
                    oppList1[0].SV_Date_Time__c = system.now();
                    update oppList1[0];
                    
                    //Create Site Visit
                    sv.Opportunity__c = oppList1[0].Id;
                    sv.SV_Date_Time__c = system.now();
                    if(oppList1[0].Site_Visit_Count__c == Null || oppList1[0].Site_Visit_Count__c == 0) {
                        sv.SV_Count__c = 1;
                       /* if(oppList1[0].Master_Source__c != sv.Master_Source__c || oppList1[0].Lead_Source__c != sv.Lead_Source__c) {
                            sv.Is_Source_Conflict__c = 'Yes';
                            if(!tmList.isEmpty() && tmList != null)
                                sv.Approver_1__c = tmList[0].Id;
                        }  */
                    } else
                        sv.SV_Count__c = oppList1[0].Site_Visit_Count__c + 1;
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
            } else if(!isOppFound && isLeadFound) {
                try {
                    //Update Lead
                    leadList1[0].Lead_Stage__c = 'Visit Done';
                  	//leadList1[0].Lead_Sub_Stage__c = 'Visit Done';
                  	//leadList1[0].Lead_Sub_Stage_Reason__c = '';
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
                    
                    Opportunity convertedOpp =  [SELECT Id, Name,Site_Visit_Count__c, Master_Source__c,Project__c, Lead_Source__c,Lead_Sub_source__c,Lead_Sub_source_Details__c from Opportunity where Id =: convertedLead.ConvertedOpportunityId];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
               		if(convertedOpp.Master_Source__c != sv.Master_Source__c || convertedOpp.Lead_Source__c != sv.Lead_Source__c || convertedOpp.Lead_Sub_source__c != sv.Lead_Sub_source__c || convertedOpp.Lead_Sub_source_Details__c != sv.Lead_Sub_source_Details__c ) {
                        sv.Is_Source_Conflict__c = 'Yes';
                      //  if(!tmList.isEmpty() && tmList != null)
                        //    sv.Approver_1__c = tmList[0].Id;
                    }
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.SV_Date_Time__c = system.now();
                    update convertedOpp;
                    
                    //Tag Site Visit Against Opportunity
                    sv.Opportunity__c = convertedLead.ConvertedOpportunityId;
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
            } else if(!isOppFound && !isLeadFound) {
                Lead l = new Lead();
                l.Salutation = sv.Salutation__c;
                l.FirstName = sv.First_Name__c;
                l.LastName = sv.Last_Name__c;
                l.MobilePhone = sv.Mobile__c;
                l.Email = sv.Email__c;
                l.Project__c = pList[0].Id;
                l.Buying_Purpose__c = sv.Buying_Purpose__c;
                l.Purchase_Timeframe__c = sv.Purchase_Timeframe__c;
                l.Possession_Timeframe_Required__c = sv.Possession_Timeframe_Required__c;
              	//l.DOB__c = sv.Birth_Date__c;
                l.Age_Group__c = sv.Age_Group__c;
                l.Gender__c = sv.Gender__c;
                l.Designation__c = sv.Designation__c;
                l.Martial_Status__c = sv.Martial_Status__c;
                l.Occupation__c = sv.Occupation__c;
                l.Current_Residence_Status__c = sv.Current_Residence_Status__c;
                //l.Family_Size__c = sv.Family_Size__c;
                //l.Highest_Education__c = sv.Highest_Education__c;
              	//l.Current_Residence_Configuration__c = sv.Current_Residence_Configuration__c;
                //l.Current_Residence_Status__c = sv.Current_Residence_Status__c;
              	//  l.Ethinicity__c = sv.Ethinicity__c;
                //  l.Household_Income_Annual__c = sv.Household_Income_Annual__c;
                //  l.Industry = sv.Industry__c;
                l.Configuration_Required__c = sv.Configuration_Required__c;
                l.Current_Residence_Configuration__c = sv.Current_Residence_Configuration__c;
                l.Budget__c = sv.Budget__c;
                l.Master_Source__c = sv.Master_Source__c;
                l.Lead_Source__c = sv.Lead_Source__c;
                l.Lead_Sub_Source__c = sv.Lead_Sub_Source__c;
                l.Lead_Sub_Source_Details__c = sv.Lead_Sub_source_Details__c;
                l.Other_Source_Details__c = sv.Other_Source_Details__c;
                l.Referrer_Name__c = sv.Referrer_Name__c;
                l.Channel_Partner__c = sv.Channel_Partner__c;
                l.Employee_Referrer_Name__c = sv.Employee_Referrer_Name__c;
                  //  l.House_No__c = sv.House_No__c;
                //  l.Locality__c = sv.Locality__c;
                //  l.Street = sv.Street_1__c;
                /*  if(String.isNotBlank(sv.Street_2__c) && sv.Street_2__c != '')
                l.Street += ' '+sv.Street_2__c;
                l.Country = sv.Country__c;
                l.State = sv.State__c;
                l.Country = sv.Country__c;  */
                l.PostalCode = String.valueOf(sv.Pincode__c);
                
                if(sv.Master_Source__c == 'Recommended by Friends/Relatives' && sv.Lead_Source__c == 'Customers') {
                  l.Referrer_Name__c = sv.Referrer_Name__c;  
                }  else if(sv.Master_Source__c == 'Recommended by Friends/Relatives' && sv.Lead_Source__c == 'Employees') {
                    l.Employee_Referrer_Name__c = sv.Employee_Referrer_Name__c;
                } else if(sv.Master_Source__c == 'Other' && sv.Lead_Source__c == 'Other') {
                    l.Other_Source_Details__c = sv.Other_Source_Details__c;
                } else if(sv.Master_Source__c == 'Channel Partner' && sv.Lead_Source__c == 'Channel Partner') {
                    l.Channel_Partner__c = sv.Channel_Partner__c;
                } 
                l.Lead_Stage__c = 'Visit Done';
              	//  l.Lead_Sub_Stage__c = 'Visit Done';
              	//  l.Lead_Sub_Stage_Reason__c = '';
                
                try {
                    insert l;
                    
                    // Converting Lead to Account & Opportunity
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.setLeadId(l.id);
                    lc.setAccountId(accList1[0].Id);
                    lc.setContactId(accList1[0].PersonContactId);
                    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus where IsConverted = true LIMIT 1];
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    Lead convertedLead = [SELECT ConvertedAccountId, ConvertedOpportunityId from Lead where Id = :l.Id];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    Opportunity convertedOpp =  [SELECT Id, Name,Site_Visit_Count__c, Master_Source__c,Project__c, Lead_Source__c,Lead_Sub_source__c,Lead_Sub_source_Details__c from Opportunity 
                                                 where Id =: convertedLead.ConvertedOpportunityId];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.SV_Date_Time__c = system.now();
                    update convertedOpp;
                    
                    //Tag Site Visit Against Converted Opportunity
                    sv.Opportunity__c = convertedOpp.Id;
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
            if(isLeadFound) {
                try {
                    //Update Lead
                    leadList1[0].Lead_Stage__c = 'Visit Done';
                    //leadList1[0].Lead_Sub_Stage__c = 'Visit Done';
                    //leadList1[0].Lead_Sub_Stage_Reason__c = '';
                    update leadList1[0];
                    
                    //Convert Lead
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.setLeadId(leadList1[0].id);
                    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus where IsConverted = true LIMIT 1];
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    Lead convertedLead = [SELECT ConvertedAccountId, ConvertedOpportunityId from Lead where Id =: leadList1[0].Id];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    Opportunity convertedOpp =  [SELECT Id,Name,Site_Visit_Count__c, Master_Source__c,Project__c, Lead_Source__c,Lead_Sub_source__c,Lead_Sub_source_Details__c from Opportunity where Id =: convertedLead.ConvertedOpportunityId];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                   	/* if(convertedOpp.Master_Source__c != sv.Master_Source__c || convertedOpp.Lead_Source__c != sv.Lead_Source__c) {
                        sv.Is_Source_Conflict__c = 'Yes';
                        if(!tmList.isEmpty() && tmList != null)
                            sv.Approver_1__c = tmList[0].Id;
                    } */
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.SV_Date_Time__c = system.now();
                    update convertedOpp;
                    
                    //Tag Site Visit Against Opportunity
                    sv.Opportunity__c = convertedOpp.Id;
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
            } else {
                Lead l = new Lead();
                l.Salutation = sv.Salutation__c;
                l.FirstName = sv.First_Name__c;
                l.LastName = sv.Last_Name__c;
                l.MobilePhone = sv.Mobile__c;
                l.Email = sv.Email__c;
                l.Project__c = pList[0].Id;
                l.Buying_Purpose__c = sv.Buying_Purpose__c;
                l.Purchase_Timeframe__c = sv.Purchase_Timeframe__c;
                l.Possession_Timeframe_Required__c = sv.Possession_Timeframe_Required__c;
                //l.DOB__c = sv.Birth_Date__c;
             //   l.Anniversary_Date__c = sv.Anniversary_Date__c;
                l.Age_Group__c = sv.Age_Group__c;
                l.Occupation__c = sv.Occupation__c;
                l.Designation__c = sv.Designation__c;
                l.Configuration_Required__c = sv.Configuration_Required__c;
                l.Current_Residence_Configuration__c = sv.Current_Residence_Configuration__c;
                l.Budget__c = sv.Budget__c;
                l.Gender__c = sv.Gender__c;
                l.Current_Residence_Status__c = sv.Current_Residence_Status__c;
              //  l.Household_Income_Annual__c = sv.Household_Income_Annual__c;
                l.Master_Source__c = sv.Master_Source__c;
                l.Martial_Status__c = sv.Martial_Status__c;
                l.Lead_Source__c = sv.Lead_Source__c;
                l.Lead_Sub_Source__c = sv.Lead_Sub_Source__c;
                l.Lead_Sub_Source_Details__c = sv.Lead_Sub_source_Details__c;
                l.Other_Source_Details__c = sv.Other_Source_Details__c;
                l.Referrer_Name__c = sv.Referrer_Name__c;
                l.Channel_Partner__c = sv.Channel_Partner__c;
                l.Employee_Referrer_Name__c = sv.Employee_Referrer_Name__c;
               // l.House_No__c = sv.House_No__c;
              //  l.Locality__c = sv.Locality__c;
              //  l.Street = sv.Street_1__c;
              //  if(String.isNotBlank(sv.Street_2__c) && sv.Street_2__c != '')
               //     l.Street += ' '+sv.Street_2__c;
              //  l.Country = sv.Country__c;
             //   l.State = sv.State__c;
             //   l.Country = sv.Country__c;
                l.PostalCode = String.valueOf(sv.Pincode__c);
                
                if(sv.Master_Source__c == 'Recommended by Friends/Relatives' && sv.Lead_Source__c == 'Customers') {
                 l.Referrer_Name__c = sv.Referrer_Name__c;
                } else if(sv.Master_Source__c == 'Recommended by Friends/Relatives' && sv.Lead_Source__c == 'Employees') {
                    l.Employee_Referrer_Name__c = sv.Employee_Referrer_Name__c;
                } else if(sv.Master_Source__c == 'Other' && sv.Lead_Source__c == 'Other') {
                    l.Other_Source_Details__c = sv.Other_Source_Details__c;
                } else if(sv.Master_Source__c == 'Channel Partner' && sv.Lead_Source__c == 'Channel Partner') {
                    l.Channel_Partner__c = sv.Channel_Partner__c;
                } 
                l.Lead_Stage__c = 'Visit Done';
               // l.Lead_Sub_Stage__c = 'Visit Done';
               // l.Lead_Sub_Stage_Reason__c = '';
                
                try {
                    insert l;
                    
                    // Converting Lead to Account & Opportunity
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.setLeadId(l.id);
                    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus where IsConverted = true LIMIT 1];
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    Lead convertedLead = [SELECT ConvertedAccountId, ConvertedOpportunityId from Lead where Id = :l.Id];
                    system.debug('Converted Lead: '+convertedLead);
                    
                    Opportunity convertedOpp =  [SELECT Id,Name,Site_Visit_Count__c, Master_Source__c,Project__c, Lead_Source__c,Lead_Sub_source__c,Lead_Sub_source_Details__c from Opportunity 
                                                 where Id =: convertedLead.ConvertedOpportunityId];
                    system.debug('Converted Opportunity: '+convertedOpp);
                    
                    //Update Opportunity
                    convertedOpp.Site_Visit_Count__c = 1;
                    convertedOpp.SV_Date_Time__c = system.now();
                    update convertedOpp;
                    
                    //Tag Site Visit Against Converted Opportunity
                    sv.Opportunity__c = convertedOpp.Id;
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
        }
    }
    
    public static List<SelectOption> getDependentPicklistValues(Schema.sObjectField dependToken, String controllingFieldValue) {
        system.debug('call getDependentPicklistValues');
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return new List<SelectOption>();
        }
     
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
     
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        List<SelectOption> dependentPicklistValues = new List<SelectOption>();
        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
                List<String> base64chars =
                        String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    Object controlValue =
                            (controlEntries == null
                                    ?   (Object) (index == 1)
                                    :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                            );
                    Integer bitIndex = index / 6;
                    if (bitIndex > base64chars.size() - 1) {
                        break;
                    }
                    Integer bitShift = 5 - Math.mod(index, 6);
                    if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                        continue;
                    system.debug('controllingFieldValue: '+controllingFieldValue);
                    system.debug('(String) controlValue: '+(String) controlValue);
                    system.debug('entry.getLabel(): '+entry.getLabel());
                    if ((String) controlValue == controllingFieldValue) {
                        dependentPicklistValues.add(new selectOption(entry.getLabel(), entry.getValue()));
                    }
                }
            }
        }
        return dependentPicklistValues;
    }
    
    @RemoteAction
    public static List<String> getChannelPartner(String cpName) {
        List<String> cpNameList = new List<String>();
        List<Account> cpList = new List<Account>();
        Id cpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        String QueryString =  'Select Id, Name, Phone from Account where RecordTypeId = \'' + cpRecordTypeId + '\' AND (Name LIKE \'' + cpName + '%\' OR  Phone LIKE \'' + cpName + '%\') ';
        cpList = Database.query(QueryString);
        system.debug('cpList: '+cpList);
        
        if(!cpList.isEmpty() && cpList != null){
            for(Account cp : cpList){
                cpNameList.add(cp.Name+'-'+cp.Phone);
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
    
    /*public Pagereference closeForm() {
        Pagereference pg = new Pagereference('/'+sv.id);
        pg.setredirect(true);
        return pg;
    }*/
    
    public Pagereference closeForm() {
    Pagereference objReference = new Pagereference('/apex/SearchPage?project=');
        objReference.setRedirect(true);
        return objReference;
    
    }
}