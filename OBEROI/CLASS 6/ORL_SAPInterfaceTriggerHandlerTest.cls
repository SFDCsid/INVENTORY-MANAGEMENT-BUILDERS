/****************************************************************************************************
Class covered :
1. ORL_SAPInterfaceTriggerHandler - 7/6/2019 - 91%

****************************************************************************************************/
@isTest(seeAllData=false)
public class ORL_SAPInterfaceTriggerHandlerTest {
     
    @testSetUp
    static void createTestData(){
        List<Site__c> lstOfSites = TestDataFactory.createSite(1);
        INSERT lstOfSites;
        
        List<Project__c> lstOfProject = TestDataFactory.createResProject(1);
        lstOfProject[0].Site__c = lstOfSites[0].Id;
        INSERT lstOfProject;
        
        List<Tower__c>lstOfTower = TestDataFactory.createTowers(1);
        lstOfTower[0].Project_Name__c = lstOfProject[0].Id;
        INSERT lstOfTower;
        
        
        List<Opportunity> lstOfOpp = TestDataFactory.createOpportunity(1);
        lstOfOpp[0].Partner_s_Firm_Name__c = 'Partner_s_Firm_Name__c';
        lstOfOpp[0].Partner_s_Name__c = 'Partner_s_Name__c';
        lstOfOpp[0].Partner_Mobile__c = '8723546789';
        lstOfOpp[0].Partner_Email__c = 'partner@test.com';
        lstOfOpp[0].PCID__c = 'PCID';
        lstOfOpp[0].Site__c = lstOfSites[0].Id;
        
        INSERT lstOfOpp;            
        
        List<Property_Type__c> lstOfProjtype = TestDataFactory.createProjectType(1);
        lstOfProjtype[0].Project1__c = lstOfProject[0].Id;
        INSERT lstOfProjtype;
        
        List<Property__c> lstOfProperty = TestDataFactory.createProperties(1);
        lstOfProperty[0].Property_Type__c = lstOfProjtype[0].Id;
        lstOfProperty[0].Temporary_Block__c = true;
        lstOfProperty[0].Block_Comments__c = 'Block property';
        lstOfProperty[0].Blocked_By__c = UserInfo.getUserId() ;
        lstOfProperty[0].Active__c = true;
        lstOfProperty[0].Tower__c = lstOfTower[0].Id;
        
        INSERT lstOfProperty;
        
        /*List<Booking__c> bookLst = TestDataFactory.createBookings(2);
        bookLst[0].Property__c = lstOfProperty[0].Id;   
        bookLst[0].Opportunity__c = lstOfOpp[0].Id;
        bookLst[0].Tower__c = lstOfTower[0].Id;
        bookLst[0].Project__c = lstOfProject[0].Id;
        bookLst[0].Site__c = lstOfSites[0].Id;
        bookLst[0].Move_to_SAP__c = false;
        
        bookLst[1].Property__c = lstOfProperty[0].Id;   
        bookLst[1].Opportunity__c = lstOfOpp[0].Id;
        bookLst[1].Tower__c = lstOfTower[0].Id;
        bookLst[1].Project__c = lstOfProject[0].Id;
        bookLst[1].Site__c = lstOfSites[0].Id;
        bookLst[1].Move_to_SAP__c = false;
        bookLst[1].Booking_Number_SAP__c = '1234';
        INSERT bookLst;
        
        SAP_Interface_Log__c obj = new SAP_Interface_Log__c();
        obj.Status__c = 'Success';
        obj.Type__c = 'CustomerCreateCall';
        obj.SAP_Message__c = 'Pull Operation created';
        obj.Related_Object__c = 'Payment_Plan__c';
        obj.Description__c='Pull Request for Payment Plan';
        obj.Booking__c=bookLst[0].Id;
        
        List<SAP_Interface_Log__c> arrList = new List<SAP_Interface_Log__c>();
        arrList.add(obj);
        INSERT arrList;*/
        
        List<Payment_Plan__c> lstOfBillingPlan = TestDataFactory.createBillingPlan(1);
        INSERT lstOfBillingPlan;
        
        List<Payment_Plan_Line_Item__c> lstOfPaymentPlanLineItem = new List<Payment_Plan_Line_Item__c>();
        for(Payment_Plan__c plan: lstOfBillingPlan){
            lstOfPaymentPlanLineItem.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=plan.Id,Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='PL01',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=plan.Id,Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='IN33',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=plan.Id,Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='PL01',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=plan.Id,Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='IN33',Percentage_Of_Value_To_Be_Invoiced__c='10'));
        }
        INSERT lstOfPaymentPlanLineItem;
        
        
        List<Billing_Plan_Line_Item__c> lstOfBillingPlanLineItem = new List<Billing_Plan_Line_Item__c>();
        for(Payment_Plan__c plan: lstOfBillingPlan){
            lstOfBillingPlanLineItem.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=plan.Id, Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='PL01'));
            lstOfBillingPlanLineItem.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=plan.Id, Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='IN33'));
            lstOfBillingPlanLineItem.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=plan.Id, Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='PL01'));
            lstOfBillingPlanLineItem.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=plan.Id, Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='IN33'));
        }
        INSERT lstOfBillingPlanLineItem;
        
        List<Booking__c> bookLst = TestDataFactory.createBookings(2);
        //bookLst[0].Property__c = lstOfProperty[0].Id;   
        bookLst[0].Opportunity__c = lstOfOpp[0].Id;
        //bookLst[0].Tower__c = lstOfTower[0].Id;
        //bookLst[0].Project__c = lstOfProject[0].Id;
        //bookLst[0].Site__c = lstOfSites[0].Id;
        bookLst[0].Billing_Plan__c = lstOfBillingPlan[0].Id;
        bookLst[0].Move_to_SAP__c = false;
        
        //bookLst[1].Property__c = lstOfProperty[0].Id;   
        bookLst[1].Opportunity__c = lstOfOpp[0].Id;
        //bookLst[1].Tower__c = lstOfTower[0].Id;
        //bookLst[1].Project__c = lstOfProject[0].Id;
        //bookLst[1].Site__c = lstOfSites[0].Id;
        bookLst[1].Billing_Plan__c = lstOfBillingPlan[0].Id;
        bookLst[1].Move_to_SAP__c = false;
        bookLst[1].Booking_Number_SAP__c = '1234';
        INSERT bookLst;
        
        SAP_Interface_Log__c obj = new SAP_Interface_Log__c();
        obj.Status__c = 'Success';
        obj.Type__c = 'CustomerCreateCall';
        obj.SAP_Message__c = 'Pull Operation created';
        obj.Related_Object__c = 'Payment_Plan__c';
        obj.Description__c='Pull Request for Payment Plan';
        obj.Booking__c=bookLst[0].Id;
    }
   
    static testMethod void ORL_SAPInterfaceTriggerHandler_Test1() {
        //createTestData();
        Test.startTest();        
        
        List<SAP_Interface_Log__c> arrList = [SELECT id,Booking__r.Id, Type__c, Status__c, Booking__c, SAP_Message__c, IsParent__c, Description__c, Related_Object__c , Payment_Plan__c FROM SAP_Interface_Log__c];
        ORL_SAPInterfaceTriggerHandler.createSalesOrder(arrList);
        
        List<Booking__c> bookLst = [SELECT id,Sales_Document_SAP__c,Booking_Number_SAP__c FROM Booking__c];
        for(Booking__c booking:bookLst){
            booking.Sales_Document_SAP__c = '1234';
            booking.Booking_Number_SAP__c = '1234';
        }
        UPDATE bookLst;
        
        
        
        Test.stopTest();
    }
    static testMethod void ORL_SAPInterfaceTriggerHandler_Test2() {
        //createTestData();
        Test.startTest();        
        
        List<SAP_Interface_Log__c> arrList = [SELECT id,Booking__r.Id, Type__c, Status__c, Booking__c, SAP_Message__c, IsParent__c, Description__c, Related_Object__c , Payment_Plan__c FROM SAP_Interface_Log__c];
        ORL_SAPInterfaceTriggerHandler.createSalesOrder(arrList);
        
        List<Booking__c> bookLst = [SELECT id,Sales_Document_SAP__c,Booking_Number_SAP__c FROM Booking__c];
        for(Booking__c booking:bookLst){
            booking.Sales_Document_SAP__c = '1234';
            booking.Booking_Number_SAP__c = '1234';
            booking.Move_to_SAP__c = true;
        }
        UPDATE bookLst;
        
        for(Booking__c booking:bookLst){
            booking.Sales_Document_SAP__c = '1234';
            booking.Booking_Number_SAP__c = '1234';
            booking.Move_to_SAP__c = false;            
        }
        
        Id billingPlanIds = [SELECT id FROM Payment_Plan__c].Id;
        ORL_SAPInterfaceTriggerHandler.createBillingLineItemsFuture(billingPlanIds);
        BillingPlanLineItemGroupingController.createBillingLineItemsFuture(billingPlanIds);
        
        
        Test.stopTest();
    }
    
}