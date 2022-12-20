@isTest
public class TestREST_WebIntegration {
    @isTest
    public static Map<String, Id> createCampaign() {
        Map<String, Id> returnMap = new Map<String,Id>();
        
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p;
        returnMap.put('Project', p.Id);
        
        Campaign c2 = new Campaign();
        c2.Name = 'Test Project';
        c2.IsActive = true;
        c2.Type = 'Advertisement'; 
        c2.Master_Source__c = 'Hoardings';
        c2.Lead_Source__c = 'Billboard';
      //  c2.Lead_Sub_Source__c = 'Mindicator';
        c2.Project__c = p.id;
        c2.StartDate = system.today();
        c2.EndDate = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        insert c2;
        // c2.Campaign_Code__c = c2.Id;
        // update c2;
        returnMap.put('Child Campaign 1', c2.Id);
        
        
        Campaign c4 = new Campaign();
        c4.Name = 'Test Project';
        c4.IsActive = true;
        c4.Type = 'Advertisement'; 
        c4.Master_Source__c = 'Hoardings';
        c4.Lead_Source__c = 'Billboard';
        //c3.Lead_Sub_Source__c = 'Mindicator';
        c4.Project__c = p.id;
        c4.StartDate = system.today();
        c4.EndDate = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Weekly';
        insert c4;
        // c4.Campaign_Code__c = c4.Id;
        // update c4;
		returnMap.put('Child Campaign 3', c4.Id); 
        
        
        Campaign c3 = new Campaign();
        c3.Name = 'Test Project';
        c3.IsActive = true;
        c3.Type = 'Advertisement'; 
        c3.Master_Source__c = 'Hoardings';
        c3.Lead_Source__c = 'Billboard';
        //c3.Lead_Sub_Source__c = 'Mindicator';
        c3.Project__c = p.id;
        c3.StartDate = system.today();
        c3.EndDate = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';
       
        insert c3;
       //  c4.Campaign_Code__c = c4.Id;
        // update c4;
        
        Campaign_Performance__c cpl = new Campaign_Performance__c();
        cpl.Lead_Count__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign__c = c2.id;
        
        insert cpl;
        
        
       
        //update c3;
		returnMap.put('Child Campaign 2', c3.Id); 
        
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
        
        Account a = new Account(FirstName = 'Test', LastName = 'Account', PersonMobilePhone = '1122334455' , RecordTypeId = devRecordTypeId);
        insert a;
        Opportunity op = new Opportunity(Name = 'Test Opp', AccountId = a.Id, StageName = 'In Follow-up', CloseDate = system.today().addDays(30), Project__c = resultMap.get('Project'));
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
    
}