@isTest
public class CustomBillingPlanTest {
    @isTest
    static void UnitTest() {
        new CustomBillingPlan();
        List<Payment_Plan__c> paymentPLan=TestDataFactory.createBillingPlan(1);
        insert paymentPLan;
        System.debug('Value' +paymentPLan);
        Test.startTest();
        PageReference pageRef = Page.ViewBillingPlan;
		Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',paymentPLan[0].id);

        CustomBillingPlan obj = new CustomBillingPlan(new ApexPages.StandardController (paymentPLan[0]));
        Test.stopTest();
        System.assertEquals(0,ApexPages.getMessages().size());
        
    }
    @isTest
    static void testCase()
    {
        
        CustomBillingPlan controller=new CustomBillingPlan();
        Case cse=new Case();
        insert cse;
 
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=cse.id;
        insert attach;
    	
    	List<Attachment> attachments=[select id, name from Attachment where parent.id=:cse.id];
    	System.assertEquals(1, attachments.size());
        
    }
    
    @isTest
    public static void testAttachment(){
        new CustomBillingPlan();
        List<Payment_Plan__c> paymentPLan=TestDataFactory.createBillingPlan(1);
        insert paymentPLan;
        System.debug('Value' +paymentPLan);
        Test.startTest();
        PageReference pageRef = Page.ViewBillingPlan;
		Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',paymentPLan[0].id);

        CustomBillingPlan obj = new CustomBillingPlan(new ApexPages.StandardController (paymentPLan[0]));
        Test.stopTest();
        obj.saveAttach();
       
    }
    
    
}