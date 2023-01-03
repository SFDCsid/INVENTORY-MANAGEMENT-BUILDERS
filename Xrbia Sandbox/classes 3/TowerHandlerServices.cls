//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 16-11-2022
//-------------------------------------------//
public class TowerHandlerServices {
    public static void updateApprovals(Map<Id, List<Tower__c>> projectTowerMap) {
        Map<String, Team_Member__c> teamMemberMap = new Map<String, Team_Member__c>();
        
        for(Id pId: projectTowerMap.keySet()) {
            teamMemberMap = Ex_InventoryPriceManagementServices.getApprovalTeamMemberDetails(pId, 'Rate Change Team');
            
            if(!teamMemberMap.isEmpty() && teamMemberMap != null) {
                for(Tower__c t: projectTowerMap.get(pId)) {
                    for(String s: teamMemberMap.KeySet()) {
                        if(s.equalsIgnoreCase('Level 1'))
                            t.Level_1_Approver__c = teamMemberMap.get(s).User__c;
                        else if(s.equalsIgnoreCase('Level 2'))
                            t.Level_2_Approver__c = teamMemberMap.get(s).User__c;
                        else if(s.equalsIgnoreCase('Level 3'))
                            t.Level_3_Approver__c = teamMemberMap.get(s).User__c;
                    }
                    t.Rate_Change_Approval_Status__c = 'Approval Pending';
                    if(String.isNotBlank(t.Level_1_Approver_Status__c))
                        t.Level_1_Approver_Status__c = '';
                    if(String.isNotBlank(t.Level_2_Approver_Status__c))
                        t.Level_2_Approver_Status__c = '';
                    if(String.isNotBlank(t.Level_3_Approver_Status__c))
                        t.Level_3_Approver_Status__c = '';
                }
            }
        }
    }
    
    public static void updatePriceListDetail(Set<Id> tIdSet) {
        Map<Id, Map<String, List<Pricing_List__c>>> priceListMap = new Map<Id, Map<String, List<Pricing_List__c>>>();
        List<Pricing_List__c> updatePriceList = new List<Pricing_List__c>();
        List<Tower__c> tList = new List<Tower__c>();
        
        tList = [Select Id, Name, Base_Rate__c, Floor_Rise__c, Floor_No_Set__c, Premium__c from Tower__c where Id IN: tIdSet];
        system.debug('tList: '+tList);
        
        if(!tList.isEmpty() && tList != null) {
            priceListMap = getPriceList(tIdSet);
            system.debug('priceListMap: '+priceListMap);
            
            if(!priceListMap.isEmpty() && priceListMap != null) {
                for(Tower__c t: tList) {
                    if(t.Base_Rate__c != null && t.Base_Rate__c > 0) {
                        for(Pricing_List__c p: priceListMap.get(t.Id).get('Basic Charge')) {
                            p.Charge_Rate__c = t.Base_Rate__c;
                            updatePriceList.add(p);
                        }
                    }
                    if(t.Floor_Rise__c != null && t.Floor_Rise__c > 0 && t.Floor_No_Set__c != null) {
                        for(Pricing_List__c p: priceListMap.get(t.Id).get('Floor Rise')) {
                            if(p.Unit__r.Floor__c >= t.Floor_No_Set__c) {
                                p.Charge_Rate__c = (((p.Unit__r.Floor__c - t.Floor_No_Set__c) + 1) * t.Floor_Rise__c);
                                updatePriceList.add(p);
                            }
                        }
                    }
                    if(t.Premium__c != null && t.Premium__c > 0) {
                        for(Pricing_List__c p: priceListMap.get(t.Id).get('Premium Charge')) {
                            p.Charge_Rate__c = t.Premium__c;
                            updatePriceList.add(p);
                        }
                    }
            	}
            }
        }
        if(!updatePriceList.isEmpty() && updatePriceList != null)
            update updatePriceList;
    }
    
    public static Map<Id, Map<String, List<Pricing_List__c>>> getPriceList(Set<Id> tIdSet) {
        Map<Id, Map<String, List<Pricing_List__c>>> priceListMap = new Map<Id, Map<String, List<Pricing_List__c>>>();
        List<Pricing_List__c> priceList = new List<Pricing_List__c>();
        
        priceList = [Select Id, Name, Charge_Bucket__c, Charge_Name__c, Charge_Rate__c, Charge_Type__c, Unit__c, Unit__r.Tower__c, Unit__r.Floor__c from Pricing_List__c
                    where Unit__r.Tower__c IN: tIdSet AND (Charge_Name__c = 'Basic Charge' OR Charge_Name__c = 'Floor Rise' OR Charge_Name__c = 'Premium Charge')
                    ]; //AND Unit__r.Unit_Status__c = 'Vacant'
        system.debug('priceList: '+priceList);
        
        if(!priceList.isEmpty() && priceList != null) {
            for(Pricing_List__c p: priceList) {
                if(priceListMap.containsKey(p.Unit__r.Tower__c)) {
                    Map<String, List<Pricing_List__c>> getMap = priceListMap.get(p.Unit__r.Tower__c);
                    if(getMap.containsKey(p.Charge_Name__c)) {
                        getMap.get(p.Charge_Name__c).add(p);
                    } else {
                        List<Pricing_List__c> newList = new List<Pricing_List__c>();
                        newList.add(p);
                        getMap.put(p.Charge_Name__c, newList);
                    }
                    priceListMap.put(p.Unit__r.Tower__c, getMap);
                } else {
                    List<Pricing_List__c> newList = new List<Pricing_List__c>();
                    newList.add(p);
                    Map<String, List<Pricing_List__c>> newMap = new Map<String, List<Pricing_List__c>>();
                    newMap.put(p.Charge_Name__c, newList);
                    priceListMap.put(p.Unit__r.Tower__c, newMap);
                }
            }
        }
        return priceListMap;
    }
}