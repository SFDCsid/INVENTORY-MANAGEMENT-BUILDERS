@isTest
public class closeleadopptyscheduletest {

     
    public static String CRON_EXP = '0 0 0 15 3 ? 2023';
    static testmethod void testScheduledJob() {
         
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP,
            new CloseLeadOpptySchedule());
        
        Test.stopTest();
         
    }
}