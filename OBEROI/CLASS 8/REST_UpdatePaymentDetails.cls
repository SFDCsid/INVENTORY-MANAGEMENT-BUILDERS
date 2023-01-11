public class REST_UpdatePaymentDetails {
    
    Public void UpdatePaymentDetails(String bId){
        
        List<Booking__c> bList = new List<Booking__c>();
        
        bList = [select id,name,Customer_Code__c,Part_Payment_towards_the_Sale_Price__c,Sale_Price_Due_Till_Date__c,Sale_Price_Received_Till_Date__c,
        GST_Due_Till_Date__c,GST_Received_Till_Date__c,Amount_paid_excl_GST__c,TDS_amount__c,balance_payable__c from Booking__c where Id =: bId];        
        System.debug('bList:::'+bList);
        JSONGenerator gen = JSON.createGenerator(true);
        /*if(bList.size()>0){
            gen.writeStartObject();
            if(bList[0].Customer_Code__c != Null){
                gen.writeStringField('customer',bList[0].Customer_Code__c);
            }else{
                gen.writeStringField('customer','');
            }
            gen.writeEndObject(); 
        }*/
        /*String JBody = gen.getAsString();
        System.debug('JBody::::'+JBody);
        if(jBody != '' && jBody != null){*/
            
            List<SAP_Credentials_Master__c> listSAPCreds = [Select Id, Name, Password__c, URL__c, User_Id__c 
                                                            from SAP_Credentials_Master__c
                                                            where Name =: 'Payment Details'];
            
            if(listSAPCreds.size()>0){
                string Endpoint = listSAPCreds[0].URL__c;
                string userid = listSAPCreds[0].User_Id__c;
                string password = listSAPCreds[0].Password__c;
                HttpRequest req = new HttpRequest();
                req.setEndpoint(Endpoint);
                req.setTimeout(120000);
                req.setHeader('Content-Type','application/json');
                String authorizationHeader = 'Basic ' +Encodingutil.base64Encode(Blob.valueOf(userid+':'+password));
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('customer',bList[0].Customer_Code__c);
                req.setMethod('POST');
                //req.setBody(jBody);
                
                //get the list of header names (keys)
                system.debug('header: ' + req.getHeader('Authorization'));
                system.debug('request :: '+req);
                
                HTTPResponse res = new HTTPResponse();
                String ResponceBody = '';
                if(!test.isRunningTest()){ 
                    Http http = new Http();
                    res = http.send(req);
                    System.debug('Response Body:::'+res.getBody());
                    ResponceBody = res.getBody();
                }
                Else{
                    ResponceBody = '{    "access_token": "test","PAY_TILL_DATE": "20000", "AMT_EXC_GST": "20000", "TDS_AMT":"20000", "BAL_PAYABLE":"20000","SAL_PRI_DUE":"20000","SAL_PRI_REC":"1000","GST_DUE":"100","GST_REC":"100", "MESSAGE": "Payment Details updated successfully" }';
                }
                if(ResponceBody !='' && ResponceBody !=Null){
                    
                    JSON2UpdatePaymentDetails r = JSON2UpdatePaymentDetails.parse(ResponceBody);
                    System.debug('Respone field "PAY_TILL_DATE" ::'+r.PAY_TILL_DATE);
                    
                    If((r.PAY_TILL_DATE)!= NULL || (r.AMT_EXC_GST)!= NULL || (r.TDS_AMT)!= NULL || (r.BAL_PAYABLE) != NULL){
                        List<SAP_Integration_Logs_Detail__c> spl = new List<SAP_Integration_Logs_Detail__c>();
                        
                        TRY{
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,'Payment Details updated successfully.'));                            
                        }CATCH(Exception e){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+e.getMessage()));
                            //System.debug('Your exception message here....'+e.getMessage());
                        }
                        
                        SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                        SILD.API_Name__c = 'Update Payment Details';
                        SILD.Booking__c = bId;
                        SILD.Status__c = 'Success';
                        SILD.Request__c = bList[0].Customer_Code__c;
                        SILD.Response__c = ResponceBody;
                        Insert SILD;
                        
                        if(r.PAY_TILL_DATE != Null)
                            bList[0].Part_Payment_towards_the_Sale_Price__c =  Decimal.valueof(r.PAY_TILL_DATE);
                        if(r.AMT_EXC_GST != Null)
                            bList[0].Amount_paid_excl_GST__c =  Decimal.valueof(r.AMT_EXC_GST);
                        if(r.TDS_AMT != Null)
                            bList[0].TDS_amount__c =  Decimal.valueof(r.TDS_AMT);
                        if(r.BAL_PAYABLE != Null)
                            bList[0].balance_payable__c =  Decimal.valueof(r.BAL_PAYABLE);
                        if(r.SAL_PRI_DUE != Null)
                            bList[0].Sale_Price_Due_Till_Date__c =  Decimal.valueof(r.SAL_PRI_DUE);
                        if(r.SAL_PRI_REC != Null)
                            bList[0].Sale_Price_Received_Till_Date__c =  Decimal.valueof(r.SAL_PRI_REC);
                        if(r.GST_DUE != Null)
                            bList[0].GST_Due_Till_Date__c =  Decimal.valueof(r.GST_DUE);
                        if(r.GST_REC != Null)
                            bList[0].GST_Received_Till_Date__c =  Decimal.valueof(r.GST_REC);
                        Update bList;
                    }else{
                        SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                        SILD.API_Name__c = 'Update Payment Details';
                        SILD.Booking__c = bId;
                        SILD.Status__c = 'Success';
                        SILD.Request__c = bList[0].Customer_Code__c;
                        SILD.Response__c = ResponceBody;
                        Insert SILD; 
                        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'));                 
                    }    
                }
            
            
        }
    }
    
}