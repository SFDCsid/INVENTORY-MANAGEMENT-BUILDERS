public with sharing class CLASSREALESTATE {
    public CLASSREALESTATE() {

    }
    @AuraEnabled (cacheable=true)
    public static Map<String,String> getProject(){
        Map<String,String> projectMap = new Map<String,String>();
        for (Project__c projectObj : [Select id,Name FROM Project__c]) {
            projectMap.put(projectObj.id, projectObj.Name);
        }
        return projectMap;
    }

    @AuraEnabled (cacheable=true)
    public static Map<String,String> getSector(String Id){
        Map<String,String> sectorMap = new Map<String,String>();
        for (Sector__c sectorObj : [Select id,Name FROM Sector__c where Project__r.id =: Id ]) {
            sectorMap.put(sectorObj.id, sectorObj.Name);
        }
        return sectorMap; 
    }

    @AuraEnabled (cacheable=true)
    public static Map<String,String> getTower(String Id){
        Map<String,String> towerMap = new Map<String,String>();
        for (Tower__c towerObj : [Select id,Name FROM Tower__c where Sector__r.id =: Id ]) {
            towerMap.put(towerObj.id, towerObj.Name);
        }
        return towerMap; 
    }

    @AuraEnabled(cacheable=true)
    public static List<Unit__c> getFloor(String Id){
        Set<Unit__c> floorSet = new Set<Unit__c>();
        for(Unit__c floor:[select Floor__c from  Unit__c where Tower__r.Id=:Id ORDER BY Floor__c DESC ]){  
            floorSet.add(floor); 
            }
            List<Unit__c> floorList = new List<Unit__c>(floorSet);
            return floorList;
        }

    @AuraEnabled(cacheable=true)
    public static Map<Decimal,List<Unit__c>> getUnits(String Id){
        Map<Decimal,List<Unit__c>> unitMap = new Map<Decimal,List<Unit__c>>(); //MAP
        List<Unit__c> unitList = [select Floor__c,Name from Unit__c where Tower__r.Id=:Id];
        for(Unit__c unitDetails : unitList){ 
            unitMap.put(unitDetails.Floor__c,unitList);
            
            if(unitMap.containsKey(unitDetails.Floor__c)){
                List<Unit__c> dataList = [select Name,Status__c from Unit__c where Unit__c.Floor__c=: unitDetails.Floor__c];
                unitMap.put(unitDetails.Floor__c,dataList);
                //List<Unit__c> keyList = unitMap.get(unitDetails.Floor__c);
                //unitMap.put(unitDetails.Floor__c,keyList);
            }else {
                unitMap.put(unitDetails.Floor__c,unitList);
            }
        } //system.debug(unitMap);
        return unitMap;
    }
}
