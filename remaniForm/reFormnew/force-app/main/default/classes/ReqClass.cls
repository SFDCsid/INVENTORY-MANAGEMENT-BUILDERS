public with sharing class ReqClass {
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
            listBom = Database.query('SELECT '+String.join(lstFieldNames,',')+' FROM Requisition_Entry__c where Milestone__c =: mpId ');
            System.debug('Bill of Material: '+ listBom);
            System.debug('Bill of Material: '+ listBom.size());
            return listBom;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Requisition_Entry__c> savePayementPlanItemData(String ppDataString){
        System.debug('input string: '+ ppDataString);
        List<Requisition_Entry__c> ppList = (List<Requisition_Entry__c>)System.JSON.deserializeStrict(ppDataString, List<Requisition_Entry__c>.Class);
        Database.insert(ppList);
        return ppList;
    }

    @AuraEnabled (cacheable=true)
    public static  list<Bill_Of_Material__c> BillMethod(string Id){
        list<Bill_Of_Material__c> billList = [SELECT   Id FROM Bill_Of_Material__c  WHERE Milestone__c =:Id ];
      return billList;
     
    }
     @AuraEnabled (cacheable=true)
    public static  list<Bill_Of_Material__c> getMaterial(string BillId){
        list<Bill_Of_Material__c> getMa = [SELECT  Id,Material__c FROM Bill_Of_Material__c  WHERE Id =:BillId  AND Material__c!=null];
        system.debug('Material__c='+getMa);
      return getMa;
     
    }

}