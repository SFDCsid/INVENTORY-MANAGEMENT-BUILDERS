public Class Rest_RM_Update{  
   @future(callout=true)
    Public static void UpdateRM(Set<Id> propId){
        
        List<Property__c> propList = [select id,name,Material_No__c,Original_RM_Name__r.Name,Original_RM_Name__r.Email,Original_RM_Name__r.MobilePhone,Original_RM_Name__r.Phone from Property__c where Id IN:propId limit 1000];
        System.debug('propList:::'+propList);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('TABLE');       
        gen.writeStartArray();
        if(propList.size()>0){
            for(Property__c prop : propList){
                gen.writeStartObject();
                if(prop.Material_No__c != Null){
                    gen.writeStringField('ZSORTL',prop.Material_No__c);
                }else{
                    gen.writeStringField('ZSORTL','');
                }
                
                if(prop.Original_RM_Name__r.Name != Null){
                    gen.writeStringField('ZRM_NAME',prop.Original_RM_Name__r.Name);
                }else{
                    gen.writeStringField('ZRM_NAME','');
                }
                
                if(prop.Original_RM_Name__r.Email != Null){
                    gen.writeStringField('SMTP_ADDR',prop.Original_RM_Name__r.Email);
                }else{
                    gen.writeStringField('SMTP_ADDR','');
                }
                
                if(prop.Original_RM_Name__r.MobilePhone != Null){
                    gen.writeStringField('ZRM_MOB',prop.Original_RM_Name__r.MobilePhone);
                    //gen.writeStringField('ZRM_MOB',prop.Original_RM_Name__r.Phone); //added 11/03/2022
                }else{
                    gen.writeStringField('ZRM_MOB','');
                }
                gen.writeEndObject(); 
            }
        }
        gen.writeEndArray();
        gen.writeEndObject();
        
        String JBody = gen.getAsString();
            System.debug('JBody::::'+JBody);
              if(jBody != '' && jBody != null){
                
               List<SAP_Credentials_Master__c> listSAPCreds = [Select Id, Name, Password__c, URL__c, User_Id__c 
                                                                from SAP_Credentials_Master__c
                                                                where Name =: 'RM Update'];
                
                  if(listSAPCreds.size()>0){
                string Endpoint = listSAPCreds[0].URL__c;
                string userid = listSAPCreds[0].User_Id__c;
                string password = listSAPCreds[0].Password__c;
                HttpRequest req = new HttpRequest();
                req.setEndpoint(Endpoint);
                req.setTimeout(20000);
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
                    ResponceBody = '{    "access_token": "test","ZSORTL": "OEY-A-0601","MESSAGE": "Data updated successfully" }';
                }
                if(ResponceBody !='' && ResponceBody !=Null){
                
                    JSON2ApexRM_Update r = JSON2ApexRM_Update.parse(ResponceBody);
                    System.debug('Respone field "Property_Name" ::'+r.ZSORTL);
                    System.debug('Respone field "MESSAGE" ::'+r.MESSAGE);
                    
                    List<Property__c> propL = new List<Property__c>();
                    propL = [select id,name,Material_No__c from Property__c where Material_No__c =: r.ZSORTL];
                    System.debug('propL::::'+propL);
                    
                    
                    If(r.MESSAGE.contains('Data updated successfully')){
                        List<SAP_Integration_Logs_Detail__c> spl = new List<SAP_Integration_Logs_Detail__c>();
                        if(propL.size()>0){
                        for(Property__c p:propL){
                            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                            SILD.API_Name__c = 'RM Update';
                            SILD.Property__c = p.Id;
                            SILD.Status__c = 'Success';
                            SILD.Request__c = jBody;
                            SILD.Response__c = ResponceBody;
                            spl.add(SILD); 
                            //Insert SILD;
                            
                         }
                         }
                         if(spl.size()>0){
                             Insert spl;
                         }
                        
                        
                    }else{
                        SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                        SILD.API_Name__c = 'RM Update';
                        //SILD.Property__c = propList[0].Id;
                        SILD.Status__c = 'Failed';
                        SILD.Request__c = jBody;
                        SILD.Response__c = ResponceBody;
                        SILD.Error_Message__c = r.MESSAGE;
                        Insert SILD;   
                        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+ResponceBody));                 
                    }
                }
               } 
            }
                  
    }

}