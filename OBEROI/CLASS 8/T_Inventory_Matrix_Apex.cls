public class T_Inventory_Matrix_Apex {
    @AuraEnabled(cacheable=true)
    public static List<Tower__c> getOpportunity(string oppId) { //List<QuotationManagmentServices.SAPPricingWrapper> AVList,
        List<Tower__c> towerList = new List<Tower__c>();
        Opportunity op = [SELECT Id,Project__c FROM Opportunity WHERE Id=:oppId];
        If(op != NULL){
            towerList = [SELECT Id,Name,Tower_Name__c,Image_Path__c FROM Tower__c WHERE Project_Name__c =: op.Project__c];
        }
        system.debug('op:: '+op);
        return towerList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Property__c> getunits(string towerId) { //List<QuotationManagmentServices.SAPPricingWrapper> AVList,
        List<Property__c> unitList = new List<Property__c>();
        unitList = [SELECT Id,Name,Status__c,House_Unit_No__c,Floor_No__c FROM Property__c WHERE Tower__c =: towerId ORDER BY House_Unit_No__c ASC];
        System.debug('unitList=>'+unitList);
        return unitList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Floor__c> getFloor(string towerId) { //List<QuotationManagmentServices.SAPPricingWrapper> AVList,
        List<Floor__c> floorList = new List<Floor__c>();
        floorList = [SELECT Id,Name,Floor_Number__c FROM Floor__c WHERE Tower__c =: towerId ORDER BY Floor_Number__c ASC];
        System.debug('floorList=>'+floorList);
        return floorList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Property__c> getunit(string unitId) { //List<QuotationManagmentServices.SAPPricingWrapper> AVList,
        List<Property__c> unit = new List<Property__c>();
        unit = [SELECT Id,Name,Status__c,House_Unit_No__c,Floor_No__c,Super_Area__c,Built_Up_Area__c,Built_Up_Area_In_Sq_Mtr1__c,Balcony_Area__c,
                Floor_Area__c
                FROM Property__c WHERE Id =: unitId];
        System.debug('unit=>'+unit);
        return unit;
    }
}