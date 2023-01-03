//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class MarketingBriefHandlerServices {
    public static void validationCheck(Map<Id, Marketing_Brief__c> mbMap) {
        List<AggregateResult> cList = new List<AggregateResult>();
        Map<Id, AggregateResult> cMap = new Map<Id, AggregateResult>();
        
        cList = [Select Marketing_Brief__c, SUM(Planned_Cost__c) plannedCost, SUM(Planned_Leads__c) plannedLeads, SUM(Planned_Visits__c) plannedVisits, 
                 SUM(Planned_Bookings__c) plannedBookings from Campaign__c where Marketing_Brief__c IN: mbMap.keySet() AND 
                 (Status__c = 'Planning' OR Status__c = 'Sent for Approval' OR Status__c = 'Approved' OR Status__c = 'Completed')
                 GROUP BY Marketing_Brief__c ORDER BY Marketing_Brief__c];
        system.debug('cList: '+cList);
        
        if(!cList.isEmpty() && cList != null) {
            for(AggregateResult ag: cList) {
                cMap.put((Id)ag.get('Marketing_Brief__c'), ag);
            }
        }
        
        /*if(!mbMap.isEmpty() && mbMap != null) {
            for(Marketing_Brief__c mb: mbMap.values()) {
                if(cMap.containsKey(mb.Id)) {
                    if(mb.Expected_Bookings__c > (Decimal)cMap.get(mb.Id).get('plannedBookings'))
                        mb.addError('Marketing Brief Expected Bookings is Greater Than All Campaign Planned Bookings');
                    if(mb.Expected_Visits__c > (Decimal)cMap.get(mb.Id).get('plannedVisits'))
                        mb.addError('Marketing Brief Expected Visits is Greater Than All Campaign Planned Visits');
                    if(mb.Expected_Leads__c > (Decimal)cMap.get(mb.Id).get('plannedLeads'))
                        mb.addError('Marketing Brief Expected Leads is Greater Than All Campaign Planned Leads');
                    if(mb.Expected_Cost__c < (Decimal)cMap.get(mb.Id).get('plannedCost'))
                        mb.addError('Marketing Brief Expected Cost is Less Than All Campaign Planned Cost');
                } else {
                    mb.addError('There is no campaign for approval.');
                }
            }
        }*/
    }
    
    public static void sendCampaignForApproval(Set<Id> mbSet) {
        List<Marketing_Brief__c> marketingBriefList = new List<Marketing_Brief__c>();
        List<Marketing_Brief__c> updateMarketingBriefList = new List<Marketing_Brief__c>();
        List<Campaign__c> campaignList = new List<Campaign__c>();
        List<Campaign__c> updateCampaignList = new List<Campaign__c>();
        
        marketingBriefList = [Select Id, Name, Status__c, Send_for_Approval__c from Marketing_Brief__c where Id IN: mbSet];
        system.debug('marketingBriefList: '+marketingBriefList);
        
        if(!marketingBriefList.isEmpty() && marketingBriefList != null) {
            for(Marketing_Brief__c mb: marketingBriefList) {
                mb.Send_for_Approval__c = false;
                mb.Status__c = 'Campaigns in Approval';
                updateMarketingBriefList.add(mb);
            }
        }
        
        campaignList = [Select Id, Name, Status__c from Campaign__c where Marketing_Brief__c IN: mbSet AND Status__c = 'Planning'];
        system.debug('campaignList: '+campaignList);
        
        if(!campaignList.isEmpty() && campaignList != null) {
            for(Campaign__c c: campaignList) {
                c.Status__c = 'Sent for Approval';
                updateCampaignList.add(c);
            }
        }
        if(!updateMarketingBriefList.isEmpty() && updateMarketingBriefList != null)
            update updateMarketingBriefList;
        if(!updateCampaignList.isEmpty() && updateCampaignList != null)
            update updateCampaignList;
    }
}