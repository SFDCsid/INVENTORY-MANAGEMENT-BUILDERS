//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class SearchPageController {
    public String strProjectId {get;set;}
    public List<SelectOption> lstProjectList {get;set;}
    public Lead__c l {get;set;}
    public List<Account> accList {get;set;}
    public List<Opportunity__c> oppList {get;set;}
    public List<Lead__c> leadList {get;set;}
    public boolean isAccount {get;set;}
    public boolean isLead {get;set;}
    public boolean isOpp {get;set;}
    public boolean isSearch {get;set;}
    
    public SearchPageController() {
        strProjectId = '';
        l = new Lead__c();
        lstProjectList = new List<SelectOption >();
        List <Project__c> listPr = [Select Id, Name from Project__c];
        System.debug('Project ::' + listPr);
        lstProjectList.add(new SelectOption('', '---Please Select Project---'));
        if (listPr != null && listPr.size() > 0) {
            for (Project__c Pr: listPr) {
                lstProjectList.add(new SelectOption(Pr.id, Pr.name));
            }
        } 
        
        accList = new List<Account>();
        oppList = new List<Opportunity__c>();
        leadList = new List<Lead__c>();
        isSearch = false;
        isAccount = false;
        isLead = false;
        isOpp = false; 
    }
    
    public void search() {
        isAccount = false;
        isLead = false;
        isOpp = false; 
    
        if(l.MobilePhone__c != Null && l.MobilePhone__c != '') {
            accList = [Select Id, Name, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, Owner.Name from Account 
                       where (PersonMobilePhone =: l.MobilePhone__c OR Phone =: l.MobilePhone__c) AND IsPersonAccount = true];
            system.debug('accList: '+accList);
            
            if(!accList.isEmpty()) {
                isAccount = true;
                
                oppList = [Select Id, Name, Project__c, Project__r.Name, AccountId__r.PersonMobilePhone, AccountId__r.PersonEmail, Owner.Name from Opportunity__c
                           where AccountId__c =: accList[0].Id AND Project__c =: strProjectId AND IsActive__c = true];
                system.debug('oppList: '+oppList);
                
                if(!oppList.isEmpty()) {
                    isOpp = true;
                }
            } else {
                if(l.Email__c != Null && l.Email__c != '') {
                    accList = [Select Id, Name, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, Owner.Name from Account 
                               where (PersonEmail =: l.Email__c OR Alternate_Email__c =: l.Email__c) AND IsPersonAccount = true];
                    system.debug('accList: '+accList);
                    
                    if(!accList.isEmpty()) {
                        isAccount = true;
                
                        oppList = [Select Id, Name, Project__c, Project__r.Name, AccountId__r.PersonMobilePhone, AccountId__r.PersonEmail, Owner.Name from Opportunity__c
                                   where AccountId__c =: accList[0].Id AND Project__c =: strProjectId AND IsActive__c = true];
                        system.debug('oppList: '+oppList);
                        
                        if(!oppList.isEmpty()) {
                            isOpp = true;
                        }
                    }
                } 
            }
            
            if(oppList.isEmpty()) {
                leadList = [Select Id, Name, MobilePhone__c, Phone__c, Email__c, Alternate_Email__c, Project__c, Project__r.Name, Status__c, Owner.Name from Lead__c 
                            where (MobilePhone__c =: l.MobilePhone__c OR Phone__c =: l.MobilePhone__c) AND Project__c =: strProjectId AND IsConverted__c = false];
                system.debug('leadList: '+leadList);
                
                if(!leadList.isEmpty()) {
                    isLead = true;
                } else {
                    if(l.Email__c != Null && l.Email__c != '') {
                        leadList = [Select Id, Name, MobilePhone__c, Phone__c, Email__c, Alternate_Email__c, Project__c, Project__r.Name, Status__c, Owner.Name from Lead__c
                                    where (Email__c =: l.Email__c OR Alternate_Email__c =: l.Email__c) AND Project__c =: strProjectId AND IsConverted__c = false];
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
        Pagereference objReference = new Pagereference('/apex/SiteVisitForm?project=' + strProjectId +'&mobile='+l.MobilePhone__c+ '&email='+l.email__c);
        objReference.setRedirect(true);
        return objReference;
    }
    
    public PageReference cancel() {
        Pagereference objReference = new Pagereference('/home/home.jsp');
        objReference.setRedirect(true);
        return objReference;
    }
}