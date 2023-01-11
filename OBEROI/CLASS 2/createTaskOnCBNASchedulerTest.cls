@isTest
public class createTaskOnCBNASchedulerTest {


    public static testMethod void testschedule() {
        Test.startTest();
        createTaskOnCBNAScheduler obs = new createTaskOnCBNAScheduler ();
        String str= '0 0 2 * * ?';
        system.schedule('createTaskOnCBNAScheduler', str , obs); 
        Test.stopTest();
    }


}