//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class MarketingBriefTriggerHandler {
    public static void beforeUpdate(Map<Id, Marketing_Brief__c> oldMap, Map<Id, Marketing_Brief__c> newMap) {
        Map<Id, Marketing_Brief__c> mbMap = new Map<Id, Marketing_Brief__c>();
        
        for(Marketing_Brief__c oldMB: oldMap.values()) {
            Marketing_Brief__c newMB = newMap.get(oldMB.Id);
            
            if(oldMB.Send_for_Approval__c != newMB.Send_for_Approval__c && newMB.Send_for_Approval__c)
                mbMap.put(newMB.Id, newMB);
        }
        if(!mbMap.isEmpty() && mbMap != null)
            MarketingBriefHandlerServices.validationCheck(mbMap);
    }
    
    public static void afterUpdate(Map<Id, Marketing_Brief__c> oldMap, Map<Id, Marketing_Brief__c> newMap) {
        Set<Id> mbSet = new Set<Id>();
        
        for(Marketing_Brief__c oldMB: oldMap.values()) {
            Marketing_Brief__c newMB = newMap.get(oldMB.Id);
            
            if(oldMB.Send_for_Approval__c != newMB.Send_for_Approval__c && newMB.Send_for_Approval__c)
                mbSet.add(newMB.Id);
        }
        if(!mbSet.isEmpty() && mbSet != null)
            MarketingBriefHandlerServices.sendCampaignForApproval(mbSet);
    }
}