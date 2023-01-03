//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class CampaignHandlerServices {
    public static void rollUpOnMarketingBrief(Set<Id> cIdSet, String Type) {
        List<AggregateResult> cList = new List<AggregateResult>();
        Map<Id, AggregateResult> cMap = new Map<Id, AggregateResult>();
        List<Marketing_Brief__c> mbList = new List<Marketing_Brief__c>();
        Map<Id, Marketing_Brief__c> mbMap = new Map<Id, Marketing_Brief__c>();
        List<Marketing_Brief__c> updateMBList = new List<Marketing_Brief__c>();
        
        cList = [Select Marketing_Brief__c, SUM(Planned_Cost__c) plannedCost, SUM(Planned_Leads__c) plannedLeads, SUM(Planned_Visits__c) plannedVisits, 
                 SUM(Planned_Bookings__c) plannedBookings, SUM(Actual_Cost__c) actualCost, SUM(Actual_Leads__c) actualLeads, SUM(Actual_Visits__c) actualVisits, 
                 SUM(Actual_Bookings__c) actualBookings from Campaign__c where Marketing_Brief__c IN: cIdSet AND (Status__c = 'Approved' OR Status__c = 'Completed')
                 GROUP BY Marketing_Brief__c];
        system.debug('cList: '+cList);
        
        if(!cList.isEmpty() && cList != null) {
            for(AggregateResult ag: cList) {
                cMap.put((Id)ag.get('Marketing_Brief__c'), ag);
            }
        }
        
        mbList = [Select Id, Name, Planned_Cost__c, Planned_Leads__c, Planned_Visits__c, Planned_Bookings__c,
                  Actual_Cost__c, Actual_Leads__c, Actual_Visits__c, Actual_Bookings__c from Marketing_Brief__c
                  where Id IN: cMap.keySet()];
        system.debug('mbList: '+mbList);
        
        if(!mbList.isEmpty() && mbList != null) {
            for(Marketing_Brief__c mb: mbList) {
                mbMap.put(mb.Id, mb);
            }
        }
        
        if(!mbMap.isEmpty() && mbMap != null) {
            for(Marketing_Brief__c mb: mbMap.values()) {
                if(cMap.containsKey(mb.Id)) {
                    if(Type.equalsIgnoreCase('Planned')) {
                        mb.Planned_Cost__c = (Decimal)cMap.get(mb.Id).get('plannedCost');
                        mb.Planned_Leads__c = (Decimal)cMap.get(mb.Id).get('plannedLeads');
                        mb.Planned_Visits__c = (Decimal)cMap.get(mb.Id).get('plannedVisits');
                        mb.Planned_Bookings__c = (Decimal)cMap.get(mb.Id).get('plannedBookings');
                    }
                    if(Type.equalsIgnoreCase('Actual')) {
                        mb.Actual_Cost__c = (Decimal)cMap.get(mb.Id).get('actualCost');
                        mb.Actual_Leads__c = (Decimal)cMap.get(mb.Id).get('actualLeads');
                        mb.Actual_Visits__c = (Decimal)cMap.get(mb.Id).get('actualVisits');
                        mb.Actual_Bookings__c = (Decimal)cMap.get(mb.Id).get('actualBookings');
                    }
                    updateMBList.add(mb);
                }
            }
        }
        if(!updateMBList.isEmpty() && updateMBList != null)
            update updateMBList;
    }
    
    public static void createCampaignPerformance(Set<Id> cId) {
        List<Campaign_Performance__c> cpList = new List<Campaign_Performance__c>();
        List<Campaign__c> cList = [Select Id, Name, IsActive__c, StartDate__c, EndDate__c, Performance_Measure_On__c from Campaign__c 
                                	where Id IN: cId];
        system.debug('cList: '+cList);
        
        if(!cList.isEmpty()) {
            for(Campaign__c c : cList) {
                Integer fDay   = c.StartDate__c.day();
                Integer fMonth = c.StartDate__c.month();
                Integer fYear  = c.StartDate__c.year();
                Integer tDay   = c.EndDate__c.day();
                Integer tMonth = c.EndDate__c.month();
                Integer tYear  = c.EndDate__c.year();
                Date fromDate  = Date.newInstance(fYear, fMonth, fDay);
                Date toDate    = Date.newInstance (tYear, tMonth, tDay);
                System.debug(fromDate +' : '+ toDate);
                
                if(c.Performance_Measure_On__c == 'Daily') {
                    while(fromDate <= toDate) {
                        Campaign_Performance__c cp = new Campaign_Performance__c();
                        cp.Campaign__c = c.Id;
                        cp.Start_Date__c = fromDate;
                        cp.End_Date__c = fromDate;
                        cpList.add(cp);
                        
                        //Add 1 Day In From Date
                        fromDate = fromDate.addDays(1);
                    }
                } else if(c.Performance_Measure_On__c == 'Weekly') {
                    while(fromDate <= toDate) {
                        Campaign_Performance__c cp = new Campaign_Performance__c();
                        cp.Campaign__c = c.Id;
                        cp.Start_Date__c = fromDate;
                        Date endDate = fromDate.addDays(6);
                        if(toDate > endDate)
                            cp.End_Date__c = endDate;
                        else
                            cp.End_Date__c = toDate;
                        cpList.add(cp);
                        
                        //Add 7 Day In From Date
                        fromDate = fromDate.addDays(7);
                    }
                } else if(c.Performance_Measure_On__c == 'Monthly') {
                    while(fromDate <= toDate) {
                        Campaign_Performance__c cp = new Campaign_Performance__c();
                        if(fMonth == tMonth && fYear == tYear) {
                            cp.Campaign__c = c.Id;
                            cp.Start_Date__c = fromDate;
                            cp.End_Date__c = toDate;
                            cpList.add(cp);
                        } else {
                            cp.Campaign__c = c.Id;
                            cp.Start_Date__c = fromDate;
                            Date endDate = Date.newInstance(fromDate.year(), fromDate.month(), Date.daysInMonth(fromDate.year(), fromDate.month()));
                            if(toDate > endDate)
                                cp.End_Date__c = endDate;
                            else
                                cp.End_Date__c = toDate;
                            cpList.add(cp);
                        } 
                        fromDate = fromDate.addMonths(1).toStartOfMonth();
                    }
                }
            }
            system.debug('cpList: '+cpList);
            system.debug('cpList Size: '+cpList.size());
            if(!cpList.isEmpty())
                insert cpList;
        }
    }
    
   public static void updateCampaignDetails(Set<Id> cIdSet, String objectType) {
        List<Campaign__c> cList = new List<Campaign__c>();
        Map<Id, Campaign__c> campaignMap = new Map<Id, Campaign__c>();
        List<AggregateResult> objectList = new List<AggregateResult>();
        List<Campaign__c> updateCampaignList = new List<Campaign__c>();
        
        cList = [Select Id, Name, Actual_Visits__c, Actual_Bookings__c from Campaign__c
                 where Id IN: cIdSet];
        system.debug('cList: '+cList);
        
        if(!cList.isEmpty() && cList != null) {
            for(Campaign__c c: cList) {
                campaignMap.put(c.Id, c);
            }
        }
        
        if(objectType.equalsIgnoreCase('Site Visit')) {
            objectList = [Select Campaign_Custom__c, SUM(Site_Visit_Count__c) svCount from Opportunity__c where Campaign_Custom__c IN: cIdSet GROUP BY Campaign_Custom__c];
            system.debug('objectList: '+objectList);
            
            if(!objectList.isEmpty() && objectList != null) {
                for(AggregateResult ag: objectList) {
                    if(campaignMap.containsKey((String) ag.get('Campaign_Custom__c'))) {
                        Campaign__c c = campaignMap.get((String) ag.get('Campaign_Custom__c'));
                        c.Actual_Visits__c = (Decimal) ag.get('svCount');
                        updateCampaignList.add(c);
                    }
                }
            }
        } else if(objectType.equalsIgnoreCase('Booking')) {
            objectList = [Select Campaign_Custom__c, COUNT(Id) bookingCount from Opportunity__c where Campaign_Custom__c IN: cIdSet AND Booking__c != null GROUP BY Campaign_Custom__c];
            system.debug('objectList: '+objectList);
            
            if(!objectList.isEmpty() && objectList != null) {
                for(AggregateResult ag: objectList) {
                    if(campaignMap.containsKey((String) ag.get('Campaign_Custom__c'))) {
                        Campaign__c c = campaignMap.get((String) ag.get('Campaign_Custom__c'));
                        c.Actual_Bookings__c = (Decimal) ag.get('bookingCount');
                        updateCampaignList.add(c);
                    }
                }
            }
        }
        if(!updateCampaignList.isEmpty() && updateCampaignList != null)
            update updateCampaignList;
    } 
    
    public static void calculateCampaignPerformance(String Type, List<Lead__c> leadList, List<Task> taskList) {
        List<Campaign_Performance__c> campaignPerformanceList = new List<Campaign_Performance__c>();
        List<Campaign_Performance__c> updateCampaignPerformanceList = new List<Campaign_Performance__c>();
        
        if(Type == 'Lead') {
            campaignPerformanceList = [Select Id, Name, Start_Date__c, End_Date__c, Actual_Leads__c, Campaign__c from Campaign_Performance__c
                                       where Campaign__c =: leadList[0].Campaign_Custom__c AND Start_Date__c <=: leadList[0].Created_Date__c
                                       AND End_Date__c >=: leadList[0].Created_Date__c LIMIT 1];
            system.debug('campaignPerformanceList: '+campaignPerformanceList);
            
            if(!campaignPerformanceList.isEmpty()) {
                if(campaignPerformanceList[0].Actual_Leads__c == null) {
                    campaignPerformanceList[0].Actual_Leads__c = 0;
                }
                campaignPerformanceList[0].Actual_Leads__c = campaignPerformanceList[0].Actual_Leads__c + 1;
                updateCampaignPerformanceList.add(campaignPerformanceList[0]);
            }                            
        } else if(Type == 'Task') {
            campaignPerformanceList = [Select Id, Name, Start_Date__c, End_Date__c, Actual_Enquiries__c, Campaign__c from Campaign_Performance__c
                                        where Campaign__c =: taskList[0].Campaign__c AND Start_Date__c <=: taskList[0].Created_Date__c
                                        AND End_Date__c >=: taskList[0].Created_Date__c LIMIT 1];
            system.debug('campaignPerformanceList: '+campaignPerformanceList);
            
            if(!campaignPerformanceList.isEmpty()) {
                if(campaignPerformanceList[0].Actual_Enquiries__c == null) {
                    campaignPerformanceList[0].Actual_Enquiries__c = 0;
                }
                campaignPerformanceList[0].Actual_Enquiries__c = campaignPerformanceList[0].Actual_Enquiries__c + 1;
                updateCampaignPerformanceList.add(campaignPerformanceList[0]);
            }
        }
        
        system.debug('updateCampaignPerformanceList: '+updateCampaignPerformanceList);
        if(!updateCampaignPerformanceList.isEmpty())
            update updateCampaignPerformanceList;
    }
    
    /*public static void createCampaignMember(List<Lead> leadList) {
        List<CampaignMember> memberList = new List<CampaignMember>();
        Map<String, List<Lead>> campaignLeadMap = new Map<String, List<Lead>>();
        Map<String, Campaign> campaignMap = new Map<String, Campaign>();
        List<Campaign> cList = new List<Campaign>();
        
        for(Lead l: leadList) {
            if(!campaignLeadMap.containsKey(l.Campaign_Code__c)) {
                List<Lead> lList = new List<Lead>();
                lList.add(l);
                campaignLeadMap.put(l.Campaign_Code__c, lList);
            } else {
                campaignLeadMap.get(l.Campaign_Code__c).add(l);
            }
        } 
        
        if(campaignLeadMap != null && !campaignLeadMap.isEmpty()) {
            cList = [Select Id, Name, Campaign_Code__c, IsActive, StartDate, EndDate from Campaign where Campaign_Code__c IN: campaignLeadMap.keySet() AND IsActive = true];
            system.debug('cList: '+cList);
            
            if(!cList.isEmpty() && cList != null) {
                for(Campaign c: cList) { 
                    campaignMap.put(c.Campaign_Code__c, c);
                }
            } 
        }
        
        if(campaignMap != null && !campaignMap.isEmpty()) {
            for(String code: campaignMap.keySet()) {
                List<Lead> getLeadList = new List<Lead>();
                getLeadList = campaignLeadMap.get(code);
                
                if(!getLeadList.isEmpty() && getLeadList != null) {
                    for(Lead l: getLeadList) {
                        CampaignMember cm = new CampaignMember(CampaignId = campaignMap.get(code).Id, LeadId = l.Id, Status = 'Responded');
                      	memberList.add(cm);
                    }
                }
            }
        }
        if(!memberList.isEmpty() && memberList != null)
            insert memberList;
    }*/
}