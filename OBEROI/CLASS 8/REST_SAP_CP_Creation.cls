Public Class REST_SAP_CP_Creation{

    Public string SAP_INT_ID {get;set;} //SAP internal ID
    Public string LIFNR      {get;set;} //Vendor Code
    Public string SFDC_ID    {get;set;} //SFDC ID 
    Public string PROJECT_ID {get;set;} //Project Code 
    Public string TOWER      {get;set;} //Tower
    Public string BUKRS      {get;set;} //Company Code 
    Public string EKORG      {get;set;} //Purchasing Organization 
    Public string KTOKK      {get;set;} //Vendor account group
    Public string TITLE      {get;set;} //Title
    Public string NAME1      {get;set;} //Applicant 1 
    Public string NAME2      {get;set;} //Applicant 2 
    Public string NAME3      {get;set;} //Applicant 3 
    Public string NAME4      {get;set;} //Applicant 4 
    Public string SORT1      {get;set;} //Search Term
    Public string STR_SUPPL1 {get;set;} //Street 1
    Public string STR_SUPPL2 {get;set;} //Street 2
    Public string STR_SUPPL3 {get;set;} //Street 3
    Public string STREET     {get;set;} //Street
    Public string LOCATION   {get;set;} //Location
    Public string POST_CODE1 {get;set;} //City postal code 
    Public string CITY1      {get;set;} //City
    Public string CITY2      {get;set;} //District
    Public string COUNTRY    {get;set;} //Country Key (IN - India) 
    Public string REGION     {get;set;} //Region (13 - State-Maharashtra) 
    Public string TIME_ZONE  {get;set;} //Time Zone(INDIA) 
    Public string PO_BOX     {get;set;} //City postal code
    Public string POST_CODE2 {get;set;} //City postal code 
    Public string STCD3      {get;set;} //Tax Number 3 
    Public string STENR      {get;set;} //Tax Number at Responsible Tax Authority
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
    Public string MOBILE1    {get;set;}
    Public string MOBILE2    {get;set;}
    Public string MOBILE3    {get;set;}
    Public string MOBILE4    {get;set;}
    Public string MOBILE5    {get;set;}
    Public string EMAIL1     {get;set;}
    Public string EMAIL2     {get;set;}
    Public string EMAIL3     {get;set;}
    Public string EMAIL4     {get;set;}
    Public string EMAIL5     {get;set;}
    Public string PAN1       {get;set;}
    Public string PAN2       {get;set;}
    Public string PAN3       {get;set;}
    Public string PAN4       {get;set;}
    Public string PAN5       {get;set;}
    Public string GST_NUMBER {get;set;}
    public List<Channel_Partner_Project__c> CPProjetList{get;set;}
    
    public string createCP(Account a, boolean sampleRun, string action){
        SAP_INT_ID = '';
        LIFNR      = '';
        SFDC_ID    = '';
        PROJECT_ID = ''; //NA
        TOWER      = ''; //NA
        BUKRS      = ''; //NA
        EKORG      = ''; //NA
        KTOKK      = '3310'; 
        TITLE      = '';
        NAME1      = '';
        NAME2      = '';
        NAME3      = '';
        NAME4      = '';
        SORT1      = '';
        STR_SUPPL1 = '';
        STR_SUPPL2 = '';
        STR_SUPPL3 = '';
        STREET     = '';
        LOCATION   = ''; //NA
        POST_CODE1 = '';
        CITY1      = '';
        CITY2      = ''; //NA
        COUNTRY    = '';
        REGION     = '';
        TIME_ZONE  = ''; 
        PO_BOX     = '';
        POST_CODE2 = '';
        STCD3      = '';
        STENR      = '';
        AKONT      = '16148598'; //MANDTORY
        ZUAWA      = ''; //NA
        ZTERM      = '0001'; 
        REPRF      = 'X'; //NA default value X
        ZWELS      = ''; //NA
        XAUSZ      = '2'; //NA default value 2
        WAERS      = ''; //NA
        WITHT1     = ''; //NA
        WT_WITHCD1 = ''; //NA
        WT_SUBJCT1 = ''; //NA
        QSREC1     = ''; //NA
        WITHT2     = ''; //NA 
        WT_WITHCD2 = ''; //NA 
        WT_SUBJCT2 = ''; //NA
        QSREC2     = ''; //NA
        MOBILE1    = '';
        MOBILE2    = '';
        MOBILE3    = '';
        MOBILE4    = '';
        MOBILE5    = '';
        EMAIL1     = '';
        EMAIL2     = '';
        EMAIL3     = '';
        EMAIL4     = '';
        EMAIL5     = '';
        PAN1       = '';
        PAN2       = '';
        PAN3       = '';
        PAN4       = '';
        PAN5       = '';
        GST_NUMBER = '';
        
        
       /* List<Account> aList = new List<Account>();
        DescribeSObjectResult describeResult = Account.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + sfdcId + '\''; 
        aList = Database.query( query ); */
        List<SAP_State_Country__c> Locationcode = new List<SAP_State_Country__c>();
        
        //Account a = new Account();
        string msg = '';
        if(a != null){
           // a = aList[0];
            if(string.isNotBlank(a.Broker_Code__c)){
                LIFNR = a.Broker_Code__c;
            }
            SFDC_ID = a.Id;
            if(string.isNotBlank(a.Title__c)){
                TITLE = a.Title__c;
            }
    /***************** Add Project details****************/
            if(action == 'Create'){
               CPProjetList =[Select Id, Name,Account__c,Extended__c,Plant_ID__c,Company_Name__c,Sales_Organization__c FROM Channel_Partner_Project__c WHERE Account__c =: a.id AND Extended__c = False order by CreatedDate desc limit 1];
            }else if(action == 'Update'){
                CPProjetList =[Select Id, Name,Account__c,Extended__c,Plant_ID__c,Company_Name__c,Sales_Organization__c FROM Channel_Partner_Project__c WHERE Account__c =: a.id order by CreatedDate ASC limit 1];
            }
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
           
    /***************** Add Names  ***********************/        
            if(string.isNotBlank(a.Name)){
                NAME1 = a.Name;
            }
            if(string.isNotBlank(a.Name_2__c)){
                NAME2 = a.Name_2__c;
            }
            if(string.isNotBlank(a.Name_3__c)){
                NAME3 = a.Name_2__c;
            }
            if(string.isNotBlank(a.Name_4__c)){
                NAME4 = a.Name_4__c;
            }
            /*if(string.isNotBlank(a.Name_1__c)){
                NAME5 = a.Mobile_5__c;
            }  */      
    /***************** Add Mobiles  ***********************/        
            if(string.isNotBlank(a.Mobile_1__c)){
                MOBILE1 = a.Mobile_1__c;
            }
            if(string.isNotBlank(a.Mobile_2__c)){
                MOBILE2 = a.Mobile_2__c;
            }
            if(string.isNotBlank(a.Mobile_3__c)){
                MOBILE3 = a.Mobile_3__c;
            }
            if(string.isNotBlank(a.Mobile_4__c)){
                MOBILE4 = a.Mobile_4__c;
            }
            if(string.isNotBlank(a.Mobile_5__c)){
                MOBILE5 = a.Mobile_5__c;
            }
    /************ Add Emails *****************/        
            if(string.isNotBlank(a.Email_1__c)){
                EMAIL1 = a.Email_1__c;
            }
            if(string.isNotBlank(a.Email_2__c)){
                EMAIL2 = a.Email_2__c;
            }
            if(string.isNotBlank(a.Email_3__c)){
                EMAIL3 = a.Email_3__c;
            }
            if(string.isNotBlank(a.Email_4__c)){
                EMAIL4 = a.Email_4__c;
            }
            if(string.isNotBlank(a.Email_5__c)){
                EMAIL5 = a.Email_5__c;
            }
            
    /********** Other Details *********************/
            if(string.isNotBlank(a.Search_Term_1__c)){
                SORT1 = a.Search_Term_1__c;
            }else{
                SORT1 = a.Name;
            }
            
    /******************** STREET and ADDRESS details   ********************/         
            if(string.isNotBlank(a.Street__c)){
                STREET = a.Street__c;
            }
            if(string.isNotBlank(a.Street_2__c)){
                STR_SUPPL1 = a.Street_2__c;
            }
            if(string.isNotBlank(a.Street_3__c)){
                STR_SUPPL2 = a.Street_3__c;
            }
            if(string.isNotBlank(a.Street_4__c)){
                STR_SUPPL3 = a.Street_4__c;
            }
            if(string.isNotBlank(a.Postal_code__c)){
                POST_CODE1 = a.Postal_code__c;
                PO_BOX = a.Postal_code__c;
                POST_CODE2 = a.Postal_code__c;
            }
            if(string.isNotBlank(a.City__c)){
                CITY1 = a.City__c;
            }
            if(string.isNotBlank(a.Region_List__c)){
                Locationcode = [select id, Name, Country_ID__c, State_ID__c, State_Description__c
                                        FROM SAP_State_Country__c WHERE State_Description__c =: a.Region_List__c];
                If(Locationcode.size()>0){
                    COUNTRY = Locationcode[0].Country_ID__c;
                    REGION = Locationcode[0].State_ID__c;
                } 
            }   
            TIME_ZONE = 'INDIA';
            if(string.isNotBlank(a.Tax_Number_3__c)){
                STCD3 = a.Tax_Number_3__c;
            }
            if(string.isNotBlank(a.Tax_Number_1__c)){
                STENR = a.Tax_Number_1__c;
            }
            WAERS = 'INR';
            
       /***********  Add PAN Details    ******************/
            if(string.isNotBlank(a.PAN_1__c)){
                PAN1 = a.PAN_1__c;
            }
            if(string.isNotBlank(a.PAN_2__c)){
                PAN2 = a.PAN_2__c;
            }
            if(string.isNotBlank(a.PAN_3__c)){
                PAN3 = a.PAN_3__c;
            }
            if(string.isNotBlank(a.PAN_4__c)){
                PAN4 = a.PAN_4__c;
            }
            if(string.isNotBlank(a.PAN_5__c)){
                PAN5 = a.PAN_5__c;
            }    
            if(string.isNotBlank(a.GST_Number__c)){
                GST_NUMBER = a.GST_Number__c;
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
            gen.writeStringField('KTOKK', KTOKK);
            gen.writeStringField('TITLE', TITLE);
            gen.writeStringField('NAME1', NAME1);
            gen.writeStringField('NAME2', NAME2);
            gen.writeStringField('NAME3', NAME3);
            gen.writeStringField('NAME4', NAME4);
            gen.writeStringField('SORT1', SORT1);
            gen.writeStringField('STR_SUPPL1', STR_SUPPL1);
            gen.writeStringField('STR_SUPPL2', STR_SUPPL2);
            gen.writeStringField('STR_SUPPL3', STR_SUPPL3);
            gen.writeStringField('STREET', STREET);
            gen.writeStringField('LOCATION', LOCATION);
            gen.writeStringField('POST_CODE1', POST_CODE1);
            gen.writeStringField('CITY1', CITY1);
            gen.writeStringField('CITY2', CITY2);
            gen.writeStringField('COUNTRY', COUNTRY);
            gen.writeStringField('REGION', REGION);
            gen.writeStringField('TIME_ZONE', TIME_ZONE);
            gen.writeStringField('PO_BOX', PO_BOX);
            gen.writeStringField('POST_CODE2', POST_CODE2);
            gen.writeStringField('STCD3', STCD3);
            gen.writeStringField('STENR', STENR);
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
            gen.writeStringField('WITHT2', WITHT2);
            gen.writeStringField('WT_WITHCD2', WT_WITHCD2);
            gen.writeStringField('WT_SUBJCT2', WT_SUBJCT2);
            gen.writeStringField('QSREC2', QSREC2);
            gen.writeStringField('MOBILE1', MOBILE1);
            gen.writeStringField('MOBILE2', MOBILE2);
            gen.writeStringField('MOBILE3', MOBILE3);
            gen.writeStringField('MOBILE4', MOBILE4);
            gen.writeStringField('MOBILE5', MOBILE5);
            gen.writeStringField('EMAIL1', EMAIL1);
            gen.writeStringField('EMAIL2', EMAIL2);
            gen.writeStringField('EMAIL3', EMAIL3);
            gen.writeStringField('EMAIL4', EMAIL4);
            gen.writeStringField('EMAIL5', EMAIL5);
            gen.writeStringField('PAN1', PAN1);
            gen.writeStringField('PAN2', PAN2);
            gen.writeStringField('PAN3', PAN3);
            gen.writeStringField('PAN4', PAN4);
            gen.writeStringField('PAN5', PAN5);
            gen.writeStringField('GST_NUMBER', GST_NUMBER);
            gen.writeEndObject();
            
            String JBody;
            if(!sampleRun){
                JBody = gen.getAsString();
            }else{
                jBody = '{ "SAP_INT_ID":"", "LIFNR":"", "SFDC_ID":"", "PROJECT_ID":"", "TOWER":"", "BUKRS":"1000", "EKORG":"1031", ' + 
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
            }
            system.debug('Body::'+JBody);
            
            List<SAP_Credentials_Master__c> listSAPCreds = new List<SAP_Credentials_Master__c>();
            if(action == 'Create'){
                listSAPCreds = [Select Id,Name, Password__c, URL__c, User_ID__c
                                from SAP_Credentials_Master__c 
                                where Name =: 'CP Creation'];
            }else if(action == 'Update'){
                listSAPCreds = [Select Id,Name, Password__c, URL__c, User_ID__c
                                from SAP_Credentials_Master__c 
                                where Name =: 'CP Update'];
            }                
            
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
                        if(action == 'Create'){
                            Account ac = new Account();
                            ac.id = a.id;
                            ac.Broker_Code__c = r.MESSAGE_V1;
                            ac.Flow_To_SAP__c = true;
                            update ac;
                            
                            CPProjetList[0].Extended__c = True;
                            update CPProjetList[0];
                        
                            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                            SILD.API_Name__c = 'CP Creation';
                            SILD.Account__C = a.id;
                            SILD.Status__c = 'Success';
                            SILD.Request__c = jBody;
                            SILD.Response__c = ResponceBody;
                            
                            Insert SILD;
                        }else if(action == 'Update'){
                            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                            SILD.API_Name__c = 'CP Update';
                            SILD.Account__C = a.id;
                            SILD.Status__c = 'Success';
                            SILD.Request__c = jBody;
                            SILD.Response__c = ResponceBody;
                            Insert SILD;
                        }
                    
                    }CATCH(Exception e){
                        if(action == 'Create'){
                            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                            SILD.API_Name__c = 'CP Creation';
                            SILD.Account__C = a.id;
                            SILD.Status__c = 'Failed';
                            SILD.Request__c = jBody;
                            SILD.Response__c = ResponceBody;
                            SILD.Error_Message__c = e.getMessage();
                            Insert SILD;
                        }else if(action == 'Update'){
                            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                            SILD.API_Name__c = 'CP Update';
                            SILD.Account__C = a.id;
                            SILD.Status__c = 'Failed';
                            SILD.Request__c = jBody;
                            SILD.Response__c = ResponceBody;
                            SILD.Error_Message__c = e.getMessage();
                            Insert SILD;
                        }
                        
                    }
                }else{
                    if(action == 'Create'){
                        SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                        SILD.API_Name__c = 'CP Creation';
                        SILD.Account__C = a.id;
                        SILD.Status__c = 'Failed';
                        SILD.Request__c = jBody;
                        SILD.Response__c = ResponceBody;
                        SILD.Error_Message__c = r.MESSAGE;
                        Insert SILD; 
                    }else if(action == 'Update'){
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
        return msg;
    }
    

}