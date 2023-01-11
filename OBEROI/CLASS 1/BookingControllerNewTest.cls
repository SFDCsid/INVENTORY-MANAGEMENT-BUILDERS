@isTest
private class BookingControllerNewTest {
    @testSetup
    static void testDataSetup(){
        List<Opportunity> oppList=TestDataFactory.createOpportunity(1);
        insert oppList;
        
        List<Project__c> projects = TestDataFactory.createResProject(1);
        insert projects;
        
        List<Site__c> sList = TestDataFactory.createSite(4);
        insert sList;
        
        List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(2);
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].Payment_Plan_Type__c = 'Non Scheme';   
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__c = projects[0].Id;
        paymentPlans[0].site__c = sList[0].id;
        
        paymentPlans[1].Opportunity__c = oppList[0].Id;
        paymentPlans[1].Payment_Plan_Type__c = 'Non Scheme';   
        paymentPlans[1].active__c = true;
        paymentPlans[1].site__c = sList[0].id;
        insert paymentPlans;
        
        paymentPlans[0].Related_Jodi_Billing_Plan__c = paymentPlans[1].Id;
        update paymentPlans;
        List<Tower__c> towers = TestDataFactory.createTowers(1);
        towers[0].Project_Name__c = paymentPlans[0].Project__c;
        insert towers;
        
        paymentPlans[0].Tower__c = towers[0].Id;
        update paymentPlans;
                
        Map<Id,List<Tower__c>> mapProjecttoTower = new Map<Id,List<Tower__c>>();
        mapProjecttoTower.put(paymentPlans[0].Project__c, towers);
        
        
        
        BookingController.OppandProjectWrapper oppAndProject = new BookingController.OppandProjectWrapper(oppList.get(0),mapProjecttoTower);
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        list<Payment_Term_Grouping__mdt> metadataGroupingList = new List<Payment_Term_Grouping__mdt>();
        BookingController.BillingPlanWrapper billingPlanWrapper = new BookingController.BillingPlanWrapper(
        oppList.get(0),billingPlanLineItems,metadataGroupingList);
    }
    
	@isTest
    private static void saveWrapperDetailsTest() {
        List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c Where Project__c != null];  
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        Billing_Plan_Line_Item__c billingPlanLineItem = new Billing_Plan_Line_Item__c();
        billingPlanLineItem.Payment_Plan__c = paymentPlans[0].Id;
        billingPlanLineItem.Terms_of_Payment_Key__c='IN';
        billingPlanLineItem.Milestone_Number__c  = '1';  
        billingPlanLineItems.add(billingPlanLineItem);
        insert billingPlanLineItems;
        System.debug('billingPlanLineItems[0].Payment_Group__c--> '+billingPlanLineItems[0].Payment_Group__c);
        List<Billing_Plan_Sub_Line_Item__c> billingPlanSubLineItems = new List<Billing_Plan_Sub_Line_Item__c>();
        Billing_Plan_Sub_Line_Item__c billingPlanSubLineItem = new Billing_Plan_Sub_Line_Item__c();
        billingPlanSubLineItem.Billing_Plan_Line_Item__c=billingPlanLineItems[0].Id;
        billingPlanSubLineItems.add(billingPlanSubLineItem);
        insert billingPlanSubLineItems;
        BookingControllerNew.saveWrapperDetails(paymentPlans[0].Id, billingPlanLineItems);
    }
@isTest
    private static void saveWrapperDetailsWithoutBillingSubLintItemsTest() {
        List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c Where Project__c != null];  
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        Billing_Plan_Line_Item__c billingPlanLineItem = new Billing_Plan_Line_Item__c();
        billingPlanLineItem.Payment_Plan__c = paymentPlans[0].Id;
        billingPlanLineItem.Milestone_Number__c  = '1';  
        billingPlanLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '0';
        billingPlanLineItem.Payment_Plan_Line_Item_Name__c = '0';
        billingPlanLineItem.Due_After_Days__c = 2;
        billingPlanLineItems.add(billingPlanLineItem);
        insert billingPlanLineItems;
        BookingControllerNew.saveWrapperDetails(paymentPlans[0].Id, billingPlanLineItems);
    }
    @isTest
    private static void saveWrapperDetailsPercentageSumTest() {
        List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c Where Project__c != null];  
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        Billing_Plan_Line_Item__c billingPlanLineItem = new Billing_Plan_Line_Item__c();
        billingPlanLineItem.Payment_Plan__c = paymentPlans[0].Id;
        billingPlanLineItem.Milestone_Number__c  = '1';  
        billingPlanLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '20';
        billingPlanLineItem.Payment_Plan_Line_Item_Name__c = '0';
        billingPlanLineItem.Due_After_Days__c = 2;
        billingPlanLineItems.add(billingPlanLineItem);
        insert billingPlanLineItems;
        BookingControllerNew.saveWrapperDetails(paymentPlans[0].Id, billingPlanLineItems);
    }
     @isTest
    private static void saveWrapperDetailsPercentageSumEquals100Test() {
        List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c Where Project__c != null];  
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        Billing_Plan_Line_Item__c billingPlanLineItem = new Billing_Plan_Line_Item__c();
        billingPlanLineItem.Payment_Plan__c = paymentPlans[0].Id;
        billingPlanLineItem.Milestone_Number__c  = '1';  
        billingPlanLineItem.Description__c = 'Proportionate';
        billingPlanLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '100';
        billingPlanLineItem.Payment_Plan_Line_Item_Name__c = 'To be paid on or Before';
        billingPlanLineItem.Due_After_Days__c = 2;
        billingPlanLineItems.add(billingPlanLineItem);
        insert billingPlanLineItems;
        BookingControllerNew.saveWrapperDetails(paymentPlans[0].Id, billingPlanLineItems);
    }
    @isTest
    	static void billingPlanObjTest()
    {                  
        List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c Where Project__c != null];
        Payment_Plan__c paymentPlan = BookingControllerNew.BillingPlanObj(paymentPlans[0].Id);
        System.assert(paymentPlan!=null);
        
        list<BookingControllerNew.BillingPlanWrapper> result = BookingControllerNew.getBillingPlanDetails(paymentPlans[0].Id);
        System.assert(result!=null);
    }
    @isTest
    static void deleteBillingPlanOnCancelTest()
    {                  
        List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c Where Project__c != null];
        BookingControllerNew.deleteBillingPlanOnCancel(paymentPlans[0].Id);
        Payment_Plan__c paymentPlan = null;
        try{
            paymentPlan = [select Id from Payment_Plan__c];
        } catch(Exception e){
            System.assert(paymentPlan==null);
        }
    }
    
    @isTest
    static void saveBillingPlanTest(){
        Payment_Plan__c paymentPlans = new Payment_Plan__c();
        List<Opportunity> opps = [select Id from Opportunity];
        
        Id result = BookingControllerNew.saveBillingPlan(paymentPlans,opps[0].Id);
        system.assert(result!=null);
    }
    
    @isTest
    static void opportunityRelatedFunctionsTest(){
        List<Opportunity> opps = [select Id from Opportunity];
        
        List<Payment_Plan__c> paymentPlans = BookingControllerNew.getBillingPlan(opps[0].Id);
        system.assert(paymentPlans!=null && paymentPlans.size()>0);
        
        Opportunity opp = BookingControllerNew.getOpptyDetailswithID(opps[0].Id);
        system.assert(opp!=null);
        
        list<BookingControllerNew.OppandProjectWrapper> result =BookingControllerNew.OppProjDetailsWrapper(opps[0].Id);
		system.assert(result!=null);
        
        List<Payment_Plan__c> existingPaymentPlans = [select Id from Payment_Plan__c Where Project__c != null];
        Opportunity oppDetails = BookingControllerNew.getOpptyDetails(existingPaymentPlans[0].Id);
        system.assert(oppDetails!=null);
    }
    @isTest
    static void billingLineItemsTest(){
        List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c Where Project__c != null];
        List<Billing_Plan_Line_Item__c> result = BookingControllerNew.billingLineItems(paymentPlans[0].Id);
        System.assert(result!=null);
    }
    @isTest
    static void insertJodiBillingLineItemTest(){
        List<Payment_Plan__c> paymentPlans = [select Id,Related_Jodi_Billing_Plan__c from Payment_Plan__c Where Project__c != null ];  
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        
        Billing_Plan_Line_Item__c billingPlanLineItem = new Billing_Plan_Line_Item__c();
        billingPlanLineItem.Payment_Plan__c = paymentPlans[0].Id;
     	billingPlanLineItems.add(billingPlanLineItem);
        insert billingPlanLineItems;
        
        BookingControllerNew.insertJodiBillingLineItem(billingPlanLineItems,paymentPlans[0]);
        try{
            billingPlanLineItem = [SELECT Id FROM Billing_Plan_Line_Item__c WHERE Payment_Plan__c=:paymentPlans[0].Id];
        } catch(Exception e){
            System.assert(billingPlanLineItem==null);
        }
        
      
    	
    }
   @isTest
    static void insertSubLineItemTest(){
        List<Payment_Plan__c> paymentPlans = [select Id,Related_Jodi_Billing_Plan__c from Payment_Plan__c Where Project__c != null];  
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        Billing_Plan_Line_Item__c billingPlanLineItem = new Billing_Plan_Line_Item__c();
        billingPlanLineItem.Payment_Plan__c = paymentPlans[0].Id;
		billingPlanLineItem.Milestone_Number__c  = '1';  
        billingPlanLineItem.Terms_of_Payment_Key__c = 'IND';
        billingPlanLineItems.add(billingPlanLineItem);
        insert billingPlanLineItems;
        
        List<Payment_Plan_Line_Item__c> paymentPlanLineItems = new List<Payment_Plan_Line_Item__c>();
        Payment_Plan_Line_Item__c paymentPlanLineItem = new Payment_Plan_Line_Item__c();
		paymentPlanLineItem.Terms_of_Payment_Key__c = 'IND';
        paymentPlanLineItem.Payment_Plan__c = paymentPlans[0].Id;
        paymentPlanLineItems.add(paymentPlanLineItem);
        insert paymentPlanLineItems;
        
        List<Billing_Plan_Sub_Line_Item__c> billingPlanSubLineItems = new List<Billing_Plan_Sub_Line_Item__c>();
        Billing_Plan_Sub_Line_Item__c billingPlanSubLineItem = new Billing_Plan_Sub_Line_Item__c();
        billingPlanSubLineItem.Billing_Plan_Line_Item__c=billingPlanLineItems[0].Id;
        billingPlanSubLineItems.add(billingPlanSubLineItem);
        insert billingPlanSubLineItems;
        map<Id,List<Billing_Plan_Sub_Line_Item__c>> mapBpliToSubLi1 = new map<Id,List<Billing_Plan_Sub_Line_Item__c>>();
             
		BookingControllerNew.insertSubLineItem(paymentPlanLineItems,billingPlanLineItems[0].Id,paymentPlans[0]);
        
        
    }
   @isTest
    static void testGetmetaData(){
        List<Payment_Term_Grouping__mdt> result = BookingControllerNew.getmetaData();
    }
   @isTest
    static void testGetTowerToProj(){
        Map<Id,List<Tower__c>> projTowerMap = BookingControllerNew.getTowerToProj();
        system.assert(projTowerMap!=null && projTowerMap.size()>0);
    }
}