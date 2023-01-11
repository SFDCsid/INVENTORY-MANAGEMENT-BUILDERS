public class GetCustomerLedger{
    public string OppId{get;set;}
    public list<Opportunity> lstoppty;
    public Opportunity oppProc;
    public String Blobmessage {get;set;}
    public String customerCode {get;set;}
    public string errorMsg{get;set;}
    public List <Channel_Partner_Project__c > CPProjetList {get;set;}
    public transient String ResponceBody {get;set;}
    public transient string BlobBody{get;set;}
    public GetCustomerLedger()
    {
        OppId = ApexPages.currentPage().getParameters().get('id');
        if(OppId != null)
        {
            //////////////////Ankur : Commenting out this line and added the next one to fetch an extra field on 18.11.2015 19:36 hrs//////////////////////////////////
            lstoppty = [Select id, Leasing_Project__c,name,Broker_Account__c,Account_Group1__c,Customer_Number__c,Company_Code1__c,Business_Entity_Number1__c,Title_Mr_Company__c,Cust_Name_1__c,Cust_Name_2__c,Cust_Name_3__c,Cust_Name_4__c,Cust_Name_5__c,Number_of_Rental_Object1__c,
                        Brand__c,Str_Suppl1__c,Str_Suppl2__c,Str_Suppl3__c,House_No__c,Building_Soc_House__c,Location_2__c,City__c,PAN_Number__c,PAN_Reference__c,GST__c,Reconciliation_Account__c,
                        Message_Type__c,Message__c,Mobile_Number_1__c,Email_Address_1__c,Mobile_Number_2__c,Email_Address_2__c,Mobile_Number_3__c,Email_Address_3__c,Mobile_Number_4__c,Email_Address_4__c,Mobile_Number_5__c,
                        Email_Address_5__c, Source_of_Walk_in_Booking__c from Opportunity where Id =: OppId];
        }
        
        if(lstoppty != null && lstoppty.size() > 0)
        {
            oppProc = lstoppty[0];
            if(string.isNotBlank(lstoppty[0].Customer_Number__c))
                customerCode = lstoppty[0].Customer_Number__c;
                
            System.debug('oppProc.Customer_Number__c =====  '+ oppProc.Customer_Number__c);
        } 
    }
    Public void GetDocument(){
         
        if(oppProc.Customer_Number__c == null){
            system.debug('inside Customer condition');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'Customer has not flown to SAP yet.'));
        }else{
        
            List<SAP_Credentials_Master__c> listSAPCreds = [Select Id,Name, Password__c, URL__c, User_ID__c
                                                            from SAP_Credentials_Master__c 
                                                            where Name =: 'Get Customer Leger'];
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
            req.setTimeout(120000);
            HTTPResponse res = new HTTPResponse();
            if(!test.isRunningTest()){ 
                Http http = new Http();
                res = http.send(req);
                System.debug(res.getBody());
                ResponceBody = res.getBody();
                
                GetCustomerLegerJ2A obj = GetCustomerLegerJ2A.parse(ResponceBody);
                BlobBody = obj.EP_XSTRING;
                errorMsg = obj.ERROR_MESSAGE;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,errorMsg));

            }else{
                BlobBody = '1234hjkll';
            }
            
        }
    }
    
    public PageReference BackToBooking(){
        pageReference P = new pageReference('/'+ OppId);
        return P;
    }
    public PageReference SaveToBooking(){
        
        DateTime d = system.NOW();
        
        blob b = EncodingUtil.base64Decode(BlobBody);
        
        ContentVersion cont = new ContentVersion();
        cont.Title = 'Customer_Leger_'+customerCode+'_'+d;
        cont.VersionData = b;
        cont.PathOnClient =  'Customer_Leger_'+customerCode+'_'+d+'.pdf';
        cont.ContentLocation = 'S';
        cont.Description =  'Customer_Leger_'+customerCode+'_'+d;
        cont.TagCSV =  'Customer_Leger_'+customerCode+'_'+d;
        insert cont;
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cont.id].ContentDocumentId;
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = oppProc.id; // you can use objectId,GroupId etc
        cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        insert cDe;
        
        pageReference P = new pageReference('/'+ OppId);
        System.debug('Page::'+P);
        return P;
    }
    
}