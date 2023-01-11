@isTest
public class CustomizedPaymentPlanControllerTest {
    static list<Milestone__c> milelist;
    static String recId,recId1;
    static  Opportunity opp;
    static   Payment_Plan__c paymentplan;
    static list<Payment_Plan_Line_Item__c>paymentPlanList;
    static list<Payment_Plan__c>payPlan;
    static list<Project__c> projList;
    static Tower__c towerObj;
    @TestSetup
    private static void createTestData() {
        projList = TestDataFactory.createResProject(1);
        insert projList;
        paymentPlanList=new list<Payment_Plan_Line_Item__c>();
        payPlan=new list<Payment_Plan__c>();
        CustomizedPaymentPlanController custpayment=new CustomizedPaymentPlanController();
        towerObj=new Tower__C();
        towerObj.Project_Name__c = projList[0].Id;
        towerObj.Description__c='sewrw';
        towerObj.Active__c=TRUE;
        insert towerObj;
        recId='1234';
        recId1='123456';
        milelist=new list<Milestone__c>();
        Milestone__c mile =new Milestone__c();
        mile.Milestone_Name__c='milelist';
        mile.Submilestone_Order__c=12;
        milelist.add(mile);
        
        opp= new Opportunity();
        opp.Name = 'Test Opp';
        opp.StageName = 'New';
        opp.CloseDate = Date.today();
        opp.Amount=200;
        opp.Broker__c='rwew';
        opp.Broker_Company__c='sales';
        opp.Company_Address__c='pune';
        insert opp;
       
        //Payment_Plan_Line_Item__c plan=new Payment_Plan_Line_Item__c();
        /*plan.Billing_Block_For_Payment_Plan__c='AB';
        plan.Description__c='hello';
        plan.Amount__c=12;
        paymentPlanList.add(plan);
        insert paymentPlanList;*/
         paymentplan=new Payment_Plan__c();
        paymentplan.Active__c=TRUE;
        //paymentplan.Basic_Cost__c=20;
        paymentplan.Billing_Plan_Name__c='ABC';
        //paymentplan.Tower__c=towerObj.Id;
        //paymentplan.RecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
        insert paymentplan;
        Payment_Plan_Line_Item__c plan=new Payment_Plan_Line_Item__c();
        plan.Billing_Block_For_Payment_Plan__c='AB';
        plan.Description__c='hello';
        plan.Payment_Plan__c = paymentplan.id;
        plan.Amount__c=12;
        paymentPlanList.add(plan);
        insert paymentPlanList;
         CustomizedPaymentPlanController.BillingPlanWrapper billing= new CustomizedPaymentPlanController.BillingPlanWrapper(opp, paymentPlanList);
        billing.oppObj=opp;
        
    }
    
    @isTest static void testCustomizedPaymentPlanController() {
       
        test.startTest();
        createTestData();
        CustomizedPaymentPlanController.saveWrapperDetails(opp,milelist);
        CustomizedPaymentPlanController.getOpptyDetails(opp.id);
        CustomizedPaymentPlanController.billingLineItems(towerObj.Id) ;
        CustomizedPaymentPlanController.getBillingPlanDetails(opp.id);
        
        test.stopTest();
       
    }
    
}