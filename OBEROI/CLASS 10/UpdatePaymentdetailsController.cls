public class UpdatePaymentdetailsController {
    public string bId{get;set;}
    public boolean status {get;set;}
    public List<Booking__c> bList = new List<Booking__c>();
    
    public UpdatePaymentdetailsController(){       
        
        bId = ApexPages.currentPage().getParameters().get('Id');
        if(bId != null)
        {
            system.debug('bId:::::::' +bId);
            bList = [select id,name,Customer_Code__c from Booking__c where id =: bId];
            system.debug('bList::::' +bList);
        }
    }
    Public void flow(){        
        TRY{
            system.debug('bList::::' +bList);
            If(bList.size() > 0 &&  bList[0].Customer_Code__c != null)
            {
                REST_UpdatePaymentDetails UPD= new REST_UpdatePaymentDetails();
                //system.debug('Inside Else with no channel partner as source:::::: ');
                //Rest_Create_Leasing_customer.CreateLCust(oppid1);
                UPD.UpdatePaymentDetails(bId);        
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Customer code is blank'));
            }
        }CATCH(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, ' ' + e.getMessage()));
            System.debug('Your exception message here....'+e.getMessage());
        }
        
    }
    
    public PageReference incrementCounter() 
    {       
        if(bId!= '')
        {
            pageReference P = new pageReference('/'+ bId);
            return P;
        }
        return null;
    }
    public PageReference BackToBooking(){
        pageReference P = new pageReference('/'+ bId);
        return P;
    }
}