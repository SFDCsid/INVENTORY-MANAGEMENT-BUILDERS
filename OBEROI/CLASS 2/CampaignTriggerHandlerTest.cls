@isTest
public class CampaignTriggerHandlerTest {
    
    static List<Campaign> campList;
    static List<Virtual_Number__c> vNoList;
    
    static testMethod void camptriggerTest(){
        
        List<Campaign> camp = TestDataFactory.createCampaign(5); 
        List<Virtual_Number__c> vNoList = TestDataFactory.createVNo(2);
        insert vNoList;
        //Inserting Plan
        camp[0].recordTypeId = CampaignTriggerHandler.plansiteSpecRTId; 
        camp[0].Marketing_Plan_Cost__c = 10000; 
        camp[0].startDate = system.today();
        camp[0].endDate = system.today()+30;
        camp[0].Hierarchy_Plan_Cost__c =0;
        camp[0].Booking_Count__c =0;
        camp[0].Advertisement_Cost__c = 1000.00;
        //camp[0].MArketing_channel__c = '701p0000000QkduAAC';
        insert camp[0];
        CampaignTriggerHandler.PlanMap.put(camp[0].id, camp[0]);
         //Inserting Campaign
         System.debug('ID '+TestDataFactory.campmultiProjId);
        camp[1].recordTypeId = CampaignTriggerHandler.campSingleRTId;
        camp[1].startDate = system.today()+2;
        camp[1].endDate = system.today()+25;
        camp[1].Booking_Count__c =0;
        camp[1].Marketing_Campaign_Cost__c = 5000;
        camp[1].Hierarchy_Campaign_Cost__c = 0;
        camp[1].Marketing_Plan__c = camp[0].id;
        camp[1].Advertisement_Cost__c = 1000.00;
        system.debug(camp[0]+'camp[0]'+camp[1]);
        insert camp[1];
        
        CampaignTriggerHandler.CampaignMap.put(camp[1].id, camp[1]);
         //Inserting Campaign
        camp[2].recordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(System.Label.ORL_Campaign_Marketing_Campaign_Single_Project).getRecordTypeId();
        camp[2].Marketing_Campaign_Cost__c =4000;
        camp[2].startDate = system.today()+2;
        camp[2].Booking_Count__c =0;
        camp[2].Hierarchy_Campaign_Cost__c = 0;
        camp[2].endDate = system.today()+25;
        camp[2].Marketing_Plan__c = camp[0].id;
        camp[2].Advertisement_Cost__c = 1000.00;
        insert camp[2];
        CampaignTriggerHandler.CampaignMap.put(camp[2].id, camp[2]);
         //Inserting Channel
        camp[3].recordTypeId = TestDataFactory.campChannelId; 
        camp[3].startDate = system.today()+4;
        camp[3].endDate = system.today()+20;
        camp[3].Marketing_Campaign__c = camp[2].id;
        camp[3].Booking_Count__c =0;
        camp[3].Marketing_Channel_Cost__c =1000 ;
        camp[3].Hierarchy_Channel_Cost__c =0;
        camp[3].Advertisement_Cost__c = 1000.00;
        insert camp[3];
        CampaignTriggerHandler.ChannelMap.put(camp[3].id, camp[3]);
         //Inserting Advertisement
        camp[4].RecordTypeId = TestDataFactory.campAdvertisementId; 
        camp[4].startDate = system.today()+10;
        camp[4].endDate = system.today()+15;
        camp[4].Advertisement_Cost__c =500;
        camp[4].Marketing_Channel__c = camp[3].id;
        camp[4].Booking_Count__c =0;
        camp[4].Virtual_Number__c =vNoList[1].id;
        camp[4].Advertisement_Cost__c = 1000.00;
        insert camp[4];
        
        //Updating Virtual No for Advertisement
        camp[4].Virtual_Number__c =vNoList[0].id;
        update camp[4];
       	delete camp[4];
        //Simply calling Method
        CampaignTriggerHandler.errorMessage( camp ,Label.Validation_Error_On_Campaign);
        CampaignTriggerHandler.errorMessage( camp ,Label.Internal_Error_Message);
       
    }
    
}