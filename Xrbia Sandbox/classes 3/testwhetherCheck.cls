@isTest
public with sharing class testwhetherCheck {
    @isTest
    public static void testMethod1() {
        
        Lead__c l1 = new Lead__c();
        l1.First_Name__c = 'lead';
        l1.Last_Name__c = 'Test';
        l1.MobilePhone__c = '902485793';
        l1.IsConverted__c = true;
        insert l1;
        whetherCheck.isChecked(l1.Id);
    }
}