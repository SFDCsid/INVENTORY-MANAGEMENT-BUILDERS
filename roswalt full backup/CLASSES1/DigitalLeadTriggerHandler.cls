//-------------------------------------------//
//  Project: Roswalt Developers
//  Created By: Exceller Consultancy
//  Created Date: 18-11-2022
//-------------------------------------------//
public with sharing class DigitalLeadTriggerHandler {
    public static void afterInsert(List<Digital_Lead__c> dList) {
        Set<Id> dLeadId = new Set<Id>();
        
        for(Digital_Lead__c dl: dList) {
            if(!dl.Executed__c)
                dLeadId.add(dl.Id);
        }
        if(!dLeadId.isEmpty() && dLeadId != null)
            DigitalLeadHandlerServices.fbLeadProcess(dLeadId);
    }
    
    public static void afterUpdate(Map<Id, Digital_Lead__c> oldMap, Map<Id, Digital_Lead__c> newMap) {
        Set<Id> dLeadId = new Set<Id>();
        
        for(Digital_Lead__c oldLead: oldMap.values()) {
            Digital_Lead__c newLead = newMap.get(oldLead.Id);
            
            if(oldLead.Executed__c != newLead.Executed__c && !newLead.Executed__c)
                dLeadId.add(newLead.Id);
        }
        if(!dLeadId.isEmpty() && dLeadId != null)
            DigitalLeadHandlerServices.fbLeadProcess(dLeadId);
    }
}