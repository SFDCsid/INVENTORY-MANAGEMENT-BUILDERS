public with sharing class getUser {

    @AuraEnabled(Cacheable=true)
    public static String getCurrentUser(){
        String userName = UserInfo.getName(); 
        system.debug('userName::'+ userName);
        return userName;
    }
}