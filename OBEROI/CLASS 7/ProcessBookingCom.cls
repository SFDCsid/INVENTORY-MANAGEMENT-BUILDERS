public class ProcessBookingCom {
	@AuraEnabled
    public static String processBooking(Id BookingId){
  		string outputmessage = '';
  		String ProjectId = '';
  		id CustomerId;
        string msg = '';
  		String TowerName = '';
  		list<Booking__c> lstbooking = new list<Booking__c>();
  		list<Property__c> lstProjunit = new list<Property__c>();
  		boolean status = false;
  		Id towerId;
  		list <id>  ListOthereUsersId = new list<id>();
  		list <User> OtherUsersBooking = new list<User>();
  		Booking__c bookingProc;
  		String customerCode = '';
  		String soCode = '';
  		String quoteID = '';
        
        system.debug('BookingID' +BookingId);
        if(BookingId != null)
        {
            //////////////////Ankur : Commenting out this line and added the next one to fetch an extra field on 18.11.2015 19:36 hrs//////////////////////////////////
              lstBooking = [select id,name,Booking_Date__c, status__c,Property__c,Property__r.name,Property__r.Status__c,Project__c,Project__r.name,/*Property__r.Param2__c,*/Property__r.Tower__r.Id, Opportunity__c,Opportunity__r.name,PAN_Number__c, Quotation__c, Quotation__r.Quote_Status__c,
                      Doc_Verification_Status__c,Central_Support__c,Site_Support__c,Customer_Code__c,Sales_Document_SAP__c,Pricing_Flown_to_SAP__c,
                      Property__r.Site_Support__c,Property__r.Central_Support__c
                      /**Sales_Managers__c, Opportunity__r.Operational_Manager__c,Opportunity__r.Operational_Manager__r.email,Opportunity__r.RealtionshipManager__c,Opportunity__r.RealtionshipManager__r.email,Property__r.Reason_For_CRM_returns_to_sales__c,Opportunity__r.Account.Salutation ,Customer__r.Account.Salutation,Ownerid,   **/
                      from Booking__c where id=: BookingId];              
      
        }
        system.debug('lstBooking' +lstBooking);

        if(lstBooking != null && lstBooking.size() > 0)
        {
            bookingProc = lstBooking[0];
            ProjectId = lstBooking[0].Project__c;
            towerId = lstBooking[0].Property__r.Tower__r.Id;         
            CustomerId = lstBooking[0].Opportunity__c;
            if(string.isNotBlank(lstBooking[0].Customer_Code__c))
                customerCode = lstBooking[0].Customer_Code__c;
            if(string.isNotBlank(lstBooking[0]. Sales_Document_SAP__c))    
                soCode = lstBooking[0]. Sales_Document_SAP__c;
            quoteID = lstBooking[0].Quotation__c;
            
        }   
        if(bookingProc != null && bookingProc.Quotation__r.Quote_Status__c != 'Valid')
        {
            system.debug('Inside If');
            return 'Quotation is not Valid.';
        }
        if(bookingProc != null && bookingProc.id != null && bookingProc.status__c != null && (bookingProc.status__c == 'UnProcessed' || (bookingProc.status__c == 'Booking In Process' && bookingProc.Property__r.Status__c == 'CRM Returned To Sales')))
        {  
            TRY{
                system.debug('customerCode ::: '+ customerCode);
                system.debug('bookingProc.Pricing_Flown_to_SAP__c ::: '+ bookingProc.Pricing_Flown_to_SAP__c);
                if(string.isBlank(customerCode)){
                    Rest_Create_customerClass RCC = new Rest_Create_customerClass();
                    msg = RCC.CreateJSON(bookingProc.id);
                    return msg;
                }else if(!bookingProc.Pricing_Flown_to_SAP__c && string.isNotBlank(customerCode)){
                    Rest_SAP_Customer_Specific_PricingClass scp = new Rest_SAP_Customer_Specific_PricingClass();
                    msg = scp.sendSpecificPricingDetailsZPRO(quoteID,customerCode);
                    return msg;
                }else if(bookingProc.Pricing_Flown_to_SAP__c && string.isNotBlank(customerCode)){
                    bookingProc.status__c = 'Booking In Process';
                    bookingProc.Doc_Verification_Status__c = 'Level 1 Pending';
                    bookingProc.Site_Support__c = bookingProc.Property__r.Site_Support__c;
                    bookingProc.Central_Support__c = bookingProc.Property__r.Central_Support__c;   
                    update bookingProc;  
                    
                    Property__c pr = new Property__c();
                    pr.id = bookingProc.Property__c;
                    pr.Status__c = 'BIP - Sales';
                    update pr;
                    If(bookingProc.Site_Support__c != '' || bookingProc.Site_Support__c != Null){
                    
                    Task tsk = new Task();
                    tsk.Subject = 'Document For level One verification is due For this Booking';
                    tsk.OwnerId = bookingProc.Site_Support__c;
                    tsk.Status = 'New';
                    tsk.ActivityDate = System.today();
                    tsk.WhatId = bookingProc.id;
                    
                        insert tsk;
                    }
                    return 'Booking Has Been Processed Sucessfully.';
                   
                }
            }CATCH(Exception e){
                
                return e.getMessage();
            }
                
        }  
        else if(bookingProc != null && bookingProc.id != null && bookingProc.status__c != null && bookingProc.status__c == 'Booking In Process')
        {
            return 'Booking has been already processed.';
        }
        else if(bookingProc != null && bookingProc.id != null && bookingProc.status__c != null && bookingProc.status__c == 'Processed')
        {
        	return 'Booking has been already processed.';
        }
        else{
            system.debug('Inside else');
            return 'Some internal error encountered while processing your request. Please Contact your Administrator.';
        }
       return null; 
        
    } 
   
}