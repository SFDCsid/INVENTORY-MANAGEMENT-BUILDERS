@isTest

public class OwnerBatchScheduleLeadTest{

    public static testMethod void testschedule() {
        Test.startTest();
        OwnerBatchScheduleLead obs = new OwnerBatchScheduleLead ();
        String str= '0 0 2 * * ?';
        system.schedule('LeadOwnerUpdateBatch', str , obs); 
        Test.stopTest();
    }
}