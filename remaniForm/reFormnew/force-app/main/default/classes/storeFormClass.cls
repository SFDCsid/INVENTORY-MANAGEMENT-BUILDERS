public with sharing class storeFormClass {
    @AuraEnabled
    public static List<Requisition_Entry__c> recRecords(Id mpId){
        try {
            List<Requisition_Entry__c> listBom = new List<Requisition_Entry__c>();
            System.debug('Bill of Material: ');
            // Get the Map of Schema of Bill_Of_Material__c SObject
            Map<String, Schema.SObjectField> fieldMap = Requisition_Entry__c.sObjectType.getDescribe().fields.getMap();
                    
            // Get all of the fields on the object
            Set<String> setFieldNames = fieldMap.keySet();
            list<String> lstFieldNames = new List<String>(setFieldNames);
            // Dynamic Query String.
            listBom = Database.query('SELECT '+String.join(lstFieldNames,',')+' FROM Requisition_Entry__c where Store__c =: mpId ');
            System.debug('Bill of Material: '+ listBom);
            System.debug('Bill of Material: '+ listBom.size());
            return listBom;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
