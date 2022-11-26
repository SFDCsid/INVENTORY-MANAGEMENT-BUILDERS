public with sharing class CreditController {
    public CreditController() {

    }
@AuraEnabled(cacheable=true)
public static List<creditobject__c> getCredit( ){
    
    return[select id,	Product_Code__c , Product_Name__c from creditobject__c ];
}

}
