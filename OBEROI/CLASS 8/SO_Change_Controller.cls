public class SO_Change_Controller {
    public string BookingId{get;set;}
    public list<Booking__c> bookingProc{Get;Set;}
    
    public SO_Change_Controller(){
        bookingProc = new list<Booking__c>();
        BookingId = ApexPages.currentPage().getParameters().get('id');   
        if(BookingId != null){
           bookingProc = [select id,name,Sales_Document_SAP__c from Booking__c where id=: BookingId ]; 
          
        }
        if(bookingProc != null && bookingProc.size() > 0){
          
        } 
    }
    
    public void SOChange(){
        TRY{
            if(bookingProc[0].Sales_Document_SAP__c != null){
                System.debug('1. ---- ' + bookingProc[0].Sales_Document_SAP__c);
                Rest_PUT_SAP_Sales_Order_Updation rps = new Rest_PUT_SAP_Sales_Order_Updation();
                rps.updateSalesOrder(bookingProc[0].Id);
            }Else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Sales Order number is blank.'));
            }                          
        }CATCH(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, ' ' + e.getMessage()));
        }          
    }
    
    public PageReference BackToBooking(){
        pageReference P = new pageReference('/'+ BookingId);
        return P;
    }
}