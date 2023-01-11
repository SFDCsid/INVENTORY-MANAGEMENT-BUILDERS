public class DeDupeChecker {
    
    public static Map < EOI__c, List < Account >> findPADupeforEoiByMobile(List < EOI__c > eoiList) {
        Map < String, List < EOI__c >> mobileKeyMap = new Map < String, List < EOI__c >> ();
        Id AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> accIdSet = new Set<Id>();
        List<Account> accMobileDupList = new List<Account>();
        
        for (EOI__c l: eoiList) {
            if (l.Mobile_No_1__c != null) {
                if (mobileKeyMap.containsKey(l.Mobile_No_1__c)) {
                    mobileKeyMap.get(l.Mobile_No_1__c).add(l);
                }else {
                    List < EOI__c > newList = new List < EOI__c > ();
                    newList.add(l);
                    mobileKeyMap.put(l.Mobile_No_1__c, newList);
                }
            }
        }
        
        Map < String, List < Account >> existingPAMobileKeyMap = new Map < String, List < Account >> ();
        
        for (Account existingPA: [Select Id,PersonMobilePhone,personEmail
                                  from Account where RecordTypeId =:AccountRecordTypeId AND PersonMobilePhone IN: mobileKeyMap.keyset()]) {
                                      accMobileDupList.add(existingPA);
                                      if (existingPAMobileKeyMap.containsKey(existingPA.PersonMobilePhone)){ 
                                          existingPAMobileKeyMap.get(existingPA.PersonMobilePhone).add(existingPA);
                                      }else {
                                          List < Account > newList = new List < Account > ();
                                          newList.add(existingPA);
                                          existingPAMobileKeyMap.put(existingPA.PersonMobilePhone, newList);
                                      }
                                  }
        
        
        // loop through the incoming list map and check if there are duplicates in the existing lead map
        Map < EOI__c, List < Account >> PAMobileDupMap = new Map < EOI__c, List < Account >> ();
        for (String mobile: mobileKeyMap.keyset()) {
            if (existingPAMobileKeyMap.containsKey(mobile)) {
                for (EOI__c l: mobileKeyMap.get(mobile)) {
                    PAMobileDupMap.put(l, existingPAMobileKeyMap.get(mobile));
                    System.debug('EOI__c:' + l.Name + 'EOI__c duplicates are:' + existingPAMobileKeyMap.get(mobile));
                }
            }
        }
        return PAMobileDupMap;
    } 
    
    public static Map < Account, List < Account >> findPADupeByMobile(List < Account > accountList) {
        Map < String, List < Account >> mobileKeyMap = new Map < String, List < Account >> ();
        Id AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> accIdSet = new Set<Id>();
        List<Account> accMobileDupList = new List<Account>();
        
        for (Account l: accountList) {
            if (l.personMobilePhone != null) {
                if (mobileKeyMap.containsKey(l.personMobilePhone)) {
                    mobileKeyMap.get(l.personMobilePhone).add(l);
                }else {
                    List < Account > newList = new List < Account > ();
                    newList.add(l);
                    mobileKeyMap.put(l.personMobilePhone, newList);
                }
            }
        }
        
        Map < String, List < Account >> existingPAMobileKeyMap = new Map < String, List < Account >> ();
        
        for (Account existingPA: [Select Id,PersonMobilePhone,personEmail 
                                  from Account where RecordTypeId =:AccountRecordTypeId AND PersonMobilePhone IN: mobileKeyMap.keyset()]) {
                                      accMobileDupList.add(existingPA);
                                      if (existingPAMobileKeyMap.containsKey(existingPA.PersonMobilePhone)){ 
                                          existingPAMobileKeyMap.get(existingPA.PersonMobilePhone).add(existingPA);
                                      }else {
                                          List < Account > newList = new List < Account > ();
                                          newList.add(existingPA);
                                          existingPAMobileKeyMap.put(existingPA.PersonMobilePhone, newList);
                                      }
                                  }
        
        
        // loop through the incoming list map and check if there are duplicates in the existing lead map
        Map < Account, List < Account >> PAMobileDupMap = new Map < Account, List < Account >> ();
        for (String mobile: mobileKeyMap.keyset()) {
            if (existingPAMobileKeyMap.containsKey(mobile)) {
                for (Account l: mobileKeyMap.get(mobile)) {
                    PAMobileDupMap.put(l, existingPAMobileKeyMap.get(mobile));
                    System.debug('Account:' + l.Name + 'Account duplicates are:' + existingPAMobileKeyMap.get(mobile));
                }
            }
        }
        return PAMobileDupMap;
    } 
    
    public static Map < EOI__c, List < Account >> findPADupeforEoiByEmail(List < EOI__c > eoiList) {
        Set<Id> accIdSet = new Set<Id>();
        Id AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Map < String, List < EOI__c >> emailKeyMap = new Map < String, List < EOI__c >> ();
        
        for (EOI__c l: eoiList) {
            if (l.Email__c != null) {
                if (emailKeyMap.containsKey(l.Email__c)){ 
                    emailKeyMap.get(l.Email__c).add(l);
                }else {
                    List < EOI__c > newList = new List < EOI__c > ();
                    newList.add(l);
                    emailKeyMap.put(l.Email__c, newList);
                }
            }
        }
        
        Map < String, List < Account >> existingPAemailKeyMap = new Map < String, List < Account >> ();
        for (Account existingPA: [Select Id,PersonEmail,personMobilePhone 
                                  from Account where RecordTypeId =:AccountRecordTypeId AND PersonEmail IN: emailKeyMap.keyset()]) {
                                      if (existingPAemailKeyMap.containsKey(existingPA.PersonEmail)){
                                          existingPAemailKeyMap.get(existingPA.PersonEmail).add(existingPA);
                                      }else {
                                          List < Account > newList = new List < Account > ();
                                          newList.add(existingPA);
                                          existingPAemailKeyMap.put(existingPA.PersonEmail, newList);
                                      }
                                  }
        
        Map < EOI__c, List < Account >> personAccountEmailDup = new Map < EOI__c, List < Account >> ();
        for (String email: emailKeyMap.keyset()) {
            if (existingPAemailKeyMap.containsKey(email)) {
                for (EOI__c l: emailKeyMap.get(email)) {
                    personAccountEmailDup.put(l, existingPAemailKeyMap.get(email));
                    System.debug('EOI__c:' + l.Name + 'person account duplicates are:' + existingPAemailKeyMap.get(email));
                }
            }
        }
        return personAccountEmailDup;
    }   
    
    public static Map < Account, List < Account >> findPADupeByEmail(List < Account > accountList) {
        Set<Id> accIdSet = new Set<Id>();
        Id AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Map < String, List < Account >> emailKeyMap = new Map < String, List < Account >> ();
        
        for (Account l: accountList) {
            if (l.personEmail != null) {
                if (emailKeyMap.containsKey(l.personEmail)){ 
                    emailKeyMap.get(l.personEmail).add(l);
                }else {
                    List < Account > newList = new List < Account > ();
                    newList.add(l);
                    emailKeyMap.put(l.personEmail, newList);
                }
            }
        }
        
        Map < String, List < Account >> existingPAemailKeyMap = new Map < String, List < Account >> ();
        for (Account existingPA: [Select Id,PersonEmail,personMobilePhone 
                                  from Account where RecordTypeId =:AccountRecordTypeId AND PersonEmail IN: emailKeyMap.keyset()]) {
                                      if (existingPAemailKeyMap.containsKey(existingPA.PersonEmail)){
                                          existingPAemailKeyMap.get(existingPA.PersonEmail).add(existingPA);
                                      }else {
                                          List < Account > newList = new List < Account > ();
                                          newList.add(existingPA);
                                          existingPAemailKeyMap.put(existingPA.PersonEmail, newList);
                                      }
                                  }
        
        Map < Account, List < Account >> personAccountEmailDup = new Map < Account, List < Account >> ();
        for (String email: emailKeyMap.keyset()) {
            if (existingPAemailKeyMap.containsKey(email)) {
                for (Account l: emailKeyMap.get(email)) {
                    personAccountEmailDup.put(l, existingPAemailKeyMap.get(email));
                    System.debug('Account:' + l.Name + 'person account duplicates are:' + existingPAemailKeyMap.get(email));
                }
            }
        }
        return personAccountEmailDup;
    }   
    
    public static Map<EOI__c, List<Opportunity>> findOptyDupeforEoiByProject(Map<EOI__c,List<Account>> eMap){
       
        Id OptyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        Map<String,List<EOI__c>> MobileDupMap = new Map<String,List<EOI__c>>();
        Map<String,List<EOI__c>> EmailDupMap = new Map<String,List<EOI__c>>();
        Map<Id,List<EOI__c>> ProjectDupMap = new Map<Id,List<EOI__c>>();
        
        for(EOI__c l:eMap.keySet()){
            if (EmailDupMap.containsKey(l.Email__c)){ 
                EmailDupMap.get(l.Email__c).add(l);
            }else {
                List < EOI__c > newList = new List < EOI__c > ();
                newList.add(l);
                EmailDupMap.put(l.Email__c, newList);
            }
            
            if (MobileDupMap.containsKey(l.Mobile_No_1__c)){ 
                MobileDupMap.get(l.Mobile_No_1__c).add(l);
            }else {
                List < EOI__c > newList = new List < EOI__c > ();
                newList.add(l);
                MobileDupMap.put(l.Mobile_No_1__c, newList);
            }
            
             system.debug('Project Site ' + l.Project__r.Site__c );
            if (ProjectDupMap.containsKey(l.Project__r.Site__c)){ 
                ProjectDupMap.get(l.Project__r.Site__c).add(l);
            }else {
                List < EOI__c > newList = new List < EOI__c > ();
                newList.add(l);
                ProjectDupMap.put(l.Project__r.Site__c, newList);
            }
        }
        
        
        List<Opportunity> optyList = [SELECT Id,Name,Project__c,Site__c,AccountId,Account.personEmail,Account.personMobilePhone,StageName,Booking__c, Booking__r.name,Opportunity_Status__c 
                                      FROM Opportunity WHERE RecordTypeId =:OptyRecordTypeId AND Site__c=:ProjectDupMap.keyset()
                                      AND (Account.PersonMobilePhone=:MobileDupMap.keySet() OR Account.personEmail=:EmailDupMap.keyset()) ];
        
        
        Map < Id, List < Opportunity >> existingOptyProjectMap = new Map < Id, List < Opportunity >> ();
        for (Opportunity existingopty:optyList ) {
            if (existingOptyProjectMap.containsKey(existingopty.Site__c)){
                existingOptyProjectMap.get(existingopty.Site__c).add(existingopty);
            }else {
                List < Opportunity > newList = new List < Opportunity > ();
                newList.add(existingopty);
                existingOptyProjectMap.put(existingopty.Site__c, newList);
            }
        }
        
        Map < EOI__c, List < Opportunity >> OptyEmailDup = new Map < EOI__c, List < Opportunity >> ();
        for (Id pr: ProjectDupMap.keyset()) {
            if (existingOptyProjectMap.containsKey(pr)) {
                for (EOI__c l: ProjectDupMap.get(pr)) {
                    OptyEmailDup.put(l, existingOptyProjectMap.get(pr));
                    System.debug('EOI__c:' + l.Name + 'Opportunity duplicates are:' + existingOptyProjectMap.get(pr));
                }
            }
        }
        return OptyEmailDup;
    }
    
    public static Map<Opportunity, List<Opportunity>> findOptyDupeByProject(List<Opportunity> OpList){
        Id OptyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        
        Map<Id,List<Opportunity>> AccountDupMap = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> ProjectDupMap = new Map<Id,List<Opportunity>>();
        
        for(Opportunity l:OpList){
            if (AccountDupMap.containsKey(l.AccountId)){ 
                AccountDupMap.get(l.AccountId).add(l);
            }else {
                List < Opportunity > newList = new List < Opportunity > ();
                newList.add(l);
                AccountDupMap.put(l.AccountId, newList);
            }
            
            if (ProjectDupMap.containsKey(l.Project__r.Site__c)){ 
                ProjectDupMap.get(l.Project__r.Site__c).add(l);
            }else {
                List < Opportunity > newList = new List < Opportunity > ();
                newList.add(l);
                ProjectDupMap.put(l.Project__r.Site__c, newList);
            }
        }
        
        List<Opportunity> optyList = [SELECT Id,Name,Project__c,AccountId,Account.personEmail,Account.personMobilePhone,StageName,Opportunity_Status__c
                                      FROM Opportunity WHERE RecordTypeId =:OptyRecordTypeId AND Project__c=:ProjectDupMap.keyset()
                                      AND AccountId =:AccountDupMap.keySet() ];
        
        Map < Id, List < Opportunity >> existingOptyProjectMap = new Map < Id, List < Opportunity >> ();
        for (Opportunity existingopty:optyList ) {
            if (existingOptyProjectMap.containsKey(existingopty.Site__c)){
                existingOptyProjectMap.get(existingopty.Site__c).add(existingopty);
            }else {
                List < Opportunity > newList = new List < Opportunity > ();
                newList.add(existingopty);
                existingOptyProjectMap.put(existingopty.Site__c, newList);
            }
        }
        
        Map < Opportunity, List < Opportunity >> OptyDup = new Map < Opportunity, List < Opportunity >> ();
        for (Id pr: ProjectDupMap.keyset()) {
            if (existingOptyProjectMap.containsKey(pr)) {
                for (Opportunity l: ProjectDupMap.get(pr)) {
                    OptyDup.put(l, existingOptyProjectMap.get(pr));
                    System.debug('Opportunity:' + l.Name + 'Opportunity duplicates are:' + existingOptyProjectMap.get(pr));
                }
            }
        }
        return OptyDup;
    }
}