public class Rest_SAP_Customer_Specific_PricingClass {

    public string customerId {get;set;}
    public string salesOrg {get;set;}
    public string distributionChannel {get;set;}
    public string conditionType {get;set;}
    public string pricingMaterial {get;set;}
    public Decimal lumpsumAmount {get;set;}
    public Decimal unitArea {get;set;}
    Public String QuoteID{get;Set;}
    Public String BookingDate{get;Set;}
    
    
    // sending details for ZPR0 or Basic charge details
    public String sendSpecificPricingDetailsZPRO(Id qId,String custId)
    {    
        String JBody ='';
        customerId = custId;
        lumpsumAmount = 0.00; 
        QuoteID = qId;
        List<SAP_Credentials_Master__c> listSAPCreds = [Select Id,Name, Password__c, URL__c, User_ID__c
        from SAP_Credentials_Master__c where Name =: 'SAP Specific Customer'];
                                                        
        List<Quotation__c> listQuotationDetails = [Select Id, Name, Carpet_Area__c,Project__c, Property__c, Project__r.Sales_Organization__c,
        booking__c,Booking__r.Booking_Date__c,booking__r.Booking_Through__c,booking__r.Customer_Code__c,Property__r.Property_Type__r.Material_No__c, Property__r.Property_Type__r.Saleable_Area__c,
        Charge_1_Name__c,Charge_1_Value_Modified__c, Additional_Car_Park_Applied__c,
        Charge_2_Name__c,Charge_2_Value_Modified__c,
        Charge_3_Name__c,Charge_3_Value_Modified__c,
        Charge_4_Name__c,Charge_4_Value_Modified__c,
        Charge_5_Name__c,Charge_5_Value_Modified__c,
        Charge_6_Name__c,Charge_6_Value_Modified__c,
        Charge_7_Name__c,Charge_7_Value_Modified__c,
        Charge_8_Name__c,Charge_8_Value_Modified__c,
        Charge_9_Name__c,Charge_9_Value_Modified__c,
        Charge_10_Name__c,Charge_10_Value_Modified__c,
        Charge_11_Name__c,Charge_11_Value_Modified__c,
        Charge_12_Name__c,Charge_12_Value_Modified__c,
        Charge_13_Name__c,Charge_13_Value_Modified__c,
        Charge_14_Name__c,Charge_14_Value_Modified__c,
        Charge_15_Name__c,Charge_15_Value_Modified__c
                
        from Quotation__c where id =: qId];
        
        if(!listQuotationDetails.isEmpty()) 
        {
            //customerId = listQuotationDetails[0].booking__r.Customer_Code__c;
            if(listQuotationDetails[0].Project__r.Sales_Organization__c != null){
                salesOrg = listQuotationDetails[0].Project__r.Sales_Organization__c;
            }else{
                salesOrg = '';
            }
            if(listQuotationDetails[0].Booking__r.Booking_Date__c != Null){
                Date d = listQuotationDetails[0].Booking__r.Booking_Date__c;
                String FormatBookingdate =  d.day()+'.'+ d.month()+'.'+d.year();
                BookingDate = FormatBookingdate;
            }else{
                BookingDate = '';
            }
            conditionType = 'ZPR0';
            if(listQuotationDetails[0].Property__r.Property_Type__r.Material_No__c != null)
                pricingMaterial = listQuotationDetails[0].Property__r.Property_Type__r.Material_No__c;
            else
                pricingMaterial = '';
            if(listQuotationDetails[0].Carpet_Area__c != Null)
                unitArea = listQuotationDetails[0].Carpet_Area__c;
            else
                unitArea = 0;
                
            for(integer i=1;i<=15;i++){
                if(listQuotationDetails[0].Additional_Car_Park_Applied__c){
                    if((string)(listQuotationDetails[0].get('Charge_'+i+'_Name__c')) == 'Basic'){
                        if((Decimal)(listQuotationDetails[0].get('Charge_'+i+'_Value_Modified__c')) > 0){
                            lumpsumAmount += (Decimal)(listQuotationDetails[0].get('Charge_'+i+'_Value_Modified__c'));
                        }Else{
                            lumpsumAmount += 0;
                        }
                    }
                    If((string)(listQuotationDetails[0].get('Charge_'+i+'_Name__c')) == 'Car Parking'){
                        if((Decimal)(listQuotationDetails[0].get('Charge_'+i+'_Value_Modified__c')) > 0){
                            lumpsumAmount += (Decimal)(listQuotationDetails[0].get('Charge_'+i+'_Value_Modified__c'));
                        }Else{
                            lumpsumAmount += 0;
                        }
                    } 
                }Else{
                     if((string)(listQuotationDetails[0].get('Charge_'+i+'_Name__c')) == 'Basic'){
                        if((Decimal)(listQuotationDetails[0].get('Charge_'+i+'_Value_Modified__c')) > 0){
                            lumpsumAmount += (Decimal)(listQuotationDetails[0].get('Charge_'+i+'_Value_Modified__c'));
                        }Else{
                            lumpsumAmount += 0;
                        }
                    }                    
                }
            }
        }
        string Endpoint = listSAPCreds[0].URL__c;
        string userid = listSAPCreds[0].User_Id__c;
        string password = listSAPCreds[0].Password__c;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Endpoint);
        req.setHeader('Content-Type','application/json');
        String authorizationHeader = 'Basic ' +Encodingutil.base64Encode(Blob.valueOf(userid+':'+password));
        req.setHeader('Authorization', authorizationHeader);
        req.setMethod('POST');
        if(!listQuotationDetails.isEmpty())
        {    
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('CUST_REF_DATE', BookingDate);
            gen.writeStringField('KUNNR', customerId);
            gen.writeStringField('VKORG',salesOrg);
            if(listQuotationDetails[0].booking__r.Booking_Through__c == 'Partner'){
                gen.writeStringField('VTWEG', '12');
            }Else{
                gen.writeStringField('VTWEG', '11');
            }
            gen.writeStringField('KSCHL', conditionType);
            gen.writeStringField('MATNR', pricingMaterial);
            gen.writeStringField('DMBTR', String.valueof(lumpsumAmount));
            gen.writeStringField('SCMNG', String.valueof(unitArea));
            gen.writeStringField('SCHME', 'FTC');
            gen.writeStringField('RESULT', '');
            gen.writeStringField('MESSAGE', '');
            gen.writeEndObject();
            
            JBody = gen.getAsString();
            System.debug('Json Body string1 +++==='+jBody);
            req.setBody(JBody);            
        }
        //get the list of header names (keys)
        system.debug('header: ' + req.getHeader('Authorization'));
        system.debug('request :: '+req);
        JSON2ApexSapPricing obj = new JSON2ApexSapPricing();
        HTTPResponse res = new HTTPResponse();
        String ResponceBody = '';
        if(!test.isRunningTest()){ 
            Http http = new Http();
            res = http.send(req);
            System.debug(res.getBody());
            ResponceBody = res.getBody();
        }
        Else{
            ResponceBody = '{"CUST_REF_DATE":"27.5.2021","KUNNR":"0033500273","VKORG":"1131","VTWEG":"12","KSCHL":"ZPLC","MATNR":"FL-OEY-SIG","DMBTR":0,"SCMNG":2538.000,"SCHME":"FTC","RESULT":"1","MESSAGE":"Condition record created successfully"}';
        }
        
        obj = JSON2ApexSapPricing.parse(ResponceBody);
        if(obj.RESULT =='1'){
        
            System.debug('obj.RESULT 1 +++==='+ obj.RESULT);                
            sendSpecificPricingDetailsVA0F(qId);
            
            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
            SILD.API_Name__c = 'Customer Specific Pricing - ZPR0';
            SILD.Booking__c = listQuotationDetails[0].Booking__c;
            SILD.Status__c = 'Success';
            SILD.Request__c = jBody;
            SILD.Response__c = res.getBody();
            Insert SILD;
        }Else{
            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
            SILD.API_Name__c = 'Customer Specific Pricing - ZPR0';
            SILD.Booking__c = listQuotationDetails[0].Booking__c;
            SILD.Status__c = 'Failed';
            SILD.Request__c = jBody;
            SILD.Response__c = res.getBody();
            SILD.Error_Message__c = obj.MESSAGE;
            Insert SILD;
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+obj.MESSAGE));  
            return obj.MESSAGE;   
        }
        return null;
    }
    
    // sending details for VA0F or Floor Rise charge details
    public String sendSpecificPricingDetailsVA0F(Id qId)
    {
        String JBody ='';
        lumpsumAmount = 0.00;
        List<SAP_Credentials_Master__c> listSAPCreds = [Select Id, Name,Password__c, URL__c, User_ID__c
                                                        from SAP_Credentials_Master__c 
                                                        where Name =: 'SAP Specific Customer'];
                                                        
        List<Quotation__c> listQuotationDetails = [Select Id, Name,Carpet_Area__c, Project__c, Property__c, Project__r.Sales_Organization__c,
        booking__r.Booking_Through__c,Booking__r.Booking_Date__c,booking__r.Customer_Code__c,Property__r.Property_Type__r.Material_No__c, Property__r.Property_Type__r.Saleable_Area__c,
        Charge_1_Name__c,Charge_1_Value_Modified__c, Additional_Car_Park_Applied__c,
        Charge_2_Name__c,Charge_2_Value_Modified__c,
        Charge_3_Name__c,Charge_3_Value_Modified__c,
        Charge_4_Name__c,Charge_4_Value_Modified__c,
        Charge_5_Name__c,Charge_5_Value_Modified__c,
        Charge_6_Name__c,Charge_6_Value_Modified__c,
        Charge_7_Name__c,Charge_7_Value_Modified__c,
        Charge_8_Name__c,Charge_8_Value_Modified__c,
        Charge_9_Name__c,Charge_9_Value_Modified__c,
        Charge_10_Name__c,Charge_10_Value_Modified__c,
        Charge_11_Name__c,Charge_11_Value_Modified__c,
        Charge_12_Name__c,Charge_12_Value_Modified__c,
        Charge_13_Name__c,Charge_13_Value_Modified__c,
        Charge_14_Name__c,Charge_14_Value_Modified__c,
        Charge_15_Name__c,Charge_15_Value_Modified__c
        
        from Quotation__c where id =: qId];
        
        if(!listQuotationDetails.isEmpty())
        {
            //customerId = listQuotationDetails[0].booking__r.Customer_Code__c;
            salesOrg = listQuotationDetails[0].Project__r.Sales_Organization__c;
            distributionChannel = '11';
            conditionType = 'VA0F';
            if(listQuotationDetails[0].Booking__r.Booking_Date__c != Null){
                Date d = listQuotationDetails[0].Booking__r.Booking_Date__c;
                String FormatBookingdate =  d.day()+'.'+ d.month()+'.'+d.year();
                BookingDate = FormatBookingdate;
            }else{
                BookingDate = '';
            }
            pricingMaterial = listQuotationDetails[0].Property__r.Property_Type__r.Material_No__c;
            if(listQuotationDetails[0].Carpet_Area__c != Null)
                unitArea = listQuotationDetails[0].Carpet_Area__c;
            else
                unitArea = 0;
            
            for(integer i=1;i<=15;i++){
               if((string)(listQuotationDetails[0].get('Charge_'+i+'_Name__c')) == 'Floor Rise'){
                    if((Decimal)(listQuotationDetails[0].get('Charge_'+i+'_Value_Modified__c')) > 0){
                        lumpsumAmount += (Decimal)(listQuotationDetails[0].get('Charge_'+i+'_Value_Modified__c'));
                    }Else{
                        lumpsumAmount += 0;
                    }
                }                    
            }
        }
        string Endpoint = listSAPCreds[0].URL__c;
        string userid = listSAPCreds[0].User_Id__c;
        string password = listSAPCreds[0].Password__c;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Endpoint);
        req.setHeader('Content-Type','application/json');
        String authorizationHeader = 'Basic ' +Encodingutil.base64Encode(Blob.valueOf(userid+':'+password));
        req.setHeader('Authorization', authorizationHeader);
        req.setMethod('POST');
        if(!listQuotationDetails.isEmpty())
        {   
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('CUST_REF_DATE', BookingDate);
            gen.writeStringField('KUNNR', customerId);
            gen.writeStringField('VKORG',salesOrg);
            if(listQuotationDetails[0].booking__r.Booking_Through__c == 'Partner'){
                gen.writeStringField('VTWEG', '12');
            }Else{
                gen.writeStringField('VTWEG', '11');
            }
            gen.writeStringField('KSCHL', conditionType);
            gen.writeStringField('MATNR', pricingMaterial);
            gen.writeStringField('DMBTR', String.valueof(lumpsumAmount));
            gen.writeStringField('SCMNG', String.valueof(unitArea));
            gen.writeStringField('SCHME', 'FTC');
            gen.writeStringField('RESULT', '');
            gen.writeStringField('MESSAGE', '');
            gen.writeEndObject();
            
            JBody = gen.getAsString();
             System.debug('Json Body string2 +++==='+jBody);
            req.setBody(JBody);    
        }
        //get the list of header names (keys)
        system.debug('header: ' + req.getHeader('Authorization'));
        system.debug('request :: '+req);
        
        JSON2ApexSapPricing obj = new JSON2ApexSapPricing();
        HTTPResponse res = new HTTPResponse();
        String ResponceBody = '';
        if(!test.isRunningTest()){ 
            Http http = new Http();
            res = http.send(req);
            System.debug(res.getBody());
            ResponceBody = res.getBody();
        }
        Else{
            ResponceBody = '{"CUST_REF_DATE":"27.5.2021","KUNNR":"0033500273","VKORG":"1131","VTWEG":"12","KSCHL":"ZPLC","MATNR":"FL-OEY-SIG","DMBTR":0,"SCMNG":2538.000,"SCHME":"FTC","RESULT":"1","MESSAGE":"Condition record created successfully"}';
        }
        
        obj = JSON2ApexSapPricing.parse(ResponceBody);
        if(obj.RESULT =='1'){
            System.debug('obj.RESULT 2 +++==='+ obj.RESULT); 
            sendSpecificPricingDetailsZPLC(qId);                
        
            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
            SILD.API_Name__c = 'Customer Specific Pricing - VA0F';
            SILD.Booking__c = listQuotationDetails[0].Booking__c;
            SILD.Status__c = 'Success';
            SILD.Request__c = jBody;
            SILD.Response__c = res.getBody();
            Insert SILD;
        }Else{
            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
            SILD.API_Name__c = 'Customer Specific Pricing - VA0F';
            SILD.Booking__c = listQuotationDetails[0].Booking__c;
            SILD.Status__c = 'Failed';
            SILD.Request__c = jBody;
            SILD.Response__c = res.getBody();
            SILD.Error_Message__c = obj.MESSAGE;
            Insert SILD;
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+obj.MESSAGE));   
            return obj.MESSAGE;
        }
        return null;
    }
    
    // sending details for ZPLC or PLC charge details
    public String sendSpecificPricingDetailsZPLC(Id qId)
    {
        String JBody ='';
        lumpsumAmount = 0.00;
        List<SAP_Credentials_Master__c> listSAPCreds = [Select Id, Name,Password__c, URL__c, User_ID__c
                                                        from SAP_Credentials_Master__c 
                                                        where Name =: 'SAP Specific Customer'];
                                                    
        List<Quotation__c> listQuotationDetails = [Select Id, Name,Carpet_Area__c, Project__c, Property__c, Project__r.Sales_Organization__c,
        booking__r.Booking_Through__c,Booking__r.Booking_Date__c,booking__r.Customer_Code__c,Property__r.Property_Type__r.Material_No__c, Property__r.Property_Type__r.Saleable_Area__c,
        Charge_1_Name__c,Charge_1_Value_Modified__c, Additional_Car_Park_Applied__c,
        Charge_2_Name__c,Charge_2_Value_Modified__c,
        Charge_3_Name__c,Charge_3_Value_Modified__c,
        Charge_4_Name__c,Charge_4_Value_Modified__c,
        Charge_5_Name__c,Charge_5_Value_Modified__c,
        Charge_6_Name__c,Charge_6_Value_Modified__c,
        Charge_7_Name__c,Charge_7_Value_Modified__c,
        Charge_8_Name__c,Charge_8_Value_Modified__c,
        Charge_9_Name__c,Charge_9_Value_Modified__c,
        Charge_10_Name__c,Charge_10_Value_Modified__c,
        Charge_11_Name__c,Charge_11_Value_Modified__c,
        Charge_12_Name__c,Charge_12_Value_Modified__c,
        Charge_13_Name__c,Charge_13_Value_Modified__c,
        Charge_14_Name__c,Charge_14_Value_Modified__c,
        Charge_15_Name__c,Charge_15_Value_Modified__c
                
        from Quotation__c where id =: qId];
        
        if(!listQuotationDetails.isEmpty())
        {
            //customerId = listQuotationDetails[0].booking__r.Customer_Code__c;
            salesOrg = listQuotationDetails[0].Project__r.Sales_Organization__c;
            distributionChannel = '11';
            conditionType = 'ZPLC';
            if(listQuotationDetails[0].Booking__r.Booking_Date__c != Null){
                Date d = listQuotationDetails[0].Booking__r.Booking_Date__c;
                String FormatBookingdate =  d.day()+'.'+ d.month()+'.'+d.year();
                BookingDate = FormatBookingdate;
            }else{
                BookingDate = '';
            }
            pricingMaterial = listQuotationDetails[0].Property__r.Property_Type__r.Material_No__c;
            
            if(listQuotationDetails[0].Carpet_Area__c != Null)
                unitArea = listQuotationDetails[0].Carpet_Area__c;
            else
                unitArea = 0;
                
            for(integer i=1;i<=15;i++){
               if((string)(listQuotationDetails[0].get('Charge_'+i+'_Name__c')) == 'PLC'){
                    if((Decimal)(listQuotationDetails[0].get('Charge_'+i+'_Value_Modified__c')) > 0){
                        lumpsumAmount += (Decimal)(listQuotationDetails[0].get('Charge_'+i+'_Value_Modified__c'));
                    }Else{
                        lumpsumAmount += 0;
                    }
                }                    
            }
        }
        string Endpoint = listSAPCreds[0].URL__c;
        string userid = listSAPCreds[0].User_Id__c;
        string password = listSAPCreds[0].Password__c;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Endpoint);
        req.setHeader('Content-Type','application/json');
        String authorizationHeader = 'Basic ' +Encodingutil.base64Encode(Blob.valueOf(userid+':'+password));
        req.setHeader('Authorization', authorizationHeader);
        req.setMethod('POST');
        if(!listQuotationDetails.isEmpty())
        {   
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('CUST_REF_DATE', BookingDate);
            gen.writeStringField('KUNNR', customerId);
            gen.writeStringField('VKORG',salesOrg);
            if(listQuotationDetails[0].booking__r.Booking_Through__c == 'Partner'){
                gen.writeStringField('VTWEG', '12');
            }Else{
                gen.writeStringField('VTWEG', '11');
            }
            gen.writeStringField('KSCHL', conditionType);
            gen.writeStringField('MATNR', pricingMaterial);
            gen.writeStringField('DMBTR', String.valueof(lumpsumAmount));
            gen.writeStringField('SCMNG', String.valueof(unitArea));
            gen.writeStringField('SCHME', 'FTC');
            gen.writeStringField('RESULT', '');
            gen.writeStringField('MESSAGE', '');
            gen.writeEndObject();
            
            JBody = gen.getAsString();
             System.debug('Json Body string3 +++==='+jBody);
            req.setBody(JBody);     
        }
        //get the list of header names (keys)
        system.debug('header: ' + req.getHeader('Authorization'));
        system.debug('request :: '+req);
        
        JSON2ApexSapPricing obj = new JSON2ApexSapPricing();
        HTTPResponse res = new HTTPResponse();
        String ResponceBody = '';
        if(!test.isRunningTest()){ 
            Http http = new Http();
            res = http.send(req);
            System.debug(res.getBody());
            ResponceBody = res.getBody();
        }
        Else{
            ResponceBody = '{"CUST_REF_DATE":"27.5.2021","KUNNR":"0033500273","VKORG":"1131","VTWEG":"12","KSCHL":"ZPLC","MATNR":"FL-OEY-SIG","DMBTR":0,"SCMNG":2538.000,"SCHME":"FTC","RESULT":"1","MESSAGE":"Condition record created successfully"}';
        }
        
        obj = JSON2ApexSapPricing.parse(ResponceBody);
        if(obj.RESULT =='1'){
            System.debug('obj.RESULT 3 +++==='+ obj.RESULT);                
            Mark(customerId);                
            
            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
            SILD.API_Name__c = 'Customer Specific Pricing - ZPLC';
            SILD.Booking__c = listQuotationDetails[0].Booking__c;
            SILD.Status__c = 'Success';
            SILD.Request__c = jBody;
            SILD.Response__c = res.getBody();
            Insert SILD;
        }Else{
            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
            SILD.API_Name__c = 'Customer Specific Pricing - ZPLC';
            SILD.Booking__c = listQuotationDetails[0].Booking__c;
            SILD.Status__c = 'Failed';
            SILD.Request__c = jBody;
            SILD.Response__c = res.getBody();
            SILD.Error_Message__c = obj.MESSAGE;
            Insert SILD;
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+obj.MESSAGE));  
            return obj.MESSAGE;
        }
        return null;
    }
    
    Public String Mark(String custId){
    
    List<Booking__c> Booklist = New List<Booking__c>();
    Booklist = [Select Id,Name,Opportunity__c,Pricing_Flown_to_SAP__c ,Booking_Through__c,Opportunity__r.AccountId,Project__c,Project__r.Plant__c,Tower__r.Customer_A_C_Group__c, Sales_Document_SAP__c,
                        Project__r.Sales_Organization__c,Property__r.House_Unit_No__c,Project__r.Company_name__c,Project__r.GST_No__c,Tower_Name__c,
                        status__c,Doc_Verification_Status__c,Property__c,Property__r.Site_Support__c,Property__r.Central_Support__c,Site_Support__c,
                        Central_Support__c
                         FROM Booking__c Where Quotation__c =: QuoteID];
    
    TRY{
       /* if(string.isBlank(Booklist[0].Sales_Document_SAP__c) && string.isNotBlank(custId)){
            Rest_SAP_Sales_Order_Creation ssoc = new Rest_SAP_Sales_Order_Creation();
            ssoc.createSalesOrder(Booklist[0].id,custId);        
        }*/
        Booklist[0].status__c = 'Booking In Process';
        Booklist[0].Doc_Verification_Status__c = 'Level 1 Pending';
        Booklist[0].Pricing_Flown_to_SAP__c = True;
        Booklist[0].Site_Support__c = Booklist[0].Property__r.Site_Support__c;
        Booklist[0].Central_Support__c = Booklist[0].Property__r.Central_Support__c;
        
        Update Booklist;
        Property__c pr = new Property__c();
        pr.id = Booklist[0].Property__c;
        pr.Status__c = 'BIP - Sales';
        update pr;
        if(Booklist[0].Site_Support__c != null){
        Task tsk = new Task();
        tsk.Subject = 'Document For level One verification is due For this Booking';
        tsk.OwnerId = Booklist[0].Site_Support__c;
        tsk.Status = 'New';
        tsk.ActivityDate = System.today() +1;
        tsk.WhatId = Booklist[0].id;
        insert tsk;
        }
        
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,'Booking Has Been Processed Sucessfully.'));
        return 'Booking Has Been Processed Sucessfully.';
    }CATCH(Exception e){
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+e.getMessage()));
           
            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
            SILD.API_Name__c = 'Customer Specific Pricing';
            SILD.Booking__c = Booklist [0].id;
            SILD.Status__c = 'Failed';
            // SILD.Request__c = jBody;
            //SILD.Response__c = res.getBody();
            SILD.Error_Message__c = e.getMessage();
            Insert SILD;
         return e.getMessage();
        //System.debug('Your exception message here....'+e.getMessage());
    }
    
    } 

}