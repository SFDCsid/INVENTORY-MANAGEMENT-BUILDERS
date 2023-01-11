public class Update_customer {
    public string BookingId{get;set;}
    public list<Booking__c> bookingProc{Get;Set;}
    
    public Update_customer(){
        bookingProc = new list<Booking__c>();
        BookingId = ApexPages.currentPage().getParameters().get('id');   
        if(BookingId != null){
           bookingProc = [select id,name,Sales_Document_SAP__c,Customer_Code__c from Booking__c where id=: BookingId ]; 
          
        }
        if(bookingProc != null && bookingProc.size() > 0){
          
        } 
    }
    
    public void Change(){
        TRY{
            if(bookingProc[0].Customer_Code__c != null){
                System.debug('1. ---- ' + bookingProc[0].Customer_Code__c);
                Rest_Update_customer RUC = new Rest_Update_customer();
                RUC.CreateJSON(bookingProc[0].Id);
                
            }Else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Custoner Code for this booking is blank.'));
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