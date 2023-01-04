@isTest
public class TestCustUnirestWebToLead {

    @isTest
    public static Map<String, Id> createCampaign() {
        Map<String, Id> returnMap = new Map<String,Id>();
        
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p;
        returnMap.put('Project', p.Id);
        
        Campaign__c c1 = new Campaign__c();
        c1.Name = 'Parent Campaign';
        c1.Active__c = true;
        //c1.Type__c = 'Advertisement'; 
        c1.Master_Source__c = 'Digital';
        c1.Lead_Source__c = 'Native';
        c1.Lead_Sub_Source__c = 'One Native';
        c1.Project__c = p.id;
        c1.SRD_Code__c = '12345';
        c1.Start_Date__c = system.today();
        c1.End_Date__c = system.today().addDays(20);
        c1.Performance_Measure_On__c = 'Daily';
        insert c1;
        returnMap.put('Parent Campaign', c1.Id);
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        //c2.ParentId = c1.Id;
        c2.Active__c = true;
        //c2.Type__c = 'Advertisement'; 
        c2.Master_Source__c = 'Digital';
        c2.Lead_Source__c = 'Native';
        c2.Lead_Sub_Source__c = 'One Native';
        c2.Project__c = p.id;
        c2.SRD_Code__c = '12345';
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(10);
        c2.Performance_Measure_On__c = 'Daily';
        insert c2;
        returnMap.put('Child Campaign 1', c2.Id);
        
        Campaign__c c3 = new Campaign__c();
        c3.Name = 'Test Project';
        //c3.ParentId = c1.Id;
        c3.Active__c = true;
        //c3.Type = 'Advertisement'; 
        c3.Master_Source__c = 'Digital';
        c3.Lead_Source__c = 'Native';
        //c1.Lead_Sub_Source__c = 'One Native';
        c3.Project__c = p.id;
        c3.SRD_Code__c = '123455';
        c3.Start_Date__c = system.today();
        c3.End_Date__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';
        insert c3;
		returnMap.put('Child Campaign 2', c3.Id); 
        
        return returnMap;
    }
    
	@isTest
    public static void freshLead() {
        Map<String, Id> resultMap = createCampaign();
        Project__c p = new Project__c();
            p.Name = 'Test Project';
        insert p;

        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        //c2.ParentId = c1.Id;
        c2.Active__c = true;
        //c2.Type__c = 'Advertisement'; 
        c2.Master_Source__c = 'Digital';
        c2.Lead_Source__c = 'Native';
        c2.Lead_Sub_Source__c = 'One Native';
        c2.Project__c = p.id;
        c2.SRD_Code__c = '12345';
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(10);
        c2.Performance_Measure_On__c = 'Daily';
        insert c2;

        Team__c tm = new Team__c();
        tm.Project__c = p.id;
        tm.Team_Type__c = 'Presales Team';
        insert tm;

        Team_Members__c tmm = new Team_Members__c();
        tmm.Team__c = tm.id;
        tmm.User__c = UserInfo.getUserId();
        tmm.Availability__c = true;
        insert tmm;
        
        universalWebToLead.REST_Request req1 = new universalWebToLead.REST_Request();
        req1.name = 'Test Lead';
        req1.mobile = '1122334455';
        req1.LeadIdentifier = 'Web';
        req1.did = '12345'; //resultMap.get('Child Campaign 1');
        req1.email = 'lead@test.in';
        req1.remarks = 'Web Created Lead.';
        //req1.url = 'www.test.com';
        //req1.UTM_Source = 'Google';
        //req1.UTM_Medium = 'Ads';
        
        universalWebToLead.REST_Request req2 = new universalWebToLead.REST_Request();
        req2.name = 'Test Lead';
        req2.mobile = '1122334455';
        req2.LeadIdentifier = 'Web';
        req2.did = '12345';//resultMap.get('Child Campaign 2');
        req2.email = 'lead@test.in';
        req2.remarks = 'Web Created Lead.';
        //req2.url = 'www.test.com';
        //req2.UTM_Source = 'Google';
        //req2.UTM_Medium = 'Ads';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/unileads/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        universalWebToLead.doPost(req1);
        universalWebToLead.doPost(req2);
        Test.stopTest();
    }
    
    @isTest
    public static void opportunityPresent() {
        Map<String, Id> resultMap = createCampaign();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

        Account a = new Account(FirstName = 'Test', LastName = 'Account', PersonMobilePhone = '1122334455', personEmail = 'lead@test.in',RecordTypeId = devRecordTypeId);
        insert a;
        //Opportunity_c__c op = new Opportunity_c__c(Last_Name__c = 'Test Opp', Account_Name__c = a.Id, Opportunity_Stage__c = 'In Follow-up',Project__c = resultMap.get('Project'), campaign_custom__c =resultMap.get('Child Campaign 1'));
        //insert op;
        
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project';
        insert p1;
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        //c2.ParentId = c1.Id;
        c2.Active__c = true;
        //c2.Type__c = 'Advertisement'; 
        c2.Master_Source__c = 'Digital';
        c2.Lead_Source__c = 'Native';
        c2.Lead_Sub_Source__c = 'One Native';
        c2.Project__c = p1.id;
        c2.SRD_Code__c = '12345';
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(10);
        c2.Performance_Measure_On__c = 'Daily';
        insert c2;
        
        Opportunity_c__c Opp = new Opportunity_c__c();
        opp.Last_Name__c = 'Test Opp';
        opp.Account_Name__c = a.id;
        opp.Opportunity_Stage__c = 'In Follow-up';
        //opp.Close_Date__c = system.today().addDays(1);
        opp.Project__c = p1.Id;
        opp.Campaign_Custom__c = c2.id;
        opp.Next_Follow_up_Date__c = system.now();
        insert opp;
        
        universalWebToLead.REST_Request req1 = new universalWebToLead.REST_Request();
        req1.name = 'Test Lead';
        req1.mobile = '1122334455';
        req1.LeadIdentifier = 'Web';
        req1.did = resultMap.get('Child Campaign 1');
        req1.email = 'lead@test.in';
        req1.remarks = 'Web Created Lead.';
        //req1.url = 'www.test.com';
        //req1.UTM_Source = 'Google';
        //req1.UTM_Medium = 'Ads';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/unileads/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        universalWebToLead.doPost(req1);
        Test.stopTest();
    }
    
    @isTest
    public static void LeadPresent() {
        Map<String, Id> resultMap = createCampaign();
       
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project';
        insert p1;
        
        Campaign__c c5 = new Campaign__c();
        c5.Name = 'Parent Campaign';
        c5.Active__c = true;
        //c1.Type__c = 'Advertisement'; 
        c5.Master_Source__c = 'Digital';
        c5.Lead_Source__c = 'Native';
        c5.Lead_Sub_Source__c = 'One Native';
        c5.Project__c = p1.id;
        c5.SRD_Code__c = '12345';
        c5.Start_Date__c = system.today();
        c5.End_Date__c = system.today().addDays(20);
        c5.Performance_Measure_On__c = 'Daily';
        insert c5;
        
            
        Lead_c__c Ld = new Lead_c__c();
            Ld.Last_Name__c = 'Test';
            Ld.Mobile__c = '7788002233';  
            Ld.Email__c = 'Test2@gmail.com';
            Ld.Project_Name__c = p1.id;
            //Ld.Description__c = 'Test244';
            Ld.SRD_Code__c = '1234';
            Ld.Master_Source_Category__c = 'Digital';
            Ld.Lead_Source__c = 'Google';
            Ld.Lead_Sub_Source__c = 'Google Search';
            ld.Campaign_Custom__c = c5.id;
            Ld.Apply_round_robin__c = true;
            insert Ld;
        
        universalWebToLead.REST_Request req1 = new universalWebToLead.REST_Request();
        req1.name = 'Test Lead';
        req1.mobile = '7788002233';
        req1.LeadIdentifier = 'Web';
        req1.did = resultMap.get('Child Campaign 1');
        req1.email = 'Test22@gmail.com';
        req1.remarks = 'Web Created Lead.';
        //req1.url = 'www.test.com';
        //req1.UTM_Source = 'Google';
        //req1.UTM_Medium = 'Ads';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/unileads/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        universalWebToLead.doPost(req1);
        Test.stopTest();
    } 
    
    
}