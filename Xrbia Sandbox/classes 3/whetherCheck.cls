public with sharing class whetherCheck {
    public whetherCheck() {

    }
    @AuraEnabled (cacheable=true)
    public static Map<ID, Lead__c> isChecked(string ID){
        Map<ID, Lead__c> checkMap = new Map<ID, Lead__c>(); 
        for (Lead__c l : [select Id,IsConverted__c FROM Lead__c where id=:ID]){
            if(l.IsConverted__c == true){
                checkMap.put(l.Id,l);
            }   
            else{
                System.debug('error');
            } 
        }
        return checkMap;
    }
}