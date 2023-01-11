public class ProcessBooking
{
  public string BookingId{get;set;}
  public string outputmessage{get;set;}
  Public String ProjectId{get;set;}
  public id CustomerId {get;set;}
  Public String TowerName{get;set;}
  public list<Booking__c> lstbooking;
  public list<Property__c> lstProjunit;
  public boolean status {get ; set ;}
  public Id towerId {get;set;}
  public list <id>  ListOthereUsersId  {get;set;}
  public list <User> OtherUsersBooking {get;set;}
  public Booking__c bookingProc;
  public String customerCode {get;set;}
  public String soCode {get;set;}
  public String quoteID {get;set;}
  
    public ProcessBooking()
    {
        list<Booking__c> lstBooking = new list<Booking__c>();
        list<Property__c> unitListToUpdate = New list<Property__c>();

        BookingId = ApexPages.currentPage().getParameters().get('id');   
        ListOthereUsersId = New list <id> ();
        OtherUsersBooking  =  new List <User> ();
        if(BookingId != null)
        {
            //////////////////Ankur : Commenting out this line and added the next one to fetch an extra field on 18.11.2015 19:36 hrs//////////////////////////////////
              lstBooking = [select id,name,Booking_Date__c, status__c,Property__c,Property__r.name,Property__r.Status__c,Project__c,Project__r.name,/*Property__r.Param2__c,*/Property__r.Tower__r.Id, Opportunity__c,Opportunity__r.name,PAN_Number__c, Quotation__c, Quotation__r.Quote_Status__c,
                      Doc_Verification_Status__c,Central_Support__c,Site_Support__c,Customer_Code__c,Sales_Document_SAP__c,Pricing_Flown_to_SAP__c,
                      Property__r.Site_Support__c,Property__r.Central_Support__c,Tower__r.Customer_A_C_Group__c
                      /**Sales_Managers__c, Opportunity__r.Operational_Manager__c,Opportunity__r.Operational_Manager__r.email,Opportunity__r.RealtionshipManager__c,Opportunity__r.RealtionshipManager__r.email,Property__r.Reason_For_CRM_returns_to_sales__c,Opportunity__r.Account.Salutation ,Customer__r.Account.Salutation,Ownerid,   **/
                      from Booking__c where id=: BookingId];              
      
        }

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
        
    }
    
    Public PageReference Process()
    {
       //////////////////Ankur : Commenting out this code as on 18.11.2015 19:36 hrs//////////////////////////////////
        if(bookingProc != null && bookingProc.Quotation__r.Quote_Status__c != 'Valid')
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Quotation is not Valid.'));
            return null;
        }
        
        
        if(bookingProc != null && bookingProc.id != null && bookingProc.status__c != null && (bookingProc.status__c == 'UnProcessed' || (bookingProc.status__c == 'Booking In Process' && bookingProc.Property__r.Status__c == 'CRM Returned To Sales')))
        {  
            TRY{
                system.debug('customerCode ::: '+ customerCode);
                system.debug('bookingProc.Pricing_Flown_to_SAP__c ::: '+ bookingProc.Pricing_Flown_to_SAP__c);
                Customer_Account_Group__c cs = Customer_Account_Group__c.getInstance(string.valueof(bookingProc.Tower__r.Customer_A_C_Group__c));
                Number_Range__c cs2 =  Number_Range__c.getInstance(string.valueof(cs.Number_Id__c));
        
                 system.debug('-Print-'+cs2.Processing_Status__c);
                 If(cs2.Processing_Status__c == True){     
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please wait you are next, retry in few seconds'));           
                 }
                 else if(string.isBlank(customerCode)){
                        cs2.Processing_Status__c = True;
                        update cs2;
                        //Rest_Create_customer RCC = new Rest_Create_customer();
                        //RCC.CreateJSON(bookingProc.id);
                        Rest_Create_customer.CreateJSON(bookingProc.id);
                }else if(!bookingProc.Pricing_Flown_to_SAP__c && string.isNotBlank(customerCode)){
                    Rest_SAP_Customer_Specific_Pricing scp = new Rest_SAP_Customer_Specific_Pricing();
                    scp.sendSpecificPricingDetailsZPRO(quoteID,customerCode);
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
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,'Booking Has Been Processed Sucessfully.'));
                }
            }CATCH(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, ' ' + e.getMessage()));
                System.debug('Your exception message here....'+e.getMessage());
            }
                
        }  
        else if(bookingProc != null && bookingProc.id != null && bookingProc.status__c != null && bookingProc.status__c == 'Booking In Process')
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Booking has been already processed.'));
        }
        else if(bookingProc != null && bookingProc.id != null && bookingProc.status__c != null && bookingProc.status__c == 'Processed')
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Booking has been already processed.'));
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'Some internal error encountered while processing your request. Please Contact your Administrator.'));
        }
        return null;
    }
        
    public PageReference incrementCounter() 
    {       
        if(BookingId!= '')
        {
            pageReference P = new pageReference('/'+ BookingId);
            return P;
        }
        return null;
    }
    public PageReference BackToBooking(){
        pageReference P = new pageReference('/'+ BookingId);
        return P;
    }
}