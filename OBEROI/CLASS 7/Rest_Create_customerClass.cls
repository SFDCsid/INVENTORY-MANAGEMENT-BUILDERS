public class Rest_Create_customerClass{
    
    //@Future(callout=True)static 
    Public String CreateJSON(string BookId){
        
        List<Booking__c> Booklist = new List<Booking__c>();
        List<Applicant__c> Applist1 = new List<Applicant__c>();
        List<Applicant__c> Applist2 = new List<Applicant__c>();
        List<Applicant__c> Applist3 = new List<Applicant__c>();
        List<Applicant__c> Applist4 = new List<Applicant__c>();
        List<Applicant__c> Applist5 = new List<Applicant__c>();
        List<SAP_State_Country__c> Locationcode = new List<SAP_State_Country__c>();
        String Title = '';
        String Name1 = '';
        String Name2 = '';
        String Name3 = '';
        String Name4 = '';
        String Name5 = '';
        String Mobile1 = '';
        String Mobile2 = '';
        String Mobile3  = '';
        String Mobile4 = '';
        String Mobile5 = '';
        String Mobile6 = '';
        String Mobile7 = '';
        String Mobile8  = '';
        String Mobile9 = '';
        String Mobile10 = '';
        String Email1 = '';
        String Email2 = '';
        String Email3 = '';
        String Email4 = '';
        String Email5 = '';
        String Email6 = '';
        String Email7 = '';
        String Email8 = '';
        String Email9 = '';
        String Email10 = '';
        String PAN1 = '';
        String PAN2 = '';
        String PAN3 = '';
        String PAN4 = '';
        String PAN5 = '';
        String GSTNO = '';
        String Street = '';
        String HOUSE_NUM1 = '';
        String Street1 = '';
        String Street2 = '';
        String Street3 = '';
        String Location = '';
        String City = '';
        String PostalCode = '';
        String Country = '';
        String Region = '';
        String state = '';
        String CustomerCode = '';
        STring TDS_BUBKZ = '';
        
        If(BookId != Null && BookId != ''){
            Booklist = [Select Id,Name,Opportunity__c,TDS_Paid_By__c,Booking_Through__c,Pricing_Flown_to_SAP__c ,Quotation__c,Opportunity__r.AccountId,Project__c,Project__r.Plant__c,Tower__r.Customer_A_C_Group__c,
                        Project__r.Sales_Organization__c,Property__r.Material_No__c, Property__r.House_Unit_No__c,Project__r.Company_name__c,Project__r.GST_No__c,Tower_Name__c FROM Booking__c Where Id =: BookId];
            
            If(Booklist.size() >0){
                Applist1 = [Select Id,Name,Applicant_Number__c,Salutation__c,Applicant_Name__c,PancardNo__c,Mobile_Number__c,
                            Email_Address__c,Street__c,City__c,Mailing_Pincode__c,State_Province__c,State__c,GSTN__c,
                            Mailing_House_No__c,Mailing_Street_1__c,Mailing_Street_2__c,Mailing_Street_3__c,
                            Alternate_Mobile_No__c,Alternate_Email_Id__c,
                            House_No__c,Street_1__c,Street_2__c,Street_3__c,Locality__c,Pincode__c
                            FROM Applicant__c WHERE Applicant_Number__c = 'Primary Applicant' and booking__c =: BookId ];
                
                Applist2 = [Select Id,Name,Applicant_Number__c,Salutation__c,Applicant_Name__c,PancardNo__c,Mobile_Number__c,
                            Alternate_Mobile_No__c,Alternate_Email_Id__c,Email_Address__c  
                            FROM Applicant__c WHERE Applicant_Number__c = 'Second Applicant' and booking__c =:BookId ];
                
                Applist3 = [Select Id,Name,Applicant_Number__c,Salutation__c,Applicant_Name__c,PancardNo__c,Mobile_Number__c,Email_Address__c,
                            Alternate_Mobile_No__c,Alternate_Email_Id__c
                            FROM Applicant__c WHERE Applicant_Number__c = 'Third Applicant' and  booking__c =:BookId ];
                
                Applist4 = [Select Id,Name,Applicant_Number__c,Salutation__c,Applicant_Name__c,PancardNo__c,Mobile_Number__c,Email_Address__c,
                            Alternate_Mobile_No__c,Alternate_Email_Id__c
                            FROM Applicant__c WHERE Applicant_Number__c = 'Fourth Applicant' and booking__c =:BookId ];
                
                Applist5 = [Select Id,Name,Applicant_Number__c,Salutation__c,Applicant_Name__c,PancardNo__c,Mobile_Number__c,Email_Address__c,
                            Alternate_Mobile_No__c,Alternate_Email_Id__c
                            FROM Applicant__c WHERE Applicant_Number__c = 'Fifth Applicant' and  booking__c =:BookId ];
                
                if(Applist1.size()>0){
                    System.debug('In App1 & size'+ Applist1.size());
                    Title = Applist1[0].Salutation__c;
                    Name1 = Applist1[0].Name;
                    
                    if(Applist1[0].Mobile_Number__c != null)
                        Mobile1 = Applist1[0].Mobile_Number__c;
                    if(Applist1[0].Email_Address__c != null)    
                        Email1 = Applist1[0].Email_Address__c;
                    
                    if(Applist1[0].Alternate_Mobile_No__c != null)
                        Mobile2 = Applist1[0].Alternate_Mobile_No__c;
                    if(Applist1[0].Alternate_Email_Id__c != null)    
                        Email2 = Applist1[0].Alternate_Email_Id__c;
                                        
                    if(Applist1[0].PancardNo__c != null)    
                        PAN1 = Applist1[0].PancardNo__c;
                    if(Applist1[0].GSTN__c != null)    
                        GSTNO = Applist1[0].GSTN__c;
                    
                    if(Applist1[0].House_No__c != null)     
                    HOUSE_NUM1 = Applist1[0].House_No__c;
                    
                    if(Applist1[0].Street_1__c != null)     
                    Street1 = Applist1[0].Street_1__c;
                    
                    if(Applist1[0].Street_2__c!= null)     
                    Street2 = Applist1[0].Street_2__c;
                    
                    if(Applist1[0].Street_3__c!= null)     
                    Street3 = Applist1[0].Street_3__c;
                    
                    if(Applist1[0].Locality__c != null)     
                    Location = Applist1[0].Locality__c;                    
                    
                    if(Applist1[0].City__c != null) 
                    City = Applist1[0].City__c;
                    
                    if(Applist1[0].Pincode__c != null)
                    PostalCode = Applist1[0].Pincode__c;
                    
                    Locationcode = [select id, Name, Country_ID__c, State_ID__c, State_Description__c
                                    FROM SAP_State_Country__c WHERE State_Description__c =: Applist1[0].State__c];
                    
                    If(Locationcode.size()>0){
                        Country = Locationcode[0].Country_ID__c;
                        Region = Locationcode[0].State_ID__c;
                        state = Locationcode[0].State_Description__c;
                    }
                }
                if(Applist2.size()>0){
                    System.debug('In App2 & size'+ Applist2.size());
                    Name2 = Applist2[0].Salutation__c+' '+Applist2[0].Name;
                    if(Applist2[0].Mobile_Number__c != null)
                        Mobile3 = Applist2[0].Mobile_Number__c;
                    if(Applist2[0].Email_Address__c != null)    
                        Email3 = Applist2[0].Email_Address__c;
                    
                    if(Applist2[0].Alternate_Mobile_No__c != null)
                        Mobile4 = Applist2[0].Alternate_Mobile_No__c;
                    if(Applist2[0].Alternate_Email_Id__c != null)    
                        Email4 = Applist2[0].Alternate_Email_Id__c;
                    
                    if(Applist2[0].PancardNo__c != null)    
                        PAN2 = Applist2[0].PancardNo__c;
                }
                if(Applist3.size()>0){
                    System.debug('In App3 & size'+ Applist3.size());
                    Name3 = Applist3[0].Salutation__c+' '+Applist3[0].Name;
                    
                    if(Applist3[0].Mobile_Number__c != null)
                        Mobile5 = Applist3[0].Mobile_Number__c;
                    if(Applist3[0].Email_Address__c != null)    
                        Email5 = Applist3[0].Email_Address__c;
                        
                    if(Applist3[0].Alternate_Mobile_No__c != null)
                        Mobile6 = Applist3[0].Alternate_Mobile_No__c;
                    if(Applist3[0].Alternate_Email_Id__c != null)    
                        Email6 = Applist3[0].Alternate_Email_Id__c;
                        
                    if(Applist3[0].PancardNo__c != null)    
                        PAN3 = Applist3[0].PancardNo__c;
                    
                }
                if(Applist4.size()>0){
                    System.debug('In App4 & size'+ Applist4.size());
                    Name4 = Applist4[0].Salutation__c+' '+Applist4[0].Name;
                    
                    if(Applist4[0].Mobile_Number__c != null)
                        Mobile7 = Applist4[0].Mobile_Number__c;
                    if(Applist4[0].Email_Address__c != null)    
                        Email7 = Applist4[0].Email_Address__c;
                    if(Applist4[0].PancardNo__c != null)    
                        PAN4 = Applist4[0].PancardNo__c;
                        
                    if(Applist4[0].Alternate_Mobile_No__c != null)
                        Mobile8 = Applist4[0].Alternate_Mobile_No__c;
                    if(Applist4[0].Alternate_Email_Id__c != null)    
                        Email8 = Applist4[0].Alternate_Email_Id__c;
                    
                }
                if(Applist5.size()>0){
                    System.debug('In App5 & size'+ Applist5.size());
                    Name5 = Applist5[0].Salutation__c+' '+Applist5[0].Name;
                    
                   if(Applist5[0].Mobile_Number__c != null)
                        Mobile9 = Applist5[0].Mobile_Number__c;
                    if(Applist5[0].Email_Address__c != null)    
                        Email9 = Applist5[0].Email_Address__c;
                    if(Applist5[0].PancardNo__c != null)    
                        PAN5 = Applist5[0].PancardNo__c;
                        
                    if(Applist5[0].Alternate_Mobile_No__c != null)
                        Mobile10 = Applist5[0].Alternate_Mobile_No__c;
                    if(Applist5[0].Alternate_Email_Id__c != null)    
                        Email10 = Applist5[0].Alternate_Email_Id__c;
                    
                }
            }        
            Customer_Account_Group__c cs = Customer_Account_Group__c.getInstance(string.valueof(Booklist[0].Tower__r.Customer_A_C_Group__c));
            Number_Range__c cs2 =  Number_Range__c.getInstance(string.valueof(cs.Number_Id__c));
            
            CustomerCode = String.valueof(Decimal.ValueOf(cs2.Last_Number_Used__c) +1);
            
            if(Booklist[0].TDS_Paid_By__c != Null && Booklist[0].TDS_Paid_By__c == 'Self'){
                TDS_BUBKZ = '2';
            }else if(Booklist[0].TDS_Paid_By__c != Null && Booklist[0].TDS_Paid_By__c == 'Authorization to Company'){
                TDS_BUBKZ = '1';
            }Else{
                TDS_BUBKZ = '0';
            } 
            
            
            JSONGenerator gen = JSON.createGenerator(true);
            // Write data to the JSON string.
            gen.writeStartObject();
            
            if(CustomerCode != Null){
                gen.writeStringField('KUNNR', CustomerCode);
            }else{
                gen.writeStringField('KUNNR', '');
            }
            
            if(Booklist[0].Opportunity__c != Null){
                gen.writeStringField('SFDC_ID',Booklist[0].Opportunity__c);
            }else{
                gen.writeStringField('SFDC_ID','');
            }          
            
            if(Booklist[0].Project__r.Plant__c != Null && Booklist[0].Project__r.Plant__c !=''){
                gen.writeStringField('PROJECT_ID',Booklist[0].Project__r.Plant__c);
            }else{
                gen.writeStringField('PROJECT_ID','');
            }
            
            if(Booklist[0].Tower_Name__c != Null && Booklist[0].Tower_Name__c !=''){
                gen.writeStringField('TOWER', Booklist[0].Tower_Name__c);
            }else{
                gen.writeStringField('TOWER', '');
            }
            
            
            if(Booklist[0].Project__r.Sales_Organization__c != Null && Booklist[0].Project__r.Sales_Organization__c !=''){
                gen.writeStringField('VKORG', Booklist[0].Project__r.Sales_Organization__c);
            }else{
                gen.writeStringField('VKORG', '');
            }
            
            if(Booklist[0].Project__r.Company_name__c != Null && Booklist[0].Project__r.Company_name__c !=''){
                 gen.writeStringField('BUKRS', Booklist[0].Project__r.Company_name__c);
            }else{
                 gen.writeStringField('BUKRS', '');
            }
           
            if(Booklist[0].Booking_Through__c == 'Partner'){
                gen.writeStringField('VTWEG', '12');
            }Else{
                gen.writeStringField('VTWEG', '11');
            }
            gen.writeStringField('SPART', '10');
            gen.writeStringField('VKGRP', '');
            gen.writeStringField('VKBUR', '');
            
            if(Booklist[0].Tower__r.Customer_A_C_Group__c != Null ){
                gen.writeStringField('KTOKD', string.valueof(Booklist[0].Tower__r.Customer_A_C_Group__c));
            }else{
                gen.writeStringField('KTOKD', '');
            }
            if(Title!= null)
                gen.writeStringField('TITLE', Title);
            else
                gen.writeStringField('TITLE', '');
            //gen.writeStringField('KUNNR', CustomerCode);
            if(Name1 != null)
                gen.writeStringField('NAME1', Name1);
            else
                gen.writeStringField('NAME1', ''); 
            if(Name2 != null)       
                gen.writeStringField('NAME2', Name2);
            else
                gen.writeStringField('NAME2', '');
            if(Name3 != null)
                gen.writeStringField('NAME3', Name3);
            else
                gen.writeStringField('NAME3', '');    
            if(Name4 != null)
                gen.writeStringField('NAME4', Name4);
            else
                gen.writeStringField('NAME4', '');    
            if(Name5 != null)
                gen.writeStringField('NAME5', Name5);
            else
                gen.writeStringField('NAME5', '');    
            
            if(Booklist[0].Property__r.Material_No__c != Null && Booklist[0].Property__r.Material_No__c !=''){
                 gen.writeStringField('SORT1', Booklist[0].Property__r.Material_No__c);
            }else{
                 gen.writeStringField('SORT1', '');
            }
            if(Street1 != null)
                gen.writeStringField('STR_SUPPL1', Street1);
            else
                gen.writeStringField('STR_SUPPL1', '');
                
            if(Street2 != null)
                gen.writeStringField('STR_SUPPL2', Street2);
            else
                gen.writeStringField('STR_SUPPL2', '');
                
            if(Street3 != null)
                gen.writeStringField('STR_SUPPL3', Street3);
            else
                gen.writeStringField('STR_SUPPL3', '');
            
            gen.writeStringField('STREET', '');
            
            if(Street != null)
                gen.writeStringField('HOUSE_NUM1', HOUSE_NUM1);
            else
                gen.writeStringField('HOUSE_NUM1', '');    
            if(Location != null)
                gen.writeStringField('LOCATION', Location);
            else
                gen.writeStringField('LOCATION','');
            if(PostalCode != null)    
                gen.writeStringField('POST_CODE1', PostalCode);
            else
                gen.writeStringField('POST_CODE1', '');
            if(Location != null)    
                gen.writeStringField('CITY1', City);
            else
                gen.writeStringField('CITY1', '');   
            if(Country != null)     
                gen.writeStringField('COUNTRY', Country);
            else
                gen.writeStringField('COUNTRY', '');   
            if(Region != null)     
                gen.writeStringField('REGION', Region);
            else
                gen.writeStringField('REGION', '');  
            if(state != null)      
                gen.writeStringField('STATE', state);
            else
                gen.writeStringField('STATE', '');
            gen.writeStringField('CIVVE', 'X');
            gen.writeStringField('AKONT', '24203110');
            gen.writeStringField('ZUAWA', '000');
            gen.writeStringField('VZSKZ', 'C2');
            gen.writeStringField('ZTERM', '0001');
            gen.writeStringField('XAUSZ', '2');
            gen.writeStringField('QLAND', '');
            gen.writeStringField('BZIRK', 'IN0005');
            gen.writeStringField('KDGRP', '11');
            gen.writeStringField('KALKS', '1');
            gen.writeStringField('VERSG', '1');
            gen.writeStringField('LPRIO', '00');
            gen.writeStringField('VSBED', '01');
            
            if(Booklist[0].Project__r.Plant__c != Null && Booklist[0].Project__r.Plant__c !=''){
                 gen.writeStringField('VWERK', Booklist[0].Project__r.Plant__c);
            }else{
                 gen.writeStringField('VWERK', '');
            }
            
            gen.writeStringField('KTGRD', '11');
            gen.writeStringField('MOBILE1', Mobile1);
            gen.writeStringField('MOBILE2', Mobile2);
            gen.writeStringField('MOBILE3', Mobile3);
            gen.writeStringField('MOBILE4', Mobile4);
            gen.writeStringField('MOBILE5', Mobile5);
            gen.writeStringField('MOBILE6', Mobile6);
            gen.writeStringField('MOBILE7', Mobile7);
            gen.writeStringField('MOBILE8', Mobile8);
            gen.writeStringField('MOBILE9', Mobile9);
            gen.writeStringField('MOBILE10', Mobile10);
            gen.writeStringField('EMAIL1', Email1);
            gen.writeStringField('EMAIL2', Email2);
            gen.writeStringField('EMAIL3', Email3);
            gen.writeStringField('EMAIL4', Email4);
            gen.writeStringField('EMAIL5', Email5);
            gen.writeStringField('EMAIL6', Email6);
            gen.writeStringField('EMAIL7', Email7);
            gen.writeStringField('EMAIL8', Email8);
            gen.writeStringField('EMAIL9', Email9);
            gen.writeStringField('EMAIL10', Email10);
            gen.writeStringField('BUBKZ', TDS_BUBKZ);
            gen.writeStringField('PAN1', PAN1);
            if(PAN2 != null)
                gen.writeStringField('PAN2', PAN2);
            else
                gen.writeStringField('PAN2', '');
            gen.writeStringField('PAN3', PAN3);
            gen.writeStringField('PAN4', PAN4);
            gen.writeStringField('PAN5', PAN5);
            gen.writeStringField('GST_NUMBER', GSTNO);
            gen.writeEndObject();
            
            String JBody = gen.getAsString();
            System.debug('Json Body string +++==='+jBody);
            
            if(jBody != '' && jBody != null){
                
                List<SAP_Credentials_Master__c> listSAPCreds = [Select Id, Name, Password__c, URL__c, User_Id__c 
                                                                from SAP_Credentials_Master__c
                                                                where Name =: 'SAP Customer Creation'];
                
                string Endpoint = listSAPCreds[0].URL__c;
                string userid = listSAPCreds[0].User_Id__c;
                string password = listSAPCreds[0].Password__c;
                HttpRequest req = new HttpRequest();
                req.setEndpoint(Endpoint);
                req.setHeader('Content-Type','application/json');
                String authorizationHeader = 'Basic ' +Encodingutil.base64Encode(Blob.valueOf(userid+':'+password));
                req.setHeader('Authorization', authorizationHeader);
                req.setMethod('POST');
                req.setTimeout(120000);
                req.setBody(jBody);
                
                //get the list of header names (keys)
                system.debug('header: ' + req.getHeader('Authorization'));
                system.debug('request :: '+req);
                String ResponceJson = '';
                HTTPResponse res = new HTTPResponse();
                if(!test.isRunningTest()){ 
                    Http http = new Http();
                    res = http.send(req);
                    System.debug(res.getBody());
                    ResponceJson = res.getBody();
                }else{
                    ResponceJson = '[{"TYPE":"E","ID":"AM","NUMBER":132,"MESSAGE":"Please enter a valid form of address","LOG_NO":"","LOG_MSG_NO":0,"MESSAGE_V1":"","MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":""}]';
                    //Dummy ResponceJson
                    /*for(intiger i=0 ; i<=1 ;i++){
                        if(i==1)
                        ResponceJson = '{"TYPE":"S","ID":"F2","NUMBER":174,"MESSAGE":"Customer 0033500273 has been created for company code 1100 sales area 1131 12 10","LOG_NO":"","LOG_MSG_NO":0,"MESSAGE_V1":"0033500273","MESSAGE_V2":"1100","MESSAGE_V3":"1131 12 10","MESSAGE_V4":""}';
                        if(i==2)
                        ResponceJson = '[{"TYPE":"E","ID":"AM","NUMBER":132,"MESSAGE":"Please enter a valid form of address","LOG_NO":"","LOG_MSG_NO":0,"MESSAGE_V1":"","MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":""}]';
                    }*/
                }
                
                
                if(ResponceJson !='' && ResponceJson !=Null){
                    JSON2ApexCostomerCreate r = JSON2ApexCostomerCreate.parse(ResponceJson);
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
                    
                    If(r.TYPE_Z =='S'){
                        
                        
                        TRY{
                            String quoteID = Booklist[0].Quotation__c;
                            if(string.isNotBlank(CustomerCode)){
                                Rest_SAP_Customer_Specific_Pricing scp = new Rest_SAP_Customer_Specific_Pricing();
                                scp.sendSpecificPricingDetailsZPRO(quoteID,'00'+CustomerCode);
                            }
                        }CATCH(Exception e){
                            /*SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                            SILD.API_Name__c = 'Customer specific Pricing';
                            SILD.Booking__c = Booklist[0].id;
                            SILD.Status__c = 'Failed';
                            SILD.Request__c = jBody;
                            SILD.Response__c = ResponceJson;
                            SILD.Error_Message__c = e.getMessage();
                            Insert SILD;*/
                            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+e.getMessage()));
                            return e.getMessage();
                            
                                //System.debug('Your exception message here....'+e.getMessage());
                        }
                        Applist1[0].Customer_Code__c = '00'+CustomerCode;
                        Update Applist1;
                        
                        cs2.Last_Number_Used__c = '00'+CustomerCode;
                        Update cs2;
                        
                        Booklist[0].Customer_Code__c = '00'+CustomerCode;
                        Booklist[0].Pricing_Flown_to_SAP__c = True;
                        Update Booklist;
                        
                        SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                        SILD.API_Name__c = 'Customer Creation';
                        SILD.Booking__c = Booklist[0].id;
                        SILD.Status__c = 'Success';
                        SILD.Request__c = jBody;
                        SILD.Response__c = ResponceJson;
                        Insert SILD;
                    }else{
                        SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                        SILD.API_Name__c = 'Customer Creation';
                        SILD.Booking__c = Booklist[0].id;
                        SILD.Status__c = 'Failed';
                        SILD.Request__c = jBody;
                        SILD.Response__c = ResponceJson;
                        SILD.Error_Message__c = r.MESSAGE;
                        Insert SILD;   
                        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+r.MESSAGE)); 
                        return r.MESSAGE;                
                    }
                }
            }        
        }
       return null;
    
}
}