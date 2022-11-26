public with sharing class TOOGLEAPEX {
    
    @AuraEnabled (cacheable=true) 
    public static  User userAPEX(){
       
        list<User> toGGLE =  [SELECT lwcActive__c FROM User where Id=:UserInfo.getUserId()];
       
         return toGGLE[0];
      
       
    }
   
}
