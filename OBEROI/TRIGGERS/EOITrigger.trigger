trigger EOITrigger on EOI__c (before insert, after insert) {
    
    
    
    if(Trigger.isBefore && Trigger.isInsert){
         List<EOI__c> EoiToConvert = new List<EOI__c>();
         Map<EOI__c,List<Account>> AccountMobileDupMap = new  Map<EOI__c,List<Account>>();
         Map<EOI__c,List<Account>> AccountEmailDupMap = new  Map<EOI__c,List<Account>>();
         Map<EOI__c,List<Account>> NoOptyAccountEmailDupMap = new  Map<EOI__c,List<Account>>();
         Map<EOI__c,List<Opportunity>> OptyProjectDupMap = new  Map<EOI__c,List<Opportunity>>();
         Map<EOI__c,List<Account>> CreateOptyDupMap = new  Map<EOI__c,List<Account>>();
         Boolean convEoi = false;
        List<EOI__c> eoiList = new List<EOI__c>();
        List<EOI__c> eList = new List<EOI__c>();
        
        Map<String,EOI__c> mapOfStrToEoi = new Map<String,EOI__c>();
        Map<Id,Project__c> mapOfProjectSite = new Map<Id,Project__c>([Select Id,Name,Site__c From Project__c]);
        
        
        try{
            for(EOI__c myEoi: Trigger.new){
                system.debug('myEoi'+ myEoi.project__c);
                system.debug('mapOfProjectSite.get(myEoi.Project__c).Site__c '+ mapOfProjectSite.get(myEoi.Project__c).Site__c);
                
                if(myEoi.project__c != null){
                    myEoi.project__r =  mapOfProjectSite.get(myEoi.Project__c);
                    eoiList.add(myEoi);
                    
                    String str = myEoi.Email__c+myEoi.Mobile_No_1__c+mapOfProjectSite.get(myEoi.Project__c).Site__c;
                    System.debug('myEoi ----- ' + myEoi);
                    System.debug('str ----- ' + str);
                    
                    if(! mapOfStrToEoi.containsKey(str)){
                        mapOfStrToEoi.put(str, myEoi);
                    }
                }
            }
            System.debug('Size ----- ' + mapOfStrToEoi.keyset().size());
            
            for(String st : mapOfStrToEoi.keyset()){
                System.debug('Value ----- ' + mapOfStrToEoi.get(st));  
            }        
            
            eList = mapOfStrToEoi.values();
            system.debug('eList'+eList);
            
            if(eList != NULL && eList.size()>0){
                AccountMobileDupMap = DeDupeChecker.findPADupeforEoiByMobile(eList);
                AccountEmailDupMap = DeDupeChecker.findPADupeforEoiByEmail(eList);
                AccountMobileDupMap.putAll(AccountEmailDupMap);
                NoOptyAccountEmailDupMap.putAll(AccountMobileDupMap);
                OptyProjectDupMap = DeDupeChecker.findOptyDupeforEoiByProject(AccountMobileDupMap);
                
                for(EOI__c l:OptyProjectDupMap.keySet()){
                    if(NoOptyAccountEmailDupMap.containsKey(l)){
                        NoOptyAccountEmailDupMap.remove(l);
                    }
                }
                
                System.debug('AccountMobileDupMap==>'+AccountMobileDupMap);
                System.debug('AccountEmailDupMap==>'+AccountEmailDupMap);
                System.debug('OptyProjectDupMap==>'+OptyProjectDupMap.values());
                System.debug('NoOptyAccountEmailDupMap==>'+NoOptyAccountEmailDupMap);
                
                for(EOI__c myLead: eList){
                    //if(AccountMobileDupMap != null){
                        if(!AccountMobileDupMap.containsKey(myLead)){
                            convEoi = true;
                            EoiToConvert.add(myLead);
                        }
                    //}
                }
                
                if(OptyProjectDupMap != NULL && !OptyProjectDupMap.isEmpty()){
                    EoiHandler.TagEoi(OptyProjectDupMap);
                }
                
                if(NoOptyAccountEmailDupMap != NULL && !NoOptyAccountEmailDupMap.isEmpty()){
                    EoiHandler.CreateOptyANDTagEoi(NoOptyAccountEmailDupMap);
                }
            }
            
            if(convEoi == true){
                EoiHandler.CreateAccountandTagEoi(EoiToConvert);
            }
            
        }catch(Exception e){
            for(EOI__c myEoi: Trigger.new){
                myEoi.Error_EOI__c = true;
            }
        }
    }
    
   /* If(Trigger.isInsert && Trigger.isAfter){
        EoiHandler.updateLeadEOITags(trigger.new);
    }*/
}