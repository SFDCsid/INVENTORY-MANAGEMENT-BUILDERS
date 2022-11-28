public with sharing class TOOGLEAPEX {
    
    @AuraEnabled (cacheable=true) 
    public static  User userAPEX(){
       
        list<User> toGGLE =  [SELECT Id , lwcActive__c FROM User where Id=:UserInfo.getUserId()];
       system.debug(toGGLE[0]);
         return toGGLE[0];
      
       
    }
   
}
