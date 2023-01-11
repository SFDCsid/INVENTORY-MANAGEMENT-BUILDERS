Public Class REST_SAP_CP_Extend{

    /*Public string SAP_INT_ID {get;set;} //SAP internal ID
    Public string LIFNR      {get;set;} //Vendor Code
    Public string SFDC_ID    {get;set;} //SFDC ID 
    Public string PROJECT_ID {get;set;} //Project Code 
    Public string TOWER      {get;set;} //Tower
    Public string BUKRS      {get;set;} //Company Code 
    Public string EKORG      {get;set;} //Purchasing Organization 
    Public string AKONT      {get;set;} //Reconciliation Account in General Ledger
    Public string ZUAWA      {get;set;} //Key for sorting according to assignment numbers 
    Public string ZTERM      {get;set;} //Terms of Payment Key
    Public string REPRF      {get;set;} //Check Flag for Double Invoices or Credit Memos 
    Public string ZWELS      {get;set;} //List of the Payment Methods to be Considered
    Public string XAUSZ      {get;set;} //Indicator for periodic account statements 
    Public string WAERS      {get;set;} //Currency Key
    Public string WITHT1     {get;set;} //Indicator for withholding tax type
    Public string WT_WITHCD1 {get;set;} //Withholding tax identification number
    Public string WT_SUBJCT1 {get;set;} //Indicator: Subject to withholding tax?
    Public string QSREC1     {get;set;} //Type of recipient
    Public string WITHT2     {get;set;} //Indicator for withholding tax type 
    Public string WT_WITHCD2 {get;set;} //Withholding tax identification number 
    Public string WT_SUBJCT2 {get;set;} //Indicator: Subject to withholding tax? 
    Public string QSREC2     {get;set;} //Type of recipient 
    public List<Channel_Partner_Project__c> CPProjetList{get;set;}*/
    
    public static void ExtendCP(Account a,String bId){
        string SAP_INT_ID = '';
        string LIFNR      = '';
        string SFDC_ID    = '';
        string PROJECT_ID = ''; //NA
        string TOWER      = ''; //NA
        string BUKRS      = ''; //NA
        string EKORG      = ''; //NA
        string AKONT      = '16148598'; //MANDTORY
        string ZUAWA      = ''; //NA
        string ZTERM      = '0001'; 
        string REPRF      = 'X'; //NA default value X
        string ZWELS      = ''; //NA
        string XAUSZ      = '2'; //NA default value 2
        string WAERS      = ''; //NA
        string WITHT1     = ''; //NA
        string WT_WITHCD1 = ''; //NA
        string WT_SUBJCT1 = ''; //NA
        string QSREC1     = ''; //NA
        string WITHT2     = ''; //NA 
        string WT_WITHCD2 = ''; //NA 
        string WT_SUBJCT2 = ''; //NA
        string QSREC2     = ''; //NA
        string soCode = ''; //NA
        string customerCode = ''; //NA
        string quoteID = '';
         List<Channel_Partner_Project__c> CPProjetList = New List<Channel_Partner_Project__c> ();
       /* List<Account> aList = new List<Account>();
        DescribeSObjectResult describeResult = Account.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + sfdcId + '\''; 
        aList = Database.query( query ); */
        List<SAP_State_Country__c> Locationcode = new List<SAP_State_Country__c>();
        List<Quotation__c> QuoteDetails =new List<Quotation__c> ();
        List<Booking__c> bkList = [Select Id, Name,Opportunity__c,Booking_Through__c,Opportunity__r.Brokerage_Percentage__c,Opportunity__r.AccountId,Project__c,Project__r.Plant__c,Tower__r.Customer_A_C_Group__c,
                                   Booking_Date__c,Project__r.Sales_Organization__c,Opportunity__r.Broker_Account__c,Vendor_Code__c,Property__r.House_Unit_No__c,Property__r.Material_No__c,Project__r.Company_name__c,Project__r.GST_No__c,Tower_Name__c,
                                   Billing_Plan_flown_to_SAP__c ,Quotation__c,Quotation__r.Billing_Plan__r.Payment_Plan_Type__c,Project__r.Broker_Percentage__c,
                                   Quotation__r.Car_Park_Type_1__c, Quotation__r.Car_Park_Count_1__c, Quotation__r.Car_Park_Type_2__c, Quotation__r.Car_Park_Count_2__c,
                                   Quotation__r.Car_Park_Type_3__c, Quotation__r.Car_Park_Count_3__c,Quotation__r.Car_Park_Type_4__c, Quotation__r.Car_Park_Count_4__c,
                                   Quotation__r.Car_Park_Type_5__c, Quotation__r.Car_Park_Count_5__c,Quotation__r.TotalAdditionalCarpark__c,Property__r.Carpet_Area__c,
                                   Property__r.Property_Type__r.Material_No__c, Tower__r.Name,Agreement_Value__c,Customer_Code__c,Sales_Document_SAP__c
                                   from Booking__c 
                                   where Id =: bId];
        if(bkList.size() > 0){
            QuoteDetails = [SELECT id,Name,Booking__c,Effective_Sale_Price__c,Token_Amount__c, ST_Token_Amount__c,Car_Park_Type_1__c,Car_Park_Type_2__c,Car_Park_Type_3__c,Car_Park_Type_4__c,Car_Park_Type_5__c, 
                            Earmarked_Car_Parking_Count_1__c,Earmarked_Car_Parking_Count_2__c,Earmarked_Car_Parking_Count_3__c,Earmarked_Car_Parking_Count_4__c,Earmarked_Car_Parking_Count_5__c,
                            Earmarked_Car_Parking_Type_1__c,Earmarked_Car_Parking_Type_2__c,Earmarked_Car_Parking_Type_3__c,Earmarked_Car_Parking_Type_4__c,Earmarked_Car_Parking_Type_5__c,
                            TotalAdditionalCarpark__c,Car_Park_Count_1__c,Total_CSGT_Modified__c,Total_SGST_Modified__c,Car_Park_Count_2__c,Total_Agreement_Value_Modified__c,Car_Park_Count_3__c,Car_Park_Count_4__c,Car_Park_Count_5__c
                            
                            FROM Quotation__c WHERE Id = : bkList[0].Quotation__c];
                        }
        soCode = bkList[0].Sales_Document_SAP__c; //NA
        customerCode = bkList[0].Customer_Code__c; //NA
        quoteID = QuoteDetails[0].id;
        //Account a = new Account();
        string msg = '';
        if(a != null){
           // a = aList[0];
            if(string.isNotBlank(a.Broker_Code__c)){
                LIFNR = a.Broker_Code__c;
            }
            SFDC_ID = a.Id;
            WAERS = 'INR';
    /***************** Add Project details****************/
           CPProjetList =[Select Id, Name,Account__c,Extended__c,Plant_ID__c,Company_Name__c,Sales_Organization__c FROM Channel_Partner_Project__c WHERE Project__c =:bkList[0].Project__c AND Account__c =: a.id AND Extended__c = False order by CreatedDate desc limit 1];
            If(CPProjetList.size()>0){
                if(string.isNotBlank(CPProjetList[0].Plant_ID__c)){
                    PROJECT_ID = CPProjetList[0].Plant_ID__c;
                }
                if(string.isNotBlank(CPProjetList[0].Company_Name__c)){
                    BUKRS = CPProjetList[0].Company_Name__c;
                }
                if(string.isNotBlank(CPProjetList[0].Sales_Organization__c)){
                    EKORG = CPProjetList[0].Sales_Organization__c;
                }
           }
           
        
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('SAP_INT_ID', SAP_INT_ID);
            gen.writeStringField('LIFNR', LIFNR);
            gen.writeStringField('SFDC_ID', SFDC_ID);
            gen.writeStringField('PROJECT_ID', PROJECT_ID);
            gen.writeStringField('TOWER', TOWER);
            gen.writeStringField('BUKRS', BUKRS);
            gen.writeStringField('EKORG', EKORG);
            gen.writeStringField('AKONT', AKONT);
            gen.writeStringField('ZUAWA', ZUAWA);
            gen.writeStringField('ZTERM', ZTERM);
            gen.writeStringField('REPRF', REPRF);
            gen.writeStringField('ZWELS', ZWELS);
            gen.writeStringField('XAUSZ', XAUSZ);
            gen.writeStringField('WAERS', WAERS);
            gen.writeStringField('WITHT1', WITHT1);
            gen.writeStringField('WT_WITHCD1', WT_WITHCD1);
            gen.writeStringField('WT_SUBJCT1', WT_SUBJCT1);
            gen.writeStringField('QSREC1', QSREC1);
            gen.writeEndObject();
            
            String JBody;
            //if(!sampleRun){
                JBody = gen.getAsString();
            //}else{
                /*jBody = '{ "SAP_INT_ID":"", "LIFNR":"", "SFDC_ID":"", "PROJECT_ID":"", "TOWER":"", "BUKRS":"1000", "EKORG":"1031", ' + 
                    '"KTOKK":"3310", "TITLE":"MR", "NAME1":"TEST NAME11", "NAME2":"TEST NAME22", "NAME3":"TEST NAME33", ' + 
                    '"NAME4":"TEST NAME44", "SORT1":"SEARCH TERM 11", "STR_SUPPL1":"TEST STR_SUPPL11", "STR_SUPPL2":"TEST STR_SUPPL22",' + 
                    '"STR_SUPPL3":"TEST STR_SUPPL33", "STREET":"TEST STREET1", "LOCATION":"TEST LOCATION1", "POST_CODE1":"401107",' + 
                    '"CITY1":"TEST CITY1", "CITY2":"TEST DISTRICT1", "COUNTRY":"IN", "REGION":"13", "TIME_ZONE":"INDIA", "PO_BOX":"401107",' +
                    '"POST_CODE2":"401107", "STCD3":"NOT APPLICABLE", "STENR":"A51800002565", "AKONT":"16148598", "ZUAWA":"000",' +
                    '"ZTERM":"0001", "REPRF":"X", "ZWELS":"C", "XAUSZ":"2", "WAERS":"INR", "WITHT1":"P7", "WT_WITHCD1":"P7",' + 
                    '"WT_SUBJCT1":"X", "QSREC1":"OT", "WITHT2":"I7", "WT_WITHCD2":"I7", "WT_SUBJCT2":"X", "QSREC2":"OT",' + 
                    '"MOBILE1":"1234567899", "MOBILE2":"9870987608", "MOBILE3":"8756565627", "MOBILE4":"3434566786", "MOBILE5":"9774344565",'+ 
                    '"EMAIL1":"ABC1@ABC.COM", "EMAIL2":"LMN2@ABC.COM", "EMAIL3":"XYZ3@ABC.COM", "EMAIL4":"PQR4@ABC.COM", "EMAIL5":"QSD5@ABC.COM",' +
                    '"PAN1":"", "PAN2":"", "PAN3":"", "PAN4":"", "PAN5":"", "GST_NUMBER":""} ';
            }*/
            system.debug('Body::'+JBody);
            
            List<SAP_Credentials_Master__c> listSAPCreds = new List<SAP_Credentials_Master__c>();
            
                listSAPCreds = [Select Id,Name, Password__c, URL__c, User_ID__c
                                from SAP_Credentials_Master__c 
                                where Name =: 'CP Extend'];
            
            string Endpoint = listSAPCreds[0].URL__c;
            string userid = listSAPCreds[0].User_Id__c;
            string password = listSAPCreds[0].Password__c;
            
            
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(Endpoint);
            req.setHeader('Content-Type','application/json');
            system.debug('user id::'+userid+' Password:: '+password );
            String authorizationHeader = 'Basic ' +Encodingutil.base64Encode(Blob.valueOf(userid+':'+password));
            req.setHeader('Authorization', authorizationHeader);
            system.debug('Authorization Value:::'+authorizationHeader);
            req.setMethod('POST');
            //req.setBody(request);
            req.setBody(JBody);
                                    
            HTTPResponse res = new HTTPResponse();
            String ResponceBody = '';
            if(!test.isRunningTest()){ 
                Http http = new Http();
                res = http.send(req);
                System.debug(res.getBody());
                ResponceBody = res.getBody();
            }
            Else{
            ResponceBody = '{"TYPE":"S","ID":"F2","NUMBER":175,"MESSAGE":"Vendor 0033101441 has been created for company code 1100 purchasing organization 1131","LOG_NO":"","LOG_MSG_NO":0,"MESSAGE_V1":"0033101441","MESSAGE_V2":"1100","MESSAGE_V3":"1131","MESSAGE_V4":""}';
            }
            
            if(ResponceBody !='' && ResponceBody !=Null){
                JSON2ApexCostomerCreate r = JSON2ApexCostomerCreate.parse(ResponceBody);
                System.debug('Respone field "Type" ::'+r.TYPE_Z);
                System.debug('Respone field "ID" ::'+r.ID);
                System.debug('Respone field "NUMBER_Z" ::'+r.NUMBER_Z);
                System.debug('Respone field "MESSAGE" ::'+r.MESSAGE);
                System.debug('Respone field "LOG_NO" ::'+r.LOG_NO);
                System.debug('Respone field "LOG_MSG_NO" ::'+r.LOG_MSG_NO);
                System.debug('Respone field "MESSAGE_V1" ::'+r.MESSAGE_V1);
                System.debug('Respone field "MESSAGE_V2" ::'+r.MESSAGE_V2);
                System.debug('Respone field "MESSAGE_V3" ::'+r.MESSAGE_V3);
                System.debug('Respone field "MESSAGE_V4" ::'+r.MESSAGE_V4 );
                msg = r.MESSAGE;
                If(r.TYPE_Z =='S'){
                    
                    TRY{
                        if(string.isBlank(soCode) && string.isNotBlank(customerCode)){
                            Rest_SAP_Sales_Order_Creation ssoc = new Rest_SAP_Sales_Order_Creation();
                            ssoc.createSalesOrder(bkList[0].id,customerCode);
                        }else if(!bkList[0].Billing_Plan_flown_to_SAP__c && string.isNotBlank(soCode)){
                            Rest_Customer_Specific_BillingPlan CSP = new Rest_Customer_Specific_BillingPlan();
                            CSP.FLowBillinDetails(quoteID,soCode);
                        }    
                         
                         CPProjetList[0].Extended__c = True;
                         Update CPProjetList[0];
                                                 
                         SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                            SILD.API_Name__c = 'CP Update';
                            SILD.Account__C = a.id;
                            SILD.Status__c = 'Success';
                            SILD.Request__c = jBody;
                            SILD.Response__c = ResponceBody;
                            Insert SILD;
                      }CATCH(Exception e){
                        SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                            SILD.API_Name__c = 'CP Extend';
                            SILD.Account__C = a.id;
                            SILD.Status__c = 'Failed';
                            SILD.Request__c = jBody;
                            SILD.Response__c = ResponceBody;
                            SILD.Error_Message__c = e.getMessage();
                            Insert SILD;
                        }
                    
                }else{
                    SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                        SILD.API_Name__c = 'CP Update';
                        SILD.Account__C = a.id;
                        SILD.Status__c = 'Failed';
                        SILD.Request__c = jBody;
                        SILD.Response__c = ResponceBody;
                        SILD.Error_Message__c = r.MESSAGE;
                        Insert SILD; 
                      
                }
            }
            
        }
       
    }
    

}