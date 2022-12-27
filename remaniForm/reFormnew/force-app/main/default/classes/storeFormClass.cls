public with sharing class storeFormClass {
    @AuraEnabled
    public static List<Stock__c> recRecords(Id mpId){
        try {
            List<Stock__c> listBom = new List<Stock__c>();
            System.debug('Bill of Material: ');
            // Get the Map of Schema of Bill_Of_Material__c SObject
            Map<String, Schema.SObjectField> fieldMap = Stock__c.sObjectType.getDescribe().fields.getMap();
                    
            // Get all of the fields on the object
            Set<String> setFieldNames = fieldMap.keySet();
            list<String> lstFieldNames = new List<String>(setFieldNames);
            // Dynamic Query String.
            listBom = Database.query('SELECT '+String.join(lstFieldNames,',')+' FROM Stock__c where Store__c =: mpId ');
            System.debug('Bill of Material: '+ listBom);
            System.debug('Bill of Material: '+ listBom.size());
            return listBom;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled (cacheable=true)
    public static list<Requisition_Entry__c> materialMethod(string materialId){
        list<Requisition_Entry__c> materialList = [select Id,Material__c, Requisition_Quantity__c, Material_Name__c,Store__c  from Requisition_Entry__c where Material__c = 'a002w00000TRQRSAA5' and Store__c = 'a092w00001pYQ9cAAG' ];
      return materialList;
     
    }
}
