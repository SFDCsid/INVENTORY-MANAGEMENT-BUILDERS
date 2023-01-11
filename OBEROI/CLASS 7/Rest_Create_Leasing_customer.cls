public Class Rest_Create_Leasing_customer{
    
   
    Public void CreateLCust(String OppId){
        List<Opportunity> oppList = new List<Opportunity>();
        List<SAP_State_Country__c> Locationcode = new List<SAP_State_Country__c>();
        
        if(OppId != Null && OppId != ''){
            oppList = [Select id,name,Account_Group1__c,Customer_Number__c,Company_Code1__c,Business_Entity_Number1__c,Title_Mr_Company__c,Cust_Name_1__c,Cust_Name_2__c,Cust_Name_3__c,Cust_Name_4__c,Cust_Name_5__c,Number_of_Rental_Object1__c,
            Brand__c,Str_Suppl1__c,Str_Suppl2__c,Str_Suppl3__c,House_No__c,Building_Soc_House__c,Location_2__c,Post_Code1__c,City__c,Country_Picklist__c,Region1__c,PAN_Number__c,PAN_Reference__c,GST__c,Reconciliation_Account__c,
            Message_Type__c,Message__c,Mobile_Number_1__c,Email_Address_1__c,Mobile_Number_2__c,Email_Address_2__c,Mobile_Number_3__c,Email_Address_3__c,Mobile_Number_4__c,Email_Address_4__c,Mobile_Number_5__c,
            Email_Address_5__c from Opportunity where Id =: OppId];
            
            List<Tan_Table__c> tanList = [select id,name,Section_code__c,Certficate_no__c,Exem_Rate__c,Exem_from__c,Exem_To__c,Exem_Threshold__c,Currency__c,
            Opportunity__c from Tan_Table__c where Opportunity__c =: OppId];
            
            JSONGenerator gen = JSON.createGenerator(true);
            if(oppList.size()>0){
                gen.writeStartObject();
                    if(oppList[0].Account_Group1__c != null){
                        gen.writeStringField('KTOKD',oppList[0].Account_Group1__c);
                    }else{
                        gen.writeStringField('KTOKD','');
                    }
                    
                    if(oppList[0].Customer_Number__c != null){
                        gen.writeStringField('KUNNR',oppList[0].Customer_Number__c);
                    }else{
                        gen.writeStringField('KUNNR','');
                    }
                    
                    if(oppList[0].Company_Code1__c != null){
                        gen.writeStringField('BUKRS',oppList[0].Company_Code1__c);
                    }else{
                        gen.writeStringField('BUKRS','');
                    }
                    
                    if(oppList[0].Business_Entity_Number1__c != null){
                        gen.writeStringField('SWENR',oppList[0].Business_Entity_Number1__c);
                    }else{
                        gen.writeStringField('SWENR','');
                    }
                    
                    if(oppList[0].Title_Mr_Company__c != null){
                       gen.writeStringField('ANRED',oppList[0].Title_Mr_Company__c);
                    //gen.writeStringField('ANRED','Company');
                    }else{
                        gen.writeStringField('ANRED','');
                    }
                    
                    if(oppList[0].name != null){
                        gen.writeStringField('NAME1',oppList[0].name);
                    }else{
                        gen.writeStringField('NAME1','');
                    }
                    
                    if(oppList[0].Cust_Name_2__c != null){
                        gen.writeStringField('NAME2',oppList[0].Cust_Name_2__c);
                    }else{
                        gen.writeStringField('NAME2','');
                    }
                    
                    if(oppList[0].Cust_Name_3__c != null){
                        gen.writeStringField('NAME3',oppList[0].Cust_Name_3__c);
                    }else{
                        gen.writeStringField('NAME3','');
                    }
                    
                    if(oppList[0].Cust_Name_4__c != null){
                        gen.writeStringField('NAME4',oppList[0].Cust_Name_4__c);
                    }else{
                        gen.writeStringField('NAME4','');
                    }
                    
                    if(oppList[0].Cust_Name_5__c != null){
                        gen.writeStringField('NAME5',oppList[0].Cust_Name_5__c);
                    }else{
                        gen.writeStringField('NAME5','');
                    }
                    
                    if(oppList[0].Number_of_Rental_Object1__c != null){
                        gen.writeStringField('SMENR',oppList[0].Number_of_Rental_Object1__c);
                    }else{
                        gen.writeStringField('SMENR','');
                    }
                    
                    if(oppList[0].Brand__c != null){
                        gen.writeStringField('BRAND',oppList[0].Brand__c);
                    }else{
                        gen.writeStringField('BRAND','');
                    }
                    
                    if(oppList[0].Str_Suppl1__c != null){
                        gen.writeStringField('STR_SUPPL1',oppList[0].Str_Suppl1__c);
                    }else{
                        gen.writeStringField('STR_SUPPL1','');
                    }
                    
                    if(oppList[0].Str_Suppl2__c != null){
                        gen.writeStringField('STR_SUPPL2',oppList[0].Str_Suppl2__c);
                    }else{
                        gen.writeStringField('STR_SUPPL2','');
                    }
                    
                    if(oppList[0].Str_Suppl3__c != null){
                        gen.writeStringField('STR_SUPPL3',oppList[0].Str_Suppl3__c);
                    }else{
                        gen.writeStringField('STR_SUPPL3','');
                    }
                    
                    if(oppList[0].Building_Soc_House__c != null){
                        gen.writeStringField('STREET',oppList[0].Building_Soc_House__c);
                    }else{
                        gen.writeStringField('STREET','');
                    }
                    
                    if(oppList[0].House_No__c != null){
                        gen.writeStringField('HOUSE_NUM1',oppList[0].House_No__c);
                    }else{
                        gen.writeStringField('HOUSE_NUM1','');
                    }
                    
                    if(oppList[0].Location_2__c != null){
                        gen.writeStringField('LOCATION',oppList[0].Location_2__c);
                    }else{
                        gen.writeStringField('LOCATION','');
                    }
                    
                    if(oppList[0].Post_Code1__c != null){
                        gen.writeStringField('POST_CODE1',oppList[0].Post_Code1__c);
                    }else{
                        gen.writeStringField('POST_CODE1','');
                    }
                    
                    if(oppList[0].City__c != null){
                        gen.writeStringField('CITY1',oppList[0].City__c);
                    }else{
                        gen.writeStringField('CITY1','');
                    }
                    
                    Locationcode = [select id, Name, Country_ID__c, State_ID__c, State_Description__c
                                    FROM SAP_State_Country__c WHERE State_Description__c =: oppList[0].Region1__c];
                    
                    If(Locationcode.size()>0){
                        if(Locationcode[0].Country_ID__c != null){
                            gen.writeStringField('COUNTRY',Locationcode[0].Country_ID__c);
                        }else{
                            gen.writeStringField('COUNTRY','');
                        } 
                        
                        if(Locationcode[0].State_ID__c != null){   
                            gen.writeStringField('REGION',Locationcode[0].State_ID__c);
                        }else{
                            gen.writeStringField('REGION','');
                        }
                        
                    }
                   
                    if(oppList[0].PAN_Number__c != null){
                        gen.writeStringField('PAN_NUMBER',oppList[0].PAN_Number__c);
                    }else{
                        gen.writeStringField('PAN_NUMBER','');
                    }
                    
                    if(oppList[0].PAN_Reference__c != null){
                        gen.writeStringField('PAN_REFERENCE',oppList[0].PAN_Reference__c);
                    }else{
                        gen.writeStringField('PAN_REFERENCE','');
                    }
                    
                    if(oppList[0].GST__c != null){
                        gen.writeStringField('GST',oppList[0].GST__c);
                    }else{
                        gen.writeStringField('GST','');
                    }
                    
                    if(oppList[0].Reconciliation_Account__c != null){
                        gen.writeStringField('AKONT',oppList[0].Reconciliation_Account__c);
                    }else{
                        gen.writeStringField('AKONT','');
                    }
                    
                    if(oppList[0].Message_Type__c != null){
                        gen.writeStringField('MSG_TYPE',oppList[0].Message_Type__c);
                    }else{
                        gen.writeStringField('MSG_TYPE','');
                    }
                    
                    if(oppList[0].Message__c != null){
                        gen.writeStringField('MESSAGE',oppList[0].Message__c);
                    }else{
                        gen.writeStringField('MESSAGE','');
                    }
                    
                    gen.writeFieldName('MOBILE');
                    gen.writeStartArray();
                    gen.writeStartObject();
                    
                    if(oppList[0].Mobile_Number_1__c != null){
                        gen.writeStringField('MOBILE',oppList[0].Mobile_Number_1__c);
                    }
                    gen.writeEndObject();
                    
                    gen.writeStartObject();
                    if(oppList[0].Mobile_Number_2__c != null){
                        gen.writeStringField('MOBILE',oppList[0].Mobile_Number_2__c);
                    }
                    gen.writeEndObject();
                    
                    gen.writeStartObject();
                    if(oppList[0].Mobile_Number_3__c != null){
                        gen.writeStringField('MOBILE',oppList[0].Mobile_Number_3__c);
                    }
                    gen.writeEndObject();
                    
                    gen.writeStartObject();
                    if(oppList[0].Mobile_Number_4__c != null){
                        gen.writeStringField('MOBILE',oppList[0].Mobile_Number_4__c);
                    }
                    gen.writeEndObject();
                    
                    gen.writeStartObject();
                    if(oppList[0].Mobile_Number_5__c != null){
                        gen.writeStringField('MOBILE',oppList[0].Mobile_Number_5__c);
                    }
                    
                    gen.writeEndObject();
                    gen.writeEndArray();
                    
                    gen.writeFieldName('EMAIL');
                    gen.writeStartArray();
                    gen.writeStartObject();
                    
                    if(oppList[0].Email_Address_1__c != null){
                        gen.writeStringField('EMAIL',oppList[0].Email_Address_1__c);
                    }
                    gen.writeEndObject();
                    
                    gen.writeStartObject();
                    if(oppList[0].Email_Address_2__c != null){
                        gen.writeStringField('EMAIL',oppList[0].Email_Address_2__c);
                    }
                    gen.writeEndObject();
                    
                    gen.writeStartObject();
                    if(oppList[0].Email_Address_3__c != null){
                        gen.writeStringField('EMAIL',oppList[0].Email_Address_3__c);
                    }
                    gen.writeEndObject();
                    
                    gen.writeStartObject();
                    if(oppList[0].Email_Address_4__c != null){
                        gen.writeStringField('EMAIL',oppList[0].Email_Address_4__c);
                    }
                    gen.writeEndObject();
                    
                    gen.writeStartObject();
                    if(oppList[0].Email_Address_5__c != null){
                        gen.writeStringField('EMAIL',oppList[0].Email_Address_5__c);
                    }
                    
                    gen.writeEndObject();
                    gen.writeEndArray();
                    
                    gen.writeFieldName('TAN_EXEM');
                    gen.writeStartArray();
                    if(tanList.size()>0){
                        for(Tan_Table__c tt: tanList){
                            gen.writeStartObject();
                            if(tt.Section_code__c != null){
                                gen.writeStringField('SECCODE',tt.Section_code__c);
                            }else{
                                gen.writeStringField('SECCODE','');
                            }
                            
                            if(tt.Certficate_no__c != null){
                                gen.writeStringField('WT_EXNR',tt.Certficate_no__c);
                            }else{
                                gen.writeStringField('WT_EXNR','');
                            }
                            
                            if(tt.Exem_Rate__c != null){
                                gen.writeStringField('WT_EXRT',String.Valueof(tt.Exem_Rate__c));
                            }else{
                                gen.writeStringField('WT_EXRT','');
                            }
                            
                            if(tt.Exem_from__c != null){
                                gen.writeStringField('WT_EXDF',String.Valueof(tt.Exem_from__c));
                            }else{
                                gen.writeStringField('WT_EXDF','');
                            }
                            
                            if(tt.Exem_To__c != null){
                                gen.writeStringField('WT_EXDT',String.Valueof(tt.Exem_To__c));
                            }else{
                                gen.writeStringField('WT_EXDT','');
                            }
                            
                            if(tt.Exem_Threshold__c != null){
                                gen.writeStringField('FIWTIN_EXEM_THR',String.Valueof(tt.Exem_Threshold__c));
                            }else{
                                gen.writeStringField('FIWTIN_EXEM_THR','');
                            }
                            
                            if(tt.Currency__c != null){
                                gen.writeStringField('WAERS',tt.Currency__c);
                            }else{
                                gen.writeStringField('WAERS','');
                            }
                            gen.writeEndObject();
                        }
                    
                   } 
                  gen.writeEndArray();
                  gen.writeEndObject();   
           }  
            String JBody = gen.getAsString();
            System.debug('JBody::::'+JBody);
              if(jBody != '' && jBody != null){
                
                List<SAP_Credentials_Master__c> listSAPCreds = [Select Id, Name, Password__c, URL__c, User_Id__c 
                                                                from SAP_Credentials_Master__c
                                                                where Name =: 'Leasing Create Customer'];
                
                string Endpoint = listSAPCreds[0].URL__c;
                string userid = listSAPCreds[0].User_Id__c;
                string password = listSAPCreds[0].Password__c;
                HttpRequest req = new HttpRequest();
                req.setEndpoint(Endpoint);
                req.setTimeout(120000);
                req.setHeader('Content-Type','application/json');
                String authorizationHeader = 'Basic ' +Encodingutil.base64Encode(Blob.valueOf(userid+':'+password));
                req.setHeader('Authorization', authorizationHeader);
                req.setMethod('POST');
                req.setBody(jBody);
                
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
                    ResponceBody = '[{"TYPE":"E","ID":"AM","NUMBER":132,"MESSAGE":"Please enter a valid form of address","LOG_NO":"","LOG_MSG_NO":0,"MESSAGE_V1":"","MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":""}]';
                    //ResponceBody = 'test responce';
                }
                if(ResponceBody !='' && ResponceBody !=Null){
                    JSON2ApexCreate_Leasing_customer r = JSON2ApexCreate_Leasing_customer.parse(ResponceBody);
                    System.debug('Respone field "Type" ::'+r.TYPE);
                    System.debug('Respone field "ID" ::'+r.ID);
                    System.debug('Respone field "NUMBER_Z" ::'+r.NUMBER_Z);
                    System.debug('Respone field "MESSAGE" ::'+r.MESSAGE);
                    System.debug('Respone field "LOG_NO" ::'+r.LOG_NO);
                    System.debug('Respone field "LOG_MSG_NO" ::'+r.LOG_MSG_NO);
                    System.debug('Respone field "MESSAGE_V1" ::'+r.MESSAGE_V1);
                    System.debug('Respone field "MESSAGE_V2" ::'+r.MESSAGE_V2);
                    System.debug('Respone field "MESSAGE_V3" ::'+r.MESSAGE_V3);
                    System.debug('Respone field "MESSAGE_V4" ::'+r.MESSAGE_V4 );
                    
                    If(r.TYPE =='S'){
                        
                        
                        TRY{
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,+r.MESSAGE));                            
                        }CATCH(Exception e){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+e.getMessage()));
                            //System.debug('Your exception message here....'+e.getMessage());
                        }
                        
                        
                        SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                        SILD.API_Name__c = 'Leasing Customer Creation';
                        SILD.Customer__c = OppId;
                        SILD.Status__c = 'Success';
                        SILD.Request__c = jBody;
                        SILD.Response__c = ResponceBody;
                        Insert SILD;
                        
                        oppList[0].Customer_flown_to_SAP__c = True;
                        oppList[0].Customer_Number__c = r.MESSAGE_V1;
                        Update oppList;
                    }else{
                        SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                        SILD.API_Name__c = 'Leasing Customer Creation';
                        SILD.Customer__c = OppId;
                        SILD.Status__c = 'Failed';
                        SILD.Request__c = jBody;
                        SILD.Response__c = ResponceBody;
                        SILD.Error_Message__c = r.MESSAGE;
                        Insert SILD;   
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+r.MESSAGE));                 
                    }
                }
                
            }
        }
    }
}