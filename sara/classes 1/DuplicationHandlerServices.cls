public class DuplicationHandlerServices {
    public static Map<Lead, List<duplicateWrapper>> duplicationCheck(List<Lead> leadList) {
        Map<Lead, List<duplicateWrapper>> duplicateWrapperMap = new Map<Lead, List<duplicateWrapper>>();
        Map<Lead, List<Opportunity>> oppDuplicateMapMobileWithProject = new Map<Lead, List<Opportunity>>();
        Map<Lead, List<Opportunity>> oppDuplicateMapEmailWithProject = new Map<Lead, List<Opportunity>>();
        Map<Lead, List<Opportunity>> oppDuplicateMapPhoneWithProject = new Map<Lead, List<Opportunity>>();
        Map<Lead, List<Opportunity>> oppDuplicateMapAlternateEmailWithProject = new Map<Lead, List<Opportunity>>();
        Map<Lead, List<Lead>> leadDuplicateMapMobileWithProject = new Map<Lead, List<Lead>>();
        Map<Lead, List<Lead>> leadDuplicateMapEmailWithProject = new Map<Lead, List<Lead>>();
        Map<Lead, List<Lead>> leadDuplicateMapPhoneWithProject = new Map<Lead, List<Lead>>();
        Map<Lead, List<Lead>> leadDuplicateMapAlternateEmailWithProject = new Map<Lead, List<Lead>>();
        
        oppDuplicateMapMobileWithProject = accountOppDuplicateCheckByMobileWithProject(leadList);
        system.debug('oppDuplicateMapMobileWithProject: '+oppDuplicateMapMobileWithProject);
        
        if(!oppDuplicateMapMobileWithProject.isEmpty() && oppDuplicateMapMobileWithProject != null) {
            for(Lead l: oppDuplicateMapMobileWithProject.keySet()) {
                List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                for(Opportunity dupOpp: oppDuplicateMapMobileWithProject.get(l)) {
                    dwList.add(new duplicateWrapper('Opportunity', null, dupOpp));
                }
                duplicateWrapperMap.put(l, dwList);
            }
        } else {
        	oppDuplicateMapEmailWithProject = accountOppDuplicateCheckByEmailWithProject(leadList);
            system.debug('oppDuplicateMapEmailWithProject: '+oppDuplicateMapEmailWithProject);
            
            if(!oppDuplicateMapEmailWithProject.isEmpty() && oppDuplicateMapEmailWithProject != null) {
                for(Lead l: oppDuplicateMapEmailWithProject.keySet()) {
                    List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                    for(Opportunity dupOpp: oppDuplicateMapEmailWithProject.get(l)) {
                        dwList.add(new duplicateWrapper('Opportunity', null, dupOpp));
                    }
                    duplicateWrapperMap.put(l, dwList);
                }
            } else {
                oppDuplicateMapPhoneWithProject = accountOppDuplicateCheckByPhoneWithProject(leadList);
                system.debug('oppDuplicateMapPhoneWithProject: '+oppDuplicateMapPhoneWithProject);
                
                if(!oppDuplicateMapPhoneWithProject.isEmpty() && oppDuplicateMapPhoneWithProject != null) {
                    for(Lead l: oppDuplicateMapPhoneWithProject.keySet()) {
                        List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                        for(Opportunity dupOpp: oppDuplicateMapPhoneWithProject.get(l)) {
                            dwList.add(new duplicateWrapper('Opportunity', null, dupOpp));
                        }
                        duplicateWrapperMap.put(l, dwList);
                    }
                } else {
                    oppDuplicateMapAlternateEmailWithProject = accountOppDuplicateCheckByAlternateEmailWithProject(leadList);
                    system.debug('oppDuplicateMapAlternateEmailWithProject: '+oppDuplicateMapAlternateEmailWithProject);
                    
                    if(!oppDuplicateMapAlternateEmailWithProject.isEmpty() && oppDuplicateMapAlternateEmailWithProject != null) {
                        for(Lead l: oppDuplicateMapAlternateEmailWithProject.keySet()) {
                            List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                            for(Opportunity dupOpp: oppDuplicateMapAlternateEmailWithProject.get(l)) {
                                dwList.add(new duplicateWrapper('Opportunity', null, dupOpp));
                            }
                            duplicateWrapperMap.put(l, dwList);
                        }
                    } else {
                        leadDuplicateMapMobileWithProject = leadDuplicateCheckByMobileWithProject(leadList);
                        system.debug('leadDuplicateMapMobileWithProject: '+leadDuplicateMapMobileWithProject);
                    
                        if(!leadDuplicateMapMobileWithProject.isEmpty() && leadDuplicateMapMobileWithProject != null) {
                            for(Lead l: leadDuplicateMapMobileWithProject.keySet()) {
                                List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                                for(Lead dupLead: leadDuplicateMapMobileWithProject.get(l)) {
                                    dwList.add(new duplicateWrapper('Lead', dupLead, null));
                                }
                                duplicateWrapperMap.put(l, dwList);
                            }
                        } else {
                            leadDuplicateMapEmailWithProject = leadDuplicateCheckByEmailWithProject(leadList);
                            system.debug('leadDuplicateMapEmailWithProject: '+leadDuplicateMapEmailWithProject);
                            
                            if(!leadDuplicateMapEmailWithProject.isEmpty() && leadDuplicateMapEmailWithProject != null) {
                                for(Lead l: leadDuplicateMapEmailWithProject.keySet()) {
                                    List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                                    for(Lead dupLead: leadDuplicateMapEmailWithProject.get(l)) {
                                        dwList.add(new duplicateWrapper('Lead', dupLead, null));
                                    }
                                    duplicateWrapperMap.put(l, dwList);
                                }
                            } else {
                                leadDuplicateMapPhoneWithProject = leadDuplicateCheckByPhoneWithProject(leadList);
                                system.debug('leadDuplicateMapPhoneWithProject: '+leadDuplicateMapPhoneWithProject);
                                
                                if(!leadDuplicateMapPhoneWithProject.isEmpty() && leadDuplicateMapPhoneWithProject != null) {
                                    for(Lead l: leadDuplicateMapPhoneWithProject.keySet()) {
                                        List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                                        for(Lead dupLead: leadDuplicateMapPhoneWithProject.get(l)) {
                                            dwList.add(new duplicateWrapper('Lead', dupLead, null));
                                        }
                                        duplicateWrapperMap.put(l, dwList);
                                    }
                                } else {
                                    leadDuplicateMapAlternateEmailWithProject = leadDuplicateCheckByAlternateEmailWithProject(leadList);
                                    system.debug('leadDuplicateMapAlternateEmailWithProject: '+leadDuplicateMapAlternateEmailWithProject);
                                    
                                    if(!leadDuplicateMapAlternateEmailWithProject.isEmpty() && leadDuplicateMapAlternateEmailWithProject != null) {
                                        for(Lead l: leadDuplicateMapAlternateEmailWithProject.keySet()) {
                                            List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                                            for(Lead dupLead: leadDuplicateMapAlternateEmailWithProject.get(l)) {
                                                dwList.add(new duplicateWrapper('Lead', dupLead, null));
                                            }
                                            duplicateWrapperMap.put(l, dwList);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return duplicateWrapperMap;
    }
    
    public static Map<Account, List<duplicateWrapper>> duplicationCheckAcccount(List<Account> accountList) {
        Map<Account, List<duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<duplicateWrapper>>();
        Map<Account, List<Account>> accountDuplicateMapMobile = new Map<Account, List<Account>>();
        Map<Account, List<Account>> accountDuplicateMapEmail = new Map<Account, List<Account>>();
        Map<Account, List<Account>> accountDuplicateMapPhone = new Map<Account, List<Account>>();
        Map<Account, List<Account>> accountDuplicateMapAlternateEmail = new Map<Account, List<Account>>();
        
        accountDuplicateMapMobile = accountDuplicateCheckByMobile(accountList);
        system.debug('accountDuplicateMapMobile: '+accountDuplicateMapMobile);
        
        if(!accountDuplicateMapMobile.isEmpty() && accountDuplicateMapMobile != null) {
            for(Account a: accountDuplicateMapMobile.keySet()) {
                List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                for(Account dupAccount: accountDuplicateMapMobile.get(a)) {
                    dwList.add(new duplicateWrapper('Account', dupAccount));
                }
                duplicateWrapperMap.put(a, dwList);
            }
        } else {
            accountDuplicateMapEmail = accountDuplicateCheckByEmail(accountList);
            system.debug('accountDuplicateMapEmail: '+accountDuplicateMapEmail);
            
            if(!accountDuplicateMapEmail.isEmpty() && accountDuplicateMapEmail != null) {
                for(Account a: accountDuplicateMapEmail.keySet()) {
                    List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                    for(Account dupAccount: accountDuplicateMapEmail.get(a)) {
                        dwList.add(new duplicateWrapper('Account', dupAccount));
                    }
                    duplicateWrapperMap.put(a, dwList);
                }
            } else {
                accountDuplicateMapPhone = accountDuplicateCheckByPhone(accountList);
                system.debug('accountDuplicateMapPhone: '+accountDuplicateMapPhone);
                
                if(!accountDuplicateMapPhone.isEmpty() && accountDuplicateMapPhone != null) {
                    for(Account a: accountDuplicateMapPhone.keySet()) {
                        List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                        for(Account dupAccount: accountDuplicateMapPhone.get(a)) {
                            dwList.add(new duplicateWrapper('Account', dupAccount));
                        }
                        duplicateWrapperMap.put(a, dwList);
                    }
                } else {
                    accountDuplicateMapAlternateEmail = accountDuplicateCheckByAlternateEmail(accountList);
                    system.debug('accountDuplicateMapAlternateEmail: '+accountDuplicateMapAlternateEmail);
                    
                    if(!accountDuplicateMapAlternateEmail.isEmpty() && accountDuplicateMapAlternateEmail != null) {
                        for(Account a: accountDuplicateMapAlternateEmail.keySet()) {
                            List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                            for(Account dupAccount: accountDuplicateMapAlternateEmail.get(a)) {
                                dwList.add(new duplicateWrapper('Account', dupAccount));
                            }
                            duplicateWrapperMap.put(a, dwList);
                        }
                    }
                }
            }
        }
        return duplicateWrapperMap;
    }
    
    public static Map<Opportunity, List<Opportunity>> duplicationCheckOpportunity(List<Opportunity> opportunityList) {
        Map<Opportunity, List<Opportunity>> oppDuplicateMap = new Map<Opportunity, List<Opportunity>>();
        Map<String, List<Opportunity>> incomingOpportunityAccountMap = new Map<String, List<Opportunity>>();
        Map<String, List<Opportunity>> incomingOpportunityAccountWithProjectMap = new Map<String, List<Opportunity>>();
        Map<String, List<Opportunity>> duplicateMapOppotunityWithProject = new Map<String, List<Opportunity>>();
        List<Opportunity> duplicateOpportunityList = new List<Opportunity>();
        Set<Id> incomingOpportunityIdSet = new Set<Id>();
        
        for(Opportunity op: opportunityList) {
            if(!incomingOpportunityAccountMap.containsKey(op.AccountId)) {
                List<Opportunity> newOppList = new List<Opportunity>();
                newOppList.add(op);
                incomingOpportunityAccountMap.put(op.AccountId, newOppList);
            } else {
				incomingOpportunityAccountMap.get(op.AccountId).add(op);
            }
            if(!incomingOpportunityAccountWithProjectMap.containsKey(op.AccountId+'-'+op.Project__c)) {
                List<Opportunity> newOppList = new List<Opportunity>();
                newOppList.add(op);
                incomingOpportunityAccountWithProjectMap.put(op.AccountId+'-'+op.Project__c, newOppList);
            } else {
				incomingOpportunityAccountWithProjectMap.get(op.AccountId+'-'+op.Project__c).add(op);
            }
            if(op.Id != null)
                incomingOpportunityIdSet.add(op.Id);
        }
        
        if(!incomingOpportunityAccountMap.isEmpty() && incomingOpportunityAccountMap != null) {
            duplicateOpportunityList = [Select Id, Name, AccountId, Project__c, Cluster__c, Opportunity_Id__c from Opportunity 
                     					where AccountId IN: incomingOpportunityAccountMap.keySet() AND Id NOT IN: incomingOpportunityIdSet AND Is_Active__c = true];
            system.debug('duplicateOpportunityList: '+duplicateOpportunityList);
            
            if(!duplicateOpportunityList.isEmpty() && duplicateOpportunityList != null) {
                for(Opportunity dupOpp: duplicateOpportunityList) {
                    if(!duplicateMapOppotunityWithProject.containsKey(dupOpp.AccountId+'-'+dupOpp.Project__c)) {
                        List<Opportunity> newOppList = new List<Opportunity>();
                        newOppList.add(dupOpp);
                        duplicateMapOppotunityWithProject.put(dupOpp.AccountId+'-'+dupOpp.Project__c, newOppList);
                    } else {
                        duplicateMapOppotunityWithProject.get(dupOpp.AccountId+'-'+dupOpp.Project__c).add(dupOpp);
                    }
                }
            }
            
            for(String oppWithProject: incomingOpportunityAccountWithProjectMap.keySet()) {
                if(duplicateMapOppotunityWithProject.containsKey(oppWithProject)) {
                    for(Opportunity opp: incomingOpportunityAccountWithProjectMap.get(oppWithProject)) {
                        oppDuplicateMap.put(opp, duplicateMapOppotunityWithProject.get(oppWithProject));
                    }
                }
            }
        }
        return oppDuplicateMap;
    }
    
    public static Map<Lead, List<Opportunity>> accountOppDuplicateCheckByMobileWithProject(List<Lead> leadList) {
        Map<Lead, List<Opportunity>> oppDuplicateMapMobileWithProject = new Map<Lead, List<Opportunity>>();
        Map<String, List<Lead>> incomingLeadMobileMap = new Map<String, List<Lead>>();
        Map<String, List<Lead>> incomingLeadMobileWithProjectMap = new Map<String, List<Lead>>();
        Map<String, List<Opportunity>> duplicateMapMobileWithProject = new Map<String, List<Opportunity>>();
        List<Opportunity> duplicateOpportunityList = new List<Opportunity>();
        
        incomingLeadMobileMap = getIncomingLeadMap('Mobile', leadList);
        incomingLeadMobileWithProjectMap = getIncomingLeadWithProjectMap('Mobile', leadList);

        if(!incomingLeadMobileMap.isEmpty() && incomingLeadMobileMap != null) {
            duplicateOpportunityList = [Select Id, Name, AccountId, Account.PersonContactId, Account.FirstName, Account.LastName, Account.PersonMobilePhone, Account.Phone, Account.PersonEmail, Account.Alternate_Email__c, Project__c, Cluster__c, Opportunity_Id__c from Opportunity 
                     					where Account.PersonMobilePhone IN: incomingLeadMobileMap.keySet() AND Is_Active__c = true];
            system.debug('duplicateOpportunityList: '+duplicateOpportunityList);
            
            if(!duplicateOpportunityList.isEmpty() && duplicateOpportunityList != null) {
                for(Opportunity dupOpp: duplicateOpportunityList) {
                    if(!duplicateMapMobileWithProject.containsKey(dupOpp.Account.PersonMobilePhone+'-'+dupOpp.Cluster__c)) {
                        List<Opportunity> newOppList = new List<Opportunity>();
                        newOppList.add(dupOpp);
                        duplicateMapMobileWithProject.put(dupOpp.Account.PersonMobilePhone+'-'+dupOpp.Cluster__c, newOppList);
                    } else {
                        duplicateMapMobileWithProject.get(dupOpp.Account.PersonMobilePhone+'-'+dupOpp.Cluster__c).add(dupOpp);
                    }
                }
            }
            
            for(String mobileWithProject: incomingLeadMobileWithProjectMap.keySet()) {
                if(duplicateMapMobileWithProject.containsKey(mobileWithProject)) {
                    for(Lead l: incomingLeadMobileWithProjectMap.get(mobileWithProject)) {
                        oppDuplicateMapMobileWithProject.put(l, duplicateMapMobileWithProject.get(mobileWithProject));
                    }
                }
            }
        }
        return oppDuplicateMapMobileWithProject;
    }
    
    public static Map<Lead, List<Opportunity>> accountOppDuplicateCheckByEmailWithProject(List<Lead> leadList) {
        Map<Lead, List<Opportunity>> oppDuplicateMapEmailWithProject = new Map<Lead, List<Opportunity>>();
        Map<String, List<Lead>> incomingLeadEmailMap = new Map<String, List<Lead>>();
        Map<String, List<Lead>> incomingLeadEmailWithProjectMap = new Map<String, List<Lead>>();
        Map<String, List<Opportunity>> duplicateMapEmailWithProject = new Map<String, List<Opportunity>>();
        List<Opportunity> duplicateOpportunityList = new List<Opportunity>();
        
        incomingLeadEmailMap = getIncomingLeadMap('Email', leadList);
        incomingLeadEmailWithProjectMap = getIncomingLeadWithProjectMap('Email', leadList);

        if(!incomingLeadEmailMap.isEmpty() && incomingLeadEmailMap != null) {
            duplicateOpportunityList = [Select Id, Name, AccountId, Account.PersonContactId, Account.FirstName, Account.LastName, Account.PersonMobilePhone, Account.Phone, Account.PersonEmail, Account.Alternate_Email__c, Project__c, Cluster__c, Opportunity_Id__c from Opportunity 
                     					where Account.PersonEmail IN: incomingLeadEmailMap.keySet() AND Is_Active__c = true];
            system.debug('duplicateOpportunityList: '+duplicateOpportunityList);
            
            if(!duplicateOpportunityList.isEmpty() && duplicateOpportunityList != null) {
                for(Opportunity dupOpp: duplicateOpportunityList) {
                    if(!duplicateMapEmailWithProject.containsKey(dupOpp.Account.PersonEmail+'-'+dupOpp.Cluster__c)) {
                        List<Opportunity> newOppList = new List<Opportunity>();
                        newOppList.add(dupOpp);
                        duplicateMapEmailWithProject.put(dupOpp.Account.PersonEmail+'-'+dupOpp.Cluster__c, newOppList);
                    } else {
                        duplicateMapEmailWithProject.get(dupOpp.Account.PersonEmail+'-'+dupOpp.Cluster__c).add(dupOpp);
                    }
                }
            }
            
            for(String emailWithProject: incomingLeadEmailWithProjectMap.keySet()) {
                if(duplicateMapEmailWithProject.containsKey(emailWithProject)) {
                    for(Lead l: incomingLeadEmailWithProjectMap.get(emailWithProject)) {
                        oppDuplicateMapEmailWithProject.put(l, duplicateMapEmailWithProject.get(emailWithProject));
                    }
                }
            }
        }
        return oppDuplicateMapEmailWithProject;
    }
    
    public static Map<Lead, List<Opportunity>> accountOppDuplicateCheckByPhoneWithProject(List<Lead> leadList) {
        Map<Lead, List<Opportunity>> oppDuplicateMapPhoneWithProject = new Map<Lead, List<Opportunity>>();
        Map<String, List<Lead>> incomingLeadPhoneMap = new Map<String, List<Lead>>();
        Map<String, List<Lead>> incomingLeadPhoneWithProjectMap = new Map<String, List<Lead>>();
        Map<String, List<Opportunity>> duplicateMapPhoneWithProject = new Map<String, List<Opportunity>>();
        List<Opportunity> duplicateOpportunityList = new List<Opportunity>();
        
        incomingLeadPhoneMap = getIncomingLeadMap('Phone', leadList);
        incomingLeadPhoneWithProjectMap = getIncomingLeadWithProjectMap('Phone', leadList);

        if(!incomingLeadPhoneMap.isEmpty() && incomingLeadPhoneMap != null) {
            duplicateOpportunityList = [Select Id, Name, AccountId, Account.PersonContactId, Account.FirstName, Account.LastName, Account.PersonMobilePhone, Account.Phone, Account.PersonEmail, Account.Alternate_Email__c, Project__c, Cluster__c, Opportunity_Id__c from Opportunity 
                     					where Account.Phone IN: incomingLeadPhoneMap.keySet() AND Is_Active__c = true];
            system.debug('duplicateOpportunityList: '+duplicateOpportunityList);
            
            if(!duplicateOpportunityList.isEmpty() && duplicateOpportunityList != null) {
                for(Opportunity dupOpp: duplicateOpportunityList) {
                    if(!duplicateMapPhoneWithProject.containsKey(dupOpp.Account.Phone+'-'+dupOpp.Cluster__c)) {
                        List<Opportunity> newOppList = new List<Opportunity>();
                        newOppList.add(dupOpp);
                        duplicateMapPhoneWithProject.put(dupOpp.Account.Phone+'-'+dupOpp.Cluster__c, newOppList);
                    } else {
                        duplicateMapPhoneWithProject.get(dupOpp.Account.Phone+'-'+dupOpp.Cluster__c).add(dupOpp);
                    }
                }
            }
            
            for(String phoneWithProject: incomingLeadPhoneWithProjectMap.keySet()) {
                if(duplicateMapPhoneWithProject.containsKey(phoneWithProject)) {
                    for(Lead l: incomingLeadPhoneWithProjectMap.get(phoneWithProject)) {
                        oppDuplicateMapPhoneWithProject.put(l, duplicateMapPhoneWithProject.get(phoneWithProject));
                    }
                }
            }
        }
        return oppDuplicateMapPhoneWithProject;
    }
    
    public static Map<Lead, List<Opportunity>> accountOppDuplicateCheckByAlternateEmailWithProject(List<Lead> leadList) {
        Map<Lead, List<Opportunity>> oppDuplicateMapAlternateEmailWithProject = new Map<Lead, List<Opportunity>>();
        Map<String, List<Lead>> incomingLeadAlternateEmailMap = new Map<String, List<Lead>>();
        Map<String, List<Lead>> incomingLeadAlternateEmailWithProjectMap = new Map<String, List<Lead>>();
        Map<String, List<Opportunity>> duplicateMapAlternateEmailWithProject = new Map<String, List<Opportunity>>();
        List<Opportunity> duplicateOpportunityList = new List<Opportunity>();
        
        incomingLeadAlternateEmailMap = getIncomingLeadMap('Alternate Email', leadList);
        incomingLeadAlternateEmailWithProjectMap = getIncomingLeadWithProjectMap('Alternate Email', leadList);

        if(!incomingLeadAlternateEmailMap.isEmpty() && incomingLeadAlternateEmailMap != null) {
            duplicateOpportunityList = [Select Id, Name, AccountId, Account.PersonContactId, Account.FirstName, Account.LastName, Account.PersonMobilePhone, Account.Phone, Account.PersonEmail, Account.Alternate_Email__c, Project__c, Cluster__c, Opportunity_Id__c from Opportunity 
                     					where Account.Alternate_Email__c IN: incomingLeadAlternateEmailMap.keySet() AND Is_Active__c = true];
            system.debug('duplicateOpportunityList: '+duplicateOpportunityList);
            
            if(!duplicateOpportunityList.isEmpty() && duplicateOpportunityList != null) {
                for(Opportunity dupOpp: duplicateOpportunityList) {
                    if(!duplicateMapAlternateEmailWithProject.containsKey(dupOpp.Account.Alternate_Email__c+'-'+dupOpp.Cluster__c)) {
                        List<Opportunity> newOppList = new List<Opportunity>();
                        newOppList.add(dupOpp);
                        duplicateMapAlternateEmailWithProject.put(dupOpp.Account.Alternate_Email__c+'-'+dupOpp.Cluster__c, newOppList);
                    } else {
                        duplicateMapAlternateEmailWithProject.get(dupOpp.Account.Alternate_Email__c+'-'+dupOpp.Cluster__c).add(dupOpp);
                    }
                }
            }
            
            for(String alternateEmailWithProject: incomingLeadAlternateEmailWithProjectMap.keySet()) {
                if(duplicateMapAlternateEmailWithProject.containsKey(alternateEmailWithProject)) {
                    for(Lead l: incomingLeadAlternateEmailWithProjectMap.get(alternateEmailWithProject)) {
                        oppDuplicateMapAlternateEmailWithProject.put(l, duplicateMapAlternateEmailWithProject.get(alternateEmailWithProject));
                    }
                }
            }
        }
        return oppDuplicateMapAlternateEmailWithProject;
    }
    
    public static Map<Lead, List<Lead>> leadDuplicateCheckByMobileWithProject(List<Lead> leadList) {
    	Map<Lead, List<Lead>> leadDuplicateMapMobileWithProject = new Map<Lead, List<Lead>>();
        Map<String, List<Lead>> incomingLeadMobileMap = new Map<String, List<Lead>>();
        Map<String, List<Lead>> incomingLeadMobileWithProjectMap = new Map<String, List<Lead>>();
        Map<String, List<Lead>> duplicateMapMobileWithProject = new Map<String, List<Lead>>();
        List<Lead> duplicateLeadList = new List<Lead>();
        Set<Id> incomingLeadIdSet = new Set<Id>();
        
        incomingLeadMobileMap = getIncomingLeadMap('Mobile', leadList);
        incomingLeadMobileWithProjectMap = getIncomingLeadWithProjectMap('Mobile', leadList);
		incomingLeadIdSet = getLeadIdSet(leadList);
		
        if(!incomingLeadMobileMap.isEmpty() && incomingLeadMobileMap != null) {
            duplicateLeadList = [Select Id, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email__c, Project__c, Cluster__c, Lead_Id__c from Lead 
                     			where MobilePhone IN: incomingLeadMobileMap.keySet() AND Id NOT IN: incomingLeadIdSet AND Is_Active__c = true AND IsConverted = false];
            system.debug('duplicateLeadList: '+duplicateLeadList);
            
            if(!duplicateLeadList.isEmpty() && duplicateLeadList != null) {
                for(Lead dupLead: duplicateLeadList) {
                    if(!duplicateMapMobileWithProject.containsKey(dupLead.MobilePhone+'-'+dupLead.Cluster__c)) {
                        List<Lead> newLeadList = new List<Lead>();
                        newLeadList.add(dupLead);
                        duplicateMapMobileWithProject.put(dupLead.MobilePhone+'-'+dupLead.Cluster__c, newLeadList);
                    } else {
                        duplicateMapMobileWithProject.get(dupLead.MobilePhone+'-'+dupLead.Cluster__c).add(dupLead);
                    }
                }
            }
            
            for(String mobileWithProject: incomingLeadMobileWithProjectMap.keySet()) {
                if(duplicateMapMobileWithProject.containsKey(mobileWithProject)) {
                    for(Lead l: incomingLeadMobileWithProjectMap.get(mobileWithProject)) {
                        leadDuplicateMapMobileWithProject.put(l, duplicateMapMobileWithProject.get(mobileWithProject));
                    }
                }
            }
        }
        return leadDuplicateMapMobileWithProject;
    }
    
    public static Map<Lead, List<Lead>> leadDuplicateCheckByEmailWithProject(List<Lead> leadList) {
    	Map<Lead, List<Lead>> leadDuplicateMapEmailWithProject = new Map<Lead, List<Lead>>();
        Map<String, List<Lead>> incomingLeadEmailMap = new Map<String, List<Lead>>();
        Map<String, List<Lead>> incomingLeadEmailWithProjectMap = new Map<String, List<Lead>>();
        Map<String, List<Lead>> duplicateMapEmailWithProject = new Map<String, List<Lead>>();
        List<Lead> duplicateLeadList = new List<Lead>();
        Set<Id> incomingLeadIdSet = new Set<Id>();
        
        incomingLeadEmailMap = getIncomingLeadMap('Email', leadList);
        incomingLeadEmailWithProjectMap = getIncomingLeadWithProjectMap('Email', leadList);
		incomingLeadIdSet = getLeadIdSet(leadList);
        
        if(!incomingLeadEmailMap.isEmpty() && incomingLeadEmailMap != null) {
            duplicateLeadList = [Select Id, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email__c, Project__c, Cluster__c, Lead_Id__c from Lead 
                     			where Email IN: incomingLeadEmailMap.keySet() AND Id NOT IN: incomingLeadIdSet AND Is_Active__c = true AND IsConverted = false];
            system.debug('duplicateLeadList: '+duplicateLeadList);
            
            if(!duplicateLeadList.isEmpty() && duplicateLeadList != null) {
                for(Lead dupLead: duplicateLeadList) {
                    if(!duplicateMapEmailWithProject.containsKey(dupLead.Email+'-'+dupLead.Cluster__c)) {
                        List<Lead> newLeadList = new List<Lead>();
                        newLeadList.add(dupLead);
                        duplicateMapEmailWithProject.put(dupLead.Email+'-'+dupLead.Cluster__c, newLeadList);
                    } else {
                        duplicateMapEmailWithProject.get(dupLead.Email+'-'+dupLead.Cluster__c).add(dupLead);
                    }
                }
            }
            
            for(String emailWithProject: incomingLeadEmailWithProjectMap.keySet()) {
                if(duplicateMapEmailWithProject.containsKey(emailWithProject)) {
                    for(Lead l: incomingLeadEmailWithProjectMap.get(emailWithProject)) {
                        leadDuplicateMapEmailWithProject.put(l, duplicateMapEmailWithProject.get(emailWithProject));
                    }
                }
            }
        }
        return leadDuplicateMapEmailWithProject;
    }
    
    public static Map<Lead, List<Lead>> leadDuplicateCheckByPhoneWithProject(List<Lead> leadList) {
    	Map<Lead, List<Lead>> leadDuplicateMapPhoneWithProject = new Map<Lead, List<Lead>>();
        Map<String, List<Lead>> incomingLeadPhoneMap = new Map<String, List<Lead>>();
        Map<String, List<Lead>> incomingLeadPhoneWithProjectMap = new Map<String, List<Lead>>();
        Map<String, List<Lead>> duplicateMapPhoneWithProject = new Map<String, List<Lead>>();
        List<Lead> duplicateLeadList = new List<Lead>();
        Set<Id> incomingLeadIdSet = new Set<Id>();
        
        incomingLeadPhoneMap = getIncomingLeadMap('Phone', leadList);
        incomingLeadPhoneWithProjectMap = getIncomingLeadWithProjectMap('Phone', leadList);
		incomingLeadIdSet = getLeadIdSet(leadList);
        
        if(!incomingLeadPhoneMap.isEmpty() && incomingLeadPhoneMap != null) {
            duplicateLeadList = [Select Id, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email__c, Project__c, Cluster__c, Lead_Id__c from Lead 
                     			where Phone IN: incomingLeadPhoneMap.keySet() AND Id NOT IN: incomingLeadIdSet AND Is_Active__c = true AND IsConverted = false];
            system.debug('duplicateLeadList: '+duplicateLeadList);
            
            if(!duplicateLeadList.isEmpty() && duplicateLeadList != null) {
                for(Lead dupLead: duplicateLeadList) {
                    if(!duplicateMapPhoneWithProject.containsKey(dupLead.Phone+'-'+dupLead.Cluster__c)) {
                        List<Lead> newLeadList = new List<Lead>();
                        newLeadList.add(dupLead);
                        duplicateMapPhoneWithProject.put(dupLead.Phone+'-'+dupLead.Cluster__c, newLeadList);
                    } else {
                        duplicateMapPhoneWithProject.get(dupLead.Phone+'-'+dupLead.Cluster__c).add(dupLead);
                    }
                }
            }
            
            for(String phoneWithProject: incomingLeadPhoneWithProjectMap.keySet()) {
                if(duplicateMapPhoneWithProject.containsKey(phoneWithProject)) {
                    for(Lead l: incomingLeadPhoneWithProjectMap.get(phoneWithProject)) {
                        leadDuplicateMapPhoneWithProject.put(l, duplicateMapPhoneWithProject.get(phoneWithProject));
                    }
                }
            }
        }
        return leadDuplicateMapPhoneWithProject;
    }
    
    public static Map<Lead, List<Lead>> leadDuplicateCheckByAlternateEmailWithProject(List<Lead> leadList) {
    	Map<Lead, List<Lead>> leadDuplicateMapAlternateEmailWithProject = new Map<Lead, List<Lead>>();
        Map<String, List<Lead>> incomingLeadAlternateEmailMap = new Map<String, List<Lead>>();
        Map<String, List<Lead>> incomingLeadAlternateEmailWithProjectMap = new Map<String, List<Lead>>();
        Map<String, List<Lead>> duplicateMapAlternateEmailWithProject = new Map<String, List<Lead>>();
        List<Lead> duplicateLeadList = new List<Lead>();
        Set<Id> incomingLeadIdSet = new Set<Id>();
        
        incomingLeadAlternateEmailMap = getIncomingLeadMap('Alternate Email', leadList);
        incomingLeadAlternateEmailWithProjectMap = getIncomingLeadWithProjectMap('Alternate Email', leadList);
		incomingLeadIdSet = getLeadIdSet(leadList);
        
        if(!incomingLeadAlternateEmailMap.isEmpty() && incomingLeadAlternateEmailMap != null) {
            duplicateLeadList = [Select Id, FirstName, LastName, MobilePhone, Phone, Email, Alternate_Email__c, Project__c, Cluster__c, Lead_Id__c from Lead 
                     			where Alternate_Email__c IN: incomingLeadAlternateEmailMap.keySet() AND Id NOT IN: incomingLeadIdSet AND Is_Active__c = true AND IsConverted = false];
            system.debug('duplicateLeadList: '+duplicateLeadList);
            
            if(!duplicateLeadList.isEmpty() && duplicateLeadList != null) {
                for(Lead dupLead: duplicateLeadList) {
                    if(!duplicateMapAlternateEmailWithProject.containsKey(dupLead.Alternate_Email__c+'-'+dupLead.Cluster__c)) {
                        List<Lead> newLeadList = new List<Lead>();
                        newLeadList.add(dupLead);
                        duplicateMapAlternateEmailWithProject.put(dupLead.Alternate_Email__c+'-'+dupLead.Cluster__c, newLeadList);
                    } else {
                        duplicateMapAlternateEmailWithProject.get(dupLead.Alternate_Email__c+'-'+dupLead.Cluster__c).add(dupLead);
                    }
                }
            }
            
            for(String alternateEmailWithProject: incomingLeadAlternateEmailWithProjectMap.keySet()) {
                if(duplicateMapAlternateEmailWithProject.containsKey(alternateEmailWithProject)) {
                    for(Lead l: incomingLeadAlternateEmailWithProjectMap.get(alternateEmailWithProject)) {
                        leadDuplicateMapAlternateEmailWithProject.put(l, duplicateMapAlternateEmailWithProject.get(alternateEmailWithProject));
                    }
                }
            }
        }
        return leadDuplicateMapAlternateEmailWithProject;
    }
	
	public static Map<String, List<Lead>> getIncomingLeadMap(String Type, List<Lead> leadList) {
        Map<String, List<Lead>> incomingLeadMap = new Map<String, List<Lead>>();
        
        if(Type.equalsIgnoreCase('Mobile') || Type.equalsIgnoreCase('Phone')) {
            for(Lead l: leadList) {
                if(l.MobilePhone != null) {
                    if(!incomingLeadMap.containsKey(l.MobilePhone)) {
                        List<Lead> newLeadList = new List<Lead>();
                        newLeadList.add(l);
                        incomingLeadMap.put(l.MobilePhone, newLeadList);
                    } else {
                        incomingLeadMap.get(l.MobilePhone).add(l);
                    }
                }
                if(l.Phone != null) {
                    if(!incomingLeadMap.containsKey(l.Phone)) {
                        List<Lead> newLeadList = new List<Lead>();
                        newLeadList.add(l);
                        incomingLeadMap.put(l.Phone, newLeadList);
                    } else {
                        incomingLeadMap.get(l.Phone).add(l);
                    }
                }
            }
        } else if(Type.equalsIgnoreCase('Email') || Type.equalsIgnoreCase('Alternate Email')) {
            for(Lead l: leadList) {
                if(l.Email != null) {
                    if(!incomingLeadMap.containsKey(l.Email)) {
                        List<Lead> newLeadList = new List<Lead>();
                        newLeadList.add(l);
                        incomingLeadMap.put(l.Email, newLeadList);
                    } else {
                        incomingLeadMap.get(l.Email).add(l);
                    }
                }
                if(l.Alternate_Email__c != null) {
                    if(!incomingLeadMap.containsKey(l.Alternate_Email__c)) {
                        List<Lead> newLeadList = new List<Lead>();
                        newLeadList.add(l);
                        incomingLeadMap.put(l.Alternate_Email__c, newLeadList);
                    } else {
                        incomingLeadMap.get(l.Alternate_Email__c).add(l);
                    }
                }
            }
        } else {
            
        }
        return incomingLeadMap;
    }
    
    public static Map<String, List<Lead>> getIncomingLeadWithProjectMap(String Type, List<Lead> leadList) {
        Map<String, List<Lead>> incomingLeadWithProjectMap = new Map<String, List<Lead>>();
        
        if(Type.equalsIgnoreCase('Mobile') || Type.equalsIgnoreCase('Phone')) {
            for(Lead l: leadList) {
                if(l.MobilePhone != null) {
                    if(!incomingLeadWithProjectMap.containsKey(l.MobilePhone+'-'+l.Cluster__c)) {
                        List<Lead> newLeadList = new List<Lead>();
                        newLeadList.add(l);
                        incomingLeadWithProjectMap.put(l.MobilePhone+'-'+l.Cluster__c, newLeadList);
                    } else {
                        incomingLeadWithProjectMap.get(l.MobilePhone+'-'+l.Cluster__c).add(l);
                    }
                }
                if(l.Phone != null) {
                    if(!incomingLeadWithProjectMap.containsKey(l.Phone+'-'+l.Cluster__c)) {
                        List<Lead> newLeadList = new List<Lead>();
                        newLeadList.add(l);
                        incomingLeadWithProjectMap.put(l.Phone+'-'+l.Cluster__c, newLeadList);
                    } else {
                        incomingLeadWithProjectMap.get(l.Phone+'-'+l.Cluster__c).add(l);
                    }
                }
            }
        } else if(Type.equalsIgnoreCase('Email') || Type.equalsIgnoreCase('Alternate Email')) {
            for(Lead l: leadList) {
                if(l.Email != null) {
                    if(!incomingLeadWithProjectMap.containsKey(l.Email+'-'+l.Cluster__c)) {
                        List<Lead> newLeadList = new List<Lead>();
                        newLeadList.add(l);
                        incomingLeadWithProjectMap.put(l.Email+'-'+l.Cluster__c, newLeadList);
                    } else {
                        incomingLeadWithProjectMap.get(l.Email+'-'+l.Cluster__c).add(l);
                    }
                }
                if(l.Alternate_Email__c != null) {
                    if(!incomingLeadWithProjectMap.containsKey(l.Alternate_Email__c+'-'+l.Cluster__c)) {
                        List<Lead> newLeadList = new List<Lead>();
                        newLeadList.add(l);
                        incomingLeadWithProjectMap.put(l.Alternate_Email__c+'-'+l.Cluster__c, newLeadList);
                    } else {
                        incomingLeadWithProjectMap.get(l.Alternate_Email__c+'-'+l.Cluster__c).add(l);
                    }
                }
            }
        } else {
            
        }
        return incomingLeadWithProjectMap;
    }
    
    public static Set<Id> getLeadIdSet(List<Lead> leadList) {
        Set<Id> leadIdSet = new Set<Id>();
        
        for(Lead l: leadList) {
            leadIdSet.add(l.Id);
        }
        return leadIdSet;
    }
    
    public static Map<Account, List<Account>> accountDuplicateCheckByMobile(List<Account> accountList) {
    	Map<Account, List<Account>> accountDuplicateMapMobile = new Map<Account, List<Account>>();
        Map<String, List<Account>> incomingAccountMobileMap = new Map<String, List<Account>>();
        Map<String, List<Account>> duplicateMapMobile = new Map<String, List<Account>>();
        List<Account> duplicateAccountList = new List<Account>();
        Set<Id> incomingAccountIdSet = new Set<Id>();
        
        incomingAccountMobileMap = getIncomingAccountMap('Mobile', accountList);
		incomingAccountIdSet = getAccountIdSet(accountList);

        if(!incomingAccountMobileMap.isEmpty() && incomingAccountMobileMap != null) {
            duplicateAccountList = [Select Id, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, Account_Id__c from Account 
                     				where PersonMobilePhone IN: incomingAccountMobileMap.keySet() AND Id NOT IN: incomingAccountIdSet AND IsPersonAccount = true];
            system.debug('duplicateAccountList: '+duplicateAccountList);
            
            if(!duplicateAccountList.isEmpty() && duplicateAccountList != null) {
                for(Account dupAccount: duplicateAccountList) {
                    if(!duplicateMapMobile.containsKey(dupAccount.PersonMobilePhone)) {
                        List<Account> newAccountList = new List<Account>();
                        newAccountList.add(dupAccount);
                        duplicateMapMobile.put(dupAccount.PersonMobilePhone, newAccountList);
                    } else {
                        duplicateMapMobile.get(dupAccount.PersonMobilePhone).add(dupAccount);
                    }
                }
            }
            
            for(String mobile: incomingAccountMobileMap.keySet()) {
                if(duplicateMapMobile.containsKey(mobile)) {
                    for(Account a: incomingAccountMobileMap.get(mobile)) {
                        accountDuplicateMapMobile.put(a, duplicateMapMobile.get(mobile));
                    }
                }
            }
        }
        return accountDuplicateMapMobile;
    }
    
    public static Map<Account, List<Account>> accountDuplicateCheckByEmail(List<Account> accountList) {
    	Map<Account, List<Account>> accountDuplicateMapEmail = new Map<Account, List<Account>>();
        Map<String, List<Account>> incomingAccountEmailMap = new Map<String, List<Account>>();
        Map<String, List<Account>> duplicateMapEmail = new Map<String, List<Account>>();
        List<Account> duplicateAccountList = new List<Account>();
        Set<Id> incomingAccountIdSet = new Set<Id>();
        
        incomingAccountEmailMap = getIncomingAccountMap('Email', accountList);
		incomingAccountIdSet = getAccountIdSet(accountList);
        
        if(!incomingAccountEmailMap.isEmpty() && incomingAccountEmailMap != null) {
            duplicateAccountList = [Select Id, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, Account_Id__c from Account 
                     				where PersonEmail IN: incomingAccountEmailMap.keySet() AND Id NOT IN: incomingAccountIdSet AND IsPersonAccount = true];
            system.debug('duplicateAccountList: '+duplicateAccountList);
            
            if(!duplicateAccountList.isEmpty() && duplicateAccountList != null) {
                for(Account dupAccount: duplicateAccountList) {
                    if(!duplicateMapEmail.containsKey(dupAccount.PersonEmail)) {
                        List<Account> newAccountList = new List<Account>();
                        newAccountList.add(dupAccount);
                        duplicateMapEmail.put(dupAccount.PersonEmail, newAccountList);
                    } else {
                        duplicateMapEmail.get(dupAccount.PersonEmail).add(dupAccount);
                    }
                }
            }
            
            for(String email: incomingAccountEmailMap.keySet()) {
                if(duplicateMapEmail.containsKey(email)) {
                    for(Account a: incomingAccountEmailMap.get(email)) {
                        accountDuplicateMapEmail.put(a, duplicateMapEmail.get(email));
                    }
                }
            }
        }
        return accountDuplicateMapEmail;
    }
    
    public static Map<Account, List<Account>> accountDuplicateCheckByPhone(List<Account> accountList) {
    	Map<Account, List<Account>> accountDuplicateMapPhone = new Map<Account, List<Account>>();
        Map<String, List<Account>> incomingAccountPhoneMap = new Map<String, List<Account>>();
        Map<String, List<Account>> duplicateMapPhone = new Map<String, List<Account>>();
        List<Account> duplicateAccountList = new List<Account>();
        Set<Id> incomingAccountIdSet = new Set<Id>();
        
        incomingAccountPhoneMap = getIncomingAccountMap('Phone', accountList);
		incomingAccountIdSet = getAccountIdSet(accountList);
        
        if(!incomingAccountPhoneMap.isEmpty() && incomingAccountPhoneMap != null) {
            duplicateAccountList = [Select Id, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, Account_Id__c from Account 
                     				where Phone IN: incomingAccountPhoneMap.keySet() AND Id NOT IN: incomingAccountIdSet AND IsPersonAccount = true];
            system.debug('duplicateAccountList: '+duplicateAccountList);
            
            if(!duplicateAccountList.isEmpty() && duplicateAccountList != null) {
                for(Account dupAccount: duplicateAccountList) {
                    if(!duplicateMapPhone.containsKey(dupAccount.Phone)) {
                        List<Account> newAccountList = new List<Account>();
                        newAccountList.add(dupAccount);
                        duplicateMapPhone.put(dupAccount.Phone, newAccountList);
                    } else {
                        duplicateMapPhone.get(dupAccount.Phone).add(dupAccount);
                    }
                }
            }
            
            for(String phone: incomingAccountPhoneMap.keySet()) {
                if(duplicateMapPhone.containsKey(phone)) {
                    for(Account a: incomingAccountPhoneMap.get(phone)) {
                        accountDuplicateMapPhone.put(a, duplicateMapPhone.get(phone));
                    }
                }
            }
        }
        return accountDuplicateMapPhone;
    }
    
    public static Map<Account, List<Account>> accountDuplicateCheckByAlternateEmail(List<Account> accountList) {
    	Map<Account, List<Account>> accountDuplicateMapAlternateEmail = new Map<Account, List<Account>>();
        Map<String, List<Account>> incomingAccountAlternateEmailMap = new Map<String, List<Account>>();
        Map<String, List<Account>> duplicateMapAlternateEmail = new Map<String, List<Account>>();
        List<Account> duplicateAccountList = new List<Account>();
        Set<Id> incomingAccountIdSet = new Set<Id>();
        
        incomingAccountAlternateEmailMap = getIncomingAccountMap('Alternate Email', accountList);
		incomingAccountIdSet = getAccountIdSet(accountList);
        
        if(!incomingAccountAlternateEmailMap.isEmpty() && incomingAccountAlternateEmailMap != null) {
            duplicateAccountList = [Select Id, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, Account_Id__c from Account 
                     				where Alternate_Email__c IN: incomingAccountAlternateEmailMap.keySet() AND Id NOT IN: incomingAccountIdSet AND IsPersonAccount = true];
            system.debug('duplicateAccountList: '+duplicateAccountList);
            
            if(!duplicateAccountList.isEmpty() && duplicateAccountList != null) {
                for(Account dupAccount: duplicateAccountList) {
                    if(!duplicateMapAlternateEmail.containsKey(dupAccount.Alternate_Email__c)) {
                        List<Account> newAccountList = new List<Account>();
                        newAccountList.add(dupAccount);
                        duplicateMapAlternateEmail.put(dupAccount.Alternate_Email__c, newAccountList);
                    } else {
                        duplicateMapAlternateEmail.get(dupAccount.Alternate_Email__c).add(dupAccount);
                    }
                }
            }
            
            for(String alternateEmail: incomingAccountAlternateEmailMap.keySet()) {
                if(duplicateMapAlternateEmail.containsKey(alternateEmail)) {
                    for(Account a: incomingAccountAlternateEmailMap.get(alternateEmail)) {
                        accountDuplicateMapAlternateEmail.put(a, duplicateMapAlternateEmail.get(alternateEmail));
                    }
                }
            }
        }
        return accountDuplicateMapAlternateEmail;
    }
    
    public static Map<String, List<Account>> getIncomingAccountMap(String Type, List<Account> accountList) {
        Map<String, List<Account>> incomingAccountMap = new Map<String, List<Account>>();
        
        if(Type.equalsIgnoreCase('Mobile') || Type.equalsIgnoreCase('Phone')) {
            for(Account a: accountList) {
                if(a.PersonMobilePhone != null) {
                    if(!incomingAccountMap.containsKey(a.PersonMobilePhone)) {
                        List<Account> newAccountList = new List<Account>();
                        newAccountList.add(a);
                        incomingAccountMap.put(a.PersonMobilePhone, newAccountList);
                    } else {
                        incomingAccountMap.get(a.PersonMobilePhone).add(a);
                    }
                }
                if(a.Phone != null) {
                    if(!incomingAccountMap.containsKey(a.Phone)) {
                        List<Account> newAccountList = new List<Account>();
                        newAccountList.add(a);
                        incomingAccountMap.put(a.Phone, newAccountList);
                    } else {
                        incomingAccountMap.get(a.Phone).add(a);
                    }
                }
            }
        } else if(Type.equalsIgnoreCase('Email') || Type.equalsIgnoreCase('Alternate Email')) {
            for(Account a: accountList) {
                if(a.PersonEmail != null) {
                    if(!incomingAccountMap.containsKey(a.PersonEmail)) {
                        List<Account> newAccountList = new List<Account>();
                        newAccountList.add(a);
                        incomingAccountMap.put(a.PersonEmail, newAccountList);
                    } else {
                        incomingAccountMap.get(a.PersonEmail).add(a);
                    }
                }
                if(a.Alternate_Email__c != null) {
                    if(!incomingAccountMap.containsKey(a.Alternate_Email__c)) {
                        List<Account> newAccountList = new List<Account>();
                        newAccountList.add(a);
                        incomingAccountMap.put(a.Alternate_Email__c, newAccountList);
                    } else {
                        incomingAccountMap.get(a.Alternate_Email__c).add(a);
                    }
                }
            }
        } else {
            
        }
        return incomingAccountMap;
    }
    
    public static Set<Id> getAccountIdSet(List<Account> accountList) {
        Set<Id> accountIdSet = new Set<Id>();
        
        for(Account a: accountList) {
            accountIdSet.add(a.Id);
        }
        return accountIdSet;
    }
    
    /*public static List<duplicateWrapper> masterduplicateCalling(List<Lead> leadList) {
        List<duplicateWrapper> duplicateLeadList = new List<duplicateWrapper>();
        duplicateLeadList = duplicationCheckPhone(leadList);
        system.debug('duplicateLeadList In duplicationCheckPhone: '+duplicateLeadList);
        
        if(duplicateLeadList.isEmpty()) {
            duplicateLeadList = duplicationCheckEmail(leadList);
            system.debug('duplicateLeadList In duplicationCheckEmail: '+duplicateLeadList);
        }
        return duplicateLeadList;
    }
    
    // Duplicate Check on Mobile or Phone //
    public static List<duplicateWrapper> duplicationCheckPhone(List<Lead> leadList) {
        Map<String, Lead> newLeadMapByPhone = new Map<String, Lead>();
        List<Lead> duplicateLeadList = new List<Lead>();
        List<Account> duplicateAccountList = new List<Account>();
        List<duplicateWrapper> duplicateWrapperList = New List<duplicateWrapper>();
        System.debug('Incoming Lead: '+leadList);
        
        for(Lead leadRecord : leadList) {
            if(leadRecord.MobilePhone != Null)
                newLeadMapByPhone.put(leadRecord.MobilePhone, leadRecord);
            if(leadRecord.Phone != Null) 
                newLeadMapByPhone.put(leadRecord.Phone, leadRecord);
        }
        System.debug('Incoming newLeadMapByPhone: '+newLeadMapByPhone);
        
        if(!newLeadMapByPhone.isEmpty()) {
            duplicateAccountList = [Select Id, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c from Account 
                                    where (PersonMobilePhone IN: newLeadMapByPhone.keyset() OR Phone IN: newLeadMapByPhone.keyset())];
            system.debug('duplicateAccountList: '+duplicateAccountList);
        }

        if(!duplicateAccountList.isEmpty()) {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
                
            for(Account dupeAcc: duplicateAccountList) {
                duplicateWrapper dw = new duplicateWrapper();
                dw.name = dupeAcc.LastName;
                dw.duplicateRecordId = dupeAcc.Id;
                tempWrapper.add(dw);
            }
            duplicateWrapperList.addAll(tempWrapper);
        } else {
            duplicateLeadList = [Select Id, LastName, MobilePhone, Phone, Email, Alternate_Email__c from Lead 
                                 where (MobilePhone IN: newLeadMapByPhone.keyset() OR Phone IN: newLeadMapByPhone.keyset()) and isConverted =: false];
            system.debug('duplicateLeadList: '+ duplicateLeadList);
        }

        if(!duplicateLeadList.isEmpty()) {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
            
            for(Lead dupeLead: duplicateLeadList) {
                duplicateWrapper dw = new duplicateWrapper();
                dw.name = dupeLead.LastName;
                dw.duplicateRecordId = dupeLead.Id;
                if(dupeLead.Id != leadList[0].id)
                    tempWrapper.add(dw);
            }
            duplicateWrapperList.addAll(tempWrapper);
        }
        return duplicateWrapperList;
    }
    
    // Duplicate Check on Email or Alternate Email //
    public static List<duplicateWrapper> duplicationCheckEmail(List<Lead> leadList) {
        Map<String, Lead> newLeadMapByEmail = new Map<String, Lead>();
        List<Lead> duplicateLeadList = new List<Lead>();
        List<Account> duplicateAccountList = new List<Account>();
        List<duplicateWrapper> duplicateWrapperList = New List<duplicateWrapper>();
        System.debug('Incoming Lead: '+leadList);
        
        for(Lead leadRecord: leadList) {
            if(leadRecord.Email != Null)
            	newLeadMapByEmail.put(leadRecord.Email, leadRecord);
            if(leadRecord.Alternate_Email__c != Null)
                newLeadMapByEmail.put(leadRecord.Alternate_Email__c, leadRecord);
        }
        system.debug('Incoming newLeadMapByEmail: '+newLeadMapByEmail);
        
        if(!newLeadMapByEmail.isEmpty()) {
            duplicateAccountList = [Select Id, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c from Account 
                                    where (PersonEmail IN: newLeadMapByEmail.keyset() OR Alternate_Email__c IN: newLeadMapByEmail.keyset())];
        	system.debug('duplicateAccountList: '+duplicateAccountList);    
        }
        
        if(!duplicateAccountList.isEmpty()) {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
            
            for(Account dupeAcc: duplicateAccountList) {
                duplicateWrapper dw = new duplicateWrapper();
                dw.name = dupeAcc.LastName;
                dw.duplicateRecordId = dupeAcc.Id;
                tempWrapper.add(dw);
            }
            duplicateWrapperList.addAll(tempWrapper);
        } else {
            duplicateLeadList = [Select Id, LastName, MobilePhone, Phone, Email,Alternate_Email__c from Lead 
                                where (Email IN: newLeadMapByEmail.keyset() OR Alternate_Email__c IN: newLeadMapByEmail.keyset()) and isConverted =: false];
            System.debug('duplicateLeadList: '+ duplicateLeadList);
        }

        if(!duplicateLeadList.isEmpty()) {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
            
            for(Lead dupeLead: duplicateLeadList) {
                duplicateWrapper dw = new duplicateWrapper();
                dw.name = dupeLead.LastName;
                dw.duplicateRecordId = dupeLead.Id;
                if(dupeLead.Id != leadList[0].id)
                    tempWrapper.add(dw);
            }
            duplicateWrapperList.addAll(tempWrapper);
        }
        return duplicateWrapperList;
	}

    public static List<duplicateWrapper> accountMasterduplicateCalling(List<Account> accountList) {
        List<duplicateWrapper> duplicateAccountList = new List<duplicateWrapper>();
        duplicateAccountList = accountDuplicationCheckPhone(accountList);
        system.debug('duplicateAccountList In duplicationCheckPhone: '+duplicateAccountList);
        
        if(duplicateAccountList.isEmpty()) {
            duplicateAccountList = accountDuplicationCheckEmail(accountList);
            system.debug('duplicateAccountList In duplicationCheckPhone: '+duplicateAccountList);
        }
        return duplicateAccountList;
    }
	
    // Duplicate Check on Mobile or Phone //
    public static List<duplicateWrapper> accountDuplicationCheckPhone(List<Account> accountList) {
        Map<String, Account> newAccountMapByPhone = new Map<String, Account>();
        List<Lead> duplicateLeadList = new List<Lead>();
        List<Account> duplicateAccountList = new List<Account>();
        List<duplicateWrapper> duplicateWrapperList = New List<duplicateWrapper>();
        System.debug('Incoming Account: '+accountList);
        
        for(Account accountRecord : accountList) {
            if(accountRecord.PersonMobilePhone != Null)
            	newAccountMapByPhone.put(accountRecord.PersonMobilePhone, accountRecord);
            if(accountRecord.Phone != Null)
            	newAccountMapByPhone.put(accountRecord.Phone, accountRecord);
        }
        system.debug('Incoming newAccountMapByPhone: '+newAccountMapByPhone);
        
        if(!newAccountMapByPhone.isEmpty()) {
            duplicateLeadList = [Select Id, LastName, MobilePhone, Phone, Email, Alternate_Email__c from Lead 
                                where (MobilePhone IN: newAccountMapByPhone.keyset() OR Phone IN: newAccountMapByPhone.keyset()) and isConverted =: false];
            system.debug('duplicateLeadList: '+duplicateLeadList);
        }
        
        if(!duplicateLeadList.isEmpty()) {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
                
            for(Lead dupeLead: duplicateLeadList) {
                duplicateWrapper dw = new duplicateWrapper();
                dw.name = dupeLead.LastName;
                dw.duplicateRecordId = dupeLead.Id;
                tempWrapper.add(dw);
            }
            duplicateWrapperList.addAll(tempWrapper);
        } else {
            duplicateAccountList = [Select Id, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c from Account 
                                    where (PersonMobilePhone IN: newAccountMapByPhone.keyset() OR Phone IN: newAccountMapByPhone.keyset())];
            system.debug('duplicateAccountList: '+duplicateAccountList);
        }
        
        if(!duplicateAccountList.isEmpty()) {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
            
            for(Account dupeAcc: duplicateAccountList) {
                duplicateWrapper dw = new duplicateWrapper();
                dw.name = dupeAcc.LastName;
                dw.duplicateRecordId = dupeAcc.Id;
                if(dupeAcc.Id != accountList[0].id)
                    tempWrapper.add(dw);
            }
            duplicateWrapperList.addAll(tempWrapper);
        }
        return duplicateWrapperList;
	}
    
    // Duplicate Check on Email or Alternate Email ////
    public static List<duplicateWrapper> accountDuplicationCheckEmail(List<Account> accountList) {
        Map<String, Account> newAccountMapByEmail = new Map<String, Account>();
        List<Lead> duplicateLeadList = new List<Lead>();
        List<Account> duplicateAccountList = new List<Account>();
        List<duplicateWrapper> duplicateWrapperList = New List<duplicateWrapper>();
        system.debug('Incoming Account: '+accountList);
        
        for(Account accountRecord: accountList) {
            if(accountRecord.PersonEmail != Null)
            	newAccountMapByEmail.put(accountRecord.PersonEmail, accountRecord);
            if(accountRecord.Alternate_Email__c != Null)
            	newAccountMapByEmail.put(accountRecord.Alternate_Email__c, accountRecord);
        }
        system.debug('Incoming newAccountMapByEmail: '+newAccountMapByEmail);
        
        if(!newAccountMapByEmail.isEmpty()) {
            duplicateLeadList = [Select Id, LastName, MobilePhone, Phone, Email, Alternate_Email__c from Lead 
                                where (Email IN: newAccountMapByEmail.keyset() OR Alternate_Email__c IN: newAccountMapByEmail.keyset()) and isConverted =: false];
            system.debug('duplicateLeadList: '+ duplicateLeadList);
        }
        
        if(!duplicateLeadList.isEmpty()) {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
            
            for(Lead dupeLead: duplicateLeadList) {
                duplicateWrapper dw = new duplicateWrapper();
                dw.name = dupeLead.LastName;
                dw.duplicateRecordId = dupeLead.Id;
                tempWrapper.add(dw);
            }
            duplicateWrapperList.addAll(tempWrapper);
        } else {
            duplicateAccountList = [Select Id, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c from Account 
                                    where (PersonEmail IN: newAccountMapByEmail.keyset() OR Alternate_Email__c IN: newAccountMapByEmail.keyset())];
            system.debug('duplicateAccountList: '+duplicateAccountList);
        }
        
        if(!duplicateAccountList.isEmpty()) {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
            
            for(Account dupeAcc: duplicateAccountList) {
            	duplicateWrapper dw = new duplicateWrapper();
                dw.name = dupeAcc.LastName;
                dw.duplicateRecordId = dupeAcc.Id;
                if(dupeAcc.Id != accountList[0].Id)
                    tempWrapper.add(dw);
            }
            duplicateWrapperList.addAll(tempWrapper);
        }
		return duplicateWrapperList;
	}*/
    
    // Wrapper for duplicate details //
    public class duplicateWrapper {
        public String objectType {get;set;}
        public Lead dupLead {get;set;}
        public Opportunity dupOpp {get;set;}
        public Account dupAccount {get;set;}
        
        public duplicateWrapper(String type, Lead l, Opportunity op) {
            this.objectType = type;
            this.dupLead = l;
            this.dupOpp = op;
        }
        public duplicateWrapper(String type, Account acc) {
            this.objectType = type;
            this.dupAccount = acc;
        }
    }
}