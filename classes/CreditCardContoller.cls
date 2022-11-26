public with sharing class CreditCardContoller {
    public CreditCardContoller() {

    }
    @AuraEnabled(cacheable=true)
    public static List<creditcard_object__c> getCreditcard( ){
        
        return[select id,	Product_Code__c , Product_Name__c from creditcard_object__c ];
    }

  



}
