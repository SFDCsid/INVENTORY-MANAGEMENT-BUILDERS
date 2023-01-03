//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class DuplicationHandlerServices {
    public static Map<Lead__c, List<duplicateWrapper>> duplicationCheck(List<Lead__c> leadList) {
        Map<Lead__c, List<duplicateWrapper>> duplicateWrapperMap = new Map<Lead__c, List<duplicateWrapper>>();
        Map<Lead__c, List<Opportunity__c>> oppDuplicateMapMobileWithProject = new Map<Lead__c, List<Opportunity__c>>();
        Map<Lead__c, List<Opportunity__c>> oppDuplicateMapEmailWithProject = new Map<Lead__c, List<Opportunity__c>>();
        Map<Lead__c, List<Opportunity__c>> oppDuplicateMapPhoneWithProject = new Map<Lead__c, List<Opportunity__c>>();
        Map<Lead__c, List<Opportunity__c>> oppDuplicateMapAlternateEmailWithProject = new Map<Lead__c, List<Opportunity__c>>();
        Map<Lead__c, List<Lead__c>> leadDuplicateMapMobileWithProject = new Map<Lead__c, List<Lead__c>>();
        Map<Lead__c, List<Lead__c>> leadDuplicateMapEmailWithProject = new Map<Lead__c, List<Lead__c>>();
        Map<Lead__c, List<Lead__c>> leadDuplicateMapPhoneWithProject = new Map<Lead__c, List<Lead__c>>();
        Map<Lead__c, List<Lead__c>> leadDuplicateMapAlternateEmailWithProject = new Map<Lead__c, List<Lead__c>>();
        
        oppDuplicateMapMobileWithProject = accountOppDuplicateCheckByMobileWithProject(leadList);
        system.debug('oppDuplicateMapMobileWithProject: '+oppDuplicateMapMobileWithProject);
        
        if(!oppDuplicateMapMobileWithProject.isEmpty() && oppDuplicateMapMobileWithProject != null) {
            for(Lead__c l: oppDuplicateMapMobileWithProject.keySet()) {
                List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                for(Opportunity__c dupOpp: oppDuplicateMapMobileWithProject.get(l)) {
                    dwList.add(new duplicateWrapper('Opportunity', null, dupOpp));
                }
                duplicateWrapperMap.put(l, dwList);
            }
        } else {
        	oppDuplicateMapEmailWithProject = accountOppDuplicateCheckByEmailWithProject(leadList);
            system.debug('oppDuplicateMapEmailWithProject: '+oppDuplicateMapEmailWithProject);
            
            if(!oppDuplicateMapEmailWithProject.isEmpty() && oppDuplicateMapEmailWithProject != null) {
                for(Lead__c l: oppDuplicateMapEmailWithProject.keySet()) {
                    List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                    for(Opportunity__c dupOpp: oppDuplicateMapEmailWithProject.get(l)) {
                        dwList.add(new duplicateWrapper('Opportunity', null, dupOpp));
                    }
                    duplicateWrapperMap.put(l, dwList);
                }
            } else {
                oppDuplicateMapPhoneWithProject = accountOppDuplicateCheckByPhoneWithProject(leadList);
                system.debug('oppDuplicateMapPhoneWithProject: '+oppDuplicateMapPhoneWithProject);
                
                if(!oppDuplicateMapPhoneWithProject.isEmpty() && oppDuplicateMapPhoneWithProject != null) {
                    for(Lead__c l: oppDuplicateMapPhoneWithProject.keySet()) {
                        List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                        for(Opportunity__c dupOpp: oppDuplicateMapPhoneWithProject.get(l)) {
                            dwList.add(new duplicateWrapper('Opportunity', null, dupOpp));
                        }
                        duplicateWrapperMap.put(l, dwList);
                    }
                } else {
                    oppDuplicateMapAlternateEmailWithProject = accountOppDuplicateCheckByAlternateEmailWithProject(leadList);
                    system.debug('oppDuplicateMapAlternateEmailWithProject: '+oppDuplicateMapAlternateEmailWithProject);
                    
                    if(!oppDuplicateMapAlternateEmailWithProject.isEmpty() && oppDuplicateMapAlternateEmailWithProject != null) {
                        for(Lead__c l: oppDuplicateMapAlternateEmailWithProject.keySet()) {
                            List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                            for(Opportunity__c dupOpp: oppDuplicateMapAlternateEmailWithProject.get(l)) {
                                dwList.add(new duplicateWrapper('Opportunity', null, dupOpp));
                            }
                            duplicateWrapperMap.put(l, dwList);
                        }
                    } else {
                        leadDuplicateMapMobileWithProject = leadDuplicateCheckByMobileWithProject(leadList);
                        system.debug('leadDuplicateMapMobileWithProject: '+leadDuplicateMapMobileWithProject);
                    
                        if(!leadDuplicateMapMobileWithProject.isEmpty() && leadDuplicateMapMobileWithProject != null) {
                            for(Lead__c l: leadDuplicateMapMobileWithProject.keySet()) {
                                List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                                for(Lead__c dupLead: leadDuplicateMapMobileWithProject.get(l)) {
                                    dwList.add(new duplicateWrapper('Lead', dupLead, null));
                                }
                                duplicateWrapperMap.put(l, dwList);
                            }
                        } else {
                            leadDuplicateMapEmailWithProject = leadDuplicateCheckByEmailWithProject(leadList);
                            system.debug('leadDuplicateMapEmailWithProject: '+leadDuplicateMapEmailWithProject);
                            
                            if(!leadDuplicateMapEmailWithProject.isEmpty() && leadDuplicateMapEmailWithProject != null) {
                                for(Lead__c l: leadDuplicateMapEmailWithProject.keySet()) {
                                    List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                                    for(Lead__c dupLead: leadDuplicateMapEmailWithProject.get(l)) {
                                        dwList.add(new duplicateWrapper('Lead', dupLead, null));
                                    }
                                    duplicateWrapperMap.put(l, dwList);
                                }
                            } else {
                                leadDuplicateMapPhoneWithProject = leadDuplicateCheckByPhoneWithProject(leadList);
                                system.debug('leadDuplicateMapPhoneWithProject: '+leadDuplicateMapPhoneWithProject);
                                
                                if(!leadDuplicateMapPhoneWithProject.isEmpty() && leadDuplicateMapPhoneWithProject != null) {
                                    for(Lead__c l: leadDuplicateMapPhoneWithProject.keySet()) {
                                        List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                                        for(Lead__c dupLead: leadDuplicateMapPhoneWithProject.get(l)) {
                                            dwList.add(new duplicateWrapper('Lead', dupLead, null));
                                        }
                                        duplicateWrapperMap.put(l, dwList);
                                    }
                                } else {
                                    leadDuplicateMapAlternateEmailWithProject = leadDuplicateCheckByAlternateEmailWithProject(leadList);
                                    system.debug('leadDuplicateMapAlternateEmailWithProject: '+leadDuplicateMapAlternateEmailWithProject);
                                    
                                    if(!leadDuplicateMapAlternateEmailWithProject.isEmpty() && leadDuplicateMapAlternateEmailWithProject != null) {
                                        for(Lead__c l: leadDuplicateMapAlternateEmailWithProject.keySet()) {
                                            List<duplicateWrapper> dwList = new List<duplicateWrapper>();
                                            for(Lead__c dupLead: leadDuplicateMapAlternateEmailWithProject.get(l)) {
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
    
    public static Map<Opportunity__c, List<Opportunity__c>> duplicationCheckOpportunity(List<Opportunity__c> opportunityList) {
        Map<Opportunity__c, List<Opportunity__c>> oppDuplicateMap = new Map<Opportunity__c, List<Opportunity__c>>();
        Map<String, List<Opportunity__c>> incomingOpportunityAccountMap = new Map<String, List<Opportunity__c>>();
        Map<String, List<Opportunity__c>> incomingOpportunityAccountWithProjectMap = new Map<String, List<Opportunity__c>>();
        Map<String, List<Opportunity__c>> duplicateMapOppotunityWithProject = new Map<String, List<Opportunity__c>>();
        List<Opportunity__c> duplicateOpportunityList = new List<Opportunity__c>();
        Set<Id> incomingOpportunityIdSet = new Set<Id>();
        
        for(Opportunity__c op: opportunityList) {
            if(!incomingOpportunityAccountMap.containsKey(op.AccountId__c)) {
                List<Opportunity__c> newOppList = new List<Opportunity__c>();
                newOppList.add(op);
                incomingOpportunityAccountMap.put(op.AccountId__c, newOppList);
            } else {
				incomingOpportunityAccountMap.get(op.AccountId__c).add(op);
            }
            if(!incomingOpportunityAccountWithProjectMap.containsKey(op.AccountId__c+'-'+op.Project__c)) {
                List<Opportunity__c> newOppList = new List<Opportunity__c>();
                newOppList.add(op);
                incomingOpportunityAccountWithProjectMap.put(op.AccountId__c+'-'+op.Project__c, newOppList);
            } else {
				incomingOpportunityAccountWithProjectMap.get(op.AccountId__c+'-'+op.Project__c).add(op);
            }
            if(op.Id != null)
                incomingOpportunityIdSet.add(op.Id);
        }
        
        if(!incomingOpportunityAccountMap.isEmpty() && incomingOpportunityAccountMap != null) {
            duplicateOpportunityList = [Select Id, Name, AccountId__c, Project__c, Opportunity_Id__c from Opportunity__c 
                     					where AccountId__c IN: incomingOpportunityAccountMap.keySet() AND Id NOT IN: incomingOpportunityIdSet]; // AND Is_Active__c = true
            system.debug('duplicateOpportunityList: '+duplicateOpportunityList);
            
            if(!duplicateOpportunityList.isEmpty() && duplicateOpportunityList != null) {
                for(Opportunity__c dupOpp: duplicateOpportunityList) {
                    if(!duplicateMapOppotunityWithProject.containsKey(dupOpp.AccountId__c+'-'+dupOpp.Project__c)) {
                        List<Opportunity__c> newOppList = new List<Opportunity__c>();
                        newOppList.add(dupOpp);
                        duplicateMapOppotunityWithProject.put(dupOpp.AccountId__c+'-'+dupOpp.Project__c, newOppList);
                    } else {
                        duplicateMapOppotunityWithProject.get(dupOpp.AccountId__c+'-'+dupOpp.Project__c).add(dupOpp);
                    }
                }
            }
            
            for(String oppWithProject: incomingOpportunityAccountWithProjectMap.keySet()) {
                if(duplicateMapOppotunityWithProject.containsKey(oppWithProject)) {
                    for(Opportunity__c opp: incomingOpportunityAccountWithProjectMap.get(oppWithProject)) {
                        oppDuplicateMap.put(opp, duplicateMapOppotunityWithProject.get(oppWithProject));
                    }
                }
            }
        }
        return oppDuplicateMap;
    }
    
    public static Map<Lead__c, List<Opportunity__c>> accountOppDuplicateCheckByMobileWithProject(List<Lead__c> leadList) {
        Map<Lead__c, List<Opportunity__c>> oppDuplicateMapMobileWithProject = new Map<Lead__c, List<Opportunity__c>>();
        Map<String, List<Lead__c>> incomingLeadMobileMap = new Map<String, List<Lead__c>>();
        Map<String, List<Lead__c>> incomingLeadMobileWithProjectMap = new Map<String, List<Lead__c>>();
        Map<String, List<Opportunity__c>> duplicateMapMobileWithProject = new Map<String, List<Opportunity__c>>();
        List<Opportunity__c> duplicateOpportunityList = new List<Opportunity__c>();
        
        incomingLeadMobileMap = getIncomingLeadMap('Mobile', leadList);
        incomingLeadMobileWithProjectMap = getIncomingLeadWithProjectMap('Mobile', leadList);

        if(!incomingLeadMobileMap.isEmpty() && incomingLeadMobileMap != null) {
            duplicateOpportunityList = [Select Id, Name, AccountId__r.PersonContactId, AccountId__c, AccountId__r.FirstName, AccountId__r.LastName, AccountId__r.PersonMobilePhone, AccountId__r.Phone, AccountId__r.PersonEmail, AccountId__r.Alternate_Email__c, Project__c, Opportunity_Id__c from Opportunity__c 
                     					where AccountId__r.PersonMobilePhone IN: incomingLeadMobileMap.keySet()]; // AND Is_Active__c = true
            system.debug('duplicateOpportunityList: '+duplicateOpportunityList);
            
            if(!duplicateOpportunityList.isEmpty() && duplicateOpportunityList != null) {
                for(Opportunity__c dupOpp: duplicateOpportunityList) {
                    if(!duplicateMapMobileWithProject.containsKey(dupOpp.AccountId__r.PersonMobilePhone+'-'+dupOpp.Project__c)) {
                        List<Opportunity__c> newOppList = new List<Opportunity__c>();
                        newOppList.add(dupOpp);
                        duplicateMapMobileWithProject.put(dupOpp.AccountId__r.PersonMobilePhone+'-'+dupOpp.Project__c, newOppList);
                    } else {
                        duplicateMapMobileWithProject.get(dupOpp.AccountId__r.PersonMobilePhone+'-'+dupOpp.Project__c).add(dupOpp);
                    }
                }
            }
            
            for(String mobileWithProject: incomingLeadMobileWithProjectMap.keySet()) {
                if(duplicateMapMobileWithProject.containsKey(mobileWithProject)) {
                    for(Lead__c l: incomingLeadMobileWithProjectMap.get(mobileWithProject)) {
                        oppDuplicateMapMobileWithProject.put(l, duplicateMapMobileWithProject.get(mobileWithProject));
                    }
                }
            }
        }
        return oppDuplicateMapMobileWithProject;
    }
    
    public static Map<Lead__c, List<Opportunity__c>> accountOppDuplicateCheckByEmailWithProject(List<Lead__c> leadList) {
        Map<Lead__c, List<Opportunity__c>> oppDuplicateMapEmailWithProject = new Map<Lead__c, List<Opportunity__c>>();
        Map<String, List<Lead__c>> incomingLeadEmailMap = new Map<String, List<Lead__c>>();
        Map<String, List<Lead__c>> incomingLeadEmailWithProjectMap = new Map<String, List<Lead__c>>();
        Map<String, List<Opportunity__c>> duplicateMapEmailWithProject = new Map<String, List<Opportunity__c>>();
        List<Opportunity__c> duplicateOpportunityList = new List<Opportunity__c>();
        
        incomingLeadEmailMap = getIncomingLeadMap('Email', leadList);
        incomingLeadEmailWithProjectMap = getIncomingLeadWithProjectMap('Email', leadList);

        if(!incomingLeadEmailMap.isEmpty() && incomingLeadEmailMap != null) {
            duplicateOpportunityList = [Select Id, Name, AccountId__r.PersonContactId, AccountId__c, AccountId__r.FirstName, AccountId__r.LastName, AccountId__r.PersonMobilePhone, AccountId__r.Phone, AccountId__r.PersonEmail, AccountId__r.Alternate_Email__c, Project__c, Opportunity_Id__c from Opportunity__c 
                     					where AccountId__r.PersonEmail IN: incomingLeadEmailMap.keySet()]; // AND Is_Active__c = true
            system.debug('duplicateOpportunityList: '+duplicateOpportunityList);
            
            if(!duplicateOpportunityList.isEmpty() && duplicateOpportunityList != null) {
                for(Opportunity__c dupOpp: duplicateOpportunityList) {
                    if(!duplicateMapEmailWithProject.containsKey(dupOpp.AccountId__r.PersonEmail+'-'+dupOpp.Project__c)) {
                        List<Opportunity__c> newOppList = new List<Opportunity__c>();
                        newOppList.add(dupOpp);
                        duplicateMapEmailWithProject.put(dupOpp.AccountId__r.PersonEmail+'-'+dupOpp.Project__c, newOppList);
                    } else {
                        duplicateMapEmailWithProject.get(dupOpp.AccountId__r.PersonEmail+'-'+dupOpp.Project__c).add(dupOpp);
                    }
                }
            }
            
            for(String emailWithProject: incomingLeadEmailWithProjectMap.keySet()) {
                if(duplicateMapEmailWithProject.containsKey(emailWithProject)) {
                    for(Lead__c l: incomingLeadEmailWithProjectMap.get(emailWithProject)) {
                        oppDuplicateMapEmailWithProject.put(l, duplicateMapEmailWithProject.get(emailWithProject));
                    }
                }
            }
        }
        return oppDuplicateMapEmailWithProject;
    }
    
    public static Map<Lead__c, List<Opportunity__c>> accountOppDuplicateCheckByPhoneWithProject(List<Lead__c> leadList) {
        Map<Lead__c, List<Opportunity__c>> oppDuplicateMapPhoneWithProject = new Map<Lead__c, List<Opportunity__c>>();
        Map<String, List<Lead__c>> incomingLeadPhoneMap = new Map<String, List<Lead__c>>();
        Map<String, List<Lead__c>> incomingLeadPhoneWithProjectMap = new Map<String, List<Lead__c>>();
        Map<String, List<Opportunity__c>> duplicateMapPhoneWithProject = new Map<String, List<Opportunity__c>>();
        List<Opportunity__c> duplicateOpportunityList = new List<Opportunity__c>();
        
        incomingLeadPhoneMap = getIncomingLeadMap('Phone', leadList);
        incomingLeadPhoneWithProjectMap = getIncomingLeadWithProjectMap('Phone', leadList);

        if(!incomingLeadPhoneMap.isEmpty() && incomingLeadPhoneMap != null) {
            duplicateOpportunityList = [Select Id, Name, AccountId__r.PersonContactId, AccountId__c, AccountId__r.FirstName, AccountId__r.LastName, AccountId__r.PersonMobilePhone, AccountId__r.Phone, AccountId__r.PersonEmail, AccountId__r.Alternate_Email__c, Project__c, Opportunity_Id__c from Opportunity__c 
                     					where AccountId__r.Phone IN: incomingLeadPhoneMap.keySet()]; // AND Is_Active__c = true
            system.debug('duplicateOpportunityList: '+duplicateOpportunityList);
            
            if(!duplicateOpportunityList.isEmpty() && duplicateOpportunityList != null) {
                for(Opportunity__c dupOpp: duplicateOpportunityList) {
                    if(!duplicateMapPhoneWithProject.containsKey(dupOpp.AccountId__r.Phone+'-'+dupOpp.Project__c)) {
                        List<Opportunity__c> newOppList = new List<Opportunity__c>();
                        newOppList.add(dupOpp);
                        duplicateMapPhoneWithProject.put(dupOpp.AccountId__r.Phone+'-'+dupOpp.Project__c, newOppList);
                    } else {
                        duplicateMapPhoneWithProject.get(dupOpp.AccountId__r.Phone+'-'+dupOpp.Project__c).add(dupOpp);
                    }
                }
            }
            
            for(String phoneWithProject: incomingLeadPhoneWithProjectMap.keySet()) {
                if(duplicateMapPhoneWithProject.containsKey(phoneWithProject)) {
                    for(Lead__c l: incomingLeadPhoneWithProjectMap.get(phoneWithProject)) {
                        oppDuplicateMapPhoneWithProject.put(l, duplicateMapPhoneWithProject.get(phoneWithProject));
                    }
                }
            }
        }
        return oppDuplicateMapPhoneWithProject;
    }
    
    public static Map<Lead__c, List<Opportunity__c>> accountOppDuplicateCheckByAlternateEmailWithProject(List<Lead__c> leadList) {
        Map<Lead__c, List<Opportunity__c>> oppDuplicateMapAlternateEmailWithProject = new Map<Lead__c, List<Opportunity__c>>();
        Map<String, List<Lead__c>> incomingLeadAlternateEmailMap = new Map<String, List<Lead__c>>();
        Map<String, List<Lead__c>> incomingLeadAlternateEmailWithProjectMap = new Map<String, List<Lead__c>>();
        Map<String, List<Opportunity__c>> duplicateMapAlternateEmailWithProject = new Map<String, List<Opportunity__c>>();
        List<Opportunity__c> duplicateOpportunityList = new List<Opportunity__c>();
        
        incomingLeadAlternateEmailMap = getIncomingLeadMap('Alternate Email', leadList);
        incomingLeadAlternateEmailWithProjectMap = getIncomingLeadWithProjectMap('Alternate Email', leadList);

        if(!incomingLeadAlternateEmailMap.isEmpty() && incomingLeadAlternateEmailMap != null) {
            duplicateOpportunityList = [Select Id, Name, AccountId__r.PersonContactId, AccountId__c, AccountId__r.FirstName, AccountId__r.LastName, AccountId__r.PersonMobilePhone, AccountId__r.Phone, AccountId__r.PersonEmail, AccountId__r.Alternate_Email__c, Project__c, Opportunity_Id__c from Opportunity__c 
                     					where AccountId__r.Alternate_Email__c IN: incomingLeadAlternateEmailMap.keySet()]; // AND Is_Active__c = true
            system.debug('duplicateOpportunityList: '+duplicateOpportunityList);
            
            if(!duplicateOpportunityList.isEmpty() && duplicateOpportunityList != null) {
                for(Opportunity__c dupOpp: duplicateOpportunityList) {
                    if(!duplicateMapAlternateEmailWithProject.containsKey(dupOpp.AccountId__r.Alternate_Email__c+'-'+dupOpp.Project__c)) {
                        List<Opportunity__c> newOppList = new List<Opportunity__c>();
                        newOppList.add(dupOpp);
                        duplicateMapAlternateEmailWithProject.put(dupOpp.AccountId__r.Alternate_Email__c+'-'+dupOpp.Project__c, newOppList);
                    } else {
                        duplicateMapAlternateEmailWithProject.get(dupOpp.AccountId__r.Alternate_Email__c+'-'+dupOpp.Project__c).add(dupOpp);
                    }
                }
            }
            
            for(String alternateEmailWithProject: incomingLeadAlternateEmailWithProjectMap.keySet()) {
                if(duplicateMapAlternateEmailWithProject.containsKey(alternateEmailWithProject)) {
                    for(Lead__c l: incomingLeadAlternateEmailWithProjectMap.get(alternateEmailWithProject)) {
                        oppDuplicateMapAlternateEmailWithProject.put(l, duplicateMapAlternateEmailWithProject.get(alternateEmailWithProject));
                    }
                }
            }
        }
        return oppDuplicateMapAlternateEmailWithProject;
    }
    
    public static Map<Lead__c, List<Lead__c>> leadDuplicateCheckByMobileWithProject(List<Lead__c> leadList) {
    	Map<Lead__c, List<Lead__c>> leadDuplicateMapMobileWithProject = new Map<Lead__c, List<Lead__c>>();
        Map<String, List<Lead__c>> incomingLeadMobileMap = new Map<String, List<Lead__c>>();
        Map<String, List<Lead__c>> incomingLeadMobileWithProjectMap = new Map<String, List<Lead__c>>();
        Map<String, List<Lead__c>> duplicateMapMobileWithProject = new Map<String, List<Lead__c>>();
        List<Lead__c> duplicateLeadList = new List<Lead__c>();
        Set<Id> incomingLeadIdSet = new Set<Id>();
        
        incomingLeadMobileMap = getIncomingLeadMap('Mobile', leadList);
        incomingLeadMobileWithProjectMap = getIncomingLeadWithProjectMap('Mobile', leadList);
		incomingLeadIdSet = getLeadIdSet(leadList);
		
        if(!incomingLeadMobileMap.isEmpty() && incomingLeadMobileMap != null) {
            duplicateLeadList = [Select Id, Name, MobilePhone__c, Phone__c, Email__c, Alternate_Email__c, Project__c, Lead_Id__c from Lead__c 
                     			where MobilePhone__c IN: incomingLeadMobileMap.keySet() AND Id NOT IN: incomingLeadIdSet AND IsConverted__c = false]; // AND Is_Active__c = true
            system.debug('duplicateLeadList: '+duplicateLeadList);
            
            if(!duplicateLeadList.isEmpty() && duplicateLeadList != null) {
                for(Lead__c dupLead: duplicateLeadList) {
                    if(!duplicateMapMobileWithProject.containsKey(dupLead.MobilePhone__c+'-'+dupLead.Project__c)) {
                        List<Lead__c> newLeadList = new List<Lead__c>();
                        newLeadList.add(dupLead);
                        duplicateMapMobileWithProject.put(dupLead.MobilePhone__c+'-'+dupLead.Project__c, newLeadList);
                    } else {
                        duplicateMapMobileWithProject.get(dupLead.MobilePhone__c+'-'+dupLead.Project__c).add(dupLead);
                    }
                }
            }
            
            for(String mobileWithProject: incomingLeadMobileWithProjectMap.keySet()) {
                if(duplicateMapMobileWithProject.containsKey(mobileWithProject)) {
                    for(Lead__c l: incomingLeadMobileWithProjectMap.get(mobileWithProject)) {
                        leadDuplicateMapMobileWithProject.put(l, duplicateMapMobileWithProject.get(mobileWithProject));
                    }
                }
            }
        }
        return leadDuplicateMapMobileWithProject;
    }
    
    public static Map<Lead__c, List<Lead__c>> leadDuplicateCheckByEmailWithProject(List<Lead__c> leadList) {
    	Map<Lead__c, List<Lead__c>> leadDuplicateMapEmailWithProject = new Map<Lead__c, List<Lead__c>>();
        Map<String, List<Lead__c>> incomingLeadEmailMap = new Map<String, List<Lead__c>>();
        Map<String, List<Lead__c>> incomingLeadEmailWithProjectMap = new Map<String, List<Lead__c>>();
        Map<String, List<Lead__c>> duplicateMapEmailWithProject = new Map<String, List<Lead__c>>();
        List<Lead__c> duplicateLeadList = new List<Lead__c>();
        Set<Id> incomingLeadIdSet = new Set<Id>();
        
        incomingLeadEmailMap = getIncomingLeadMap('Email', leadList);
        incomingLeadEmailWithProjectMap = getIncomingLeadWithProjectMap('Email', leadList);
		incomingLeadIdSet = getLeadIdSet(leadList);
        
        if(!incomingLeadEmailMap.isEmpty() && incomingLeadEmailMap != null) {
            duplicateLeadList = [Select Id, Name, MobilePhone__c, Phone__c, Email__c, Alternate_Email__c, Project__c, Lead_Id__c from Lead__c 
                     			where Email__c IN: incomingLeadEmailMap.keySet() AND Id NOT IN: incomingLeadIdSet AND IsConverted__c = false]; // AND Is_Active__c = true
            system.debug('duplicateLeadList: '+duplicateLeadList);
            
            if(!duplicateLeadList.isEmpty() && duplicateLeadList != null) {
                for(Lead__c dupLead: duplicateLeadList) {
                    if(!duplicateMapEmailWithProject.containsKey(dupLead.Email__c+'-'+dupLead.Project__c)) {
                        List<Lead__c> newLeadList = new List<Lead__c>();
                        newLeadList.add(dupLead);
                        duplicateMapEmailWithProject.put(dupLead.Email__c+'-'+dupLead.Project__c, newLeadList);
                    } else {
                        duplicateMapEmailWithProject.get(dupLead.Email__c+'-'+dupLead.Project__c).add(dupLead);
                    }
                }
            }
            
            for(String emailWithProject: incomingLeadEmailWithProjectMap.keySet()) {
                if(duplicateMapEmailWithProject.containsKey(emailWithProject)) {
                    for(Lead__c l: incomingLeadEmailWithProjectMap.get(emailWithProject)) {
                        leadDuplicateMapEmailWithProject.put(l, duplicateMapEmailWithProject.get(emailWithProject));
                    }
                }
            }
        }
        return leadDuplicateMapEmailWithProject;
    }
    
    public static Map<Lead__c, List<Lead__c>> leadDuplicateCheckByPhoneWithProject(List<Lead__c> leadList) {
    	Map<Lead__c, List<Lead__c>> leadDuplicateMapPhoneWithProject = new Map<Lead__c, List<Lead__c>>();
        Map<String, List<Lead__c>> incomingLeadPhoneMap = new Map<String, List<Lead__c>>();
        Map<String, List<Lead__c>> incomingLeadPhoneWithProjectMap = new Map<String, List<Lead__c>>();
        Map<String, List<Lead__c>> duplicateMapPhoneWithProject = new Map<String, List<Lead__c>>();
        List<Lead__c> duplicateLeadList = new List<Lead__c>();
        Set<Id> incomingLeadIdSet = new Set<Id>();
        
        incomingLeadPhoneMap = getIncomingLeadMap('Phone', leadList);
        incomingLeadPhoneWithProjectMap = getIncomingLeadWithProjectMap('Phone', leadList);
		incomingLeadIdSet = getLeadIdSet(leadList);
        
        if(!incomingLeadPhoneMap.isEmpty() && incomingLeadPhoneMap != null) {
            duplicateLeadList = [Select Id, Name, MobilePhone__c, Phone__c, Email__c, Alternate_Email__c, Project__c, Lead_Id__c from Lead__c 
                     			where Phone__c IN: incomingLeadPhoneMap.keySet() AND Id NOT IN: incomingLeadIdSet AND IsConverted__c = false]; // AND Is_Active__c = true
            system.debug('duplicateLeadList: '+duplicateLeadList);
            
            if(!duplicateLeadList.isEmpty() && duplicateLeadList != null) {
                for(Lead__c dupLead: duplicateLeadList) {
                    if(!duplicateMapPhoneWithProject.containsKey(dupLead.Phone__c+'-'+dupLead.Project__c)) {
                        List<Lead__c> newLeadList = new List<Lead__c>();
                        newLeadList.add(dupLead);
                        duplicateMapPhoneWithProject.put(dupLead.Phone__c+'-'+dupLead.Project__c, newLeadList);
                    } else {
                        duplicateMapPhoneWithProject.get(dupLead.Phone__c+'-'+dupLead.Project__c).add(dupLead);
                    }
                }
            }
            
            for(String phoneWithProject: incomingLeadPhoneWithProjectMap.keySet()) {
                if(duplicateMapPhoneWithProject.containsKey(phoneWithProject)) {
                    for(Lead__c l: incomingLeadPhoneWithProjectMap.get(phoneWithProject)) {
                        leadDuplicateMapPhoneWithProject.put(l, duplicateMapPhoneWithProject.get(phoneWithProject));
                    }
                }
            }
        }
        return leadDuplicateMapPhoneWithProject;
    }
    
    public static Map<Lead__c, List<Lead__c>> leadDuplicateCheckByAlternateEmailWithProject(List<Lead__c> leadList) {
    	Map<Lead__c, List<Lead__c>> leadDuplicateMapAlternateEmailWithProject = new Map<Lead__c, List<Lead__c>>();
        Map<String, List<Lead__c>> incomingLeadAlternateEmailMap = new Map<String, List<Lead__c>>();
        Map<String, List<Lead__c>> incomingLeadAlternateEmailWithProjectMap = new Map<String, List<Lead__c>>();
        Map<String, List<Lead__c>> duplicateMapAlternateEmailWithProject = new Map<String, List<Lead__c>>();
        List<Lead__c> duplicateLeadList = new List<Lead__c>();
        Set<Id> incomingLeadIdSet = new Set<Id>();
        
        incomingLeadAlternateEmailMap = getIncomingLeadMap('Alternate Email', leadList);
        incomingLeadAlternateEmailWithProjectMap = getIncomingLeadWithProjectMap('Alternate Email', leadList);
		incomingLeadIdSet = getLeadIdSet(leadList);
        
        if(!incomingLeadAlternateEmailMap.isEmpty() && incomingLeadAlternateEmailMap != null) {
            duplicateLeadList = [Select Id, Name, MobilePhone__c, Phone__c, Email__c, Alternate_Email__c, Project__c, Lead_Id__c from Lead__c 
                     			where Alternate_Email__c IN: incomingLeadAlternateEmailMap.keySet() AND Id NOT IN: incomingLeadIdSet AND IsConverted__c = false]; // AND Is_Active__c = true
            system.debug('duplicateLeadList: '+duplicateLeadList);
            
            if(!duplicateLeadList.isEmpty() && duplicateLeadList != null) {
                for(Lead__c dupLead: duplicateLeadList) {
                    if(!duplicateMapAlternateEmailWithProject.containsKey(dupLead.Alternate_Email__c+'-'+dupLead.Project__c)) {
                        List<Lead__c> newLeadList = new List<Lead__c>();
                        newLeadList.add(dupLead);
                        duplicateMapAlternateEmailWithProject.put(dupLead.Alternate_Email__c+'-'+dupLead.Project__c, newLeadList);
                    } else {
                        duplicateMapAlternateEmailWithProject.get(dupLead.Alternate_Email__c+'-'+dupLead.Project__c).add(dupLead);
                    }
                }
            }
            
            for(String alternateEmailWithProject: incomingLeadAlternateEmailWithProjectMap.keySet()) {
                if(duplicateMapAlternateEmailWithProject.containsKey(alternateEmailWithProject)) {
                    for(Lead__c l: incomingLeadAlternateEmailWithProjectMap.get(alternateEmailWithProject)) {
                        leadDuplicateMapAlternateEmailWithProject.put(l, duplicateMapAlternateEmailWithProject.get(alternateEmailWithProject));
                    }
                }
            }
        }
        return leadDuplicateMapAlternateEmailWithProject;
    }
	
	public static Map<String, List<Lead__c>> getIncomingLeadMap(String Type, List<Lead__c> leadList) {
        Map<String, List<Lead__c>> incomingLeadMap = new Map<String, List<Lead__c>>();
        
        if(Type.equalsIgnoreCase('Mobile') || Type.equalsIgnoreCase('Phone')) {
            for(Lead__c l: leadList) {
                if(l.MobilePhone__c != null) {
                    if(!incomingLeadMap.containsKey(l.MobilePhone__c)) {
                        List<Lead__c> newLeadList = new List<Lead__c>();
                        newLeadList.add(l);
                        incomingLeadMap.put(l.MobilePhone__c, newLeadList);
                    } else {
                        incomingLeadMap.get(l.MobilePhone__c).add(l);
                    }
                }
                if(l.Phone__c != null) {
                    if(!incomingLeadMap.containsKey(l.Phone__c)) {
                        List<Lead__c> newLeadList = new List<Lead__c>();
                        newLeadList.add(l);
                        incomingLeadMap.put(l.Phone__c, newLeadList);
                    } else {
                        incomingLeadMap.get(l.Phone__c).add(l);
                    }
                }
            }
        } else if(Type.equalsIgnoreCase('Email') || Type.equalsIgnoreCase('Alternate Email')) {
            for(Lead__c l: leadList) {
                if(l.Email__c != null) {
                    if(!incomingLeadMap.containsKey(l.Email__c)) {
                        List<Lead__c> newLeadList = new List<Lead__c>();
                        newLeadList.add(l);
                        incomingLeadMap.put(l.Email__c, newLeadList);
                    } else {
                        incomingLeadMap.get(l.Email__c).add(l);
                    }
                }
                if(l.Alternate_Email__c != null) {
                    if(!incomingLeadMap.containsKey(l.Alternate_Email__c)) {
                        List<Lead__c> newLeadList = new List<Lead__c>();
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
    
    public static Map<String, List<Lead__c>> getIncomingLeadWithProjectMap(String Type, List<Lead__c> leadList) {
        Map<String, List<Lead__c>> incomingLeadWithProjectMap = new Map<String, List<Lead__c>>();
        
        if(Type.equalsIgnoreCase('Mobile') || Type.equalsIgnoreCase('Phone')) {
            for(Lead__c l: leadList) {
                if(l.MobilePhone__c != null) {
                    if(!incomingLeadWithProjectMap.containsKey(l.MobilePhone__c+'-'+l.Project__c)) {
                        List<Lead__c> newLeadList = new List<Lead__c>();
                        newLeadList.add(l);
                        incomingLeadWithProjectMap.put(l.MobilePhone__c+'-'+l.Project__c, newLeadList);
                    } else {
                        incomingLeadWithProjectMap.get(l.MobilePhone__c+'-'+l.Project__c).add(l);
                    }
                }
                if(l.Phone__c != null) {
                    if(!incomingLeadWithProjectMap.containsKey(l.Phone__c+'-'+l.Project__c)) {
                        List<Lead__c> newLeadList = new List<Lead__c>();
                        newLeadList.add(l);
                        incomingLeadWithProjectMap.put(l.Phone__c+'-'+l.Project__c, newLeadList);
                    } else {
                        incomingLeadWithProjectMap.get(l.Phone__c+'-'+l.Project__c).add(l);
                    }
                }
            }
        } else if(Type.equalsIgnoreCase('Email') || Type.equalsIgnoreCase('Alternate Email')) {
            for(Lead__c l: leadList) {
                if(l.Email__c != null) {
                    if(!incomingLeadWithProjectMap.containsKey(l.Email__c+'-'+l.Project__c)) {
                        List<Lead__c> newLeadList = new List<Lead__c>();
                        newLeadList.add(l);
                        incomingLeadWithProjectMap.put(l.Email__c+'-'+l.Project__c, newLeadList);
                    } else {
                        incomingLeadWithProjectMap.get(l.Email__c+'-'+l.Project__c).add(l);
                    }
                }
                if(l.Alternate_Email__c != null) {
                    if(!incomingLeadWithProjectMap.containsKey(l.Alternate_Email__c+'-'+l.Project__c)) {
                        List<Lead__c> newLeadList = new List<Lead__c>();
                        newLeadList.add(l);
                        incomingLeadWithProjectMap.put(l.Alternate_Email__c+'-'+l.Project__c, newLeadList);
                    } else {
                        incomingLeadWithProjectMap.get(l.Alternate_Email__c+'-'+l.Project__c).add(l);
                    }
                }
            }
        } else {
            
        }
        return incomingLeadWithProjectMap;
    }
    
    public static Set<Id> getLeadIdSet(List<Lead__c> leadList) {
        Set<Id> leadIdSet = new Set<Id>();
        
        for(Lead__c l: leadList) {
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
            duplicateAccountList = [Select Id, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, Account_Id__c, PersonContactId from Account 
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
            duplicateAccountList = [Select Id, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, Account_Id__c, PersonContactId from Account 
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
            duplicateAccountList = [Select Id, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, Account_Id__c, PersonContactId from Account 
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
            duplicateAccountList = [Select Id, FirstName, LastName, PersonMobilePhone, Phone, PersonEmail, Alternate_Email__c, Account_Id__c, PersonContactId from Account 
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
    
    // Wrapper for duplicate details //
    public class duplicateWrapper {
        public String objectType {get;set;}
        public Lead__c dupLead {get;set;}
        public Opportunity__c dupOpp {get;set;}
        public Account dupAccount {get;set;}
        
        public duplicateWrapper(String type, Lead__c l, Opportunity__c op) {
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