public class GetInterestLetter{
    public string BookingId{get;set;}
    public list<Booking__c> lstbooking;
    public Booking__c bookingProc;
    public String Blobmessage {get;set;}
    public String customerCode {get;set;}
    public string errorMsg{get;set;}
    public List <Channel_Partner_Project__c > CPProjetList {get;set;}
    public transient String ResponceBody {get;set;}
    public transient string BlobBody{get;set;}
    public GetInterestLetter()
    {
        list<Booking__c> lstBooking = new list<Booking__c>();
        BookingId = ApexPages.currentPage().getParameters().get('id');   
        if(BookingId != null)
        {
            //////////////////Ankur : Commenting out this line and added the next one to fetch an extra field on 18.11.2015 19:36 hrs//////////////////////////////////
            lstBooking = [select id,name,Booking_Date__c, status__c,Property__c,Billing_Plan_flown_to_SAP__c,Sales_Document_SAP__c,Property__r.name,Property__r.Status__c,Project__c,Project__r.name,Property__r.Tower__r.Id, Opportunity__c,Opportunity__r.name,PAN_Number__c, Quotation__c, Quotation__r.Quote_Status__c,
                          Doc_Verification_Status__c,Central_Support__c,Is_ROFR_Booking__c,Site_Support__c,Customer_Code__c,Flown_to_SAP__c,Pricing_Flown_to_SAP__c,
                          Booking_Through__c, Vendor_Code__c,Property__r.Site_Support__c,Property__r.Central_Support__c,Opportunity__r.Broker_Account__c
                          from Booking__c where id=: BookingId]; 
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
            if(string.isNotBlank(lstBooking[0].Customer_Code__c))
                customerCode = lstBooking[0].Customer_Code__c;
                
            System.debug('bookingProc.Flown_to_SAP__c =====  '+ bookingProc.Flown_to_SAP__c);
            System.debug('bookingProc.Customer_Code__c =====  '+ bookingProc.Customer_Code__c);
            System.debug('bookingProc.Pricing_Flown_to_SAP__c =====  '+ bookingProc.Pricing_Flown_to_SAP__c);
            System.debug('bookingProc.Sales_Document_SAP__c =====  '+ bookingProc.Sales_Document_SAP__c);
            System.debug('bookingProc.Billing_Plan_flown_to_SAP__c =====  '+ bookingProc.Billing_Plan_flown_to_SAP__c);
        } 
    }
    Public void GetDocument(){
         
        //if(!bookingProc.Flown_to_SAP__c){// this condition added for ROFR booking
        if((!bookingProc.Flown_to_SAP__c) && (bookingProc.Is_ROFR_Booking__c && String.ISBLANK(bookingProc.Sales_Document_SAP__c))){
        
            system.debug('inside flown condition');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'Customer has not flown to SAP yet.'));
        }else{
        
            List<SAP_Credentials_Master__c> listSAPCreds = [Select Id,Name, Password__c, URL__c, User_ID__c
                                                            from SAP_Credentials_Master__c 
                                                            where Name =: 'Get Interest Letter'];
            string Endpoint = listSAPCreds[0].URL__c+'&KUNNR='+customerCode;
            string userid = listSAPCreds[0].User_Id__c;
            string password = listSAPCreds[0].Password__c;
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(Endpoint);
            //req.setHeader('Content-Type','application/json');
            system.debug('user id::'+userid+' Password:: '+password );
            String authorizationHeader = 'Basic ' +Encodingutil.base64Encode(Blob.valueOf(userid+':'+password));
            req.setHeader('Authorization', authorizationHeader);
            system.debug('Authorization Value:::'+authorizationHeader);
            req.setMethod('GET');
            HTTPResponse res = new HTTPResponse();
            if(!test.isRunningTest()){ 
                Http http = new Http();
                res = http.send(req);
                System.debug(res.getBody());
                ResponceBody = res.getBody();
                
                GetAccountStatementJ2A obj = GetAccountStatementJ2A.parse(ResponceBody);
                BlobBody = obj.EP_XSTRING;
                errorMsg = obj.ERROR_MESSAGE;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,errorMsg));

            }else{
                BlobBody = '123fghjl';
            }
            
        }
    }
    
    public PageReference BackToBooking(){
        pageReference P = new pageReference('/'+ BookingId);
        return P;
    }
    public PageReference SaveToBooking(){
        
        DateTime d = system.NOW();
        
        blob b = EncodingUtil.base64Decode(BlobBody);
        
        ContentVersion cont = new ContentVersion();
        cont.Title = 'Account_Statement_'+customerCode+'_'+d;
        cont.VersionData = b;
        cont.PathOnClient =  'Account_Statement_'+customerCode+'_'+d+'.pdf';
        cont.ContentLocation = 'S';
        cont.Description =  'Account_Statement_'+customerCode+'_'+d;
        cont.TagCSV =  'Account_Statement_'+customerCode+'_'+d;
        insert cont;
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cont.id].ContentDocumentId;
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = bookingProc.id; // you can use objectId,GroupId etc
        cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        insert cDe;
        
        pageReference P = new pageReference('/'+ BookingId);
        return P;
    }
    
}