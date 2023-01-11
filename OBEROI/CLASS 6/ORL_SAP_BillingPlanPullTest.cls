@isTest
public class ORL_SAP_BillingPlanPullTest {
static testmethod void schedulerTest() 
    {
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        // Create your test data
        Account acc = new Account();
        acc.name= 'test';
        insert acc;
        Test.setMock(WebServiceMock.class, new  ORL_SAP_BillingPlanPullServiceMock());
        ORL_SAP_BillingPlanPull.ZSDST_BILLING_PLAN bp = new ORL_SAP_BillingPlanPull.ZSDST_BILLING_PLAN();
        ORL_SAP_BillingPlanPull.BAPIRET2 bn = new ORL_SAP_BillingPlanPull.BAPIRET2();
        Test.startTest();
       ORL_SAP_BillingPlanPullService.BillingPlan bp1 = new ORL_SAP_BillingPlanPullService.BillingPlan('1','Eternia','Mulund');
            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new ORL_SAP_ScheduledBillingPlanPull());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
        // Add assert here to validate result
    }
    
}