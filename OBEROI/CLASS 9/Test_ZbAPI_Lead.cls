@isTest
public class Test_ZbAPI_Lead {
    @isTest
	public static void ZeroBounce1(){
		
		Lead l1 = new lead();
        l1.LastName = 'Wani';
        l1.Email = 'yash.wani@stetig.in';
        l1.On_Demand_Email_Check__c = true;
        l1.MobilePhone = '9658874215';
        l1.Budget__c = '1.5 cr - 2.5 cr';
        l1.Requirement__c = '2.5 BHK';
        l1.Lead_Stage__c = 'Open';        
		insert l1;        

        l1.Email = 'yash1.wani@stetig.in';
        l1.On_Demand_Email_Check__c = true;
        String Status = 'test';
        l1.Email_Status__c = 'test';
        l1.Email_Sub_Status__c = 'test';
        update l1;     
	}      
}