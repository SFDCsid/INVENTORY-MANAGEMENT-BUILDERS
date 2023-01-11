public class WrapperBookingFormHandler {
    
    public string type{get;set;} 
    public String SAPSync{get;set;}
    Public String bookingId;
    public Booking__c booking{get;set;}
    
    public WrapperBookingFormHandler(ApexPages.StandardController controller){
        
        bookingId = ApexPages.currentPage().getParameters().get('id');
        booking = new Booking__c();
        
        if(bookingId != '' && bookingId != null ){
            booking = [SELECT billing_plan__r.recordtypeid 
                       FROM Booking__c WHERE Id=:bookingId];
        
    }
    }
    
    public PageReference getRedir() {
        
        //type = ApexPages.currentPage().getParameters().get('type');
        //SAPSync = ApexPages.currentPage().getParameters().get('SAPsync');
        
        
        if(bookingId != '' && bookingId != null ){
            booking = [SELECT billing_plan__r.recordtypeid,project__r.name 
                       FROM Booking__c WHERE Id=:bookingId];
        
    }
        Id CustomBillingRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
        Id NonSchemeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
        
         if(booking.project__r.name.contains('Sky City')){
        if(booking.billing_plan__r.recordtypeid == CustomBillingRecordTypeId || 
        booking.billing_plan__r.recordtypeid == NonSchemeRecordTypeId){ 
            PageReference pagePdf = new PageReference('/apex/ORL_AcceptanceForm'); 
            pagePdf.getParameters().put('id', bookingId ); 
             
        return pagePdf;
        }
        else{
            PageReference pagePdf = new PageReference('/apex/ORL_AcceptanceFormScheme'); 
            pagePdf.getParameters().put('id', bookingId ); 
           return pagePdf;
        }
        }
        
        if(booking.project__r.name.contains('Enigma')){
        if(booking.billing_plan__r.recordtypeid == CustomBillingRecordTypeId || 
        booking.billing_plan__r.recordtypeid == NonSchemeRecordTypeId){ 
            PageReference pagePdf = new PageReference('/apex/ORL_AcceptanceFormNonScheme_Enigma'); 
            pagePdf.getParameters().put('id', bookingId ); 
             
        return pagePdf;
        }
        else{
            PageReference pagePdf = new PageReference('/apex/ORL_AcceptanceFormScheme_Enigma'); 
            pagePdf.getParameters().put('id', bookingId ); 
            
        return pagePdf;
        }
        }
                if(booking.project__r.name.contains('Eternia')){
        if(booking.billing_plan__r.recordtypeid == CustomBillingRecordTypeId || 
        booking.billing_plan__r.recordtypeid == NonSchemeRecordTypeId){ 
            PageReference pagePdf = new PageReference('/apex/ORL_AcceptanceFormNonScheme_Eternia'); 
            pagePdf.getParameters().put('id', bookingId ); 
             
        return pagePdf;
        }
        else{
            PageReference pagePdf = new PageReference('/apex/ORL_AcceptanceFormScheme_Eternia'); 
            pagePdf.getParameters().put('id', bookingId ); 
           return pagePdf;
        }
        }
          if(booking.project__r.name.contains('Prisma')){
              
             PageReference pagePdf = new PageReference('/apex/ORL_AcceptanceFormNonScheme_Prisma'); 
            pagePdf.getParameters().put('id', bookingId );
              return pagePdf;
 
              
          }
        else{
            return null;
        }
    }
    

}