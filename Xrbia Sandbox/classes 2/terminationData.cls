public with sharing class terminationData {
    @AuraEnabled (cacheable=true)
    public static Map<String,String> getProject(){
        Map<String,String> projectMap = new Map<String,String>();
        for (Project__c projectObj : [Select id,Name FROM Project__c]) {
            projectMap.put(projectObj.id, projectObj.Name);
        }
        return projectMap;  
    }
    @AuraEnabled (cacheable=true)
    public static Map<String, reportDataWrapperClass> Wrapper(String pId, Date sdate, Date edate ){
        Map<String, reportDataWrapperClass> wrapperMap = new Map<String, reportDataWrapperClass>();
        List<AggregateResult> overAllConnected = new List<AggregateResult>();
        List<AggregateResult> callTerminatedByAgent = new List<AggregateResult>();
        List<AggregateResult> callTerminatedByCust = new List<AggregateResult>();
        
        if(pId=='All'){            
            overAllConnected = [select owner.name ownerName, COUNT(WhatId) overAll from task where Created_Date__c >=:sdate AND Created_Date__c <=:edate 
        	                    AND Call_Status__c='Answered' AND RecordType.Name ='Presales Call' group by owner.name];            
            system.debug('overAllConnected: '+overAllConnected);
        }else if(pId != 'All'){
            overAllConnected = [select owner.name ownerName, COUNT(WhatId) overAll from task where Project__c=:pId AND Created_Date__c >=:sdate AND Created_Date__c <=:edate AND 
                               Call_Status__c='Answered' AND RecordType.Name ='Presales Call'  group by owner.name];
            system.debug('overAllConnected: '+overAllConnected);
        }
        if(pId=='All'){
            callTerminatedByAgent = [select owner.name ownerName, COUNT(WhatId) agentHangup from task where Created_Date__c >=:sdate AND Created_Date__c <=:edate AND
                                     Call_Status__c='Answered' AND Hangup_By__c ='AgentHangup' AND RecordType.Name ='Presales Call' group by owner.name];
            system.debug('callTerminatedByAgent: '+callTerminatedByAgent);
        }else if(pId != 'All'){
            callTerminatedByAgent = [select owner.name ownerName, COUNT(WhatId) agentHangup from task where Project__c=:pId AND Created_Date__c >=:sdate AND Created_Date__c <=:edate AND
                                     Call_Status__c='Answered' AND Hangup_By__c ='AgentHangup' AND RecordType.Name ='Presales Call' group by owner.name];
            system.debug('callTerminatedByAgent: '+callTerminatedByAgent);
        }
        if(pId=='All'){
            callTerminatedByCust = [select owner.name ownerName, COUNT(WhatId) userHangup from task where Created_Date__c >=:sdate AND Created_Date__c <=:edate AND
                                     Call_Status__c='Answered' AND Hangup_By__c ='UserHangup' AND RecordType.Name ='Presales Call' group by owner.name];
            system.debug('callTerminatedByCust: '+callTerminatedByCust);
        }else if(pId != 'All'){
            callTerminatedByCust = [select owner.name ownerName, COUNT(WhatId) userHangup from task where Project__c=:pId AND Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                                    AND RecordType.Name ='Presales Call' AND Call_Status__c='Answered'  AND Hangup_By__c ='UserHangup'  
                                    group by owner.name];
            system.debug('callTerminatedByCust: '+callTerminatedByCust);
        }

        if(!overAllConnected.isEmpty() && overAllConnected != null) {
            for(AggregateResult ag: overAllConnected) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.overAllConnected = (Decimal)ag.get('overAll');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.overAllConnected = (Decimal)ag.get('overAll'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!callTerminatedByCust.isEmpty() && callTerminatedByCust != null) {
            for(AggregateResult ag: callTerminatedByCust) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName')); 
                    rwc.agentHangUp = (Decimal)ag.get('userHangup');                                                            
                   	//rwc.agentHangUp = (Decimal)ag.get('agentHangup');  //comment as per above list  callTerminatedByCust 27dec2022                                                          
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.agentHangUp = (Decimal)ag.get('userHangup'); 
                    //rwc.agentHangUp = (Decimal)ag.get('agentHangup');  //comment as per above list  callTerminatedByCust 27dec2022 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!callTerminatedByAgent.isEmpty() && callTerminatedByAgent != null) {
            for(AggregateResult ag: callTerminatedByAgent) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));    
                    rwc.userHangup = (Decimal)ag.get('agentHangup');                                                            
                   	//rwc.userHangup = (Decimal)ag.get('userHangup');    //comment as per above list callTerminatedByAgent 27dec2022                                                         
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.userHangup = (Decimal)ag.get('agentHangup'); 
                    //rwc.userHangup = (Decimal)ag.get('userHangup');  //comment as per above list callTerminatedByAgent 27dec2022                                                           
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        system.debug('wrapperMap: '+wrapperMap);
        return wrapperMap;
    }
    public class reportDataWrapperClass{
        @AuraEnabled 
        public Decimal overAllConnected{get;set;}
        @AuraEnabled 
        public Decimal agentHangUp{get;set;}
        @AuraEnabled 
        public Decimal userHangup{get;set;}

        public reportDataWrapperClass() {
            this.overAllConnected = 0;
            this.agentHangUp = 0;
            this.userHangup = 0;
        }
    }
}