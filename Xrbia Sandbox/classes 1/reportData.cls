public with sharing class reportData {
    
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
        List<AggregateResult> leadList = new List<AggregateResult>();
        List<AggregateResult> siteVisitList = new List<AggregateResult>();
        List<AggregateResult> bookingList = new List<AggregateResult>();
        List<AggregateResult> unqualifiedLeads = new List<AggregateResult>();
        List<AggregateResult> ringingList = new List<AggregateResult>();
        List<AggregateResult> totalConnectedCallsList = new List<AggregateResult>();
        List<AggregateResult> dailyConnectedCountList = new List<AggregateResult>();
        List<AggregateResult> callCountList = new List<AggregateResult>();
        Decimal totalLeadCount = 0;
        Decimal totalSiteVisitCount = 0;
		Decimal totalBookingCount = 0;
        Decimal totalRingingCount = 0;
        Decimal totalUnqualifiedCount = 0;
        Decimal totalTalkTimeCount = 0;
        Decimal totalDailyConnectedCount = 0;
        Decimal totalConnectedCallCount = 0;
        Decimal totalSiteVisitPercentage = 0;
        Decimal totalRingingPercentage = 0;
        Decimal totalUnqualifiedPercentage = 0;

        //LEADS
        if(pId=='All'){
            leadList = [SELECT Owner.Name ownerName, COUNT(Id) lcount FROM Lead__c where
                       Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                       GROUP BY Owner.Name
                       ORDER BY COUNT(Id) DESC];
            system.debug('leadList: '+leadList);
        }else if(pId != 'All'){
            leadList = [SELECT Owner.Name ownerName, COUNT(Id) lcount FROM Lead__c where Project__r.Id=:pId AND 
                       Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                       GROUP BY Owner.Name 
                       ORDER BY COUNT(Id) DESC];
            system.debug('leadList: '+leadList);
        }
        //SITE VISIT
        if(pId=='All'){
            siteVisitList = [select Presales_Manager__r.Name ownerName, COUNT(Id) svCount from Site_Visit__c 
                            Where Presales_Manager__c!=Null AND SV_Date__c >=:sdate AND SV_Date__c <=:edate 
                            group by Presales_Manager__r.Name ORDER BY COUNT(Id) DESC];
            system.debug('siteVisitList: '+siteVisitList);
        }else if(pId != 'All'){
            siteVisitList = [select Presales_Manager__r.Name ownerName, COUNT(Id) svCount from Site_Visit__c 
                            Where Project__r.Id=:pId AND Presales_Manager__c!=Null AND SV_Date__c >=:sdate AND SV_Date__c <=:edate 
                            group by Presales_Manager__r.Name ORDER BY COUNT(Id) DESC];
            system.debug('siteVisitList: '+siteVisitList);
        }
        //BOOKING
        if(pId=='All'){
            bookingList = [select Presales_Manager__r.Name ownerName, count(Booking__r.id) bkCount from opportunity__c 
                          Where Presales_Manager__r.Name != Null  
                          AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate group by Presales_Manager__r.Name
                          ORDER BY COUNT(Id) DESC];     
            system.debug('bookingList: '+bookingList);
        }else if(pId != 'All'){ 
            bookingList = [select Presales_Manager__r.Name ownerName, count(Booking__r.id) bkCount from opportunity__c 
                           Where Presales_Manager__r.Name != Null  AND Project__r.Id=:pId
                           AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate group by Presales_Manager__r.Name
                           ORDER BY COUNT(Id) DESC];
            system.debug('bookingList: '+bookingList);
        }
        //Unqualified Leads
        if(pId=='All'){
            unqualifiedLeads = [select Owner.Name ownerName, COUNT(Id) unCount from Lead__c 
                                where Created_Date__c >=:sdate AND Created_Date__c <=:edate     
                                AND Status__c = 'Unqualified' group by Owner.Name ORDER BY COUNT(Id) DESC];
            system.debug('unqualifiedLeads: '+unqualifiedLeads);
        }else if(pId != 'All'){
            unqualifiedLeads = [select Owner.Name ownerName, COUNT(Id) unCount from Lead__c 
                                where Project__r.Id=:pId AND Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                                AND Status__c = 'Unqualified' group by Owner.Name ORDER BY COUNT(Id) DESC];
            system.debug('unqualifiedLeads: '+unqualifiedLeads);
        }
        //Ringing List
        if(pId=='All'){
            ringingList = [select owner.name ownerName, count(Lead_Sub_Stage__c) ringC from Lead__c 
                            where Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                            AND (Lead_Sub_Stage__c ='Not Responding' OR Lead_Sub_Stage__c ='Call Misses' OR Lead_Sub_Stage__c ='Not answering / responding') 
                            group by Owner.Name ORDER BY COUNT(Lead_Sub_Stage__c) DESC];   
            system.debug('ringingCount: '+ringingList);
        }else if(pId != 'All'){
            ringingList = [select owner.name ownerName, count(Lead_Sub_Stage__c) ringC from Lead__c 
                            where Project__r.Id=:pId AND Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                            AND (Lead_Sub_Stage__c ='Not Responding' OR Lead_Sub_Stage__c ='Call Misses' OR Lead_Sub_Stage__c ='Not answering / responding') 
                            group by Owner.Name ORDER BY COUNT(Lead_Sub_Stage__c) DESC];   
            system.debug('ringingCount: '+ringingList);
        }
        //Total Connected Calls
        if(pId=='All'){
            totalConnectedCallsList = [select owner.name ownerName, count(id) totalconnect from Task   
                                      where Created_Date__c  >=:sdate AND Created_Date__c  <=:edate 
                                      AND (Call_Status__c =:'Answered' OR Call_Status__c =:'Call Complete') group by Owner.Name
                                      ORDER BY COUNT(id) DESC];
            system.debug('totalConnectedCallsList: '+totalConnectedCallsList);
        }else if(pId != 'All'){
            totalConnectedCallsList = [select owner.name ownerName, count(id) totalconnect from Task   
                                      where Project__r.Id=:pId AND Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                                      AND (Call_Status__c =:'Answered' OR Call_Status__c =:'Call Complete') group by Owner.Name
                                      ORDER BY COUNT(id) DESC];
            system.debug('totalConnectedCallsList: '+totalConnectedCallsList);
        }
        /*if(pId=='All'){
            dailyConnectedCountList = [select owner.name ownerName, count(Lead_Sub_Stage__c) dailyconnect from Lead__c 
                                        where CreatedDate =TODAY 
                                        AND (Status__c ='Incoming' OR Status__c='In-Followup' OR Status__c='Site Visit Scheduled' OR Status__c='Unqualified') 
                                        AND (Lead_Sub_Stage__c ='Call Back' OR Lead_Sub_Stage__c ='Call Scheduled' OR Lead_Sub_Stage__c ='Site Visit Reminder' OR Lead_Sub_Stage__c ='Site Visit Reminder' OR Lead_Sub_Stage__c ='Area/Configuration Mismatch' OR Lead_Sub_Stage__c ='Booked with competitor' OR Lead_Sub_Stage__c ='Budget does not match' OR Lead_Sub_Stage__c ='Commercial Property Enquiry') 
                                        group by Owner.Name];
            system.debug('dailyConnectedCountList: '+dailyConnectedCountList);
        }else if(pId != 'All'){
            dailyConnectedCountList = [select owner.name ownerName, count(Lead_Sub_Stage__c) dailyconnect from Lead__c 
                                        where Project__r.Id=:pId  
                                        AND (Status__c ='Incoming' OR Status__c='In-Followup' OR Status__c='Site Visit Scheduled' OR Status__c='Unqualified') 
                                        AND (Lead_Sub_Stage__c ='Call Back' OR Lead_Sub_Stage__c ='Call Scheduled' OR Lead_Sub_Stage__c ='Site Visit Reminder' OR Lead_Sub_Stage__c ='Site Visit Reminder' OR Lead_Sub_Stage__c ='Area/Configuration Mismatch' OR Lead_Sub_Stage__c ='Booked with competitor' OR Lead_Sub_Stage__c ='Budget does not match' OR Lead_Sub_Stage__c ='Commercial Property Enquiry') 
                                        AND CreatedDate =TODAY group by Owner.Name];
            system.debug('dailyConnectedCountList: '+dailyConnectedCountList);
        }*/

        //Total Call Count
        if(pId=='All'){
            callCountList = [select owner.name ownerName, sum(CallDurationInSeconds) duration from Task 
                            where Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name ORDER BY sum(CallDurationInSeconds) DESC];
            system.debug('callCountList: '+callCountList);
        }else if(pId != 'All'){
            callCountList = [select owner.name ownerName, sum(CallDurationInSeconds) duration from Task 
                             where Project__r.Id=:pId AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name 
                             ORDER BY sum(CallDurationInSeconds) DESC];
            system.debug('callCountList: '+callCountList);
        }
        
        
        if(!leadList.isEmpty() && leadList != null) {
            for(AggregateResult ag: leadList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.lCount = (Decimal)ag.get('lcount');                                        
                    totalLeadCount += (Decimal)ag.get('lcount');                    
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.lCount = (Decimal)ag.get('lcount');                    
                    totalLeadCount += (Decimal)ag.get('lcount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!siteVisitList.isEmpty() && siteVisitList != null) {
            for(AggregateResult ag: siteVisitList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.svCount = (Decimal)ag.get('svCount');
                    if(rwc.lCount>0)
                    	rwc.svpCount = ((rwc.svCount/rwc.lCount)*100).setScale(2,System.RoundingMode.HALF_UP);
                    else
                        rwc.svpCount = 0;
                    totalSiteVisitCount += (Decimal)ag.get('svCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } /*else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.svCount = (Decimal)ag.get('svCount');
					if(rwc.lCount>0)
                    	rwc.svpCount = ((rwc.svCount/rwc.lCount)*100).setScale(2,System.RoundingMode.HALF_UP);
                    else
                        rwc.svpCount = 0;                  
                    totalSiteVisitCount += (Decimal)ag.get('svCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }*/
            }
        }
        if(!bookingList.isEmpty() && bookingList != null) {
            for(AggregateResult ag: bookingList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.bkCount = (Decimal)ag.get('bkCount');
                    totalBookingCount += (Decimal)ag.get('bkCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } /*else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.bkCount = (Decimal)ag.get('bkCount');
                    totalBookingCount += (Decimal)ag.get('bkCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }*/
            }
        }
        if(!ringingList.isEmpty() && ringingList != null) {
            for(AggregateResult ag: ringingList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.ringingCount = (Decimal)ag.get('ringC');
                    if(rwc.lCount>0)
                        rwc.ringingpercentCount = ((rwc.ringingCount/rwc.lCount)*100).setScale(2,System.RoundingMode.HALF_UP);
                    else
                    rwc.ringingpercentCount = 0;
                    totalRingingCount += (Decimal)ag.get('ringC');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } /*else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.ringingCount = (Decimal)ag.get('ringC');
                    rwc.ringingpercentCount = 0;
                    totalRingingCount += (Decimal)ag.get('ringC');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }*/
            }
        }
        if(!unqualifiedLeads.isEmpty() && unqualifiedLeads != null) {
            for(AggregateResult ag: unqualifiedLeads) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.unqualifiedCount = (Decimal)ag.get('unCount');  
                    if(rwc.lCount>0)
                        rwc.unqualifiedPercentCount = ((rwc.unqualifiedCount/rwc.lCount)*100).setScale(2,System.RoundingMode.HALF_UP);
                    else
                        rwc.unqualifiedPercentCount = 0;
                    totalUnqualifiedCount += (Decimal)ag.get('unCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } /*else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.unqualifiedCount = (Decimal)ag.get('unCount');
                    rwc.unqualifiedPercentCount = 0;
                    totalUnqualifiedCount += (Decimal)ag.get('unCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }*/
            }
        }
        if(!callCountList.isEmpty() && callCountList != null) {
            for(AggregateResult ag: callCountList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    if((Decimal)ag.get('duration') != null) {
                        Decimal talkTime = (Decimal)ag.get('duration');
                        talkTime = talkTime.setScale(0,System.RoundingMode.HALF_UP);
                        rwc.talkTimeCount = string.valueOf(Datetime.valueOf(talkTime*1000).formatGMT('HH:mm:ss'));
                        totalTalkTimeCount += talkTime;
                        //rwc.talkTimeCount = (Decimal)ag.get('duration');
                        //rwc.talkTimeCount = (rwc.talkTimeCount/3600).setScale(2,System.RoundingMode.HALF_UP);
                        //totalTalkTimeCount += rwc.talkTimeCount;
                    } else {
                        rwc.talkTimeCount = String.valueOf(0);
                        totalTalkTimeCount += 0;
                    }
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } /*else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    if((Decimal)ag.get('duration') != null) {
                        //rwc.talkTimeCount = (Decimal)ag.get('duration');
                        Decimal talkTime = (Decimal)ag.get('duration');
                        talkTime = talkTime.setScale(0,System.RoundingMode.HALF_UP);
                        rwc.talkTimeCount = string.valueOf(Datetime.valueOf(talkTime*1000).formatGMT('HH:mm:ss'));
                        //rwc.talkTimeCount = (rwc.talkTimeCount/3600).setScale(2,System.RoundingMode.HALF_UP);
                        //Integer seconds = 7249;
                       //String totalTalkTime = Datetime.valueOf(rwc.talkTimeCount*1000).formatGMT('HH:mm:ss');
						//rwc.talkTimeCount = Datetime.valueOf(rwc.talkTimeCount*1000).formatGMT('HH:mm:ss');
                        totalTalkTimeCount += talkTime;
                        //totalTalkTimeCount += rwc.talkTimeCount;
                    } else {
                        rwc.talkTimeCount = '';
                        totalTalkTimeCount += 0;
                    }
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }*/
            }
        }
        /*if(!dailyConnectedCountList.isEmpty() && dailyConnectedCountList != null) {
            for(AggregateResult ag: dailyConnectedCountList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.dailyConnectedCount = (Decimal)ag.get('dailyconnect');
                    totalDailyConnectedCount += (Decimal)ag.get('dailyconnect');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.dailyConnectedCount = (Decimal)ag.get('dailyconnect');
                    totalDailyConnectedCount += (Decimal)ag.get('dailyconnect');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
            }
        }*/
        if(!totalConnectedCallsList.isEmpty() && totalConnectedCallsList != null) {
            for(AggregateResult ag: totalConnectedCallsList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.totalConnectedCount = (Decimal)ag.get('totalconnect');
                    if(rwc.lCount>0)
                    	rwc.dailyConnectedCount =  (rwc.totalConnectedCount/rwc.lCount).setScale(2,System.RoundingMode.HALF_UP);
                    else
                        rwc.dailyConnectedCount = 0;
                    totalDailyConnectedCount += rwc.dailyConnectedCount;
                    totalConnectedCallCount += (Decimal)ag.get('totalconnect');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } /*else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.totalConnectedCount = (Decimal)ag.get('totalconnect');
                    if(rwc.lCount>0)
                    	rwc.dailyConnectedCount = (rwc.totalConnectedCount/rwc.lCount).setScale(2,System.RoundingMode.HALF_UP);
                    else
                        rwc.dailyConnectedCount = 0;
                    totalDailyConnectedCount += rwc.dailyConnectedCount;
                    totalConnectedCallCount += (Decimal)ag.get('totalconnect');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }*/
            }
        }
        if(totalLeadCount > 0) {
            totalSiteVisitPercentage = ((totalSiteVisitCount / totalLeadCount) * 100).setScale(2,System.RoundingMode.HALF_UP);
            totalRingingPercentage = ((totalRingingCount / totalLeadCount) * 100).setScale(2,System.RoundingMode.HALF_UP);
            totalUnqualifiedPercentage = ((totalUnqualifiedCount / totalLeadCount) * 100).setScale(2,System.RoundingMode.HALF_UP);
        } else {
            totalSiteVisitPercentage = 0;
            totalRingingPercentage = 0;
            totalUnqualifiedPercentage = 0;
        }
        reportDataWrapperClass rwc = new reportDataWrapperClass();
        rwc.lCount = totalLeadCount;
        rwc.svCount = totalSiteVisitCount;
        rwc.bkCount = totalBookingCount;
        rwc.ringingCount = totalRingingCount;
        rwc.unqualifiedCount = totalUnqualifiedCount;
        rwc.svpCount = totalSiteVisitPercentage;
        rwc.ringingpercentCount = totalRingingPercentage;
        rwc.unqualifiedPercentCount = totalUnqualifiedPercentage;
        rwc.totalConnectedCount = totalConnectedCallCount;
        rwc.dailyConnectedCount = totalDailyConnectedCount;
        rwc.talkTimeCount = string.valueOf(Datetime.valueOf(totalTalkTimeCount*1000).formatGMT('HH:mm:ss'));
        if(pId=='All'){
            wrapperMap.put('Total', rwc);
        }
        
        system.debug('wrapperMap: '+wrapperMap);
        return wrapperMap;
    }
    public class reportDataWrapperClass{
        @AuraEnabled 
        public Decimal lCount{get;set;}
        @AuraEnabled 
        public Decimal bkCount{get;set;}
        @AuraEnabled 
        public Decimal svCount{get;set;}
        @AuraEnabled
        public Decimal ringingCount{get;set;}
        @AuraEnabled
        public Decimal unqualifiedCount{get;set;}
        @AuraEnabled
        public Decimal svpCount{get;set;}
        @AuraEnabled
        public Decimal ringingpercentCount{get;set;}
        @AuraEnabled
        public Decimal unqualifiedPercentCount{get;set;}
        @AuraEnabled
        public Decimal totalConnectedCount{get;set;}
        @AuraEnabled
        public Decimal dailyConnectedCount{get;set;}
        @AuraEnabled
        public String talkTimeCount{get;set;}

        public reportDataWrapperClass() {
            this.lCount = 0;
            this.bkCount = 0;
            this.svCount = 0;
            this.ringingCount = 0;
            this.unqualifiedCount = 0;
            this.svpCount = 0;
            this.ringingpercentCount = 0;
            this.unqualifiedPercentCount = 0;
            this.totalConnectedCount = 0;
            this.dailyConnectedCount = 0;
            this.talkTimeCount = '';
        }
    }
}