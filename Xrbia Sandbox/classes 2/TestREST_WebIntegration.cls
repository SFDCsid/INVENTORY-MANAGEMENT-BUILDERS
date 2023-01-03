@isTest
public class TestREST_WebIntegration {
    @isTest
    public static Map<String, Id> createCampaign() {
        Map<String, Id> returnMap = new Map<String,Id>();
        
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p;
        returnMap.put('Project', p.Id);
        
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
        returnMap.put('Child Campaign 1', c2.Id);
        
        
        Campaign__c c4 = new Campaign__c();
        c4.RecordTypeId = Schema.SObjectType.Campaign__c.getRecordTypeInfosByName().get('TV Plan').getRecordTypeId();
        c4.Name = 'Test Project';
        c4.IsActive__c = true;
        c4.Type__c = 'Event'; 
        c4.Project__c = p.id;
        c4.StartDate__c = system.today();
        c4.EndDate__c = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Weekly';
        c4.Campaign_Code__c = '123';
        c4.Campaign_Type__c =  'TV Plan';
        c4.Media__c = 'Print';
        c4.Status__c = 'Approved';
        insert c4;
       // c4.Campaign_Code__c = c4.Id;
       // update c4;
		returnMap.put('Child Campaign 3', c4.Id); 
        
        
        Campaign__c c3 = new Campaign__c();
        c3.RecordTypeId = Schema.SObjectType.Campaign__c.getRecordTypeInfosByName().get('TV Plan').getRecordTypeId();
        c3.Name = 'Test Project';
        c3.IsActive__c = true;
        c3.Type__c = 'Event'; 
        c3.Project__c = p.id;
        c3.StartDate__c = system.today();
        c3.EndDate__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';
        c3.Campaign_Code__c = '123';
        c3.Campaign_Type__c =  'TV Plan';
        c3.Media__c = 'Print';
        c3.Status__c = 'Approved';
        insert c3;
        returnMap.put('Child Campaign 2', c3.Id); 
        
        Campaign_Performance__c cpl = new Campaign_Performance__c();
        cpl.Actual_Leads__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign__c = c2.id;
        
        insert cpl;
        cpl.Actual_Leads__c = 1;
        update cpl;
       
        //update c3;
		
       
        return returnMap;
    }
    
	@isTest
    public static void freshLead() {
        Map<String, Id> resultMap = createCampaign();
        
        REST_WebIntegration.REST_Request req1 = new REST_WebIntegration.REST_Request();
        req1.name = 'Test Lead';
        req1.mobile = '1122334455';
        req1.LeadIdentifier = 'Web';
        req1.campaignCode = resultMap.get('Child Campaign 1');
        req1.email = 'lead@test.in';
        req1.remarks = 'Web Created Lead.';
        req1.url = 'www.test.com';
        req1.UTM_Source = 'Google';
        req1.UTM_Medium = 'Ads';
        
        REST_WebIntegration.REST_Request req2 = new REST_WebIntegration.REST_Request();
        req2.name = 'Test Lead';
        req2.mobile = '1122334455';
        req2.LeadIdentifier = 'Web';
        req2.campaignCode = resultMap.get('Child Campaign 2');
        req2.email = 'lead@test.in';
        req2.remarks = 'Web Created Lead.';
        req2.url = 'www.test.com';
        req2.UTM_Source = 'Google';
        req2.UTM_Medium = 'Ads';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/CreateLead/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        REST_WebIntegration.createLead(req1);
        REST_WebIntegration.createLead(req2);
        Test.stopTest();
    }
    
    @isTest
    public static void opportunityPresent() {
        Map<String, Id> resultMap = createCampaign();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account a = new Account(FirstName = 'Test', LastName = 'Account', PersonMobilePhone = '1122334455', RecordTypeId = devRecordTypeId);
        insert a;
        system.debug('Test: '+a.PersonContactId);
        Opportunity__c op = new Opportunity__c(Name = 'Test Opp', AccountId__c = a.Id, StageName__c = 'Assigned', CloseDate__c = system.today().addDays(30), Project__c = resultMap.get('Project'));
        insert op;
        
        REST_WebIntegration.REST_Request req1 = new REST_WebIntegration.REST_Request();
        req1.name = 'Test Lead';
        req1.mobile = '1122334455';
        req1.LeadIdentifier = 'Web';
        req1.campaignCode = resultMap.get('Child Campaign 1');
        req1.email = 'lead@test.in';
        req1.remarks = 'Web Created Lead.';
        req1.url = 'www.test.com';
        req1.UTM_Source = 'Google';
        req1.UTM_Medium = 'Ads';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/CreateLead/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        REST_WebIntegration.createLead(req1);
        Test.stopTest();
    }
    
    
    @isTest
    public static void LeadPresent() {
        Map<String, Id> resultMap = createCampaign();
       
        Lead__c Ld = new Lead__c();
        Ld.Last_Name__c = 'Test';
        Ld.MobilePhone__c = '7788002233';
        Ld.Email__c = 'Test2@gmail.com';
        Ld.Project__c = resultMap.get('Project');
        Ld.Description__c = 'Test244';
        Ld.Campaign_Code__c = '1234';
        Ld.Apply_round_robin__c = true;
        insert Ld;
        
        REST_WebIntegration.REST_Request req1 = new REST_WebIntegration.REST_Request();
        req1.name = 'Test';
        req1.mobile = '7788002233';
        req1.LeadIdentifier = 'Web';
        req1.campaignCode = resultMap.get('Child Campaign 1');
        req1.email = 'Test2@gmail.com';
        req1.remarks = 'Web Created Lead.';
        req1.url = 'www.test.com';
        req1.UTM_Source = 'Google';
        req1.UTM_Medium = 'Ads';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/CreateLead/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        REST_WebIntegration.createLead(req1);
        Test.stopTest();
    }
}