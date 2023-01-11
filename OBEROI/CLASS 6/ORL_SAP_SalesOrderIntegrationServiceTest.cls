@isTest
public class ORL_SAP_SalesOrderIntegrationServiceTest {
    static List<Booking__c> bookingList;
    @TestSetup
    private static void createTestData() {
        bookingList = new List<Booking__c>(TestDataFactory.createBookings(1));
        insert bookingList;
        
    }
    
   public static testMethod void myTestMethod(){
        try{
        Test.startTest();
        ORL_SAP_SalesOrderIntegrationServiceV1 obj=new ORL_SAP_SalesOrderIntegrationServiceV1();
        obj.createSalesOrderInSAP(bookingList[0].id);
        Test.stopTest();
        }
        catch(exception ec){
            
        }
    }
    
    
    
}