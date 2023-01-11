public class REST_SAP_CP_Extend_Leasing {
    
    
    public static void ExtendCP(Account a,String oppId){
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
        // string quoteID = '';
        List<Channel_Partner_Project__c> CPProjetList = New List<Channel_Partner_Project__c> ();      
        List<SAP_State_Country__c> Locationcode = new List<SAP_State_Country__c>();        
        List<Opportunity> opList = [Select Id, Name, Customer_Number__c, Leasing_Project__c  
                                    from Opportunity 
                                    where Id =: oppId];
        
        //soCode = opList[0].Sales_Document_SAP__c; //NA
        //customerCode = opList[0].Customer_Number__c ; //NA
        //quoteID = QuoteDetails[0].id;
        //Account a = new Account();
        string msg = '';
        if(a != null){
            // a = aList[0];
            if(string.isNotBlank(a.Broker_Code__c)){
                LIFNR = a.Broker_Code__c;
            }
            SFDC_ID = a.Id;
            WAERS = 'INR';
            //    PROJECT_ID = '1285'; 
            //    BUKRS = '1200';
            //    EKORG = '1285';
            
            /***************** Add Project details****************/
            CPProjetList =[Select Id, Name,Account__c,Extended__c,Plant_ID__c,Company_Name__c,account__r.Broker_Code__c,
                           Leasing_Project__c , Sales_Organization__c FROM Channel_Partner_Project__c
                           WHERE Leasing_Project__c  =:opList[0].Leasing_Project__c AND Account__c =: a.id 
                           AND Extended__c = False order by CreatedDate desc limit 1];
            system.debug('CPProjetList:::::'+CPProjetList);
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
                        if( string.isBlank(customerCode)){
                            //         Rest_SAP_Sales_Order_Creation ssoc = new Rest_SAP_Sales_Order_Creation();
                            //         ssoc.createSalesOrder(bkList[0].id,customerCode);
                            Rest_Create_Leasing_customer CLC = new Rest_Create_Leasing_customer();
                            CLC.CreateLCust(OppId);
                        }//else if(!opList[0].Customer_flown_to_SAP__c && string.isNotBlank(soCode)){
                        //        Rest_Customer_Specific_BillingPlan CSP = new Rest_Customer_Specific_BillingPlan();
                        //        CSP.FLowBillinDetails(quoteID,soCode);
                        //    }    
                        
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
                        system.debug('error : ' + e.getLineNumber() + e.getMessage());
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