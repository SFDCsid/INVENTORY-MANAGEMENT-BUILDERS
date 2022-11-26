public with sharing class AmountController {
    public AmountController() {

    }

    @AuraEnabled(cacheable=true)
    public static List <Amount__c> getAmount( ){
        
        return[select id,	Product_Code__c , Product_Name__c from Amount__c];
    }
}
