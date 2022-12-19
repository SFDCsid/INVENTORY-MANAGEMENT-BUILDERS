public class LeadTriggerHandler {
    public static void beforeInsert(List<Lead> leadList) {
        List<Lead> lList = new List<Lead>();
        List<Lead> clusterLeadList = new List<Lead>();
        
        for(Lead l: leadList) {
            clusterLeadList.add(l);
            if(!l.Legacy_Record__c) {
                lList.add(l);
            }
        }
        if(!clusterLeadList.isEmpty() && clusterLeadList != null)
            LeadHandlerServices.updateClusterOnLead(clusterLeadList);
        //LeadHandlerServices.validationCheck(leadList);
        if(!lList.isEmpty() && lList != null)
        	LeadHandlerServices.duplicationCheck(lList);
    }
    
    public static void afterInsert(List<Lead> leadList) {
        List<Lead> lList = new List<Lead>();
        List<Lead> cLeadList = new List<Lead>();
        
        for(Lead l: leadList) {
        	if(l.Campaign_Custom__c != null)
                lList.add(l);
            if(l.Campaign_Code__c != null)
                cLeadList.add(l);
        }
        if(!lList.isEmpty() && lList != null)
            CampaignHandlerServices.calculateCampaignPerformance('Lead', leadList, null);
        if(!cLeadList.isEmpty() && cLeadList != null)
            CampaignHandlerServices.createCampaignMember(cLeadList);
    }
    
    public static void beforeUpdate(Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {
        //List<Lead> valLeadList = new List<Lead>();
        List<Lead> lList = new List<Lead>();
        
        for(Lead oldLead: oldMap.values()) {
            Lead newLead = newMap.get(oldLead.Id);
            
            if(oldLead.MobilePhone != newLead.MobilePhone || oldLead.Phone != newLead.Phone || oldLead.Email != newLead.Email || oldLead.Alternate_Email__c != newLead.Alternate_Email__c || oldLead.Project__c != newLead.Project__c)
                lList.add(newLead);
        }
        //if(!valLeadList.isEmpty() && valLeadList != null)
            //LeadHandlerServices.validationCheck(valLeadList);
        if(!lList.isEmpty() && lList != null)
        	LeadHandlerServices.duplicationCheck(lList);
    }
    
    public static void afterUpdate(Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {
        List<Lead> cLeadList = new List<Lead>();
        Map<Id, Id> leadOwners = new Map<Id, Id>();

        for(Lead oldLead: oldMap.values()) {
            Lead newLead = newMap.get(oldLead.Id);
            
            if(oldLead.Campaign_Code__c != newLead.Campaign_Code__c && newLead.Campaign_Code__c != null)
                cLeadList.add(newLead);
            if(oldLead.OwnerId != newLead.OwnerId && String.valueOf(newLead.OwnerId).startswith('00G'))
                leadOwners.put(newLead.Id, newLead.OwnerId);
        }
        if(!cLeadList.isEmpty() && cLeadList != null)
            CampaignHandlerServices.createCampaignMember(cLeadList);
        if(!leadOwners.isEmpty() && leadOwners != null)
            LeadHandlerServices.applyRoundRobinLogic(leadOwners);
    }
}