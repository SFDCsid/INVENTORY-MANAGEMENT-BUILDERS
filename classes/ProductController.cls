public with sharing class ProductController {
    public ProductController() {

    }
@AuraEnabled(cacheable=true)
public static List<Product__c> getProducts( ){
    
 return[select id,	Product_Code__c , Product_Name__c from Product__c];
}

}
