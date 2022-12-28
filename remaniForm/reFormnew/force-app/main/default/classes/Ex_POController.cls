public with sharing class Ex_POController {
    @AuraEnabled
    public static List<Indent_Line_Item__c> returnIndentLineItem(){
        try {
            List<Indent_Line_Item__c> listILI = new List<Indent_Line_Item__c>();
            listILI = [Select Id, Name, Indent__c, Indent__r.Status__c, Indent__r.Approval_Status__c, Lead_Time_Days__c, 
                            Material__c, Material_Name__c, Requested_Quantity__c, UOM__c, Cost_Center__c, Store__c, Store_Name__c
                        from Indent_Line_Item__c
                        Where Indent__r.Status__c != 'Complete' 
                        AND Indent__r.Approval_Status__c =: 'Approved'];
            
            return listILI;            
    } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}