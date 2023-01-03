//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class LeadTriggerHandler {
    public static void beforeInsert(List<Lead__c> leadList) {
        List<Lead__c> lList = new List<Lead__c>();
        Map<Id, List<Lead__c>> pLeadMap = new Map<Id, List<Lead__c>>();
        
        for(Lead__c l: leadList) {
            if(!l.Legacy_Record__c)
                lList.add(l);
            if(l.Project__c != null && l.Apply_Round_Robin__c) {
                if(!pLeadMap.containsKey(l.Project__c)) {
                    List<Lead__c> newList = new List<Lead__c>();
                    newList.add(l);
                    pLeadMap.put(l.Project__c, newList);
                } else {
                    pLeadMap.get(l.Project__c).add(l);
                }
            }
        }
        if(!lList.isEmpty() && lList != null)
        	LeadHandlerServices.duplicationCheck(lList);
        if(!pLeadMap.isEmpty() && pLeadMap != null)
            LeadHandlerServices.assignQueueOnLead(pLeadMap);
    }
    
    public static void afterInsert(List<Lead__c> leadList) {
        List<Lead__c> lList = new List<Lead__c>();
        //List<Lead__c> cLeadList = new List<Lead__c>();
        Map<Id, Id> leadOwners = new Map<Id, Id>();
        
        for(Lead__c l: leadList) {
        	if(l.Campaign_Custom__c != null)
                lList.add(l);
            //if(l.Campaign_Code__c != null)
                //cLeadList.add(l);
            if(String.valueOf(l.OwnerId).startswith('00G'))
                leadOwners.put(l.Id, l.OwnerId);
        }
        if(!lList.isEmpty() && lList != null)
            CampaignHandlerServices.calculateCampaignPerformance('Lead', leadList, null);
        //if(!cLeadList.isEmpty() && cLeadList != null)
            //CampaignHandlerServices.createCampaignMember(cLeadList);
        if(!leadOwners.isEmpty() && leadOwners != null)
            LeadHandlerServices.applyRoundRobinLogic(leadOwners);
    }
    
    public static void beforeUpdate(Map<Id, Lead__c> oldMap, Map<Id, Lead__c> newMap) {
        List<Lead__c> lList = new List<Lead__c>();
        
        for(Lead__c oldLead: oldMap.values()) {
            Lead__c newLead = newMap.get(oldLead.Id);
            
            if(oldLead.MobilePhone__c != newLead.MobilePhone__c || oldLead.Phone__c != newLead.Phone__c || oldLead.Email__c != newLead.Email__c || oldLead.Alternate_Email__c != newLead.Alternate_Email__c || oldLead.Project__c != newLead.Project__c)
                lList.add(newLead);
            
             }
        
        if(!lList.isEmpty() && lList != null)
        	LeadHandlerServices.duplicationCheck(lList);
    }
    
    public static void afterUpdate(Map<Id, Lead__c> oldMap, Map<Id, Lead__c> newMap) {
        //List<Lead__c> cLeadList = new List<Lead__c>();
        
		for(Lead__c oldLead: oldMap.values()) {
            Lead__c newLead = newMap.get(oldLead.Id);
            
            //if(oldLead.Campaign_Code__c != newLead.Campaign_Code__c && newLead.Campaign_Code__c != null)
                //cLeadList.add(newLead);
        }
        //if(!cLeadList.isEmpty() && cLeadList != null)
            //CampaignHandlerServices.createCampaignMember(cLeadList);
    }
}