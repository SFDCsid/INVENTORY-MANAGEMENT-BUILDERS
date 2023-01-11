public class FlowCustomerToSAP{
    public string BookingId{get;set;}
    public string outputmessage{get;set;}
    Public String ProjectId{get;set;}
    public id CustomerId {get;set;}
    Public String TowerName{get;set;}
    public list<Booking__c> lstbooking;
    public boolean status {get ; set ;}
    public Id towerId {get;set;}
    public list <id>  ListOthereUsersId  {get;set;}
    public list <User> OtherUsersBooking {get;set;}
    public Booking__c bookingProc;
    public String Emessage {get;set;}
    public String quoteID {get;set;}
    public String customerCode {get;set;}
    public String soCode {get;set;}
    //public Integer i {get;set;}
    //public string errorMsg{get;set;}
    public List <Channel_Partner_Project__c > CPProjetList {get;set;}
    
    public FlowCustomerToSAP()
    {
        list<Booking__c> lstBooking = new list<Booking__c>();
        BookingId = ApexPages.currentPage().getParameters().get('id');   
        ListOthereUsersId = New list <id> ();
        OtherUsersBooking  =  new List <User> ();
        //errorMsg = '';
        if(BookingId != null)
        {
            //////////////////Ankur : Commenting out this line and added the next one to fetch an extra field on 18.11.2015 19:36 hrs//////////////////////////////////
            lstBooking = [select id,name,Booking_Date__c, status__c,Property__c,Billing_Plan_flown_to_SAP__c,Sales_Document_SAP__c,Property__r.name,Property__r.Status__c,Project__c,Project__r.name,Property__r.Tower__r.Id, Opportunity__c,Opportunity__r.name,PAN_Number__c, Quotation__c, Quotation__r.Quote_Status__c,
                          Doc_Verification_Status__c,Central_Support__c,Site_Support__c,Customer_Code__c,Flown_to_SAP__c,Pricing_Flown_to_SAP__c,
                          Booking_Through__c, Vendor_Code__c,Property__r.Site_Support__c,Property__r.Central_Support__c,Opportunity__r.Broker_Account__c
                          from Booking__c where id=: BookingId]; 
            quoteID = lstBooking[0].Quotation__c;
            
        }
        if(lstBooking[0].Booking_Through__c == 'Partner'){
        System.Debug('In PArtner :::::::::::::::::::::');
            CPProjetList = [Select Id, Name,Extended__c,account__c,account__r.Broker_Code__c FROM Channel_Partner_Project__c WHERE Project__c =:lstBooking[0].Project__c AND account__r.Broker_Code__c =:lstBooking[0].Vendor_Code__c];
            System.Debug('CPProjetList  :::::::::::::::::::::'+CPProjetList .size());
        }else{
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
            
            System.debug('bookingProc.Flown_to_SAP__c =====  '+ bookingProc.Flown_to_SAP__c);
            System.debug('bookingProc.Customer_Code__c =====  '+ bookingProc.Customer_Code__c);
            System.debug('bookingProc.Pricing_Flown_to_SAP__c =====  '+ bookingProc.Pricing_Flown_to_SAP__c);
            System.debug('bookingProc.Sales_Document_SAP__c =====  '+ bookingProc.Sales_Document_SAP__c);
            System.debug('bookingProc.Billing_Plan_flown_to_SAP__c =====  '+ bookingProc.Billing_Plan_flown_to_SAP__c);
        } 
    }
    
    Public void flow(){
        
        //////////////////Ankur : Commenting out this code as on 18.11.2015 19:36 hrs//////////////////////////////////
        if(bookingProc.Doc_Verification_Status__c != 'Level 1 Accepted' && bookingProc.Doc_Verification_Status__c != 'Level 2 Accepted')
        {
            //i=1;
            //errorMsg = 'This Booking is not Processed yet.';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Document verification level 1 is not completed.'));
        }else if(bookingProc.Booking_Through__c == 'Partner' && string.isBlank(bookingProc.Vendor_Code__c)){
            //i=1;
            //errorMsg = 'Can not process request. This Booking is Cancelled.';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Either Broker Code is Blank or Broker is not tagged to Opportunity.'));
        }else if(bookingProc.status__c == 'Cancelled'){
            //i=1;
            //errorMsg = 'Can not process request. This Booking is Cancelled.';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Can not process request. This Booking is Cancelled.'));
        }
        else if(bookingProc.Flown_to_SAP__c){
            system.debug('inside flown condition');
            //i=1;
            //errorMsg = 'Customer has been Already flown to SAP.';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'Customer has been Already flown to SAP.'));
        }else{
            system.debug('inside condition');
            TRY{
                if(bookingProc.Booking_Through__c == 'Partner'){
                    if(CPProjetList.size() > 0){
                        If(CPProjetList[0].Extended__c){
                            if(string.isBlank(soCode) && string.isNotBlank(customerCode)){
                                Rest_SAP_Sales_Order_Creation ssoc = new Rest_SAP_Sales_Order_Creation();
                                ssoc.createSalesOrder(bookingProc.id,customerCode);
                            }else if(!bookingProc.Billing_Plan_flown_to_SAP__c && string.isNotBlank(soCode)){
                                Rest_Customer_Specific_BillingPlan CSP = new Rest_Customer_Specific_BillingPlan();
                                CSP.FLowBillinDetails(quoteID,soCode);
                            }                             
                        }Else{
                            List<Account> a = [Select Id, Name,Broker_Code__c From Account Where Id =: bookingProc.Opportunity__r.Broker_Account__c];
                            REST_SAP_CP_Extend.ExtendCP(a[0],bookingProc.id);
                        }
                    }                        
                    if([select id,name,Flown_to_SAP__c from booking__c where id =: bookingProc.id].Flown_to_SAP__c){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,'Customer has been flown to SAP Sucessfully.'));
                    }
                }Else{
                    if(string.isBlank(soCode) && string.isNotBlank(customerCode)){
                        Rest_SAP_Sales_Order_Creation ssoc = new Rest_SAP_Sales_Order_Creation();
                        ssoc.createSalesOrder(bookingProc.id,customerCode);
                    }else if(!bookingProc.Billing_Plan_flown_to_SAP__c && string.isNotBlank(soCode)){
                        Rest_Customer_Specific_BillingPlan CSP = new Rest_Customer_Specific_BillingPlan();
                        CSP.FLowBillinDetails(quoteID,soCode);
                    }
                    if([select id,name,Flown_to_SAP__c from booking__c where id =: bookingProc.id].Flown_to_SAP__c){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,'Customer has been flown to SAP Sucessfully.'));
                    }
                }
            }CATCH(Exception e){
                //i=1;
                //errorMsg += e.getMessage() + '\n'; 
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, ' ' + e.getMessage()));
                System.debug('Your exception message here....'+e.getMessage());
            }     
        }
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