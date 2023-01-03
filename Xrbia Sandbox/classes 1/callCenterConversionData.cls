public with sharing class callCenterConversionData {
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getProjects(){
        Map<String,String> projectMap = new Map<String,String>();
        for (Project__c projectObj : [Select id,Name FROM Project__c]) {
            projectMap.put(projectObj.id, projectObj.Name);
        }
        return projectMap; 
    }
    @AuraEnabled (cacheable=true)
    public static Map<String, reportDataWrapperClass> Wrapper(String pId, Date sdate, Date edate ){
        Map<String, reportDataWrapperClass> wrapperMap = new Map<String, reportDataWrapperClass>();
        List<AggregateResult> totalCallsCount = new List<AggregateResult>();
        List<AggregateResult> svSchedule = new List<AggregateResult>();
        List<AggregateResult> followupSchedule = new List<AggregateResult>();
        List<AggregateResult> svConducted = new List<AggregateResult>();
        List<AggregateResult> unqualifiedList = new List<AggregateResult>();
        Decimal totalCall = 0;
        Decimal totalsvScheduleCount = 0;
        Decimal totalfollowupCount = 0;
        Decimal totalsvConductedCount = 0;
        Decimal totalunqualifiedCount = 0;
        Decimal totalconversionRatio = 0;
        

        if(pId == 'All'){
            totalCallsCount = [select owner.name ownerName, count(Id) lcount from Lead__c where Created_Date__c >=:sdate AND Created_Date__c <=:edate AND Total_Call_Duration__c!= Null AND Total_Call_Duration__c>0 
                           	  group by owner.name];
            System.debug('totalCallsCount::'+totalCallsCount);
        }else if(pId!='All'){
            totalCallsCount = [select owner.name ownerName, count(Id) lcount from Lead__c where Project__c =: pId AND Created_Date__c >=:sdate AND Created_Date__c <=:edate  
                           	   AND Total_Call_Duration__c!= Null AND Total_Call_Duration__c>0 group by owner.name];
            System.debug('totalCallsCount::'+totalCallsCount);
        }
        if(pId == 'All'){
            svSchedule = [select owner.name ownerName, count(Id) svSchCount from Lead__c where Status__c ='Site Visit Scheduled' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate AND 
                          Total_Call_Duration__c!= Null AND Total_Call_Duration__c>0 group by owner.name];
            system.debug('svSchedule: '+svSchedule);
        }else if(pId != 'All'){
            svSchedule = [select owner.name ownerName, count(Id) svSchCount from Lead__c where Project__c=:pId AND Status__c ='Site Visit Scheduled' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate AND 
                          Total_Call_Duration__c!= Null AND Total_Call_Duration__c>0 group by owner.name];
            system.debug('svSchedule: '+svSchedule);
        }
        if(pId == 'All'){
            followupSchedule = [select owner.name ownerName, count(Id) fUpCount from Lead__c where Status__c ='In-Followup' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                                AND Total_Call_Duration__c!= Null AND Total_Call_Duration__c>0 group by owner.name];
            system.debug('followupSchedule: '+followupSchedule);
        }else if(pId != 'All'){
            followupSchedule = [select owner.name ownerName, count(Id) fUpCount from Lead__c where Project__c =: pId AND Status__c ='In-Followup' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                                AND Total_Call_Duration__c!= Null AND Total_Call_Duration__c>0 group by owner.name];
            system.debug('followupSchedule: '+followupSchedule);
        }
        if(pId == 'All'){
            svConducted = [select owner.name ownerName, count(Id) svConductCount from Lead__c where Status__c ='Site Visit Conducted' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate AND
                           Total_Call_Duration__c!= Null AND Total_Call_Duration__c>0 group by owner.name];
            system.debug('svConducted: '+svConducted);
        }else if(pId != 'All'){
            svConducted = [select owner.name ownerName, count(Id) svConductCount from Lead__c where Project__c =: pId AND Status__c ='Site Visit Conducted' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate AND
                           Total_Call_Duration__c!= Null AND Total_Call_Duration__c>0 group by owner.name];
            system.debug('svConducted: '+svConducted);
        }
        if(pId == 'All'){
            unqualifiedList = [select owner.name ownerName, count(Id) unCount from Lead__c where Status__c ='Unqualified' AND Total_Call_Duration__c!= Null AND Total_Call_Duration__c>0 
                           AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('unqualifiedList::'+unqualifiedList);
        }else if(pId != 'All'){
            unqualifiedList = [select owner.name ownerName, count(Id) unCount from Lead__c where Project__c =: pId AND Status__c ='Unqualified' AND Total_Call_Duration__c!= Null AND Total_Call_Duration__c>0
                           AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('unqualifiedList::'+unqualifiedList);
        }
        
        if(!totalCallsCount.isEmpty() && totalCallsCount != null) {
            for(AggregateResult ag: totalCallsCount) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.totalCalls = (Decimal)ag.get('lcount'); 
                    totalCall += (Decimal)ag.get('lcount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.totalCalls = (Decimal)ag.get('lcount');
                    totalCall += (Decimal)ag.get('lcount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!svSchedule.isEmpty() && svSchedule != null) {
            for(AggregateResult ag: svSchedule) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.svScheduleCount = (Decimal)ag.get('svSchCount'); 
                    totalsvScheduleCount += (Decimal)ag.get('svSchCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.svScheduleCount = (Decimal)ag.get('svSchCount'); 
                    totalsvScheduleCount += (Decimal)ag.get('svSchCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!followupSchedule.isEmpty() && followupSchedule != null) {
            for(AggregateResult ag: followupSchedule) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.followupCount = (Decimal)ag.get('fUpCount');
                    totalfollowupCount += (Decimal)ag.get('fUpCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.followupCount = (Decimal)ag.get('fUpCount'); 
                    totalfollowupCount += (Decimal)ag.get('fUpCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!svConducted.isEmpty() && svConducted != null) {
            for(AggregateResult ag: svConducted) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.svConductedCount = (Decimal)ag.get('svConductCount');
                    totalsvConductedCount += (Decimal)ag.get('svConductCount');
                    if(rwc.totalCalls > 0)
                        rwc.conversionRatio = (rwc.svConductedCount/rwc.totalCalls).setScale(2,System.RoundingMode.HALF_UP);
                    else 
                        rwc.conversionRatio = 0;                                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.svConductedCount = (Decimal)ag.get('svConductCount');
                    totalsvConductedCount += (Decimal)ag.get('svConductCount');
                    if(rwc.totalCalls > 0)
                        rwc.conversionRatio = (rwc.svConductedCount/rwc.totalCalls).setScale(2,System.RoundingMode.HALF_UP);
                    else 
                        rwc.conversionRatio = 0;
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!unqualifiedList.isEmpty() && unqualifiedList != null) {
            for(AggregateResult ag: unqualifiedList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.unqualifiedCount = (Decimal)ag.get('unCount');
                    totalunqualifiedCount += (Decimal)ag.get('unCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.unqualifiedCount = (Decimal)ag.get('unCount');  
                    totalunqualifiedCount += (Decimal)ag.get('unCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(totalCall > 0){
            totalconversionRatio = ((totalsvConductedCount / totalCall)*100).setScale(2,System.RoundingMode.HALF_UP);
        }
		reportDataWrapperClass rwc = new reportDataWrapperClass();
        rwc.totalCalls = totalCall;
        rwc.svScheduleCount = totalsvScheduleCount;
        rwc.followupCount = totalfollowupCount;
        rwc.svConductedCount = totalsvConductedCount;
        rwc.unqualifiedCount = totalunqualifiedCount;
        rwc.conversionRatio = totalconversionRatio;
        
        if(pId == 'All'){
            wrapperMap.put('Total', rwc);
        }        
        
        system.debug('wrapperMap: '+wrapperMap);
        return wrapperMap;
    }
    public class reportDataWrapperClass{
        
        @AuraEnabled 
        public Decimal totalCalls{get;set;}
        @AuraEnabled 
        public Decimal svScheduleCount{get;set;}
        @AuraEnabled 
        public Decimal followupCount{get;set;}
        @AuraEnabled 
        public Decimal svConductedCount{get;set;}
        @AuraEnabled 
        public Decimal unqualifiedCount{get;set;}
        @AuraEnabled 
        public Decimal conversionRatio{get;set;}
        

        public reportDataWrapperClass() {
            this.totalCalls = 0;
            this.svScheduleCount = 0;
            this.followupCount = 0;
            this.svConductedCount = 0;
            this.unqualifiedCount = 0;
            this.conversionRatio = 0;
        }
    }
}