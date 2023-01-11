/****************************************************************************************************
Class covered :
1. ORL_SAP_ScheduledBillingPlanPull - 7/6/2019 - 100%
2. ORL_SAP_IntegrationHelper - 7/6/2019 - 39%

****************************************************************************************************/
@isTest(seeAllData=false)
public class ORL_SAP_ScheduledBillingPlanPullTest {
static testmethod void schedulerTest() 
    {
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        // Create your test data
        Account acc = new Account();
        acc.name= 'test';
        insert acc;
        
        Test.startTest();

            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new ORL_SAP_ScheduledBillingPlanPull());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
        // Add assert here to validate result
    }

}