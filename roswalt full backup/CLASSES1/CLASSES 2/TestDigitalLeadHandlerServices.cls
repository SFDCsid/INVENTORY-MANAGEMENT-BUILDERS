@isTest
public with sharing class TestDigitalLeadHandlerServices {
    @isTest
    public static void createfbLead() {
        Test.startTest();
        Campaign c = New Campaign();
        c.Name = 'Test Project';
        c.isActive =True;
        c.Type = 'Advertisement';
        c.Campaign_Code__c = '78945';
        c.StartDate = system.today();
        c.EndDate = system.today().addDays(1);
        Insert c;
        system.debug(c.Campaign_Code__c );
        
        Digital_Lead__c dl = new Digital_Lead__c();
        dl.Lead_Id__c = '1234';
        dl.Form_Id__c = '78945';
        dl.Mobile__c = '4455667722';
        dl.Email__c = 'test@fb.com';
        dl.Platform__c = 'Facebook';
        dl.Executed__c = false;
        
        dl.Lead_Id__c = '12234';
        dl.Form_Id__c = c.id;
        dl.Configuration__c = '1BHK';
        dl.Ad_Name__c = 'Test Adset';
        dl.Ad_Id__c = '112233';
        dl.Adset_Id__c ='6888';
        dl.Full_Name__c = 'Test DigiLead';
        
        insert dl;
        
        Digital_Lead__c dl1 = new Digital_Lead__c();
        dl1.Lead_Id__c = '12345';
        dl1.Form_Id__c = '78945';
        dl1.Mobile__c = '9527003050';
        dl1.Email__c = 'test@fb.com';
        dl1.Platform__c = 'Facebook';
        dl1.Executed__c = false;
        dl1.Configuration__c = '1BHK';
        dl1.Ad_Name__c = 'Test Adset';
        dl1.Ad_Id__c = '112233';
        dl1.Adset_Id__c ='6888';
        dl1.Full_Name__c = 'Test DigiLead';
        
        insert dl1;
        
        Digital_Lead__c dl2 = new Digital_Lead__c();
        dl2.Lead_Id__c = '123456';
      
        dl2.Form_Id__c = '223305';
        dl2.Mobile__c = '4450667723';
        dl2.Email__c = 'test012@fb1.com';
        dl2.Platform__c = 'Facebook';
        dl2.Executed__c = false;
        dl2.Configuration__c = '1BHK';
        dl2.Ad_Name__c = 'Test Adset';
        dl2.Ad_Id__c = '112233';
        dl2.Adset_Id__c ='6888';
        dl2.Full_Name__c = 'Test DigiLead';        
        insert dl2;
     
        test.stopTest();
    }

    @isTest
    public static void ContactPresent() {
  
        Campaign c = New Campaign();
        c.Name = 'Test Project';
        c.isActive =True;
        c.Type = 'Advertisement';
        c.Master_Source__c = 'Newspaper';
        c.Lead_Source__c = 'Advertorial';
        c.Lead_Sub_Source__c = '';
        c.campaign_code__c ='223300'; 
        c.StartDate = system.today();
        c.EndDate = system.today().addDays(10);
        c.Performance_Measure_On__c = 'Monthly';
        insert c;
        system.debug(c.Campaign_Code__c ); 

        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account a = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '9527002088' , RecordTypeId = devRecordTypeId);
        insert a;
        
        Opportunity op = new Opportunity(Name = 'Test Opp', AccountId = a.Id, StageName = 'Qualification', CloseDate = system.today().addDays(30),CampaignId = c.Id);
        insert op;   // is Active
        
      
        test.startTest();   
        
        Digital_Lead__c dl = new Digital_Lead__c();
        dl.Lead_Id__c = '1234';
        dl.Form_Id__c = '223355';
        dl.Mobile__c = '9527002088';
        dl.Email__c = 'test@fb.com';
        dl.Platform__c = 'Facebook';
        dl.Executed__c = false;
        dl.Configuration__c = '1BHK';
        dl.Ad_Name__c = 'Test Adset';
        dl.Ad_Id__c = '112233';
        dl.Adset_Id__c ='6888';
        dl.Full_Name__c = 'Test DigiLead';
        dl.Adset_Name__c =  'Test Adset';
        insert dl;
       
        Digital_Lead__c dl1 = new Digital_Lead__c();
        dl1.Lead_Id__c = '12345';
        dl1.Form_Id__c = '223355';
        dl1.Mobile__c = '9527002088';
        dl1.Email__c = 'test1@fb.com';
        dl1.Platform__c = 'Facebook';
        dl1.Executed__c = false;
        dl1.Configuration__c = '1BHK';
        dl1.Ad_Name__c = 'Test Adset';
        dl1.Ad_Id__c = '112233';
        dl1.Adset_Id__c ='6888';
        dl1.Full_Name__c = 'Test DigiLead';
        dl1.Adset_Name__c =  'Test Adset';
        insert dl1;
        
        Test.stopTest();
    }  
}