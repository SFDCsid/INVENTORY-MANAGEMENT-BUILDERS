public class SearchPageController {
    public String strProjectId {get;set;}
    public String strCluster {get;set;}
    public List<SelectOption> lstProjectList {get;set;}
    public Lead l {get;set;}
    public List<Account> accList {get;set;}
    public List<Opportunity> oppList {get;set;}
    public List<Lead> leadList {get;set;}
    public boolean isAccount {get;set;}
    public boolean isLead {get;set;}
    public boolean isOpp {get;set;}
    public boolean isSearch {get;set;}
    
    public SearchPageController() {
        strProjectId = '';
        strCluster = '';
        l = new Lead();
        lstProjectList = new List<SelectOption >();
        List <Project__c> listPr = [Select Id, Name, Address__c, Cluster__c 
                                      from Project__c];
        System.debug('Project ::' + listPr);
        lstProjectList.add(new SelectOption('', '---Please Select Project---'));
        if (listPr != null && listPr.size() > 0) {
            for (Project__c Pr: listPr) {
                lstProjectList.add(new SelectOption(Pr.id, Pr.name));
            }
        } 
        
        accList = new List<Account>();
        oppList = new List<Opportunity>();
        leadList = new List<Lead>();
        isSearch = false;
        isAccount = false;
        isLead = false;
        isOpp = false; 
    }
    
    public void search() {
        isAccount = false;
        isLead = false;
        isOpp = false; 
    	
        if(strProjectId != null && strProjectId != '') {
            List<Project__c> pList = [Select Id, Name, Cluster__c from Project__c where Id =: strProjectId];
            if(pList != null) {
                strCluster = pList[0].Cluster__c;
            }
        }
        
        if(l.MobilePhone != Null && l.MobilePhone != '') {
            system.debug(l.MobilePhone);
            accList = [Select Id, Name, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, Owner.Name from Account 
                       where (PersonMobilePhone =: l.MobilePhone OR Phone =: l.MobilePhone) AND IsPersonAccount = true];
            system.debug('accList: '+accList);
            
            if(!accList.isEmpty()) {
                isAccount = true;
                
                oppList = [Select Id, Name, Project__c, Project__r.Name, Account.PersonMobilePhone, Account.PersonEmail, Master_Source__c, Owner.Name, Last_Presale_Call_Date__c from Opportunity
                           where AccountId =: accList[0].Id AND Cluster__c =: strCluster AND Is_Active__c = true];
                system.debug('oppList: '+oppList);
                
                if(!oppList.isEmpty()) {
                    isOpp = true;
                }
            } else {
                if(l.Email != Null && l.Email != '') {
                    accList = [Select Id, Name, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, Owner.Name from Account 
                               where (PersonEmail =: l.Email OR Alternate_Email__c =: l.Email) AND IsPersonAccount = true];
                    system.debug('accList: '+accList);
                    
                    if(!accList.isEmpty()) {
                        isAccount = true;
                
                        oppList = [Select Id, Name, Project__c, Project__r.Name, Account.PersonMobilePhone, Account.PersonEmail, Master_Source__c, Owner.Name, Last_Presale_Call_Date__c 
                                   from Opportunity
                                   where AccountId =: accList[0].Id AND Cluster__c =: strCluster AND Is_Active__c = true];
                        system.debug('oppList: '+oppList);
                        
                        if(!oppList.isEmpty()) {
                            isOpp = true;
                        }
                    }
                } 
            }
            
            if(oppList.isEmpty()) {
                leadList = [Select Id, Name, MobilePhone, Phone, Email, Alternate_Email__c, Project__c, Project__r.Name, Status, Last_Presale_Call_Date__c, Owner.Name from Lead 
                            where (MobilePhone =: l.MobilePhone OR Phone =: l.MobilePhone) AND Cluster__c =: strCluster AND isConverted = false AND Is_Active__c = true];
                system.debug('leadList: '+leadList);
                
                if(!leadList.isEmpty()) {
                    isLead = true;
                } else {
                    if(l.Email != Null && l.Email != '') {
                        leadList = [Select Id, Name, MobilePhone, Phone, Email, Alternate_Email__c, Project__c, Project__r.Name, Status, Last_Presale_Call_Date__c, Owner.Name from Lead
                                        where (Email =: l.Email OR Alternate_Email__c =: l.Email) AND Cluster__c =: strCluster AND isConverted = false AND Is_Active__c = true];
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
        if(l.Email == Null) {
            l.Email = '';
        }
        Pagereference objReference = new Pagereference('/apex/SiteVisitForm?project=' + strProjectId +'&mobile='+l.MobilePhone + '&email='+l.email);
        objReference.setRedirect(true);
        return objReference;
    }
    
    public PageReference cancel() {
        Pagereference objReference = new Pagereference('/home/home.jsp');
        objReference.setRedirect(true);
        return objReference;
    }
}