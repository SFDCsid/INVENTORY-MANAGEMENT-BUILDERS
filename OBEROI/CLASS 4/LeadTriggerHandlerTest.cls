/****************************************************************************************************
Class covered :
1. LeadTriggerHandler - 7/6/2019 - 85%
2. LeadTriggerHandler2 - 7/6/2019 - 90%

****************************************************************************************************/
@isTest(seeAllData=false)
public class LeadTriggerHandlerTest {
    static List<Lead> leadList;
    static List<Virtual_Number__c> virtNoList;
    static List<Project__c> projList;
    static List<Campaign> campList;
    static Map<Id, Lead> leadOldMap;
    static Map<Id, Lead> leadNewMap;
    
    //This method covers LeadTriggerHandler2
    static testMethod void createTestData(){
        test.startTest();
        leadList = TestDataFactory.createResLead(1);
        insert leadList[0];
        campList = TestDataFactory.createCampaign(1);
        campList[0].Marketing_Campaign_Cost__c =10;
        campList[0].Advertisement_Cost__c =10;
        campList[0].Marketing_Plan_Cost__c =10;
        campList[0].Marketing_Channel_Cost__c  =10;
        insert campList;
        USer u = TestDataFactory.createUser('standard user', '');
        leadList[0].Status=Label.Lead_Status_Site_Visit_to_be_Scheduled;
        leadList[0].OwnerId= u.Id;
        leadList[0].Deferred_Task_for_Site_Visit__c = true;
        leadList[0].Deffered_Task_Campaign__c =campList[0].id;
        update leadList[0];  
        test.stopTest();        
    }
    
    //This method covers LeadTriggerHandler
    static testMethod void leadTest() {
        set<ID> pSet = new set<id>();
        set<string> noSet = new set<string>();
        leadList = TestDataFactory.createResLead(1);
        virtNoList = TestDataFactory.createVNo(3);
        projList = TestDataFactory.createResProject(1);
        campList = TestDataFactory.createCampaign(2);
        campList[0].Tracking_Code__c = 'TESTDUMMY111';
        campList[0].Marketing_Campaign_Cost__c =10;
        campList[0].Advertisement_Cost__c =10;
        campList[0].Marketing_Plan_Cost__c =10;
        campList[0].Marketing_Channel_Cost__c  =10;
        campList[1].Marketing_Campaign_Cost__c =10;
        campList[1].Advertisement_Cost__c =10;
        campList[1].Marketing_Plan_Cost__c =10;
        campList[1].Marketing_Channel_Cost__c  =10;
        campList[1].Tracking_Code__c = 'TESTDUMMY222';        
        Test.startTest();
        insert campList;
        insert projList;
        insert virtNoList;
        noSet.add(virtNoList[0].NAme);
        noSet.add(virtNoList[1].NAme);        
        LeadTriggerHandler.getVirtualNumbers(noSet);
        pSet.add(projList[0].id);
        LeadTriggerHandler.getProjects(pSet);
        leadList[0].Tracking_No__c = 'TESTDUMMY111';
        leadList[0].Project__c = projList[0].id;
        leadList[0].Country_Code__c ='+91';
        leadList[0].Country_Code_for_Other_Mobile_Number__c ='+91';
        leadList[0].Country_Code_for_Phone__c ='+91';
        leadList[0].PC_Mobile_Country_Code__c ='+91';
        leadList[0].Virtual_Number_Text__c = virtNoList[0].Name;
        insert leadList;
        leadList[0].Status = 'Follow-up';
        leadList[0].Lead_Stage__c = Label.Lead_Status_Site_Visit_to_be_Scheduled;
        leadList[0].Date_of_Site_Visit__c = datetime.newInstance(System.Today().year(), System.Today().month(), System.Today().day(), 12, 30, 0);
        leadList[0].Tracking_No__c = 'TESTDUMMY222';
        leadList[0].Virtual_Number_Text__c = virtNoList[1].Name;
        //leadList[0].Project__c = projList[0].id;
        update leadList;
        
        Test.stopTest();
    }
}