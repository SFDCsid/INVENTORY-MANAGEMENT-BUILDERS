//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 22-11-2022
//-------------------------------------------//
@isTest
public class TestDigitalLeadHandlerServices {
    @isTest
    public static void createfbLead()
    {
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p;
        
        Account a = new Account(FirstName = 'Test', LastName = 'Account', PersonMobilePhone = '4455667723');
        insert a;
        Opportunity__c op = new Opportunity__c(Name = 'Test Opp', AccountId__c = a.Id, StageName__c = 'In Follow-up', CloseDate__c = system.today().addDays(30), Project__c = p.id);
        insert op;
        
        Campaign__c c2 = new Campaign__c();
        c2.RecordTypeId = Schema.SObjectType.Campaign__c.getRecordTypeInfosByName().get('TV Plan').getRecordTypeId();
        c2.Name = 'Test Project';
        c2.IsActive__c = true;
        c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        c2.StartDate__c = system.today();
        c2.EndDate__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        c2.Campaign_Code__c = '123';
        c2.Campaign_Type__c =  'TV Plan';
        c2.Media__c = 'Print';
        c2.Status__c = 'Approved';
        insert c2;
        c2.Campaign_Code__c = c2.Id;
        update c2;
        
        Digital_Lead__c dl = new Digital_Lead__c();
        dl.Lead_Id__c = '1234';
        dl.Full_Name__c = 'Test fb';
        dl.Form_Id__c = c2.id;
        dl.Mobile__c = '4455667722';
        dl.Email__c = 'test@fb.com';
        dl.Platform__c = 'Facebook';
        insert dl;
        
        Digital_Lead__c dl1 = new Digital_Lead__c();
        dl1.Lead_Id__c = '12345';
        dl1.Full_Name__c = 'Test fb';
        dl1.Form_Id__c = c2.id;
        dl1.Mobile__c = '4455667722';
        dl1.Email__c = 'test@fb.com';
        dl1.Platform__c = 'Facebook';
        insert dl1;
        
        Digital_Lead__c dl2 = new Digital_Lead__c();
        dl2.Lead_Id__c = '123456';
        dl2.Full_Name__c = 'Test';
        dl2.Form_Id__c = c2.id;
        dl2.Mobile__c = '4455667723';
        dl2.Email__c = 'test@fb1.com';
        dl2.Platform__c = 'Facebook';
        insert dl2;   
    }   
}