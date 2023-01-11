@isTest
private class ORL_PaymentPlanDomainTest {
    
    /*@testSetup static void setup() {
Id recordTypeIdBP = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
List<Payment_Plan__c> paymentPlanList = new List<Payment_Plan__c>();
Payment_Plan__c sinlgePlaymentPlan = new Payment_Plan__c();
sinlgePlaymentPlan.Payment_Plan_Type__c='Scheme';
sinlgePlaymentPlan.Payment_Plan_Number__c = '1234567';
sinlgePlaymentPlan.RecordTypeId = recordTypeIdBP;
paymentPlanList.add(sinlgePlaymentPlan);
// insert paymentPlanList;

List<Payment_Plan_Line_Item__c> paymentPlanItemList = new List<Payment_Plan_Line_Item__c>();
Payment_Plan_Line_Item__c sinlgePlaymentPlanItem = new Payment_Plan_Line_Item__c();
sinlgePlaymentPlanItem.Payment_Plan_Line_Item_Name__c = 'Test Payment Plan';
sinlgePlaymentPlanItem.Payment_Plan__c = sinlgePlaymentPlan.id;
paymentPlanItemList.add(sinlgePlaymentPlanItem);
//  insert paymentPlanItemList;
}*/
    
    @isTest  
    static void insertPaymentPlan() {
        Test.startTest();
        List<Opportunity> opps = TestDataFactory.createOpportunity(1);
        insert opps;
        
        User usr = TestDataFactory.createUser('ORL Admin', 'MD');
        
        List<Site__c> sList = TestDataFactory.createSite(4);
        insert sList;
        
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        
        List<Project__c> pList = TestDataFactory.createResProject(4);
        
        pList[0].Name = 'Enigma';
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
        
        List<Property_Type__c> projectTypeList = TestDataFactory.createProjectType(4);
        projectTypeList[0].Project1__c = pList[0].Id;
        insert projectTypeList;
        
      
        
        List<Property__c> properties = TestDataFactory.createProperties(1);
        properties[0].Property_Type__c = projectTypeList[0].id;
        insert properties;
        
        
            
        Id recordTypeIdBP = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
        List<Payment_Plan__c> paymentPlanList = new List<Payment_Plan__c>();
        Payment_Plan__c sinlgePlaymentPlan = new Payment_Plan__c();
        sinlgePlaymentPlan.Payment_Plan_Type__c='Scheme';
        sinlgePlaymentPlan.Payment_Plan_Number__c = '1234567';
        sinlgePlaymentPlan.RecordTypeId = recordTypeIdBP;
        sinlgePlaymentPlan.Opportunity__c = opps[0].Id;
		sinlgePlaymentPlan.Property__c = properties[0].id;
       
        paymentPlanList.add(sinlgePlaymentPlan);
                
        ORL_PaymentPlanDomain paymentPlanDomain = new ORL_PaymentPlanDomain();
        paymentPlanDomain.insertPaymentPlan(paymentPlanList);
        
        Test.stopTest();
    }  
    
    @isTest  
    static void insertPaymentPlanItems() {
        
        List<Payment_Plan_Line_Item__c> paymentPlanItemList = new List<Payment_Plan_Line_Item__c>();
        Payment_Plan_Line_Item__c sinlgePlaymentPlanItem = new Payment_Plan_Line_Item__c();
        sinlgePlaymentPlanItem.Payment_Plan_Line_Item_Name__c = 'Test Payment Plan';
        List<payment_plan__c> pp = TestDataFactory.createBillingPlan(1);
        insert pp;
       	sinlgePlaymentPlanItem.Payment_Plan__c = pp[0].id;
        paymentPlanItemList.add(sinlgePlaymentPlanItem);
        
        ORL_PaymentPlanDomain paymentPlanDomain = new ORL_PaymentPlanDomain();
        paymentPlanDomain.insertPaymentPlanItems(paymentPlanItemList);
        
        List<Payment_Plan_Line_Item__c> paymentPlanLineItems = [select Id from Payment_Plan_Line_Item__c];
        system.assert(paymentPlanLineItems!=null&&paymentPlanLineItems.size()==1);
    }
    
    @isTest  
    static void testInsertPaymentPlanItemsException() {
        
        List<Payment_Plan_Line_Item__c> paymentPlanItemList = new List<Payment_Plan_Line_Item__c>();
        Payment_Plan_Line_Item__c sinlgePlaymentPlanItem = new Payment_Plan_Line_Item__c();
        sinlgePlaymentPlanItem.Payment_Plan_Line_Item_Name__c = 'Test Payment Plan';
        paymentPlanItemList.add(sinlgePlaymentPlanItem);
        
        try{
        	ORL_PaymentPlanDomain paymentPlanDomain = new ORL_PaymentPlanDomain();
        	paymentPlanDomain.insertPaymentPlanItems(paymentPlanItemList);
        } catch(Exception e){
            System.assert(e!=null);
        }
    }
    
    @isTest(SeeAllData=true)
    static void amendPaymentPlan() {
        
        List<Payment_Plan__c> paymentPlanList = [SELECT Id,Payment_Plan_Type__c,Payment_Plan_Number__c FROM Payment_Plan__c where Status__c !='Approved' limit 1];
        
        For(Payment_Plan__c singlePlaymentPlan:paymentPlanList){
            singlePlaymentPlan.Status__c='Approved';
        }
        
        ORL_PaymentPlanDomain paymentPlanDomain = new ORL_PaymentPlanDomain();
        paymentPlanDomain.amendPaymentPlan(paymentPlanList);
        
    }
    @isTest  
    static void amendPaymentPlanItems() {
        List<Payment_Plan__c> paymentPlanList = [SELECT Id,Payment_Plan_Type__c,Payment_Plan_Number__c FROM Payment_Plan__c];
        List<Payment_Plan_Line_Item__c> paymentPlanLineList = [SELECT Payment_Plan_Line_Item_Name__c FROM Payment_Plan_Line_Item__c];
        For(Payment_Plan_Line_Item__c paymentPlanLineItem:paymentPlanLineList){
            paymentPlanLineItem.Description__c = 'amendPaymentPlanItems';
            paymentPlanLineItem.Payment_Plan__c = paymentPlanList[0].Id;
        }
        ORL_PaymentPlanDomain paymentPlanDomain = new ORL_PaymentPlanDomain();
        paymentPlanDomain.amendPaymentPlanItems(paymentPlanLineList);
        
    }
    @isTest  
    static void deletePaymentPlanItems() {
        List<Payment_Plan__c> paymentPlanList = [SELECT Id,Payment_Plan_Type__c,Payment_Plan_Number__c FROM Payment_Plan__c];
        List<Payment_Plan_Line_Item__c> paymentPlanLineList = [SELECT Payment_Plan_Line_Item_Name__c FROM Payment_Plan_Line_Item__c];
        For(Payment_Plan_Line_Item__c paymentPlanLineItem:paymentPlanLineList){
            paymentPlanLineItem.Payment_Plan__c = paymentPlanList[0].Id;
        }
        ORL_PaymentPlanDomain paymentPlanDomain = new ORL_PaymentPlanDomain();
        paymentPlanDomain.deletePaymentPlanItems(paymentPlanLineList);
    }
    
    @isTest  
    static void retrievePaymentPlanBySAPNumber() {
        
        List<Payment_Plan__c> paymentPlanList = [SELECT Id,Payment_Plan_Type__c,Payment_Plan_Number__c FROM Payment_Plan__c];
        List<String> paymentPlanNumberList = new List<String>();
        For(Payment_Plan__c singlePlaymentPlan:paymentPlanList){
            System.debug('singlePlaymentPlan__'+singlePlaymentPlan.Payment_Plan_Number__c);
            paymentPlanNumberList.add(singlePlaymentPlan.Payment_Plan_Number__c);
        }
        ORL_PaymentPlanDomain paymentPlanDomain = new ORL_PaymentPlanDomain();
        paymentPlanDomain.retrievePaymentPlanBySAPNumber(paymentPlanNumberList);
        
    }
    @isTest  
    static void retrievePaymentPlanItemsBySAPNumber() {
        
        List<Payment_Plan__c> paymentPlanList = [SELECT Id,Payment_Plan_Type__c,Payment_Plan_Number__c FROM Payment_Plan__c];
        List<Payment_Plan_Line_Item__c> paymentPlanLineList = [SELECT Payment_Plan_Line_Item_Name__c,Item_of_Payment_Plan__c,Payment_Plan__r.Payment_Plan_Number__c FROM Payment_Plan_Line_Item__c];
        List<String> paymentPlanNumberList = new List<String>();
        List<String> itemOfPaymentPlanList = new List<String>();
        For(Payment_Plan_Line_Item__c paymentPlanLineItem:paymentPlanLineList){
            paymentPlanLineItem.Payment_Plan__c = paymentPlanList[0].Id;
            paymentPlanNumberList.add(paymentPlanLineItem.Payment_Plan__r.Payment_Plan_Number__c);
            System.debug('12345__'+paymentPlanLineItem.Item_of_Payment_Plan__c);
            itemOfPaymentPlanList.add(paymentPlanLineItem.Item_of_Payment_Plan__c);
            
        }
        update paymentPlanLineList;
        
        ORL_PaymentPlanDomain paymentPlanDomain = new ORL_PaymentPlanDomain();
        paymentPlanDomain.retrievePaymentPlanItemsBySAPNumber(paymentPlanNumberList,itemOfPaymentPlanList);
        
    }
    
}