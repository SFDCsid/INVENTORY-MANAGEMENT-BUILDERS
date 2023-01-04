public class SearchPageController {
    public String strProjectId {get;set;}
    public List<SelectOption> lstProjectList {get;set;}
    public Lead_c__c l {get;set;}
    public List<Account> accList {get;set;}
    public List<Opportunity_c__c> oppList {get;set;}
    public List<Lead_c__c> leadList {get;set;}
    public boolean isAccount {get;set;}
    public boolean isLead {get;set;}
    public boolean isOpp {get;set;}
    public boolean isSearch {get;set;}
    public DateTime dT {get;set;}
    public Date myDate {get;set;}
    public String sdate {get;set;}
    
    public SearchPageController() {
        strProjectId = '';
        l = new Lead_c__c();
        lstProjectList = new List<SelectOption >();
        List <Project__c> listPr = [Select Id, Name  
                                      from Project__c];
        System.debug('Project ::' + listPr);
        lstProjectList.add(new SelectOption('', '---Please Select Project---'));
        if (listPr != null && listPr.size() > 0) {
            for (Project__c Pr: listPr) {
                lstProjectList.add(new SelectOption(Pr.id, Pr.name));
            }
        } 
        
        accList = new List<Account>();
        oppList = new List<Opportunity_c__c>();
        leadList = new List<Lead_c__c>();
        isSearch = false;
        isAccount = false;
        isLead = false;
        isOpp = false; 
    }
    
    public void search() {
        isAccount = false;
        isLead = false;
        isOpp = false; 
    
        if(l.Mobile__c != Null && l.Mobile__c != '') {
            system.debug('Mobile:' +l.Mobile__c);
            accList = [Select Id, Name, PersonMobilePhone, Phone,RG_Code__c, PersonEmail, Alternate_Email_Id__c, Owner.Name from Account 
                       where (PersonMobilePhone =: l.Mobile__c OR Phone =: l.Mobile__c) AND IsPersonAccount = true];
            system.debug('accList: '+accList);
            
            if(!accList.isEmpty()) {
                isAccount = true;
                
                oppList = [Select Id, Name, Project__c, Project__r.Name,Last_SV_Date__c,Channel_Partner_Account__c,Channel_Partner_Account__r.Name,CP_Account__r.Name,Sales_Manager__c, Account_Name__r.PersonMobilePhone,Account_Name__r.Phone, Account_Name__r.PersonEmail, Master_Source__c, Owner.Name from Opportunity_c__c
                           where Account_Name__c =: accList[0].Id AND Is_Active__c = true]; //AND Project__c =: strProjectId  removed for showing existing opportunity of customer
                system.debug('oppList: '+oppList);
                
                  /* dT = oppList[0].Last_SV_Date__c;
                   myDate = date.newinstance(dT.year(), dT.month(), dT.day());
                   sdate = String.valueOf(myDate);*/

                
                if(!oppList.isEmpty()) {
                    isOpp = true;
                     
                  
                }
            } else {
                if(l.Email__c != Null && l.Email__c != '') {
                    accList = [Select Id, Name, PersonMobilePhone, Phone,RG_Code__c, PersonEmail, Alternate_Email_Id__c, Owner.Name from Account 
                               where (PersonEmail =: l.Email__c OR Alternate_Email_Id__c =: l.Email__c) AND IsPersonAccount = true];
                    system.debug('accList: '+accList);
                    
                    if(!accList.isEmpty()) {
                        isAccount = true;
                
                        oppList = [Select Id, Name, Project__c, Project__r.Name,Last_SV_Date__c,Channel_Partner_Account__c,Channel_Partner_Account__r.Name,Sales_Manager__c,CP_Account__r.Name, Account_Name__r.PersonMobilePhone, Account_Name__r.PersonEmail, Master_Source__c, Owner.Name from Opportunity_c__c
                                   where Account_Name__c =: accList[0].Id AND Is_Active__c = true]; //AND Project__c =: strProjectId removed for showing existing opportunity of customer
                        system.debug('oppList: '+oppList);
                        
                        if(!oppList.isEmpty()) {
                            isOpp = true;
                        }
                    }
                } 
            }
            
            if(oppList.isEmpty()) {
                
                leadList = [Select Id, Name, Mobile__c, Alternate_Mobile_No__c, Email__c,Last_Comment__c,Alternate_Email_Id__c, Project_Name__c, Project_Name__r.Name, Lead_Stage__c, Owner.Name from Lead_c__c 
                            where (Mobile__c =: l.Mobile__c OR Alternate_Mobile_No__c =: l.Mobile__c) /*AND Project_Name__c =: strProjectId*/ AND isConverted__c =: false AND Is_Active__c = true];
                system.debug('leadList: '+leadList);
                
                if(!leadList.isEmpty()) {
                    isLead = true;
                } 
                else {
                    if(l.Email__c != Null && l.Email__c != '') {
                        leadList = [Select Id, Name, Mobile__c, Alternate_Mobile_No__c, Email__c, Alternate_Email_Id__c,Last_Comment__c,Project_Name__c, Project_Name__r.Name, Lead_Stage__c, Owner.Name from Lead_c__c
                                    where (Email__c =: l.Email__c OR Alternate_Email_Id__c =: l.Email__c) /*AND Project_Name__c =: strProjectId*/ AND isConverted__c =: false AND Is_Active__c = true];
                        system.debug('leadList: '+leadList);
                        
                        if(!leadList.isEmpty()) {
                            isLead = true;
                        }
                    }
                    
                }
           
            }
        }
        isSearch = true;
    }
    
    public PageReference continueMethod() {
        if(l.Email__c == Null) {
            l.Email__c = '';
        }
        Pagereference objReference = new Pagereference('/apex/SiteVisitForm?project=' + strProjectId +'&mobile='+l.Mobile__c + '&email='+l.Email__c);
        objReference.setRedirect(true);
        return objReference;
    }
    
    public PageReference cancel() {
        Pagereference objReference = new Pagereference('/home/home.jsp');
        objReference.setRedirect(true);
        return objReference;
    }
}