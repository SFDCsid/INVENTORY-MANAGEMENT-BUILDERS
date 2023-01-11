@isTest
public class BillingPlanLineItemTriggerHandlerTest {
    
    public static List<Site__c> createSite( Integer numberOfsites) {
        //Id PrRecordTypeId = Schema.SObjectType.Site__c.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
        List<Site__c> sList = new List<Site__c>();
        for ( Integer i = 0 ; i < numberOfsites ; i++ ) {            
            Site__c st = new Site__c( Name = 'Test site' + Math.random());
            sList.add(st);
        }
        return sList;        
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
        
        Id paymentPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
        List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = paymentPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].Payment_Plan_Type__c = 'Non Scheme';   
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = pList[0].Id;
        paymentPlans[0].Tower__c = towers[0].Id;
        paymentPlans[0].site__c =sList[0].id;
        insert paymentPlans;
        
        
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
        insert billingPlanLineItems;   
        
    }
    
}