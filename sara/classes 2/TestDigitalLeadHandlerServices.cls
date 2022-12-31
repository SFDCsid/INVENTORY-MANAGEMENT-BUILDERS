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
        Opportunity op = new Opportunity(Name = 'Test Opp', AccountId = a.Id, StageName = 'In Follow-up', CloseDate = system.today().addDays(30), Project__c = p.id);
        insert op;
        
        Campaign c2 = new Campaign();
        c2.Name = 'Test Project';
        c2.IsActive = true;
        c2.Type = 'Advertisement'; 
        c2.Master_Source__c = 'Digital';
        c2.Lead_Source__c = 'Aggregator';
        c2.Lead_Sub_Source__c = 'Magicbricks';
        c2.Project__c = p.id;
        c2.StartDate = system.today();
        c2.EndDate = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        
        insert c2;
        
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