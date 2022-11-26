public with sharing class DebitCardController {
    public DebitCardController() {



       
    }



    @AuraEnabled(cacheable=true)
    public static List <Debit_Card__c> getDebitcard( ){
        
        return[select id,	Product_Code__c , Product_Name__c from Debit_Card__c];
    }
}
