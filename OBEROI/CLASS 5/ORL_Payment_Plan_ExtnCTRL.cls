public with sharing class ORL_Payment_Plan_ExtnCTRL {
//public Booking__c currentBooking {get;set;} 
public string currenRecid{get;set;}
public Booking__c currentBooking {
   get {
        currentBooking =[select id,Billing_Plan__c,Contact_Name__c,/*Contact_Address__c,*/Booking_Flat_No__c,Unitcode__c,Booking_Date__c,Tower__c,Tower__r.Billing_Plan__c,Project_Name__c,Tower__r.name,Net_Amount__c from Booking__c where id=:currenRecid]; 
        lstActualBilling = new list<Billing_Plan_Line_Item__c >();
        lstCustomBilling = new list<Billing_Plan_Line_Item__c >();
      
       lstCustomBilling =[select id,Percentage_Of_Value_To_Be_Invoiced__c,Payment_Plan_Line_Item_Name__c from Billing_Plan_Line_Item__c where Payment_Plan__c=:currentBooking.Tower__r.Billing_Plan__c]; 
       lstActualBilling =[select id,Percentage_Of_Value_To_Be_Invoiced__c,Payment_Plan_Line_Item_Name__c from Billing_Plan_Line_Item__c where Payment_Plan__c=:currentBooking.Billing_Plan__c]; 
      return currentBooking; }
   set;
}
 
public list<Billing_Plan_Line_Item__c> lstActualBilling {get;set;}
public list<Billing_Plan_Line_Item__c> lstCustomBilling {get;set;}

    public ORL_Payment_Plan_ExtnCTRL(){
        currentBooking = new Booking__c();
        system.debug('@@@@@@'+currenRecid);
       
        //currentBooking =[select id,Unitcode__c,Booking_Date__c,Tower__c,Tower__r.Billing_Plan__c from Booking__c where id=:currenRecid]; 
        lstActualBilling = new list<Billing_Plan_Line_Item__c >();
        lstCustomBilling = new list<Billing_Plan_Line_Item__c >();
      
        //lstCustomBilling =[select id,Percentage_Of_Value_To_Be_Invoiced__c,Payment_Plan_Line_Item_Name__c from Billing_Plan_Line_Item__c where Payment_Plan__c=:currentBooking.Tower__r.Billing_Plan__c]; 
        //lstActualBilling =[select id,Percentage_Of_Value_To_Be_Invoiced__c,Payment_Plan_Line_Item_Name__c from Billing_Plan_Line_Item__c where Payment_Plan__c=:currentBooking.Billing_Plan__c]; 
       
    }
    

}