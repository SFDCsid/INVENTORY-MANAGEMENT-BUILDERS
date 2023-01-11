@isTest
public class Test_ZbAPI_Opp {
    @isTest
    public static void ZeroBounce2(){
        Account acc = new Account(Name = 'Test Yash',Company__c = 'Stetig');
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.AccountId = acc.id;
        opp.StageName = 'New';
        opp.CloseDate = System.today();
        opp.Email__c = 'yash.wani@stetig.in';        
        opp.On_Demand_Email_Check__c = true;        
        insert opp;
        
        opp.Email__c = 'yash1.wani@stetig.in';
        opp.On_Demand_Email_Check__c = true;
        String Status = 'test';
        opp.Email_Status__c = 'test';
        opp.Email_Sub_Status__c = 'test';
        update opp;
        
    }
}