public class GetBrokerageIntimationNote{
    public string MDAppId{get;set;}
    public string BookingId{get;set;}
    public list<MD_Approval__c> lstMDAppro;
    public Booking__c bookingProc;
    public String Blobmessage {get;set;}
    public String customerCode {get;set;}
    public string errorMsg{get;set;}
    public List <Channel_Partner_Project__c > CPProjetList {get;set;}
    public String ResponceBody {get;set;}
    public string BlobBody{get;set;}
    public GetBrokerageIntimationNote()
    {
        lstMDAppro = new list<MD_Approval__c>();
        MDAppId = ApexPages.currentPage().getParameters().get('id');   
        if(MDAppId != null)
        {
            //////////////////Ankur : Commenting out this line and added the next one to fetch an extra field on 18.11.2015 19:36 hrs//////////////////////////////////
            /*lstBooking = [select id,name,Booking_Date__c, status__c,Property__c,Billing_Plan_flown_to_SAP__c,Sales_Document_SAP__c,Property__r.name,Property__r.Status__c,Project__c,Project__r.name,Property__r.Tower__r.Id, Opportunity__c,Opportunity__r.name,PAN_Number__c, Quotation__c, Quotation__r.Quote_Status__c,
Doc_Verification_Status__c,Central_Support__c,Site_Support__c,Customer_Code__c,Flown_to_SAP__c,Pricing_Flown_to_SAP__c,
Booking_Through__c, Vendor_Code__c,Property__r.Site_Support__c,Property__r.Central_Support__c,Opportunity__r.Broker_Account__c
from Booking__c where id=: BookingId]; */
            lstMDAppro = [select id,name,Allotment_Date__c,Principal_Brokerage_Amount__c,Is_Brokerage_Intimation_Note_Save__c,Agreement_Date__c,Booking__r.Customer_Code__c from MD_Approval__c where id=: MDAppId and Booking__c != null];
        }
        
        if(lstMDAppro != null && lstMDAppro.size() > 0)
        {
            if(string.isNotBlank(lstMDAppro[0].Booking__r.Customer_Code__c)){
                customerCode = lstMDAppro[0].Booking__r.Customer_Code__c;
            }
            
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'Booking record blank on this MD Approval.'));
        }
        system.debug('BlobBody:::::'+BlobBody);
    }
    Public void GetDocument(){
        
        if(customerCode == Null){
            system.debug('inside flown condition');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'Customer Code blank.'));
        }else{
            system.debug('lstMDAppro:::::'+lstMDAppro);
            if(lstMDAppro.size()>0){
                /*if(lstMDAppro[0].Allotment_Date__c == Null && lstMDAppro[0].Agreement_Date__c == Null){
ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'Agreement & Allotment Date are mandatory.'));
}else{*/
                List<SAP_Credentials_Master__c> listSAPCreds = [Select Id,Name, Password__c, URL__c, User_ID__c
                                                                from SAP_Credentials_Master__c 
                                                                where Name =: 'Brokerage Intimation Note'];
                string Endpoint = listSAPCreds[0].URL__c+'&KUNNR='+customerCode;
                string userid = listSAPCreds[0].User_Id__c;
                string password = listSAPCreds[0].Password__c;
                
                HttpRequest req = new HttpRequest();
                req.setEndpoint(Endpoint);
                //req.setHeader('Content-Type','application/json');
                //system.debug('user id::'+userid+' Password:: '+password );
                String authorizationHeader = 'Basic ' +Encodingutil.base64Encode(Blob.valueOf(userid+':'+password));
                req.setHeader('Authorization', authorizationHeader);
                system.debug('Authorization Value::: '+authorizationHeader);
                req.setMethod('GET');
                HTTPResponse res = new HTTPResponse();
                if(!test.isRunningTest()){ 
                    Http http = new Http();
                    res = http.send(req);
                    System.debug(res.getBody());
                    ResponceBody = res.getBody();
                    System.debug('ResponceBody'+ResponceBody);
                    
                }else{
                    BlobBody = '1ASfghjkhgvbn';
                    ResponceBody = '{\"EP_XSTRING\":\"JVBERi0xLjMNCiXi48/TDQolUlNUWFBERjMgUGFyYW1ldGVyczogRFJTVFhoDQoyIDAgb2JqDQo8PA0KL0ZpbHRlciAzIDAgUg0KL0VnN0YXJ0eHJlZg0KNDg2NTcNCiUlRU9GDQo=\",\"EP_BROKERAGE1\":\"12,94,230.00\",\"EP_SERV_TAX\":\"0.00\",\"AMOUNT_RECIEVED_INCL_TAXES\":\"2,16,95,473.00\",\"AMOUNT_DUE_INCL_TAXES\":\"2,16,95,473.00\",\"ERROR_MESSAGE\":\"\"}';
                }
                system.debug('BlobBody:::::'+BlobBody);
                //}
                if(ResponceBody !='' && ResponceBody !=Null){
                    GetBrokerageStatementJ2A obj = GetBrokerageStatementJ2A.parse(ResponceBody);
                    BlobBody = obj.EP_XSTRING;
                    errorMsg = obj.ERROR_MESSAGE;
                    String target = ',';
                    String replacement = '';
                    String s2 = obj.EP_BROKERAGE1.replace(target, replacement).trim();
                    String s3 = obj.EP_SERV_TAX.replace(target, replacement).trim();
                    String s4 = obj.amount_due_incl_taxes.replace(target, replacement).trim();
                    String s5 = obj.amount_recieved_incl_taxes.replace(target, replacement).trim();
                 
                    System.debug('obj.Prin_Brokerage_Amount:::::'+Decimal.valueof(s2));
                    System.debug('obj.GST_Amount:::::'+Decimal.valueof(s3));
                    
                    
                    lstMDAppro[0].Principal_Brokerage_Amount__c = Decimal.valueof(s2);
                    lstMDAppro[0].GST_Amount__c = Decimal.valueof(s3);
                    lstMDAppro[0].amount_due_incl_taxes__c = Decimal.valueof(s4);
                    lstMDAppro[0].amount_recieved_incl_taxes__c = Decimal.valueof(s5);
                    
                    update lstMDAppro;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,errorMsg));
                    if(obj.ERROR_MESSAGE == 'SUCCESS'){
                        SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                        SILD.API_Name__c = 'Brokerage release process';
                        SILD.MD_Approval__c = lstMDAppro[0].id;
                        SILD.Status__c = 'Success';
                        SILD.Request__c = Endpoint;
                        SILD.Response__c = ResponceBody;
                        Insert SILD;
                    }else{
                        SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                        SILD.API_Name__c = 'Brokerage release process';
                        SILD.MD_Approval__c = lstMDAppro[0].id;
                        SILD.Status__c = 'Failed';
                        SILD.Request__c = Endpoint;
                        SILD.Response__c = ResponceBody;
                        SILD.Error_Message__c = obj.ERROR_MESSAGE;
                        Insert SILD;
                    }
                }
            }
        }
    }
    
    public PageReference BackToBooking(){
        pageReference P = new pageReference('/'+ MDAppId);
        return P;
    }
    public PageReference SaveToBooking(){
        
        DateTime d = system.NOW();
        
        system.debug('BlobBody:::::'+BlobBody);
        blob b = EncodingUtil.base64Decode(BlobBody);
        
        ContentVersion cont = new ContentVersion();
        cont.Title = 'Brokerage_Intimation_Note_'+customerCode+'_'+d;
        cont.VersionData = b;
        cont.PathOnClient =  'Brokerage_Intimation_Note_'+customerCode+'_'+d+'.pdf';
        cont.ContentLocation = 'S';
        cont.Description =  'Brokerage_Intimation_Note_'+customerCode+'_'+d;
        cont.TagCSV =  'Brokerage_Intimation_Note_'+customerCode+'_'+d;
        insert cont;
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cont.id].ContentDocumentId;
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = MDAppId; // you can use objectId,GroupId etc
        cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        insert cDe;
        
        lstMDAppro[0].Is_Brokerage_Intimation_Note_Save__c = true;
        update lstMDAppro;
        pageReference P = new pageReference('/'+ MDAppId);
        return P;
    }
    
}