public with sharing class leadDetails {
    public leadDetails() {

    }
    @AuraEnabled(cacheable=true)
    public static list<Lead> getNumber(string Id){
        list<Lead> phone = [select MobilePhone,Phone from Lead where Id=: Id];
        return phone;
    }
}