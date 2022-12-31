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
    public static Map<String,String> getCampaign(String pId){
        Map<String,String> campaignMap = new Map<String,String>();
        for (Campaign campaignObj : [select id, Name from Campaign where Project__r.Id=:pId]) {
            campaignMap.put(campaignObj.id, campaignObj.Name);
        }
        return campaignMap;  
    }

    @AuraEnabled (cacheable=true)
    public static Map<String, reportDataWrapperClass> Wrapper(String pId, Date sdate, Date edate, String cId){
        Map<String, reportDataWrapperClass> wrapperMap = new Map<String, reportDataWrapperClass>();
        List<AggregateResult> leadList = new List<AggregateResult>();
        List<AggregateResult> siteVisitList = new List<AggregateResult>();
        List<AggregateResult> bookingList = new List<AggregateResult>();
        List<AggregateResult> totalIncomingCountList = new List<AggregateResult>();
        List<AggregateResult> snpList = new List<AggregateResult>();
        List<AggregateResult> hotProspectCountList = new List<AggregateResult>();
        List<AggregateResult> warmProspectCountList = new List<AggregateResult>();
        List<AggregateResult> regularProspectCountList = new List<AggregateResult>();
        List<AggregateResult> nrProspectCountList = new List<AggregateResult>();
        List<AggregateResult> tomorrowFollowupCount = new List<AggregateResult>();
        List<AggregateResult> overDueCount = new List<AggregateResult>();
        List<AggregateResult> connectedCallCountList = new List<AggregateResult>();
        Datetime nextFollowupDateVar = System.today().addDays(1); 
        Decimal serialNumber;

        //TOTAL LEADS 
        if(pId=='All'){
            leadList = [SELECT Owner.Name ownerName, COUNT(Id) lcount FROM Lead where
                        Created_Date__c >=:sdate AND Created_Date__c <=:edate  GROUP BY Owner.Name];
            system.debug('leadList: '+leadList);
        }else if(pId != 'All'){
            leadList = [SELECT Owner.Name ownerName, COUNT(Id) lcount FROM Lead where Project__r.Id=:pId AND Campaign_Custom__r.Id =:cId AND
                        Created_Date__c >=:sdate AND Created_Date__c <=:edate  GROUP BY Owner.Name];
            system.debug('leadList: '+leadList);
        }
        //TOTAL SITE VISITS
        if(pId=='All'){
            siteVisitList = [select Presales_Manager__r.Name ownerName, COUNT(Id) svCount from Site_Visit__c 
                            Where Presales_Manager__c!=Null AND SV_Date__c >=:sdate AND SV_Date__c <=:edate 
                            group by Presales_Manager__r.Name];
            system.debug('siteVisitList: '+siteVisitList);
        }else if(pId != 'All'){
            siteVisitList = [select Presales_Manager__r.Name ownerName, COUNT(Id) svCount from Site_Visit__c 
                            Where Presales_Manager__c!=Null AND Project__r.Id=:pId AND SV_Date__c >=:sdate AND SV_Date__c <=:edate 
                            group by Presales_Manager__r.Name];
            system.debug('siteVisitList: '+siteVisitList);
        }
        //TOTAL BOOKINGS
        if(pId=='All'){
            bookingList = [select Presales_Manager__r.Name ownerName, count(Booking__r.id) bkCount from opportunity Where Presales_Manager__r.Name != Null 
                            AND Created_Date__c >=:sdate AND Created_Date__c<=:edate 
                            group by Presales_Manager__r.Name];
            system.debug('bookingList: '+bookingList);
        }else if(pId != 'All'){
            bookingList = [select Presales_Manager__r.Name ownerName, count(Booking__r.id) bkCount from opportunity Where Presales_Manager__r.Name != Null 
                            AND Project__r.Id=:pId AND Campaign_Custom__r.Id =:cId AND Created_Date__c >=:sdate AND Created_Date__c<=:edate 
                            group by Presales_Manager__r.Name];
            system.debug('bookingList: '+bookingList);
        }
        //TOTAL INCOMING's
        if(pId=='All'){
            totalIncomingCountList = [select Owner.Name ownername, count(Id) tcount from Lead where Project__r.Id =:pId AND Created_Date__c>=:sdate 
                                        AND Created_Date__c<=:edate AND Status=: 'Incoming' group by Owner.Name];
            system.debug('totalIncomingCountList: '+totalIncomingCountList);
        }else if(pId != 'All'){
            totalIncomingCountList = [select Owner.Name ownername, count(Id) tcount from Lead where Project__r.Id =:pId AND Campaign_Custom__r.Id =:cId 
                                     AND Created_Date__c >=:sdate AND Created_Date__c <=:edate AND Status=:'Incoming' group by Owner.Name];
            system.debug('totalIncomingCountList: '+totalIncomingCountList);
        }
        //TOTAL SNP's
        if(pId=='All'){
            snpList = [select Owner.Name ownername, count(Id) snpcount from Lead where Project__r.Id =:pId AND Created_Date__c>=:sdate 
                        AND Created_Date__c<=:edate AND Status=:'SNP'  group by Owner.Name ];   
            system.debug('snpList: '+snpList);
        }else if(pId != 'All'){
            snpList = [select Owner.Name ownername, count(Id) snpcount from Lead where Project__r.Id =:pId AND Created_Date__c>=:sdate 
                        AND Created_Date__c<=:edate AND Campaign_Custom__r.Id =:cId AND Status=:'SNP'  group by Owner.Name ];   
            system.debug('snpList: '+snpList);
        }
        //TOTAL HOT PROSPECT's
        if(pId=='All'){
            hotProspectCountList = [select Owner.Name ownername, count(Id) hotCount from Lead where Project__r.Id =:pId AND Created_Date__c>=:sdate
                                    AND Created_Date__c<=:edate AND Lead_Sub_Stage__c =:'Visit proposed (Hot)' group by Owner.Name ];
            system.debug('hotProspectCountList: '+hotProspectCountList);
        }else if(pId != 'All'){
            hotProspectCountList = [select Owner.Name ownername, count(Id) hotCount from Lead where Project__r.Id =:pId AND Created_Date__c>=:sdate
                                    AND Created_Date__c<=:edate AND Campaign_Custom__r.Id =:cId AND Lead_Sub_Stage__c =:'Visit proposed (Hot)' group by Owner.Name];
            system.debug('hotProspectCountList: '+hotProspectCountList);
        }
        //TOTAL WARM PROSPECT's
        if(pId=='All'){
            warmProspectCountList = [select Owner.Name ownername, count(Id) warmCount from Lead where Project__r.Id =:pId AND Created_Date__c>=:sdate
                                    AND Created_Date__c<=:edate AND Lead_Sub_Stage__c =:'In Follow-up (Warm)' group by Owner.Name];
            system.debug('warmProspectCountList: '+warmProspectCountList);
        }else if(pId != 'All'){
            warmProspectCountList = [select Owner.Name ownername, count(Id) warmCount from Lead where Project__r.Id =:pId AND Created_Date__c>=:sdate
                                    AND Created_Date__c<=:edate AND Campaign_Custom__r.Id =:cId AND Lead_Sub_Stage__c =:'In Follow-up (Warm)' group by Owner.Name];
            system.debug('warmProspectCountList: '+warmProspectCountList);
        }
        //TOTAL REGULAR PROSPECT's
        if(pId=='All'){
            regularProspectCountList = [select Owner.Name ownername, count(Id) regularCount from Lead where Project__r.Id =:pId 
                                        AND Created_Date__c>=:sdate AND Created_Date__c<=:edate AND Lead_Sub_Stage__c =:'In Follow-up (Regular)' 
                                        group by Owner.Name];
            system.debug('regularProspectCountList: '+regularProspectCountList);
        }else if(pId != 'All'){
            regularProspectCountList = [select Owner.Name ownername, count(Id) regularCount from Lead where Project__r.Id =:pId 
                                        AND Campaign_Custom__r.Id =:cId AND Created_Date__c>=:sdate AND Created_Date__c<=:edate AND 
                                        Lead_Sub_Stage__c =:'In Follow-up (Regular)' group by Owner.Name];
            system.debug('regularProspectCountList: '+regularProspectCountList);
        }
        //TOTAL NORESPONSE
        if(pId=='All'){
            nrProspectCountList = [select Owner.Name ownername, count(Id) nrCount from Lead where Project__r.Id =:pId 
                                    AND Created_Date__c>=:sdate AND Created_Date__c<=:edate AND Lead_Sub_Stage__c =:'In Follow-up (Noresponse)' 
                                    group by Owner.Name];
            system.debug('nrProspectCountList: '+nrProspectCountList);
        }
        else if(pId != 'All'){
            nrProspectCountList = [select Owner.Name ownername, count(Id) nrCount from Lead where Project__r.Id =:pId AND Campaign_Custom__r.Id =:cId
                                    AND Created_Date__c>=:sdate AND Created_Date__c<=:edate AND Lead_Sub_Stage__c =:'In Follow-up (Noresponse)' 
                                    group by Owner.Name];
            system.debug('nrProspectCountList: '+nrProspectCountList);
        }
        //TOTAL FOLLOWUP ON NEXT DAY
        if(pId=='All'){
            tomorrowFollowupCount = [select Owner.Name ownername, count(Id) tomFollowUpCount from Lead where Project__r.Id =:pId 
                                    AND Created_Date__c>=:sdate AND Created_Date__c<=:edate AND Presale_Next_Follow_up_Date__c=:nextFollowupDateVar 
                                    group by Owner.Name];
            system.debug('tomorrowFollowupCount: '+tomorrowFollowupCount);
        }else if(pId != 'All'){
            tomorrowFollowupCount = [select Owner.Name ownername, count(Id) tomFollowUpCount from Lead where Project__r.Id =:pId AND Campaign_Custom__r.Id =:cId
                                    AND Created_Date__c>=:sdate AND Created_Date__c<=:edate AND Presale_Next_Follow_up_Date__c=:nextFollowupDateVar 
                                    group by Owner.Name];
            system.debug('tomorrowFollowupCount: '+tomorrowFollowupCount);
        }
        //OVER DUE TASKS
        if(pId=='All'){
            overDueCount = [select Owner.Name ownername, count(Id) overdueCount from Lead where Project__r.Id =:pId 
                            AND Created_Date__c>=:sdate AND Created_Date__c<=:edate AND Presale_Next_Follow_up_Date__c < today 
                            group by Owner.Name];
            System.debug('overDueCount :'+overDueCount);
        }else{
            overDueCount = [select Owner.Name ownername, count(Id) overdueCount from Lead where Project__r.Id =:pId AND Campaign_Custom__r.Id =:cId
                            AND Created_Date__c>=:sdate AND Created_Date__c<=:edate AND Presale_Next_Follow_up_Date__c < today 
                            group by Owner.Name];
            System.debug('overDueCount :'+overDueCount);
        }
        //Connected Calls
        if(pId=='All'){
            connectedCallCountList = [select Owner.Name ownername, count(Id) connectedCall from task where Project__r.Id =:pId AND Created_Date__c>=:sdate AND Created_Date__c<=:edate
                                  AND (Call_Type__c='Outbound Call' OR Call_Type__c='Inbound Call') 
                                  AND (Status__c='Call Complete' OR Status__c='Connected' OR Status__c='ANSWER') group by Owner.Name]; 
            system.debug('connectedCallCountList:'+connectedCallCountList);
        }else{
            connectedCallCountList = [select Owner.Name ownername, count(Id) connectedCall from task where Project__r.Id =:pId AND Created_Date__c>=:sdate AND Created_Date__c<=:edate
                                  AND (Call_Type__c='Outbound Call' OR Call_Type__c='Inbound Call') 
                                  AND (Status__c='Call Complete' OR Status__c='Connected' OR Status__c='ANSWER') group by Owner.Name]; 
            system.debug('connectedCallCountList:'+connectedCallCountList);
        }

        //Lead
        if(!leadList.isEmpty() && leadList != null) {
            for(AggregateResult ag: leadList){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {                    
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.lCount = (Decimal)ag.get('lcount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.lCount = (Decimal)ag.get('lcount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
            }
        }
        //Site Visit
        if(!siteVisitList.isEmpty() && siteVisitList != null) {
            for(AggregateResult ag: siteVisitList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.svCount = (Decimal)ag.get('svCount');
                    if(rwc.lCount>0)
                        rwc.svpCount = ((rwc.svCount/rwc.lCount)*100).setScale(2,System.RoundingMode.HALF_UP);
                    else 
                        rwc.svpCount = ((rwc.svCount/rwc.lCount)*100).setScale(2,System.RoundingMode.HALF_UP);                                        
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.svCount = (Decimal)ag.get('svCount');
                    if(rwc.lCount>0)
                        rwc.svpCount = ((rwc.svCount/rwc.lCount)*100).setScale(2,System.RoundingMode.HALF_UP);                    
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
            }
        }
        //Booking
        if(!bookingList.isEmpty() && bookingList != null) {
            for(AggregateResult ag: bookingList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.bkCount = (Decimal)ag.get('bkCount');
                    rwc.bookingPercent = ((rwc.bkCount/rwc.lCount)*100).setScale(2,System.RoundingMode.HALF_UP);
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.bkCount = (Decimal)ag.get('bkCount');
                    rwc.bookingPercent = ((rwc.bkCount/rwc.lCount)*100).setScale(2,System.RoundingMode.HALF_UP);
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
            }
        }
        //Incoming
        if(!totalIncomingCountList.isEmpty() && totalIncomingCountList != null){
            for(AggregateResult ag: totalIncomingCountList){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.totalIncomingCount = (Decimal)ag.get('tcount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.totalIncomingCount = (Decimal)ag.get('tcount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
            }
        }
        //SNP
        if(!snpList.isEmpty() && snpList != null) {
            for(AggregateResult ag: snpList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.snpcount = (Decimal)ag.get('snpcount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.snpcount = (Decimal)ag.get('snpcount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
            }
        }
        //HOT
        if(!hotProspectCountList.isEmpty() && hotProspectCountList != null) {
            for(AggregateResult ag: hotProspectCountList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.totalHotCount = (Decimal)ag.get('hotCount');  
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.totalHotCount = (Decimal)ag.get('hotCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
            }
        }
        //WARM
        if(!warmProspectCountList.isEmpty() && warmProspectCountList != null) {
            for(AggregateResult ag: warmProspectCountList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.totalWarmCount = (Decimal)ag.get('warmCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.totalWarmCount = (Decimal)ag.get('warmCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
            }
        }
        //Regular
        if(!regularProspectCountList.isEmpty() && regularProspectCountList != null) {
            for(AggregateResult ag: regularProspectCountList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.totalRegularCount = (Decimal)ag.get('regularCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.totalRegularCount = (Decimal)ag.get('regularCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
            }
        }
        //NORESPONSE
        if(!nrProspectCountList.isEmpty() && nrProspectCountList != null) {
            for(AggregateResult ag: nrProspectCountList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.totalNoResponseCount = (Decimal)ag.get('nrCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.totalNoResponseCount = (Decimal)ag.get('nrCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
            }
        }
        //TOMORROW's FOLLOWUP
        if(!tomorrowFollowupCount.isEmpty() && tomorrowFollowupCount != null){
            for(AggregateResult ag:tomorrowFollowupCount){
                if(wrapperMap.containsKey((string)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((string)ag.get('ownerName'));
                    rwc.totalTomorrowFollowupCount = (Decimal)ag.get('tomFollowUpCount');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }else{
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.totalTomorrowFollowupCount = (Decimal)ag.get('tomFollowUpCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
            }
        }
        //OverDue
        if(!overDueCount.isEmpty() && overDueCount!= null){
            for(Aggregateresult ag: overDueCount){
                if(wrapperMap.containsKey((string)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.totalOverDueCount = (Decimal)ag.get('overdueCount');
                    wrapperMap.put((string)ag.get('ownerName'),rwc);
                }else{
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.totalOverDueCount = (Decimal)ag.get('overdueCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
            }
        }
        //Connected Calls
        if(!connectedCallCountList.isEmpty() && connectedCallCountList != null){
            for(AggregateResult ag: connectedCallCountList){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.totalConnected = (Decimal)ag.get('lcount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.totalConnected = (Decimal)ag.get('lcount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);
                }
            }
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
        public Decimal snpcount{get;set;}
        @AuraEnabled
        public Decimal totalIncomingCount{get;set;}
        @AuraEnabled
        public Decimal svpCount{get;set;}
        @AuraEnabled
        public Decimal totalHotCount{get;set;}
        @AuraEnabled
        public Decimal totalWarmCount{get;set;}
        @AuraEnabled
        public Decimal totalRegularCount{get;set;}
        @AuraEnabled
        public Decimal totalNoResponseCount{get;set;}
        @AuraEnabled
        public Decimal totalTomorrowFollowupCount{get;set;}
        @AuraEnabled
        public Decimal bookingPercent{get;set;}
        @AuraEnabled
        public Decimal totalOverDueCount{get;set;}
        @AuraEnabled
        public Decimal totalConnected{get;set;}
        @AuraEnabled
        public Decimal qualificationRatio{get;set;}
        @AuraEnabled
        public Decimal ratingOfTC{get;set;}
        @AuraEnabled
        public Decimal SLNO{get;set;}

        public reportDataWrapperClass() {
            this.lCount = 0;
            this.bkCount = 0;
            this.svCount = 0;
            this.snpcount = 0;
            this.totalIncomingCount = 0;
            this.svpCount = 0;
            this.totalHotCount = 0;
            this.totalWarmCount = 0;
            this.totalRegularCount = 0;
            this.totalNoResponseCount = 0;
            this.totalTomorrowFollowupCount = 0;
            this.bookingPercent = 0;
            this.totalOverDueCount = 0;
            this.totalConnected = 0;
            this.qualificationRatio = 0;
            this.ratingOfTC = 0;
            this.SLNO = 0;
        }
    }
}