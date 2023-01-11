public class SuccessController {
    public id bookingid {get;set;}

    public SuccessController() { 
        bookingid = ApexPages.currentPage().getParameters().get('id');
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Document Generated Successfully'));
    }  
      
    public PageReference Home() {  
      
        return new PageReference('/'+bookingid); 
          
    }
}