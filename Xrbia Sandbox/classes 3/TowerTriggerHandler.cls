//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 16-11-2022
//-------------------------------------------//
public class TowerTriggerHandler {
	public static void beforeUpdate(Map<Id, Tower__c> oldMap, Map<Id, Tower__c> newMap) {
        Map<Id, List<Tower__c>> projectTowerMap = new Map<Id, List<Tower__c>>();
        
        for(Tower__c oldTower: oldMap.values()) {
            Tower__c newTower = newMap.get(oldTower.Id);
            
            if((oldTower.Base_Rate__c != newTower.Base_Rate__c || oldTower.Floor_Rise__c != newTower.Floor_Rise__c || oldTower.Premium__c != newTower.Premium__c) && newTower.Project__c != null) {
                if(projectTowerMap.containsKey(newTower.Project__c)) {
                    projectTowerMap.get(newTower.Project__c).add(newTower);
                } else {
                    List<Tower__c> newList = new List<Tower__c>();
                    newList.add(newTower);
                    projectTowerMap.put(newTower.Project__c, newList);
                }
            }
        }
        if(!projectTowerMap.isEmpty() && projectTowerMap != null)
            TowerHandlerServices.updateApprovals(projectTowerMap);
    }
    
    public static void afterUpdate(Map<Id, Tower__c> oldMap, Map<Id, Tower__c> newMap) {
        Set<Id> tIdSet = new Set<Id>();
        
        for(Tower__c oldTower: oldMap.values()) {
            Tower__c newTower = newMap.get(oldTower.Id);
            
            if(oldTower.Rate_Change_Approval_Status__c != newTower.Rate_Change_Approval_Status__c && newTower.Rate_Change_Approval_Status__c == 'Approved')
                tIdSet.add(newTower.Id);
        }
        if(!tIdSet.isEmpty() && tIdSet != null)
            TowerHandlerServices.updatePriceListDetail(tIdSet);
    }
}