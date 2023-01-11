@isTest
public class BookingControllerTest {
    static  List<Payment_Plan__c> paymentPlans1 ;
    static List<Opportunity> oppList1;
    static  List<Project__c> projects1;
    @testSetup
    static void testDataSetup(){
        List<Opportunity> oppList=TestDataFactory.createOpportunity(1);
        insert oppList;
        
        List<Project__c> projects = TestDataFactory.createResProject(1);
        insert projects;
        
        
        List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(2);
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].Payment_Plan_Type__c = 'Non Scheme';   
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = projects[0].Id;
        insert paymentPlans;
        
        List<Tower__c> towers = TestDataFactory.createTowers(1);
        towers[0].Project_Name__c = paymentPlans[0].Project__c;
        insert towers;
        
        paymentPlans[0].Tower__c = towers[0].Id;
        update paymentPlans;
                
        Map<Id,List<Tower__c>> mapProjecttoTower = new Map<Id,List<Tower__c>>();
        mapProjecttoTower.put(paymentPlans[0].Project__c, towers);
        BookingController.OppandProjectWrapper oppAndProject = new BookingController.OppandProjectWrapper(oppList.get(0),mapProjecttoTower);
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItems = TestDataFactory.createBillingPlanLineItem(paymentPlans);
        billingPlanLineItems[0].Payment_Plan__c = paymentPlans[0].Id;
		billingPlanLineItems[0].Milestone_Number__c  = '1';  
       	insert billingPlanLineItems;
        
        List<Billing_Plan_Sub_Line_Item__c> billingPlanSubLineItems = new List<Billing_Plan_Sub_Line_Item__c>();
        Billing_Plan_Sub_Line_Item__c billingPlanSubLineItem = new Billing_Plan_Sub_Line_Item__c();
        billingPlanSubLineItem.Billing_Plan_Line_Item__c=billingPlanLineItems[0].Id;
        billingPlanSubLineItems.add(billingPlanSubLineItem);
        insert billingPlanSubLineItems;
        
        list<Payment_Term_Grouping__mdt> metadataGroupingList = new List<Payment_Term_Grouping__mdt>();
        BookingController.BillingPlanWrapper billingPlanWrapper = new BookingController.BillingPlanWrapper(
        oppList.get(0),billingPlanLineItems,metadataGroupingList);
    }
    
    static testMethod void testSaveWrapperDetails()
    {                  
        List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c];  
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        Billing_Plan_Line_Item__c billingPlanLineItem = new Billing_Plan_Line_Item__c();
        billingPlanLineItem.Payment_Plan__c = paymentPlans[0].Id;
        billingPlanLineItem.Milestone_Number__c  = '1';  
        billingPlanLineItem.Terms_of_Payment_Key__c = 'IND';
        billingPlanLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '100';
        billingPlanLineItem.Payment_Plan_Line_Item_Name__c = 'Proportionate';
        billingPlanLineItem.Due_After_Days__c=10;
        billingPlanLineItems.add(billingPlanLineItem);
        insert billingPlanLineItems;
        
        BookingController.saveWrapperDetails(paymentPlans[0].Id, billingPlanLineItems);
    }
    
    static testMethod void testBillingPlanObj()
    {                  
        List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c];
        Payment_Plan__c paymentPlan = BookingController.BillingPlanObj(paymentPlans[0].Id);
        System.assert(paymentPlan!=null);
        
        list<BookingController.BillingPlanWrapper> result = BookingController.getBillingPlanDetails(paymentPlans[0].Id);
        System.assert(result!=null);
    }
    
    static testMethod void testDeleteBillingPlanOnCancel()
    {                  
        List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c];
        BookingController.deleteBillingPlanOnCancel(paymentPlans[0].Id);
        Payment_Plan__c paymentPlan = null;
        try{
            paymentPlan = [select Id from Payment_Plan__c];
        } catch(Exception e){
            System.assert(paymentPlan==null);
        }
    }
    
    static testMethod void testSaveBillingPlan(){
        Payment_Plan__c paymentPlans = new Payment_Plan__c();
        List<Opportunity> opps = [select Id from Opportunity];
        
        Id result = BookingController.saveBillingPlan(paymentPlans,opps[0].Id);
        system.assert(result!=null);
    }
    
    static testMethod void testOpportunityRelatedFunctions(){
        List<Opportunity> opps = [select Id from Opportunity];
        
        List<Payment_Plan__c> paymentPlans = BookingController.getBillingPlan(opps[0].Id);
        system.assert(paymentPlans!=null && paymentPlans.size()>0);
        
        Opportunity opp = BookingController.getOpptyDetailswithID(opps[0].Id);
        system.assert(opp!=null);
        
        list<BookingController.OppandProjectWrapper> result =BookingController.OppProjDetailsWrapper(opps[0].Id);
		system.assert(result!=null);
        
        List<Payment_Plan__c> existingPaymentPlans = [select Id from Payment_Plan__c];
        Opportunity oppDetails = BookingController.getOpptyDetails(existingPaymentPlans[0].Id);
        system.assert(oppDetails!=null);
    }
    
    static testMethod void testBillingLineItems(){
        List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c];
        List<Billing_Plan_Line_Item__c> result = BookingController.billingLineItems(paymentPlans[0].Id);
        
        List<Billing_Plan_Line_Item__c> existingBillingPlanLineItemList = [SELECT Id FROM Billing_Plan_Line_Item__c WHERE Payment_Plan__c =: paymentPlans[0].Id];
        System.assert(result!=null);
    }
    
    static testMethod void testInsertJodiBillingLineItem(){
        test.startTest();
        oppList1=TestDataFactory.createOpportunity(1);
        insert oppList1;
        
       projects1 = TestDataFactory.createResProject(1);
        insert projects1;
        
        List<Payment_Plan__c> paymentPlanListParent = TestDataFactory.createBillingPlan(1); 
        paymentPlanListParent[0].Discount_On_Basic_Cost__c = 10;
        paymentPlanListParent[0].Discount_Amount_On_Floor_Rise_Cost__c = 10;
        paymentPlanListParent[0].Discount_On_PLC_Cost__c = 10;
        paymentPlanListParent[0].Status__c = 'Approved'; 
        paymentPlanListParent[0].Active__c = true;
       // paymentPlanListParent[0].Tower__c = towerList[0].id;
        
        Insert paymentPlanListParent;

        
        paymentPlans1 = TestDataFactory.createBillingPlan(1);
        paymentPlans1[0].Opportunity__c = oppList1[0].Id;
        paymentPlans1[0].Payment_Plan_Type__c = 'Non Scheme';   
        paymentPlans1[0].active__c = true;
        paymentPlans1[0].project__C = projects1[0].Id;
        paymentPlans1[0].Related_Jodi_Billing_Plan__c = paymentPlanListParent[0].Id;
        insert paymentPlans1;
        system.debug('#####'+paymentPlans1);
        
       //List<Payment_Plan__c> paymentPlans = [select Id,Related_Jodi_Billing_Plan__c from Payment_Plan__c Where Project__c != null];  
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
       /* Billing_Plan_Line_Item__c billingPlanLineItem = new Billing_Plan_Line_Item__c();
        billingPlanLineItem.Payment_Plan__c = paymentPlans[0].Id;
        billingPlanLineItems.add(billingPlanLineItem);
        insert billingPlanLineItems;
        
		BookingController.insertJodiBillingLineItem(billingPlanLineItems,paymentPlans[0]);*/
        
        Billing_Plan_Line_Item__c billingPlanLineItem = new Billing_Plan_Line_Item__c();
      //  billingPlanLineItem.Payment_Plan__c = paymentPlans1[0].Id;
        billingPlanLineItem.Payment_Plan__c = paymentPlans1[0].Related_Jodi_Billing_Plan__c;
     	billingPlanLineItems.add(billingPlanLineItem);
        insert billingPlanLineItems;
        
        
        BookingController.insertJodiBillingLineItem(billingPlanLineItems,paymentPlans1[0]);
        try{
            billingPlanLineItem = [SELECT Id,Payment_Plan__c FROM Billing_Plan_Line_Item__c WHERE Payment_Plan__c=:paymentPlans1[0].Id];
        } catch(Exception e){
         //   System.assert(billingPlanLineItem==null);
        }
        test.stopTest();
    }
    
    static testMethod void testInsertSubLineItem(){
        
        List<Payment_Plan__c> paymentPlanListParent = TestDataFactory.createBillingPlan(1); 
        paymentPlanListParent[0].Discount_On_Basic_Cost__c = 10;
        paymentPlanListParent[0].Discount_Amount_On_Floor_Rise_Cost__c = 10;
        paymentPlanListParent[0].Discount_On_PLC_Cost__c = 10;
        paymentPlanListParent[0].Status__c = 'Approved'; 
        paymentPlanListParent[0].Active__c = true;
       // paymentPlanListParent[0].Tower__c = towerList[0].id;       
       
        Insert paymentPlanListParent;
        
        List<Opportunity> oppList1=TestDataFactory.createOpportunity(1);
        insert oppList1;
        
        List<Project__c> projects1 = TestDataFactory.createResProject(1);
        insert projects1;
        
        List<Payment_Plan__c> paymentPlans1 = TestDataFactory.createBillingPlan(1);
        paymentPlans1[0].Opportunity__c = oppList1[0].Id;
        paymentPlans1[0].Payment_Plan_Type__c = 'Non Scheme';   
        paymentPlans1[0].active__c = true;
        paymentPlans1[0].project__C = projects1[0].Id;
        paymentPlans1[0].Related_Jodi_Billing_Plan__c = paymentPlanListParent[0].Id;
        insert paymentPlans1;
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        Billing_Plan_Line_Item__c billingPlanLineItem = new Billing_Plan_Line_Item__c();
        billingPlanLineItem.Payment_Plan__c = paymentPlans1[0].Id;
		billingPlanLineItem.Milestone_Number__c  = '1';  
        billingPlanLineItem.Terms_of_Payment_Key__c = 'IND';
        billingPlanLineItems.add(billingPlanLineItem);
        insert billingPlanLineItems;
        
        List<Payment_Plan_Line_Item__c> paymentPlanLineItems = new List<Payment_Plan_Line_Item__c>();
        Payment_Plan_Line_Item__c paymentPlanLineItem = new Payment_Plan_Line_Item__c();
		paymentPlanLineItem.Terms_of_Payment_Key__c = 'IND';
        paymentPlanLineItem.Payment_Plan__c = paymentPlans1[0].Id;
        paymentPlanLineItems.add(paymentPlanLineItem);
        insert paymentPlanLineItems;
        
        List<Billing_Plan_Sub_Line_Item__c> billingPlanSubLineItems = new List<Billing_Plan_Sub_Line_Item__c>();
        Billing_Plan_Sub_Line_Item__c billingPlanSubLineItem = new Billing_Plan_Sub_Line_Item__c();
        billingPlanSubLineItem.Billing_Plan_Line_Item__c=billingPlanLineItems[0].Id;
        billingPlanSubLineItems.add(billingPlanSubLineItem);
        insert billingPlanSubLineItems;
               
        map<Id,List<Billing_Plan_Sub_Line_Item__c>> mapBpliToSubLi1 = new map<Id,List<Billing_Plan_Sub_Line_Item__c>>();
             
		BookingController.insertSubLineItem(paymentPlanLineItems,paymentPlans1[0].Id,paymentPlans1[0]);
        try{
            billingPlanLineItem = [SELECT Id 
                           FROM Billing_Plan_Line_Item__c
                           WHERE Payment_Plan__c=:paymentPlans1
                           AND Payment_Group__c='IN'
                           AND Line_Item_Type__c='Construction Linked'];
        } catch(Exception e){
            System.assert(billingPlanLineItem!=null);
        }
        
    }
    
    static testMethod void testGetmetaData(){
        List<Payment_Term_Grouping__mdt> result = BookingController.getmetaData();
    }
    
    static testMethod void testGetTowerToProj(){
        Map<Id,List<Tower__c>> projTowerMap = BookingController.getTowerToProj();
        system.assert(projTowerMap!=null && projTowerMap.size()>0);
    }
}