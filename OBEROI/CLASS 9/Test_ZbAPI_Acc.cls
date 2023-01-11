@isTest
public class Test_ZbAPI_Acc {
    @isTest
    public static void ZeroBounce(){
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.PersonEmail = 'yash.wani@stetig.in';
        acc.On_Demand_Email_Check__c = true;
        insert acc;
        
        acc.PersonEmail = 'yash1.wani@stetig.in';
        acc.On_Demand_Email_Check__c = true;
        String Status = 'test';
        acc.Email_Status__c = 'test';
        acc.Email_Sub_Status__c = 'test';
        acc.Status__c = 'test';
        update acc;
    }
}