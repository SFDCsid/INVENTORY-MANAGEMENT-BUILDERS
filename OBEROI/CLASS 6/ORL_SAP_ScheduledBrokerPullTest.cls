/****************************************************************************************************
Class covered :
1. ORL_SAP_ScheduledBrokerPull - 7/6/2019 - 100%
2. ORL_SAP_IntegrationHelper - 7/6/2019 - 12%

****************************************************************************************************/
@isTest(seeAllData=false)
public class ORL_SAP_ScheduledBrokerPullTest {
    static testmethod void schedulerTest() 
    {
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        Test.startTest();
            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new ORL_SAP_ScheduledBrokerPull());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }

}