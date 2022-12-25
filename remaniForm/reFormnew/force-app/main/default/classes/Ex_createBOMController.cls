public with sharing class Ex_createBOMController {
    @AuraEnabled
    public static List<Bill_Of_Material__c> bomRecords(Id mpId){
        try {
            List<Bill_Of_Material__c> listBom = new List<Bill_Of_Material__c>();
            System.debug('Bill of Material: ');
            // Get the Map of Schema of Bill_Of_Material__c SObject
            Map<String, Schema.SObjectField> fieldMap = Bill_Of_Material__c.sObjectType.getDescribe().fields.getMap();
                    
            // Get all of the fields on the object
            Set<String> setFieldNames = fieldMap.keySet();
            list<String> lstFieldNames = new List<String>(setFieldNames);
            // Dynamic Query String.
            listBom = Database.query('SELECT '+String.join(lstFieldNames,',')+' FROM Bill_Of_Material__c where Milestone__c =: mpId ');
            System.debug('Bill of Material: '+ listBom);
            System.debug('Bill of Material: '+ listBom.size());
            return listBom;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Bill_Of_Material__c> savePayementPlanItemData(String ppDataString){
        System.debug('input string: '+ ppDataString);
        List<Bill_Of_Material__c> ppList = (List<Bill_Of_Material__c>)System.JSON.deserializeStrict(ppDataString, List<Bill_Of_Material__c>.Class);
        Database.insert(ppList);
        return ppList;
    }
}