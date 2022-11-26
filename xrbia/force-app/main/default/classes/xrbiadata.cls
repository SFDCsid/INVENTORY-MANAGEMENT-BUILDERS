public with sharing class xrbiadata {
    @AuraEnabled (cacheable=true)
    public static Map<String,String> getProject(){
        Map<String,String> projectMap = new Map<String,String>();
        for (Project__c projectObj : [Select id,Name FROM Project__c]) {
            projectMap.put(projectObj.id, projectObj.Name);
        }
        return projectMap;
    }
   
   @AuraEnabled(cacheable=true)
   public static list<Tower__c> getTower(){
    list<Tower__c> towerlist = [SELECT Id,	Name, Project__r.Name , Sector__r.Name FROM Tower__c];
    return towerlist;
    
   }
   @AuraEnabled(cacheable=true)
   public static list<Unit__c> getUnit(){
    list<Unit__c> unitlist = [SELECT Id, Name,Tower__r.Name FROM Unit__c];
    return unitlist;
   
   }
   @AuraEnabled(cacheable=true)
   public static list<Sector__c> getSector(){
    list<Sector__c> sectorlist = [SELECT Id, Name, 	Project__r.Name FROM Sector__c];
    return sectorlist;
   }
}
