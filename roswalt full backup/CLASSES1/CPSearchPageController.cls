//By Yogesh Swami 27-02-2022
public  without sharing class CPSearchPageController {
    public String strSearchBy {get;set;}
    public List<SelectOption> searchList {get;set;}
    public Account accSearch {get;set;}
    public List<Account> accList {get;set;}
    public List<Opportunity> oppList {get;set;}
    public boolean isAccount {get;set;}
    public boolean isLead {get;set;}
    public boolean isOpp {get;set;}
    public boolean isSearch {get;set;}


    public String searchRera{get;set;}
    public String paramValueMobile{get;set;}
    public String paramValueAccId{get;set;}
    
    public CPSearchPageController() {
        strSearchBy = '';
        searchRera='';
        paramValueMobile='';
        paramValueAccId='';
        accSearch = new Account();
        searchList = new List<SelectOption >();
        List <Project__c> listPr = [Select Id, Name 
                                      from Project__c];
        System.debug('Project ::' + listPr);
        searchList.add(new SelectOption('', '---Please Select Search Type---'));
        if (listPr != null && listPr.size() > 0) {
            for (Project__c Pr: listPr) {
                searchList.add(new SelectOption(Pr.id, Pr.name));
            }
        } 
        
       
        oppList = new List<Opportunity>();
        isSearch = false;
        isAccount = false;
        isLead = false;
        isOpp = false; 
        
        
    }
    
    public void search() {
        isAccount = false;
        isLead = false;
        isOpp = false; 
        accList = new List<Account>();
        if(accSearch.Phone != Null && accSearch.Phone != '' && accSearch.MahaRERA_Registration_No__c!='' && accSearch.MahaRERA_Registration_No__c!=null) {
            system.debug(accSearch.Phone);
                RecordType rt = new RecordType();
                rt = [Select Id, DeveloperName, Name from RecordType where Name =: 'Channel Partner'];      
                System.debug('Record Type:: '+rt.Name);
            accList = [Select Id, Name,Phone,Point_of_Contact_Name__c,Point_of_Contact_Mobile__c,MahaRERA_Registration_No__c,CP_Type__c,CP_Stage__c,TAN_No__c,CP_Sub_stage__c,CP_Firm_Type__c ,Point_of_Contact__c,Point_of_Contact__r.Name,Alternate_Mobile_No__c,Alternate_Email__c, Email__c,PAN_No__c ,GST_No__c,PAN_Card__c,GST_Registration_Certificate__c,Passport__c,RERA_Certificate__c,Name_as_per_MahaRERA__c,RecordTypeId from Account where (Phone =: accSearch.Phone and  MahaRERA_Registration_No__c =:accSearch.MahaRERA_Registration_No__c) AND RecordTypeId=:rt.id];

            system.debug('accList: '+accList);
            
            if(!accList.isEmpty()) {
                isAccount = true;
            }
            isSearch = true;
        }else{
            if(accSearch.Phone != Null && accSearch.Phone != '') {
            system.debug(accSearch.Phone);
                RecordType rt = new RecordType();
                rt = [Select Id, DeveloperName, Name from RecordType where Name =: 'Channel Partner'];      
                System.debug('Record Type:: '+rt.Name);
            accList = [Select Id, Name,FirstName,LastName,Firm_First_Name__c,Firm_Last_Name__c, Phone,Point_of_Contact_Name__c,Point_of_Contact_Mobile__c, MahaRERA_Registration_No__c,CP_Type__c,CP_Stage__c,TAN_No__c,CP_Sub_stage__c,CP_Firm_Type__c, Email__c,Point_of_Contact__c,Point_of_Contact__r.Name,Alternate_Mobile_No__c,PAN_Card__c,Name_as_per_MahaRERA__c,GST_Registration_Certificate__c,Passport__c,RERA_Certificate__c, Alternate_Email__c,PAN_No__c ,GST_No__c,RecordTypeId from Account where ( Phone =: accSearch.Phone) AND RecordTypeId=:rt.id];

            system.debug('accList: '+accList);
            
            if(!accList.isEmpty()) {
                isAccount = true;
            }
                
                isSearch = true;
            }
            else if(accSearch.MahaRERA_Registration_No__c != Null && accSearch.MahaRERA_Registration_No__c != '') {
            system.debug(accSearch.Phone);
                RecordType rt = new RecordType();
                rt = [Select Id, DeveloperName, Name from RecordType where Name =: 'Channel Partner'];      
                System.debug('Record Type:: '+rt.Name);
            accList = [Select Id, Name,FirstName,LastName,Firm_First_Name__c,Firm_Last_Name__c, Phone,Point_of_Contact_Name__c,Point_of_Contact_Mobile__c, MahaRERA_Registration_No__c,CP_Type__c,CP_Stage__c,TAN_No__c,CP_Sub_stage__c,CP_Firm_Type__c, Email__c,Point_of_Contact__c,Point_of_Contact__r.Name,Alternate_Mobile_No__c,PAN_Card__c,Name_as_per_MahaRERA__c,GST_Registration_Certificate__c,Passport__c,RERA_Certificate__c, Alternate_Email__c,PAN_No__c ,GST_No__c,RecordTypeId from Account where ( MahaRERA_Registration_No__c =: accSearch.MahaRERA_Registration_No__c) AND RecordTypeId=:rt.id];

            system.debug('accList: '+accList);
            
            if(!accList.isEmpty()) {
                isAccount = true;
                
            }   isSearch = true;
            }
            else{
                isSearch = false;
            }
        }
    }
    
    public PageReference continueMethod() {
       
        Pagereference objReference = new Pagereference('/apex/CPFORM?type=create&mobile='+accSearch.Phone+'&reraId='+accSearch.MahaRERA_Registration_No__c);
        objReference.setRedirect(true);
        return objReference;
    }  
     public PageReference editMethod() {
            system.debug('Params: mobile: '+paramValueMobile+' accId: '+paramValueAccId);
        Pagereference objReference = new Pagereference('/apex/CPFORM?type=edit&mobile='+paramValueMobile+'&accId='+paramValueAccId);
        objReference.setRedirect(true);
        return objReference;
    }  
}