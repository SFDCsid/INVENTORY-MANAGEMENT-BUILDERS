@isTest(seeAllData=false)
public class sendSMSonAssignedToSalesTest {
    
    static Set<Id> campIdSet;
    static List<Campaign> campList;
    static List<Project__c> lstOfProjects;
    static List<Opportunity> lstOfOpp;
    static List<Campaign> lstOfCampaign;
    static Id resRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.Lead_RecordType_Residential).getRecordTypeId();
    
    @IsTest 
    static void opportunityTestData(){               
        
        lstOfProjects = TestDataFactory.createResProject(1);
        insert lstOfProjects;
        
        lstOfOpp = TestDataFactory.createOpportunity(1);
        
        lstOfCampaign = TestDataFactory.createCampaign(1);
        insert lstOfCampaign;       
        
        lstOfOpp[0].StageName= 'New';
        lstOfOpp[0].RecordTypeId = resRecordTypeId;
        lstOfOpp[0].Opportunity_Status__c=Label.AssignedToSales;
        lstOfOpp[0].LeadSource='Web';
        lstOfOpp[0].Date_of_Site_Visit__c=datetime.newInstance(System.Today().year(), System.Today().month(), System.Today().day(), 12, 30, 0);
        lstOfOpp[0].Country_Code__c='+91';
        lstOfOpp[0].Mobile__c='9999999999';
        lstOfOpp[0].Data_Sheet_Submitted__c = true;
        lstOfOpp[0].Project__c=lstOfProjects[0].Id;
        // lstOfOpp[0].OwnerId = UserInfo.getUserId();
        
        Test.startTest();
        insert lstOfOpp;
        system.debug('TestClass--->'+lstOfOpp[0].OwnerId+'  '+lstOfOpp[0]);
        sendSMSonAssignedToSales.checkForStatus(lstOfOpp);
        Test.stopTest();
    }
    
}