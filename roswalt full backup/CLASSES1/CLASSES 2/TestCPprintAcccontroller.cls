@isTest
public class TestCPprintAcccontroller 
{
 @isTest
    public static void TestCPprintAcccontroller1()
    {
        Test.startTest();
        Id rctId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        CPprintAcccontroller cp = new CPprintAcccontroller();
        Test.stopTest();
    }
    
}