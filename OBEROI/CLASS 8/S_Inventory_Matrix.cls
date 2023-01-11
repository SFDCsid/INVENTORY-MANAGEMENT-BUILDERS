Public class S_Inventory_Matrix{
    @AuraEnabled(cacheable=true)
    public static Opportunity getOpportunity(string oppId) { //List<QuotationManagmentServices.SAPPricingWrapper> AVList,
        Opportunity op = QuotationManagmentServices.getOpportunityDetails(oppId);
        system.debug('op:: '+op);
        return op;
    }
    @AuraEnabled(cacheable=true)
    public static List<Tower__c> getTowerlist(string Projid) {
        List<Tower__c> Towerlist = new List<Tower__c>();
        Towerlist = [select Id, name,Tower_Name__c FROM Tower__c WHERE Project_Name__c =:  Projid];
        system.debug('Towerlist::'+Towerlist);
        return Towerlist;
    }
    @AuraEnabled(cacheable=true)
    public static List<Property__c> getUnitlist(string Towerid) {
        List<Property__c> Unitlist = new List<Property__c>();
        Unitlist = [select Id, name,Tower__c,Material_No__c,House_Unit_No__c,Status__c FROM Property__c WHERE Tower__c =:  Towerid];
        system.debug('Unitlist::'+Unitlist);
        return Unitlist;
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getFloorList(string Towerid) {
    system.debug('Towerid::'+Towerid);
        List<Property__c> Unitlist = new List<Property__c>();
        List<String> Floorlist = new List<String>();
        Set<String> FNO = new Set<String>();
        Unitlist = [select Id, name,Floor_No__c,Tower__c,Material_No__c,Unit_URL__c,Status__c FROM Property__c 
        WHERE Tower__c =:  Towerid Order by Floor_No__c Desc];
        system.debug('Unitlistfloor::'+Unitlist);
        if(Unitlist.size()>0){
            For(Property__c pro : Unitlist){
                FNO.add(String.valueOf(pro.Floor_No__c));
                system.debug('FNO::'+FNO);
            }

        }
        if(FNO.size()>0){
            for(String D:FNO){
                Floorlist.add(d);
            }
        }
        system.debug('Floorlist::'+Floorlist);
        return Floorlist;
    }
    @AuraEnabled(Cacheable=false)
    public static List<UnitWrapper> getFloorUnit(Id towerId) {                 
        List<UnitWrapper> unitWrap = new List<UnitWrapper>(); // List of UnitWrapper to return
        List<Decimal> allUnitFloorNos = new List<Decimal>(); // List of all floors in desc order
        Set<Decimal> allUniqueUnitFloorNos = new Set<Decimal>(); // Unique set of floors in desc order
        List<Decimal> uniqueFloorNoList = new List<Decimal>(); // Unique List of floors in desc order
        
        if (towerId != null) {
            List <Property__c> unitlist = ([SELECT Id, name,Floor_No__c,Tower__c,Material_No__c,House_Unit_No__c,Carpet_Area__c,Unit_URL__c,Status__c,Property_Type_Name__c  
                                        from Property__c where Tower__c = :towerId 
                                        order by Floor_No__c DESC, House_Unit_No__c ASC]);
                                        
            System.debug('UNIT LIST:' + unitList);
            
            /* List of all floors in desc order */
            for (Property__c u: unitList) {
                allUnitFloorNos.add(u.Floor_No__c); 
            }
            system.debug('allUnitFloorNos:: ' + allUnitFloorNos);
            
            /* Add all list to set so that it can have only unique floor nos. */
            allUniqueUnitFloorNos.addAll(allUnitFloorNos);
            system.debug('unique floor Nos.:: ' + allUniqueUnitFloorNos);
            
            /* Unique list of floor in desc order */
            uniqueFloorNoList.addAll(allUniqueUnitFloorNos);
            system.debug('uniqueFloorNoList:: ' + uniqueFloorNoList);
            
            for(Decimal floor: uniqueFloorNoList){
                UnitWrapper u = new UnitWrapper();
                u.floorNo = floor;
                unitWrap.add(u);
            }
            system.debug('unitWrap with floor:: ' + unitWrap);
            
            for (Property__c thisUnit: unitList) {
                system.debug('thisUnit:: ' + thisUnit.Floor_No__c);
                for(UnitWrapper uw: unitWrap){
                    if(uw.floorNo == thisUnit.Floor_No__c){  
                        system.debug('thisUnit.House_Unit_No__c:: ' + thisUnit.House_Unit_No__c);
                        uw.unitList.add(thisUnit);
                    }                
                }               
            }
            system.debug('unitWrap:: ' + unitWrap);           
        }
        return unitWrap;
    }
    public class UnitWrapper{
        @AuraEnabled public Decimal floorNo;
        @AuraEnabled public List<Property__c> unitList;
        
        UnitWrapper(){
            unitList = new List<Property__c>();
        }
    }
    
}