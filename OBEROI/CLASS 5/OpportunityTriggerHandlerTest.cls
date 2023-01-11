/***************************************************************************************************
Class Covered: OpptyTrigger - Trigger - 90%
OpportunityTriggerHandler - Class - 83%  
***************************************************************************************************/
@isTest(seeAllData=false)
public class OpportunityTriggerHandlerTest {
    static Set<Id> campIdSet;
    static List<Campaign> campList;
    static List<Project__c> lstOfProjects;
    static List<Opportunity> lstOfOpp;
    static List<Campaign> lstOfCampaign;
    
    @isTest
    public static void createCO(){
        Account ac = new Account();
        ac.LastName = 'test';
        ac.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        insert ac;
        
        Site__c s = new Site__c();
        s.Name = 'test';
        s.Active__c = true;
        insert s;
        
        User u = new User();
        u.FirstName = 'test';
        u.LastName = 'test2';
        u.Email = 'test@test.com';
        u.Username = 'test@tstt.com';
        u.MobilePhone = '1234567890';
        u.CommunityNickname = 'testshvbsihv';
        Profile p = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator'];
        u.ProfileId = p.id;
        u.LastName = 'test';
        u.Alias = 'tst';
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.IsActive = True;
        insert u;
        
        Project__c pr = new Project__c();
        pr.Active__c = true;
        pr.Name = 'test';
        pr.Site__c = s.Id;
        pr.CFO__c = u.Id;
        pr.Front_Desk_User__c = u.Id;
        pr.Marcom_Head__c = u.Id;
        pr.Marcom_Manager__c = u.Id;
        pr.MD__c = u.Id;
        pr.Sales_Head__c = u.Id;
        pr.Site_Head__c = u.Id;
        pr.Plant__c = '4788';
        pr.Company_name__c = '4788';
        pr.Amount__c = 1000000;
        pr.Payment_Options__c = 'Payment not Required';
        insert pr;
        
        EOI__c eo= new EOI__c();
        eo.Mobile_No_1__c = '1234567890';
        eo.Email__c = 'test@test.com';
        eo.Don_t_create_applicant2_as_co_owner__c = false;
        eo.Applicant_Name_2__c = 'test';
        eo.Don_t_create_applicant3_as_co_owner__c = false;
        eo.Applicant_Name_3__c = 'test';
        eo.Don_t_create_applicant4_as_co_owner__c = false;
        eo.Applicant_Name_4__c = 'test';
        eo.Don_t_create_applicant5_as_co_owner__c = false;
        eo.Applicant_Name_5__c = 'test';
        eo.Project__c = pr.Id;
        insert eo;
        
        Opportunity o = new Opportunity();
        o.AccountId = ac.Id;
        o.Name = 'test';
        o.Project__c = pr.Id;
        o.Site__c = s.Id;
        o.Initial_EOI__c = eo.Id;
        o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        o.StageName = 'New';
        o.CloseDate = system.today() + 10;
        insert o;
        o.Update_booking_details__c = true;
        update o;
        o.Update_booking_details__c = false;
        update o;
        o.Opportunity_Status__c='Closed';
        update o;
    }
    
    @TestSetup
    private static void createTestData() {
        campList = new List<Campaign>(TestDataFactory.createCampaign(1));
        campList[0].Marketing_Campaign_Cost__c =10;
        campList[0].Advertisement_Cost__c =10;
        campList[0].Marketing_Plan_Cost__c =10;
        campList[0].Marketing_Channel_Cost__c  =10;
        
        insert campList[0];
        campIdSet = new Set<Id>();
        for(Campaign camp: campList) {
            campIdSet.add(camp.Id);
        }
        System.debug('Ids ' +campIdSet);    
        
        OpportunityTriggerHandler.updateBookingCountOnCampaign(campIdSet);
        
    }
    
    @IsTest static void opportunityTest1(){ 
        list<lead> l=TestDataFactory.createResLead(1);
        
        insert l;
        lstOfProjects = TestDataFactory.createResProject(1);
        INSERT lstOfProjects;
        
        lstOfOpp = TestDataFactory.createOpportunity(4);
        
        lstOfCampaign = TestDataFactory.createCampaign(1);
        INSERT lstOfCampaign;       
        
        lstOfOpp[0].StageName= 'Follow Up';
        lstOfOpp[0].Opportunity_Status__c='Site Visit Scheduled';
        lstOfOpp[0].LeadSource='Web';
        lstOfOpp[0].Date_of_Site_Visit__c=datetime.newInstance(System.Today().year(), System.Today().month(), System.Today().day(), 12, 30, 0);
        lstOfOpp[0].Country_Code__c='+91';
        lstOfOpp[0].Mobile__c='9744227656';
        
        lstOfOpp[0].Project__c=lstOfProjects[0].Id;
        lstOfOpp[0].CampaignId = lstOfCampaign[0].Id;
        
        lstOfOpp[1].StageName= 'Follow Up';
        lstOfOpp[1].Opportunity_Status__c='Site Visit Rescheduled';
        lstOfOpp[1].Date_of_Site_Visit__c=datetime.newInstance(System.Today().year(), System.Today().month(), System.Today().day(), 12, 30, 0);
        lstOfOpp[1].Country_Code__c='+91';
        lstOfOpp[1].Mobile__c='9744227656';
        lstOfOpp[1].Project__c=lstOfProjects[0].Id;
        lstOfOpp[1].CampaignId = lstOfCampaign[0].Id;
        
        lstOfOpp[2].StageName= 'Follow Up';
        lstOfOpp[2].Opportunity_Status__c='Site Visit Scheduled';
        lstOfOpp[2].Date_of_Site_Visit__c=datetime.newInstance(System.Today().year(), System.Today().month(), System.Today().day(), 12, 30, 0);
        lstOfOpp[2].Country_Code__c='+91';
        lstOfOpp[2].Mobile__c='9744227656';
        lstOfOpp[2].Project__c=lstOfProjects[0].Id;
        lstOfOpp[2].CampaignId = lstOfCampaign[0].Id;
        
        
        Test.startTest();
        INSERT lstOfOpp;
        //System.debug('stage='+lstOfOpp[0].StageName+'=status='+lstOfOpp[0].Opportunity_Status__c+'=mobile='+lstOfOpp[0].Mobile__c);
        
        lstOfOpp[3].StageName= 'Booked';
        lstOfOpp[3].Opportunity_Status__c='Booked';
        lstOfOpp[3].Date_of_Site_Visit__c=datetime.newInstance(System.Today().year(), System.Today().month(), System.Today().day(), 12, 30, 0);
        lstOfOpp[3].Country_Code__c='+91';
        lstOfOpp[3].Mobile__c='9744127656';
        lstOfOpp[3].Project__c=lstOfProjects[0].Id;
        lstOfOpp[3].CampaignId = lstOfCampaign[0].Id;
        
        lstOfOpp[2].StageName= 'Lost';
        lstOfOpp[2].Opportunity_Status__c='Closed';
        lstOfOpp[2].Partner_Mobile_Country_Code__c='+91';
        lstOfOpp[2].Country_Code_for_Other_Mobile_Number__c='+91';
        lstOfOpp[2].Related_Lead__c=l[0].id;
        UPDATE lstOfOpp;
        
        OpportunityTriggerHandler.GetCountryName('+91');
        OpportunityTriggerHandler.dummy();
        Test.stopTest();           
        
    }
    
    
    
}