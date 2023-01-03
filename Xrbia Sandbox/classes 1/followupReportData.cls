public with sharing class followupReportData {
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
        Datetime startDate = sdate;
        System.debug('startDate:'+startDate);
        Datetime endDate = edate;
        System.debug('endDate:'+endDate);

        Set<Id> lIdSet = new Set<Id>();
        Set<Date> followDateSet = new Set<Date>();
        Map<String, Map<Id, Date>> followUpMap = new Map<String, Map<Id, Date>>();
        
        List<AggregateResult> followupReportDateList = new List<AggregateResult>();
        List<AggregateResult> followupConductedForReportDateList = new List<AggregateResult>();        
        List<AggregateResult> cnrMoreThan5 = new List<AggregateResult>();
        List<AggregateResult> callNotReceivedList = new List<AggregateResult>();
        List<AggregateResult> unqualifiedDueToCNR = new List<AggregateResult>();

        if(pId == 'All'){
            followupReportDateList = [select Owner.Name ownerName, WhatId, MAX(Next_Follow_up_Date__c) cd from Task where Stage__c =:'In-Followup' 
                                      AND Next_Follow_up_Date__c >=:startDate AND Next_Follow_up_Date__c<=:endDate AND RecordType.Name = 'Presales Call'
                                      group by Owner.Name, WhatId];
            System.debug('followupReportDateList::'+followupReportDateList);
        }else if(pId != 'All'){
            followupReportDateList = [select Owner.Name ownerName, WhatId, MAX(Next_Follow_up_Date__c) cd from Task where Project__c=:pId AND Stage__c =:'In-Followup' 
                                      AND Next_Follow_up_Date__c >=:startDate AND Next_Follow_up_Date__c<=:endDate AND RecordType.Name = 'Presales Call'
                                      group by Owner.Name, WhatId];
            System.debug('followupReportDateList::'+followupReportDateList);
        }

        if(!followupReportDateList.isEmpty() && followupReportDateList != null) {
            for(AggregateResult ag: followupReportDateList) { 
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

        if(pId == 'All'){
            followupConductedForReportDateList  = [select Owner.Name ownerName, WhatId, Created_Date__c, Call_Status__c from Task where
                                                   WhatId IN: lIdSet AND Created_Date__c IN: followDateSet
                                                   group by Owner.Name, WhatId, Created_Date__c, Call_Status__c];
            System.debug('followupConductedForReportDateList::'+followupConductedForReportDateList);
        }else if(pId != 'All'){
            followupConductedForReportDateList  = [select Owner.Name ownerName, WhatId, Created_Date__c, Call_Status__c from Task where 
                                                   Project__c =: pId AND WhatId IN: lIdSet AND Created_Date__c IN: followDateSet
                                                   group by Owner.Name, WhatId, Created_Date__c, Call_Status__c];
            System.debug('followupConductedForReportDateList::'+followupConductedForReportDateList);
        }

        if(!followupConductedForReportDateList.isEmpty() && followupConductedForReportDateList != null) {
            for(AggregateResult ag: followupConductedForReportDateList) {
                if(followUpMap.containsKey((String)ag.get('ownerName')) && followUpMap.get((String)ag.get('ownerName')).containsKey((Id)ag.get('WhatId'))) {
                    if(followUpMap.get((String)ag.get('ownerName')).get((Id)ag.get('WhatId')) == (Date)ag.get('Created_Date__c')) {
                        if(wrappermap.containsKey((String)ag.get('ownername'))) {
                            reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                            rwc.conductedCount = rwc.conductedCount + 1;
                            rwc.notConductedCount = rwc.leadCount - rwc.conductedCount;
                            if((String)ag.get('Call_Status__c') != Null && (String)ag.get('Call_Status__c') != '' ){
                                if(((String)ag.get('Call_Status__c')).equalsIgnoreCase('Answered') || ((String)ag.get('Call_Status__c')).equalsIgnoreCase('Call Complete')) {
                                    rwc.receivedByCustCount = rwc.receivedByCustCount + 1;
                                } else if(((String)ag.get('Call_Status__c')).equalsIgnoreCase('NotAnswered') || ((String)ag.get('Call_Status__c')).equalsIgnoreCase('Not Answering') || ((String)ag.get('Call_Status__c')).equalsIgnoreCase('Busy')) {
                                    rwc.notReceivedByCustCount = rwc.notReceivedByCustCount + 1;
                                }
                            }
                            wrapperMap.put((String)ag.get('ownerName'),rwc);
                        }
                    }
                }
            }
        }

        if(pId == 'All'){
            cnrMoreThan5 = [select owner.name ownerName, COUNT_DISTINCT(WhatId) cnrCount from Task where
                            WhatId IN (Select Id from Lead__c where Not_Responding_Count__c > 5) AND
                            Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('cnrMoreThan5::'+cnrMoreThan5);
        }else if(pId == 'All'){
            cnrMoreThan5 = [select owner.name ownerName, COUNT_DISTINCT(WhatId) cnrCount from Task where Project__c =: pId AND
                            WhatId IN (Select Id from Lead__c where Not_Responding_Count__c > 5) AND
                            Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('cnrMoreThan5::'+cnrMoreThan5);
        }

        if(!cnrMoreThan5.isEmpty() && cnrMoreThan5 != null) {
            for(AggregateResult ag: cnrMoreThan5) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.CNRCallCount = (Decimal)ag.get('cnrCount');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }
        
        if(pId == 'All'){
            callNotReceivedList = [select owner.name ownerName, COUNT_DISTINCT(WhatId) totalUnasnwered from Task where                                  
                                  (Call_Status__c = 'NotAnswered' OR Call_Status__c ='Not Answering' OR Call_Status__c ='Busy') AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('callNotReceivedList::'+callNotReceivedList);
        }else if(pId != 'All'){
            callNotReceivedList = [select owner.name ownerName, COUNT_DISTINCT(WhatId) totalUnasnwered from Task where Project__c =: pId AND                                   
                                  (Call_Status__c = 'NotAnswered' OR Call_Status__c ='Not Answering' OR Call_Status__c ='Busy') AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('callNotReceivedList::'+callNotReceivedList);
        }

        if(!callNotReceivedList.isEmpty() && callNotReceivedList != null) {
            for(AggregateResult ag: callNotReceivedList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.totalCallNotReceivedCount = (Decimal)ag.get('totalUnasnwered');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }


        if(pId == 'All'){
            unqualifiedDueToCNR = [select owner.name ownerName, COUNT_DISTINCT(WhatId) unCount from Task where
                                   WhatId IN (Select Id from Lead__c where Not_Responding_Count__c > 5 AND Status__c ='Unqualified') AND
                                   Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('unqualifiedDueToCNR::'+unqualifiedDueToCNR);
        }else if(pId != 'All'){
            unqualifiedDueToCNR = [select owner.name ownerName, COUNT_DISTINCT(WhatId) unCount from Task where Project__c =: pId AND
                                   WhatId IN (Select Id from Lead__c where Not_Responding_Count__c > 5 AND Status__c ='Unqualified') AND
                                   Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('unqualifiedDueToCNR::'+unqualifiedDueToCNR);
        }
        
        if(!unqualifiedDueToCNR.isEmpty() && unqualifiedDueToCNR != null) {
            for(AggregateResult ag: unqualifiedDueToCNR) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.UnqualifiedDuetoCNR = (Decimal)ag.get('unCount');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }        
    
        system.debug('wrapperMap: '+wrapperMap);
        return wrapperMap;
    }

    public class reportDataWrapperClass{
        @AuraEnabled 
        public Decimal leadCount{get;set;}
        @AuraEnabled 
        public Decimal conductedCount{get;set;}
        @AuraEnabled 
        public Decimal notConductedCount{get;set;}
        @AuraEnabled 
        public Decimal receivedByCustCount{get;set;}
        @AuraEnabled 
        public Decimal notReceivedByCustCount{get;set;}
        @AuraEnabled 
        public Decimal CNRCallCount{get;set;}
        @AuraEnabled 
        public Decimal totalCallNotReceivedCount{get;set;}
        @AuraEnabled 
        public Decimal UnqualifiedDuetoCNR{get;set;}

        public reportDataWrapperClass() {
            this.leadCount = 0;
            this.conductedCount = 0;
            this.notConductedCount = 0;
            this.receivedByCustCount = 0;
            this.notReceivedByCustCount = 0;
            this.CNRCallCount = 0;
            this.totalCallNotReceivedCount = 0;
            this.UnqualifiedDuetoCNR = 0;
        }
    }
}