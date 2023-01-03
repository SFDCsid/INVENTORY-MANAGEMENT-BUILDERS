public with sharing class svScheduleReport {
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
        dateTime startDate = sdate;
        System.debug('startDate::'+startDate);
        dateTime endDate = edate;
        System.debug('endDate::'+endDate);
        
        
        Set<Id> lIdSet = new Set<Id>();
        Set<Date> followDateSet = new Set<Date>();
        Map<String, Map<Id, Date>> followUpMap = new Map<String, Map<Id, Date>>();
        List<AggregateResult> leadList = new List<AggregateResult>();
        List<AggregateResult> followUpConducted = new List<AggregateResult>();
        List<AggregateResult> cnrMoreThan5 = new List<AggregateResult>();
        List<AggregateResult> unqualifiedLeads = new List<AggregateResult>();
        Decimal totalleadCount = 0;
        Decimal totaltotalFollowupConducted = 0;
        Decimal totalFollowupNotConduct = 0;
        Decimal totalcallAnswered = 0;
        Decimal totalcallUnanswered = 0;
        Decimal totalcnrCounter = 0; 
        Decimal totalunqualifiedCount = 0;
	
        //SV Scheduled in Followup
        if(pId == 'All') {
            leadList = [select Owner.Name ownerName, WhatId, MAX(Next_Follow_up_Date__c) cd from Task where Stage__c =:'Site Visit Scheduled' 
                        AND Next_Follow_up_Date__c >=:startDate AND Next_Follow_up_Date__c<=:endDate AND Date_of_Visit__c != null AND RecordType.Name = 'Presales Call'
                        group by Owner.Name, WhatId];
        	system.debug('leadList: '+leadList);
        } else if(pId != 'All') {           
            leadList = [select Owner.Name ownerName, WhatId, MAX(Next_Follow_up_Date__c) cd from Task where Project__c=:pId AND Stage__c =:'Site Visit Scheduled' 
                        AND Next_Follow_up_Date__c >=:startDate AND Next_Follow_up_Date__c<=:endDate AND Date_of_Visit__c != null AND RecordType.Name = 'Presales Call'
                        group by Owner.Name, WhatId];
        	system.debug('leadList: '+leadList);
        }
        
        if(!leadList.isEmpty() && leadList != null) {
            for(AggregateResult ag: leadList) { 
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {                                
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.leadCount = rwc.leadCount + 1;                    
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.leadCount = 1;
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
                if(followUpMap.containsKey((String)ag.get('ownerName'))) {
                    Map<Id, Date> getMap = followUpMap.get((String)ag.get('ownerName'));
                    
                    if(getMap.containsKey((Id)ag.get('WhatId'))) {
                        if(getMap.get((Id)ag.get('WhatId')) < DATE.valueOf((DateTime)ag.get('cd'))) {
                            getMap.put((Id)ag.get('WhatId'), DATE.valueOf((DateTime)ag.get('cd')));
                        }
                    } else {
                        getMap.put((Id)ag.get('WhatId'), DATE.valueOf((DateTime)ag.get('cd')));
                    }
                    followUpMap.get((String)ag.get('ownerName')).putAll(getMap);
                } else {
                    Map<Id, Date> newMap = new Map<Id, Date>();
                    newMap.put((Id)ag.get('WhatId'), DATE.valueOf((DateTime)ag.get('cd')));
                    followUpMap.put((String)ag.get('ownerName'), newMap);
                }
                lIdSet.add((Id)ag.get('WhatId'));
                followDateSet.add(DATE.valueOf((DateTime)ag.get('cd')));
            }
        }
        
        //SV Scheduled in Followup Conducted	
        if(pId == 'All') {
            followUpConducted = [select Owner.Name ownerName, WhatId, Created_Date__c, Call_Status__c from Task where
                                WhatId IN: lIdSet AND Created_Date__c IN: followDateSet
                                group by Owner.Name, WhatId, Created_Date__c, Call_Status__c];
        	system.debug('followUpConducted: '+followUpConducted);
        } else if(pId != 'All') {
            followUpConducted = [select Owner.Name ownerName, WhatId, Created_Date__c, Call_Status__c from Task where 
                                 Project__c =: pId AND WhatId IN: lIdSet AND Created_Date__c IN: followDateSet
                                 group by Owner.Name, WhatId, Created_Date__c, Call_Status__c];
        	system.debug('followUpConducted: '+followUpConducted);
        }
        
		if(!followUpConducted.isEmpty() && followUpConducted != null) {
            for(AggregateResult ag: followUpConducted) {
                if(followUpMap.containsKey((String)ag.get('ownerName')) && followUpMap.get((String)ag.get('ownerName')).containsKey((Id)ag.get('WhatId'))) {
                    if(followUpMap.get((String)ag.get('ownerName')).get((Id)ag.get('WhatId')) == (Date)ag.get('Created_Date__c')) {
                        if(wrappermap.containsKey((String)ag.get('ownername'))) {
                            reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                            rwc.totalFollowupConducted = rwc.totalFollowupConducted + 1;
                            rwc.totalFollowupNotConducted = rwc.leadCount - rwc.totalFollowupConducted;
                            if((String)ag.get('Call_Status__c') != Null && (String)ag.get('Call_Status__c') != '' ){
                                if(((String)ag.get('Call_Status__c')).equalsIgnoreCase('Answered') || ((String)ag.get('Call_Status__c')).equalsIgnoreCase('Call Complete')) {
                                    rwc.callAnswered = rwc.callAnswered + 1;
                                } else if(((String)ag.get('Call_Status__c')).equalsIgnoreCase('NotAnswered') || ((String)ag.get('Call_Status__c')).equalsIgnoreCase('Not Answering') || ((String)ag.get('Call_Status__c')).equalsIgnoreCase('Busy')) {
                                    rwc.callUnanswered = rwc.callUnanswered + 1;
                                }
                            }
                            wrapperMap.put((String)ag.get('ownerName'),rwc);
                        }
                    }
                }
            }
        }
        
        //Call not received for more than 5 times
        if(pId == 'All') {
            cnrMoreThan5 = [select owner.name ownerName, COUNT_DISTINCT(WhatId) cnrCount from Task where
                            WhatId IN (Select Id from Lead__c where Not_Responding_Count__c > 5) AND
                            Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('cnrMoreThan5::'+cnrMoreThan5);
        } else if(pId != 'All') {
            cnrMoreThan5 = [select owner.name ownerName, COUNT_DISTINCT(WhatId) cnrCount from Task where Project__c =: pId AND
                            WhatId IN (Select Id from Lead__c where Not_Responding_Count__c > 5) AND
                            Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('cnrMoreThan5::'+cnrMoreThan5);
        }
        
        if(!cnrMoreThan5.isEmpty() && cnrMoreThan5 != null) {
            for(AggregateResult ag: cnrMoreThan5) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.cnrCounter = (Decimal)ag.get('cnrCount');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }

        //Unqualified due to Call not received for more than 5 times
        if(pId == 'All') {
            unqualifiedLeads = [select owner.name ownerName, COUNT_DISTINCT(WhatId) unCount from Task where
                                WhatId IN (Select Id from Lead__c where Not_Responding_Count__c > 5 AND Status__c ='Unqualified') AND
                                Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('unqualifiedLeads::'+unqualifiedLeads);
        } else if(pId != 'All') {
            unqualifiedLeads = [select owner.name ownerName, COUNT_DISTINCT(WhatId) unCount from Task where Project__c =: pId AND
                                WhatId IN (Select Id from Lead__c where Not_Responding_Count__c > 5 AND Status__c ='Unqualified') AND
                                Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('unqualifiedLeads::'+unqualifiedLeads);
        }
        
        if(!unqualifiedLeads.isEmpty() && unqualifiedLeads != null) {
            for(AggregateResult ag: unqualifiedLeads) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.unqualifiedCount = (Decimal)ag.get('unCount');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }
        reportDataWrapperClass rwc = new reportDataWrapperClass();
        rwc.leadCount = totalleadCount;
        rwc.totalFollowupConducted = totaltotalFollowupConducted;
        rwc.totalFollowupNotConducted = totalFollowupNotConduct;
        rwc.callAnswered = totalcallAnswered;
        rwc.callUnanswered = totalcallUnanswered;
        rwc.cnrCounter = totalcnrCounter;
        rwc.unqualifiedCount = totalunqualifiedCount;
        if(pId == 'All'){
            wrapperMap.put('Total', rwc);
        } 
        
        system.debug('wrapperMap: '+wrapperMap);
        return wrapperMap;
    }
    public class reportDataWrapperClass{
        @AuraEnabled 
        public Decimal leadCount{get;set;}
        @AuraEnabled
        public Decimal totalFollowupConducted{get;set;}
        @AuraEnabled
        public Decimal totalFollowupNotConducted{get;set;}
        @AuraEnabled
        public Decimal callAnswered{get;set;}
        @AuraEnabled
        public Decimal callUnanswered{get;set;}
        @AuraEnabled
        public Decimal cnrCounter{get;set;}
        @AuraEnabled
        public Decimal unqualifiedCount{get;set;}

        public reportDataWrapperClass() {
            this.leadCount = 0;
            this.totalFollowupConducted = 0;
            this.totalFollowupNotConducted = 0;
            this.cnrCounter = 0;
            this.callAnswered = 0;
            this.callUnanswered = 0;
            this.unqualifiedCount = 0;
        }
    }
}