@isTest
public class BillingPlanTriggerHandlerTest {
  public static List<Site__c> createSite( Integer numberOfsites) {
        //Id PrRecordTypeId = Schema.SObjectType.Site__c.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
        List<Site__c> sList = new List<Site__c>();
        for ( Integer i = 0 ; i < numberOfsites ; i++ ) {            
            Site__c st = new Site__c( Name = 'Test site' + Math.random());
            sList.add(st);
        }
        return sList;        
    }
    
    public static List<Pricing__c> createPricing( Integer numberOfPricing) {
        List<Pricing__c> pricingList = new List<Pricing__c>();
        for ( Integer i = 0 ; i < numberOfPricing ; i++ ) {
            
            Pricing__c pL = new Pricing__c(Name = 'Test Price');
            pricingList.add(pL);            
        }
        return pricingList;        
    }
@testSetup
    static void testDataSetup(){
        
        User usr = TestDataFactory.createUser('ORL Admin', 'MD');
        
        List<Site__c> sList = createSite(1);
        insert sList;
        
        List<Opportunity> oppList=TestDataFactory.createOpportunity(1);
        oppList[0].site__c =sList[0].id;
        insert oppList;
        
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        List<Project__c> pList = TestDataFactory.createResProject(1);
        		pList[0].Name = 'test';
                pList[0].Plant__c ='767c';
                pList[0].site__c =sList[0].id;
                pList[0].Active__c=true;
                pList[0].Company_name__c='test'; 
                pList[0].recordtypeId= PrRecordTypeId;
                pList[0].Front_Desk_User__c = usr.id;
                pList[0].Marcom_Head__c =usr.Id; 
                pList[0].Sales_Head__c =usr.Id;
                pList[0].Site_Head__c=usr.Id; 
                pList[0].MD__c =usr.Id; 
                pList[0].Marcom_Manager__c = usr.Id; 
                /*v1.1 Start*/
                pList[0].CFO__c =usr.Id/*v1.1 Ends*/;
       			insert pList;
        system.debug('Project :' + pList);
        
        List<Tower__c> towers = TestDataFactory.createTowers(1);
        towers[0].Project_Name__c = pList[0].Id;
        
        insert towers;
        
        List<Property_Type__c> projectTypeList = TestDataFactory.createProjectType(1);
        projectTypeList[0].Project1__c = pList[0].Id;
        //projectTypeList[0].Basic_Sale_Price__c = 50; 
        insert projectTypeList;
        
        List<Pricing__c> pricingList = createPricing(1);
        pricingList[0].Property_Type__c = projectTypeList[0].Id;
        pricingList[0].Active__c = true;
        pricingList[0].Type__c = 'Non Scheme';
        pricingList[0].Base_Cost__c = 1300;
        pricingList[0].Floor_Rise_Cost__c  = 1100;
        pricingList[0].PLC_Cost__c = 2000;
        pricingList[0].ITC_Basic_Cost__c = 1200;
        pricingList[0].ITC_Floor_Rise_Cost__c = 1000;
        pricingList[0].ITC_PLC_Cost__c = 1500;
        insert pricingList; 
        
        projectTypeList[0].Active__c = true;
        update projectTypeList;
        
        List<Property__c> propertyList=TestDataFactory.createProperties(2);
        propertyList[0].Temporary_Block__c = true;
        propertyList[0].Property_Type__c = projectTypeList[0].Id;
        propertyList[0].Is_Jodi_Flat__c = true;
        propertyList[0].Related_Jodi_Property__c = propertyList[1].Id;
        propertyList[0].Active__c = true;
        propertyList[0].Block_Comments__c = 'Test';
        propertyList[0].Blocked_By__c = usr.Id;
        propertyList[0].Tower__c = towers[0].Id;
        propertyList[0].Super_Area__c = 10;
        propertyList[0].Admin_Base_Sale_Price__c = 50;
        //propertyList[0].Basic_Sale_Price__c = 50;
        propertyList[0].Property_Type__c = projectTypeList[0].Id;
        propertyList[0].Admin_Floor_Rise_Charges__c = 5;
        
        propertyList[1].Temporary_Block__c = true;
        propertyList[1].Property_Type__c = projectTypeList[0].Id;
        propertyList[1].Related_Jodi_Property__c = propertyList[0].Id;
        propertyList[1].Is_Jodi_Flat__c = true;
        propertyList[1].Active__c = true;
        propertyList[1].Block_Comments__c = 'Test';
        propertyList[1].Blocked_By__c = usr.Id;
        propertyList[1].Tower__c = towers[0].Id;
        propertyList[1].Super_Area__c = 10;
        propertyList[1].Admin_Base_Sale_Price__c = 50;
        //propertyList[1].Basic_Sale_Price__c = 50;
        propertyList[1].Property_Type__c = projectTypeList[0].Id;
        
        insert propertyList;
        
        Id paymentPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
        Id defaultRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId(); 
        Id schemeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan w/t Tower').getRecordTypeId();
        Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan').getRecordTypeId();
        Id NonSchemeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
        
        List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(4);
        paymentPlans[0].recordTypeID = paymentPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        //paymentPlans[0].Payment_Plan_Type__c = 'Non Scheme';   
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[0].id;
        paymentPlans[0].Discount_On_Basic_Cost__c = 10;
        paymentPlans[0].Discount_On_ITC_Basic_Cost__c = 1;
        paymentPlans[0].Discount_On_ITC_Floor_Rise_Cost__c = 1;
        paymentPlans[0].Discount_On_ITC_PLC_Cost__c = 1;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 5;
        paymentPlans[0].Discount_On_Floor_Rise_Cost__c = 5;
        //paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c = 1;
        paymentPlans[0].Discount_On_PLC_Cost__c = 15;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 1;
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 2;
        
        
        paymentPlans[1].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[1].Opportunity__c = oppList[0].Id;
        //paymentPlans[1].Payment_Plan_Type__c = 'Non Scheme';   
        paymentPlans[1].active__c = true;
        paymentPlans[1].project__C = pList[0].Id;
        paymentPlans[1].Tower__c = towers[0].Id;
        paymentPlans[1].site__c =sList[0].id;
        paymentPlans[1].property__c = propertyList[0].id;
        paymentPlans[1].Discount_On_Basic_Cost__c = 10;
        paymentPlans[1].Discount_On_ITC_Basic_Cost__c = 1;
        paymentPlans[1].Discount_On_ITC_Floor_Rise_Cost__c = 1;
        paymentPlans[1].Discount_On_ITC_PLC_Cost__c = 1;
        //paymentPlans[1].Discount_Amount_On_Basic_Cost__c = 10;
        paymentPlans[1].Discount_On_Floor_Rise_Cost__c = 5;
        //paymentPlans[1].Discount_Amount_On_Floor_Rise_Cost__c = 1;
        paymentPlans[1].Discount_On_PLC_Cost__c = 15;
        //paymentPlans[1].Discount_Amount_On_PLC_Cost__c = 1;	
        
        
        paymentPlans[2].recordTypeID = NonSchemeRecordTypeId;
        paymentPlans[2].Opportunity__c = oppList[0].Id;
        paymentPlans[2].active__c = true;
        paymentPlans[2].project__C = pList[0].Id;
        paymentPlans[2].Tower__c = towers[0].Id;
        paymentPlans[2].site__c =sList[0].id;
        paymentPlans[2].property__c = propertyList[1].id;
        
        paymentPlans[3].recordTypeID = NonSchemeRecordTypeId;
        paymentPlans[3].Opportunity__c = oppList[0].Id;
        paymentPlans[3].active__c = true;
        paymentPlans[3].project__C = pList[0].Id;
        paymentPlans[3].Tower__c = towers[0].Id;
        paymentPlans[3].site__c =sList[0].id;
        paymentPlans[3].property__c = propertyList[1].id;
        paymentPlans[3].Discount_amount_on_basic_cost__C = 1;
        
        
      
        	
        insert paymentPlans;       
        
        
        paymentPlans[1].Discount_On_Basic_Cost__c = 11;
        paymentPlans[1].Discount_On_Floor_Rise_Cost__c = 7;
        paymentPlans[1].Discount_On_PLC_Cost__c = 10;
        paymentPlans[1].Discount_On_ITC_Basic_Cost__c = 2;
        paymentPlans[1].Discount_On_ITC_Floor_Rise_Cost__c = 2;
        paymentPlans[1].Discount_On_ITC_PLC_Cost__c = 2;
        
        paymentPlans[2].recordTypeID = NonSchemeRecordTypeId;
        paymentPlans[2].Opportunity__c = oppList[0].Id;
        paymentPlans[2].active__c = true;
        paymentPlans[2].project__C = pList[0].Id;
        paymentPlans[2].Tower__c = towers[0].Id;
        paymentPlans[2].site__c =sList[0].id;
        paymentPlans[2].property__c = propertyList[1].id;
        
        update paymentPlans;
        
    }
    
    static testMethod void testCreateBillingLineItems()
    {
       List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c];

        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        Billing_Plan_Line_Item__c billingPlanLineItem1 = new Billing_Plan_Line_Item__c();
        billingPlanLineItem1.Payment_Plan__c = paymentPlans[0].Id;
		billingPlanLineItem1.Milestone_Number__c  = '1';  
        billingPlanLineItem1.Terms_of_Payment_Key__c = 'IND';
        billingPlanLineItems.add(billingPlanLineItem1);
		
		Billing_Plan_Line_Item__c billingPlanLineItem2 = new Billing_Plan_Line_Item__c();  
        billingPlanLineItem2.Payment_Plan__c = paymentPlans[1].Id;
		billingPlanLineItem2.Milestone_Number__c  = '1';  
        billingPlanLineItem2.Terms_of_Payment_Key__c = 'IND';
        billingPlanLineItems.add(billingPlanLineItem2);
        
        insert billingPlanLineItems;  

        
    }
    
    static testMethod void testCreateBillingLineItems2()
    {
        
       
        
    Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan').getRecordTypeId();
        List<opportunity> oppList = new list<opportunity>([select id from opportunity]);
        List<project__C> pList = new list<project__C>([select id from project__C]);
        List<Tower__c> towers = new list<Tower__c>([select id from Tower__c]);
        List<site__C> sList = new list<site__C>([select id from site__C]);
        List<property__c> propertyList = new list<property__c>([select id from property__c]);
       List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[1].id;
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].Floor_Rise_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c = 0;
        paymentPlans[0].PLC_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 1;
        paymentPlans[0].ITC_Basic_Sale_Price_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        paymentPlans[0].ITC_Floor_Rise_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Floor_Rise_Cost__c =1;
        paymentPlans[0].ITC_PLC_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        //paymentPlans[0].ITC_Floor_Rise_Charges__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c =1;
        
       test.startTest();
       insert paymentPlans;
        update paymentPlans;
        test.stopTest();
        
    }
    
    static testMethod void testCreateBillingLineItems3()
    {
        
       
        
    Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
        List<opportunity> oppList = new list<opportunity>([select id from opportunity]);
        List<project__C> pList = new list<project__C>([select id from project__C]);
        List<Tower__c> towers = new list<Tower__c>([select id from Tower__c]);
        List<site__C> sList = new list<site__C>([select id from site__C]);
        List<property__c> propertyList = new list<property__c>([select id from property__c limit 1]);
        property__c a = [select id from property__c where id != :propertyList[0].id limit 1];
        propertyList[0].Related_Jodi_Property__c = a.id;
        update propertyList;
       List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[0].id; 
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 10;
        //paymentPlans[0].Admin_Base_Sale_Price__c = 10;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].Floor_Rise_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c = 0;
        paymentPlans[0].PLC_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 0;
        paymentPlans[0].ITC_Basic_Sale_Price_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        paymentPlans[0].ITC_Floor_Rise_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Floor_Rise_Cost__c =1;
        paymentPlans[0].ITC_PLC_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        //paymentPlans[0].ITC_Floor_Rise_Charges__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c =1;
        
       test.startTest();
       insert paymentPlans;
        
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 2;
        update paymentPlans;
        test.stopTest();
        
    }
    
      static testMethod void testCreateBillingLineItems4()
    {
        
       
        
    Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan').getRecordTypeId();
        List<opportunity> oppList = new list<opportunity>([select id from opportunity]);
        List<project__C> pList = new list<project__C>([select id from project__C]);
        List<Tower__c> towers = new list<Tower__c>([select id from Tower__c]);
        List<site__C> sList = new list<site__C>([select id from site__C]);
        List<property__c> propertyList = new list<property__c>([select id from property__c limit 1]);
        property__c a = [select id from property__c where id != :propertyList[0].id limit 1];
        propertyList[0].Related_Jodi_Property__c = a.id;
        update propertyList;
       List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[0].id; 
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 10;
        //paymentPlans[0].Admin_Base_Sale_Price__c = 10;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].Floor_Rise_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c = 0;
        paymentPlans[0].PLC_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 0;
        paymentPlans[0].ITC_Basic_Sale_Price_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        paymentPlans[0].ITC_Floor_Rise_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Floor_Rise_Cost__c =1;
        paymentPlans[0].ITC_PLC_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        //paymentPlans[0].ITC_Floor_Rise_Charges__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c =1;
        
       test.startTest();
       insert paymentPlans;
        
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 2;
        update paymentPlans;
        test.stopTest();
        
    }
    
      static testMethod void testCreateBillingLineItems5()
    {
        
       
        
    Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
        List<opportunity> oppList = new list<opportunity>([select id from opportunity]);
        List<project__C> pList = new list<project__C>([select id from project__C]);
        List<Tower__c> towers = new list<Tower__c>([select id from Tower__c]);
        List<site__C> sList = new list<site__C>([select id from site__C]);
        List<property__c> propertyList = new list<property__c>([select id from property__c limit 1]);
        property__c a = [select id from property__c where id != :propertyList[0].id limit 1];
        propertyList[0].Related_Jodi_Property__c = a.id;
        update propertyList;
       List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[0].id; 
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 10;
        //paymentPlans[0].Admin_Base_Sale_Price__c = 10;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].Floor_Rise_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c = 0;
        paymentPlans[0].PLC_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 0;
        paymentPlans[0].ITC_Basic_Sale_Price_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        paymentPlans[0].ITC_Floor_Rise_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Floor_Rise_Cost__c =1;
        paymentPlans[0].ITC_PLC_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        //paymentPlans[0].ITC_Floor_Rise_Charges__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c =1;
        
       test.startTest();
       insert paymentPlans;
        
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 2;
        update paymentPlans;
        test.stopTest();
        
    }


   /* 
      static testMethod void testCreateBillingLineItems4()
    {
        
       
        
    Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
        List<opportunity> oppList = new list<opportunity>([select id from opportunity]);
        List<project__C> pList = new list<project__C>([select id from project__C]);
        List<Tower__c> towers = new list<Tower__c>([select id from Tower__c]);
        List<site__C> sList = new list<site__C>([select id from site__C]);
        List<property__c> propertyList = new list<property__c>([select id from property__c where Related_Jodi_Property__c != null]);
       List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[1].id;
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 10;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 0;
        paymentPlans[0].Floor_Rise_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c = 0;
        paymentPlans[0].PLC_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 1;
        paymentPlans[0].ITC_Basic_Sale_Price_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        paymentPlans[0].ITC_Floor_Rise_Charges_Scheme__c = 10;
        paymentPlans[0].Discount_Amount_On_ITC_Floor_Rise_Cost__c =1;
        paymentPlans[0].ITC_PLC_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        //paymentPlans[0].ITC_Floor_Rise_Charges__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c =1;
        
       test.startTest();
       insert paymentPlans;
        
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 50;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 2;
        update paymentPlans;
        test.stopTest();
        
    }*/
    
     static testMethod void testCreateBillingLineItems6()
    {
        Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan').getRecordTypeId();
        List<opportunity> oppList = new list<opportunity>([select id from opportunity]);
        List<project__C> pList = new list<project__C>([select id from project__C]);
        List<Tower__c> towers = new list<Tower__c>([select id from Tower__c]);
        List<site__C> sList = new list<site__C>([select id from site__C]);
        List<property__c> propertyList = new list<property__c>([select id from property__c]);
        Id defaultRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
       Payment_Plan__c propertyList1 = new Payment_Plan__c();
        propertyList1.recordTypeID =defaultRecordTypeId;
        propertyList1.active__C = true;
        propertyList1.Opportunity__c = oppList[0].Id;
        propertyList1.Tower__c = towers[0].id;
        //propertyList1.Type__c = 'Non Scheme';
       insert  propertyList1;
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        Billing_Plan_Line_Item__c billingPlanLineItem1 = new Billing_Plan_Line_Item__c();
        billingPlanLineItem1.Payment_Plan__c = propertyList1.id;
		billingPlanLineItem1.Milestone_Number__c  = '1';  
        billingPlanLineItem1.Terms_of_Payment_Key__c = 'IND';
        billingPlanLineItems.add(billingPlanLineItem1);
		
		Billing_Plan_Line_Item__c billingPlanLineItem2 = new Billing_Plan_Line_Item__c();  
        billingPlanLineItem2.Payment_Plan__c = propertyList1.id;
		billingPlanLineItem2.Milestone_Number__c  = '1';  
        billingPlanLineItem2.Terms_of_Payment_Key__c = 'IND';
        billingPlanLineItems.add(billingPlanLineItem2);
        
        insert billingPlanLineItems;  
        
        update billingPlanLineItems;
        
       towers[0].Project_Name__c = pList[0].id ;
       towers[0].Billing_Plan__c =  propertyList1.id;
        update towers;
       List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[1].id;
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].Floor_Rise_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c = 0;
        paymentPlans[0].PLC_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 1;
        paymentPlans[0].ITC_Basic_Sale_Price_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        paymentPlans[0].ITC_Floor_Rise_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Floor_Rise_Cost__c =1;
        paymentPlans[0].ITC_PLC_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        //paymentPlans[0].ITC_Floor_Rise_Charges__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c =1;
        
       test.startTest();
       insert paymentPlans;
        update paymentPlans;
        test.stopTest();
       

        
    }
    
    static testMethod void testCreateBillingLineItems7()
    {
        
       
        
    Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan').getRecordTypeId();
        List<opportunity> oppList = new list<opportunity>([select id from opportunity]);
        List<project__C> pList = new list<project__C>([select id from project__C]);
        List<Tower__c> towers = new list<Tower__c>([select id from Tower__c]);
        List<site__C> sList = new list<site__C>([select id from site__C]);
        List<property__c> propertyList = new list<property__c>([select id from property__c]);
       List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[1].id;
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].Floor_Rise_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c = 0;
        paymentPlans[0].PLC_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 1;
        paymentPlans[0].ITC_Basic_Sale_Price_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        paymentPlans[0].ITC_Floor_Rise_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Floor_Rise_Cost__c =1;
        paymentPlans[0].ITC_PLC_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        //paymentPlans[0].ITC_Floor_Rise_Charges__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c =1;
        
       test.startTest();
       insert paymentPlans;
        paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 2;
        //paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c =2;
        paymentPlans[0].Discount_Amount_On_PLC_Cost__c=2;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c=2;
        paymentPlans[0].Discount_Amount_On_ITC_Floor_Rise_Cost__c=2;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c=2;
        update paymentPlans;
        test.stopTest();
        
    }
    
    static testMethod void testCreateBillingLineItems8()
    {
        
       
        
    Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
        List<opportunity> oppList = new list<opportunity>([select id from opportunity]);
        List<project__C> pList = new list<project__C>([select id from project__C]);
        List<Tower__c> towers = new list<Tower__c>([select id from Tower__c]);
        List<site__C> sList = new list<site__C>([select id from site__C]);
        List<property__c> propertyList = new list<property__c>([select id from property__c]);
       List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[1].id;
        //paymentPlans[0].ITC_Basic_Sale_Price__c = 100;
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].Floor_Rise_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c = 0;
        paymentPlans[0].PLC_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 1;
        paymentPlans[0].ITC_Basic_Sale_Price_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        paymentPlans[0].ITC_Floor_Rise_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Floor_Rise_Cost__c =1;
        paymentPlans[0].ITC_PLC_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        //paymentPlans[0].ITC_Floor_Rise_Charges__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c =1;
        
       test.startTest();
       insert paymentPlans;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 2;
        //paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c =2;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c=2;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c=2;
        paymentPlans[0].Discount_Amount_On_ITC_Floor_Rise_Cost__c=2;
        paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c=2;
        //paymentPlans[0].Discount_On_ITC_Floor_Rise_Cost__c =2;
        //paymentPlans[0].Discount_On_ITC_PLC_Cost__c =2;
        update paymentPlans;
        test.stopTest();
        
    }
    
    static testMethod void testCreateBillingLineItems9()
    {
        
       
        
    Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
        List<opportunity> oppList = new list<opportunity>([select id from opportunity]);
        List<project__C> pList = new list<project__C>([select id from project__C]);
        List<Tower__c> towers = new list<Tower__c>([select id from Tower__c]);
        List<site__C> sList = new list<site__C>([select id from site__C]);
        List<property__c> propertyList = new list<property__c>([select id from property__c]);
       List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[1].id;
        //paymentPlans[0].ITC_Basic_Sale_Price__c = 100;
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].Floor_Rise_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c = 0;
        paymentPlans[0].PLC_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 1;
        paymentPlans[0].ITC_Basic_Sale_Price_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        paymentPlans[0].ITC_Floor_Rise_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_On_ITC_Floor_Rise_Cost__c =1;
        paymentPlans[0].ITC_PLC_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_On_ITC_PLC_Cost__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        //paymentPlans[0].ITC_Floor_Rise_Charges__c = 1;
        //paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c =1;
        
       test.startTest();
       insert paymentPlans;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 2;
        //paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c =2;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c=2;
        //paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c=2;
        //paymentPlans[0].Discount_Amount_On_ITC_Floor_Rise_Cost__c=2;
        //paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c=2;
        paymentPlans[0].Discount_On_ITC_Floor_Rise_Cost__c =2;
        paymentPlans[0].Discount_On_ITC_PLC_Cost__c =2;
        update paymentPlans;
        test.stopTest();
        
    }
    
     static testMethod void testCreateBillingLineItems10()
    {
        
       
        
    Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
        List<opportunity> oppList = new list<opportunity>([select id from opportunity]);
        List<project__C> pList = new list<project__C>([select id from project__C]);
        List<Tower__c> towers = new list<Tower__c>([select id from Tower__c]);
        List<site__C> sList = new list<site__C>([select id from site__C]);
        List<property__c> propertyList = new list<property__c>([select id from property__c where Admin_Floor_Rise_Charges__c = 5]);
       List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[0].id;
        //paymentPlans[0].ITC_Basic_Sale_Price__c = 100;
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].Floor_Rise_Charges_Scheme__c = 100;
        paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c = 0;
        paymentPlans[0].PLC_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 1;
        paymentPlans[0].ITC_Basic_Sale_Price_Scheme__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        paymentPlans[0].ITC_Floor_Rise_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_On_ITC_Floor_Rise_Cost__c =1;
        paymentPlans[0].ITC_PLC_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_On_ITC_PLC_Cost__c = 1;
        paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        //paymentPlans[0].ITC_Floor_Rise_Charges__c = 1;
        //paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c =1;
        
       test.startTest();
       insert paymentPlans;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 2;
        paymentPlans[0].Discount_Amount_On_Floor_Rise_Cost__c =2;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c=2;
        //paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c=2;
        //paymentPlans[0].Discount_Amount_On_ITC_Floor_Rise_Cost__c=2;
        //paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c=2;
        //paymentPlans[0].Discount_On_ITC_Floor_Rise_Cost__c =2;
        //paymentPlans[0].Discount_On_ITC_PLC_Cost__c =2;
        update paymentPlans;
        test.stopTest();
        
    }
   
     static testMethod void testCreateBillingLineItems11()
    {
        
       
        
    Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
        List<opportunity> oppList = new list<opportunity>([select id from opportunity]);
        List<project__C> pList = new list<project__C>([select id from project__C]);
        List<Tower__c> towers = new list<Tower__c>([select id from Tower__c]);
        List<site__C> sList = new list<site__C>([select id from site__C]);
        List<property__c> propertyList = new list<property__c>([select id from property__c where Admin_Floor_Rise_Charges__c = 5]);
       List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[0].id;
        //paymentPlans[0].ITC_Basic_Sale_Price__c = 100;
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].Floor_Rise_Charges_Scheme__c = 100;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 0;
        paymentPlans[0].Discount_On_ITC_Basic_Cost__c = 1;
        paymentPlans[0].PLC_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 1;
        //paymentPlans[0].ITC_Basic_Sale_Price_Scheme__c = 1;
        //paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        //paymentPlans[0].ITC_Floor_Rise_Charges_Scheme__c = 1;
        paymentPlans[0].Discount_On_ITC_Floor_Rise_Cost__c =1;
        //paymentPlans[0].ITC_PLC_Charges_Scheme__c = 1;
        //paymentPlans[0].Discount_On_ITC_PLC_Cost__c = 1;
        //paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c = 1;
        //paymentPlans[0].ITC_Floor_Rise_Charges__c = 1;
        //paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c =1;
        
       test.startTest();
       insert paymentPlans;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 2;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c =2;
        paymentPlans[0].Discount_On_ITC_Basic_Cost__c = 2;
        //paymentPlans[0].Discount_Amount_On_PLC_Cost__c=2;
        //paymentPlans[0].Discount_Amount_On_ITC_Basic_Cost__c=2;
        //paymentPlans[0].Discount_Amount_On_ITC_Floor_Rise_Cost__c=2;
        //paymentPlans[0].Discount_Amount_On_ITC_PLC_Cost__c=2;
        //paymentPlans[0].Discount_On_ITC_Floor_Rise_Cost__c =2;
        //paymentPlans[0].Discount_On_ITC_PLC_Cost__c =2;
        update paymentPlans;
        test.stopTest();
        
    }
    
     static testMethod void testCreateBillingLineItems12()
    {
        
       
        
    Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
        List<opportunity> oppList = new list<opportunity>([select id from opportunity]);
        List<project__C> pList = new list<project__C>([select id from project__C]);
        List<Tower__c> towers = new list<Tower__c>([select id from Tower__c]);
        List<site__C> sList = new list<site__C>([select id from site__C]);
        List<property__c> propertyList = new list<property__c>([select id from property__c where Admin_Floor_Rise_Charges__c = 5]);
       List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[0].id;
        //paymentPlans[0].ITC_Basic_Sale_Price__c = 100;
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 100;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].Floor_Rise_Charges_Scheme__c = 100;
        paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 0;
        paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].PLC_Charges_Scheme__c = 100;
        
        
       test.startTest();
       insert paymentPlans;
        
        paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 2;
        paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 2;
      
        update paymentPlans;
        test.stopTest();
        
    }
    
    static testMethod void testCreateBillingLineItems13()
    {
        
       
        
    Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
        List<opportunity> oppList = new list<opportunity>([select id from opportunity]);
        List<project__C> pList = new list<project__C>([select id from project__C]);
        List<Tower__c> towers = new list<Tower__c>([select id from Tower__c]);
        List<site__C> sList = new list<site__C>([select id from site__C]);
        List<property__c> propertyList = new list<property__c>([select id from property__c where Admin_Floor_Rise_Charges__c = 5]);
       List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = schemeBPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        paymentPlans[0].property__c = propertyList[0].id;
        //paymentPlans[0].ITC_Basic_Sale_Price__c = 100;
        paymentPlans[0].Basic_Sale_Price_Scheme__c = 100;
        //paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].Floor_Rise_Charges_Scheme__c = 100;
        paymentPlans[0].Discount_Amount_On_PLC_Cost__c = 0;
        paymentPlans[0].Discount_Amount_On_Basic_Cost__c = 1;
        paymentPlans[0].PLC_Charges_Scheme__c = 100;
        
        
       test.startTest();
       insert paymentPlans;
        
        paymentPlans[0].Discount_Amount_On_Basic_Cost__c = null;
        paymentPlans[0].Discount_Amount_On_PLC_Cost__c = null;
      
        update paymentPlans;
        test.stopTest();
        
    }
   
    


    
    
    
    
    
    
    
    
}