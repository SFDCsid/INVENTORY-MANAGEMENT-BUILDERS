@isTest
public class ORL_Payment_Plan_ExtnCTRLTest {
    static List<Booking__c> bookinglist = new  List<Booking__c>(); 
    static List<Tower__c> towerlist = new  List<Tower__c>();
    
    
    @TestSetup
    private static void createTestData() {
        
    }
       
    @isTest static void testORL_Payment_Plan_ExtnCTRL() {
        bookinglist= new List<Booking__c>();
        
         Booking__c booking= new Booking__c();
        booking.Billing_Location__c = 'hjfs';
          bookinglist.add(booking);
         bookinglist.add(booking);
        
        ORL_Payment_Plan_ExtnCTRL obj = new ORL_Payment_Plan_ExtnCTRL();
        obj.currenRecid = '52121212121';
        
        Booking__c book = obj.currentBooking;
      
        List<Billing_Plan_Line_Item__c> arr = new List<Billing_Plan_Line_Item__c>();
        Billing_Plan_Line_Item__c objBill = new Billing_Plan_Line_Item__c();
        objBill.Percentage_Of_Value_To_Be_Invoiced__c = '652521';
        objBill.Payment_Plan_Line_Item_Name__c = 'hjdgw';
        arr.add(objBill);
        
        
    } 
}