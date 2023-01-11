public class Rest_SAP_Sales_Order_Creation{
    public string SO_NUMBER {set;get;}
    public string DOC_TYPE{set;get;}
    public string VKORG {set;get;}
    public string VTWEG  {set;get;}
    public string SPRAT {set;get;}
    public string CUST_REF_NO {set;get;}
    public string CUST_REF_DATE {set;get;}
    public string PROJECT_ID {set;get;}
    public string TOWER {set;get;}
    public string KUNNR {set;get;}
    public string LIFNR {set;get;}
    public string BROKER_PERCENT {set;get;}
    public string ORDER_REASON {set;get;}
    public string NOC_BANK_NAME {set;get;}
    public string MARKET_VALUE {set;get;}
    public string STAMP_DUTY {set;get;}
    public string NOC_DATE {set;get;}
    public string REG_DATE {set;get;}
    public string SFDC_ID {set;get;}
    public Decimal NET_VALUE {set;get;}
    public string TAX {set;get;}
    public string SALE_VALUE {set;get;}
    public string POSNR {set;get;}
    public string MATNR {set;get;}
    public string ZMENG {set;get;}
    public string ZIEME {set;get;}
    public string KWMENG {set;get;}
    public string ITEM_NUMBER {set;get;}
    public string COND_TYPE {set;get;}
    public string COND_RATE {set;get;}
    public string FPLNR {set;get;}
    public string FPLTR {set;get;}
    public string Billing_date {set;get;}
    public string date_description {set;get;}
    public string usage_milestone {set;get;}
    public string billing_rule {set;get;}
    public string percentage {set;get;}
    public string billing_value {set;get;}
    public string MLSTN {set;get;}
    public string ZTERM {set;get;}
    public string customerId{set;get;}
    public string VAN{set;get;}
    public List < Quotation__c > QuoteDetails {get;set;}
    public List <Channel_Partner_Project__c > CPProjetList {get;set;}
    
    
    public void createSalesOrder(Id bId , String custId)
    {
        //Id bId = 'a00p000000A0BLQ';
        customerId = custId;
        List<Car_Parking__c> totalAdditionalCarParkAvailable = new List<Car_Parking__c>();
        Map<String,Integer> totalAdditionalCarParkAvailableMap = new Map<String,Integer>();
        Map<String,Decimal> totalAdditionalCarParkRequiredMap = new Map<String,Decimal>();
        List<Car_Parking__c> totalEarmarkedCarParkAvailable = new List<Car_Parking__c>();
        Map<String,Integer> totalEarmarkedCarParkAvailableMap = new Map<String,Integer>();
        Map<String,Decimal> totalEarmarkedCarParkRequiredMap = new Map<String,Decimal>();
        
        string count = 'Car_Park_Count_';
        string type = 'Car_Park_Type_';
        
        List<SAP_Credentials_Master__c> listSAPCreds = [Select Id,Name, Password__c, URL__c, User_ID__c
                                                        from SAP_Credentials_Master__c 
                                                        where Name =: 'Sales Order Creation'];
        
        List<Booking__c> bkList = [Select Id, Name,Opportunity__c,Booking_Through__c,Opportunity__r.Brokerage_Percentage__c,Opportunity__r.AccountId,Project__c,Project__r.Plant__c,Tower__r.Customer_A_C_Group__c,
                                   Booking_Date__c,Project__r.Sales_Organization__c,Opportunity__r.Broker_Account__c,Vendor_Code__c,Property__r.House_Unit_No__c,Property__r.Material_No__c,Project__r.Company_name__c,Project__r.GST_No__c,Tower_Name__c,
                                   Quotation__c,Quotation__r.Billing_Plan__r.Payment_Plan_Type__c,Project__r.Broker_Percentage__c,
                                   Quotation__r.Car_Park_Type_1__c, Quotation__r.Car_Park_Count_1__c, Quotation__r.Car_Park_Type_2__c, Quotation__r.Car_Park_Count_2__c,
                                   Quotation__r.Car_Park_Type_3__c, Quotation__r.Car_Park_Count_3__c,Quotation__r.Car_Park_Type_4__c, Quotation__r.Car_Park_Count_4__c,
                                   Quotation__r.Car_Park_Type_5__c, Quotation__r.Car_Park_Count_5__c,Quotation__r.TotalAdditionalCarpark__c,Property__r.Carpet_Area__c,
                                   Property__r.Property_Type__r.Material_No__c, Tower__r.Name,Agreement_Value__c,Customer_Code__c,Sales_Document_SAP__c,Virtual_Account_Number__c
                                   from Booking__c 
                                   where Id =: bId];
        if(bkList.size() > 0){
            QuoteDetails = [SELECT id,Name,Booking__c,Effective_Sale_Price__c,Token_Amount__c, ST_Token_Amount__c,Car_Park_Type_1__c,Car_Park_Type_2__c,Car_Park_Type_3__c,Car_Park_Type_4__c,Car_Park_Type_5__c, 
                            Earmarked_Car_Parking_Count_1__c,Earmarked_Car_Parking_Count_2__c,Earmarked_Car_Parking_Count_3__c,Earmarked_Car_Parking_Count_4__c,Earmarked_Car_Parking_Count_5__c,
                            Earmarked_Car_Parking_Type_1__c,Earmarked_Car_Parking_Type_2__c,Earmarked_Car_Parking_Type_3__c,Earmarked_Car_Parking_Type_4__c,Earmarked_Car_Parking_Type_5__c,
                            TotalAdditionalCarpark__c,Car_Park_Count_1__c,Total_CSGT_Modified__c,Total_SGST_Modified__c,Car_Park_Count_2__c,Total_Agreement_Value_Modified__c,Car_Park_Count_3__c,Car_Park_Count_4__c,Car_Park_Count_5__c
                            
                            FROM Quotation__c WHERE Id = : bkList[0].Quotation__c];
            
            totalAdditionalCarParkAvailable = [Select id,Status__c,Name,Type__c From Car_Parking__c where Additional_Earmarked__c = 'Additional' And Status__c = 'Allotted' and Project__c =: bkList[0].Project__c];
            totalEarmarkedCarParkAvailable  = [Select id,Status__c,Name,Type__c From Car_Parking__c where Additional_Earmarked__c = 'Earmarked' And Status__c = 'Allotted' and Project__c =: bkList[0].Project__c];
            
            /*if(bkList[0].Booking_Through__c == 'Partner'){
                CPProjetList = [Select Id, Name,account__c,account__r.Broker_Code__c FROM Channel_Partner_Project__c WHERE Project__c =:bkList[0].Project__c AND account__r.Broker_Code__c =:bkList[0].Vendor_Code__c];
                if(CPProjetList.size() > 0){
                
                }else{
                    System.debug('Error Occured'+' Channel Partner Project dose not exist For this Broker and this project');
                    ////////////Create Channel Partner Project with Booking projet/
                    Channel_Partner_Project__c CPProj = new Channel_Partner_Project__c ();
                    CPProj.Account__c = bkList[0].Opportunity__r.Broker_Account__c;
                    CPProj.Project__c = bkList[0].Project__c;
                    insert CPProj;
                    List<Account> a = [Select Id, Name,Broker_Code__c From Account Where Id =: bkList[0].Opportunity__r.Broker_Account__c];
                    REST_SAP_CP_Extend.ExtendCP(a[0]);
                }
            }*/
                
            if(!totalAdditionalCarParkAvailable.isEmpty()) {
                for(Car_Parking__c cp : totalAdditionalCarParkAvailable){
                    Integer i = 0;
                    if(totalAdditionalCarParkAvailableMap.containskey(cp.Type__c)){
                        i = totalAdditionalCarParkAvailableMap.get(cp.Type__c);
                        i = i+1;
                        totalAdditionalCarParkAvailableMap.put(cp.Type__c,i);                                
                    }else{
                        i = 1;
                        totalAdditionalCarParkAvailableMap.put(cp.Type__c,i); 
                    }     
                }     
            }
            
            if(!totalAdditionalCarParkAvailable.isEmpty()) {
                for(Car_Parking__c cp : totalAdditionalCarParkAvailable){
                    Integer i = 0;
                    if(totalEarmarkedCarParkAvailableMap .containskey(cp.Type__c)){
                        i = totalEarmarkedCarParkAvailableMap.get(cp.Type__c);
                        i = i+1;
                        totalEarmarkedCarParkAvailableMap.put(cp.Type__c,i);                                
                    }else{
                        i = 1;
                        totalEarmarkedCarParkAvailableMap.put(cp.Type__c,i); 
                    }     
                }     
            }
            
            for(integer i = 1;i <= 5; i++){
                if((Decimal)(QuoteDetails[0].get(count+i+'__c')) != null && (QuoteDetails[0].get(type+i+'__c') != null)){
                    if((Decimal)(QuoteDetails[0].get(count+i+'__c')) > 0){
                        
                        totalAdditionalCarParkRequiredMap.put((String)QuoteDetails[0].get(type+i+'__c'),(Decimal)QuoteDetails[0].get(count+i+'__c'));
                    }                      
                }
                if((Decimal)(QuoteDetails[0].get('Earmarked_Car_Parking_Count_' + i + '__c')) != null && (QuoteDetails[0].get('Earmarked_Car_Parking_Type_' + i + '__c') != null)){
                    if((Decimal)(QuoteDetails[0].get('Earmarked_Car_Parking_Count_' + i + '__c')) > 0){
                        
                        totalEarmarkedCarParkRequiredMap.put((String)QuoteDetails[0].get('Earmarked_Car_Parking_Type_' + i + '__c'),(Decimal)QuoteDetails[0].get('Earmarked_Car_Parking_Count_' + i + '__c'));
                    }                      
                }
            }     
            System.debug('totalAdditionalCarParkRequiredMap: '+totalAdditionalCarParkRequiredMap);
            System.debug('Total Car park available:: '+ totalAdditionalCarParkAvailable);
            
            List<Car_Parking__c> TempCPList = new List<Car_Parking__c>();
            List<Car_Parking__c> cpList = new List<Car_Parking__c>();
            if(!totalAdditionalCarParkRequiredMap.isEmpty()) {
                for(string s : totalAdditionalCarParkRequiredMap.keySet()) {
                    
                    Integer carParkCount = Integer.valueOf(totalAdditionalCarParkRequiredMap.get(s));
                    
                    TempCPList = [Select id,Status__c,Name,Type__c From Car_Parking__c 
                                  where Type__c =: s and Status__c = 'Allotted' 
                                  and Project__c =: bkList[0].Project__c
                                  LIMIT :carParkCount];
                    cpList.addAll(TempCPList);                      
                }
                system.debug(cpList);
            }
            if(!totalEarmarkedCarParkRequiredMap.isEmpty()) {
                for(string s : totalEarmarkedCarParkRequiredMap.keySet()) {
                    
                    Integer carParkCount = Integer.valueOf(totalEarmarkedCarParkRequiredMap.get(s));
                    
                    TempCPList = [Select id,Status__c,Name,Type__c From Car_Parking__c 
                                  where Type__c =: s and Status__c = 'Allotted' 
                                  and Project__c =: bkList[0].Project__c
                                  LIMIT :carParkCount];
                    cpList.addAll(TempCPList);                      
                }
                system.debug(cpList);
            }
            
            string request = '{"SO_NUMBER": "","DOC_TYPE": "ZSCE","VKORG": "4731","VTWEG": "11","SPART": "10","VKBUR": "4786","VKGRP": "131","CUST_REF_NO": "NON SCHEME","CUST_REF_DATE": "27.01.2021","PROJECT_ID": "4789","TOWER": "E",'+
                '"KUNNR": "0042001386","LIFNR": "","BROKER_PERCENT": 0,"ORDER_REASON": "501","NOC_BANK_NAME": "003","MARKET_VALUE": 30000000.00,"STAMP_DUTY": 0,'+
                '"NOC_DATE": "00.00.0000","REG_DATE": "00.00.0000","SFDC_ID": "5000000000","NET_VALUE": 25500000.00,"TAX": 5820029.10,"SALE_VALUE": 31320029.10,"ORDER_ITEMS": ['+
                '{"POSNR": 10,"MATNR": "OSC-E-1204","ZMENG": 1034.000,"ZIEME": "EA","KWMENG": 0},{"POSNR": 20,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0},'+
                '{"POSNR": 30,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0},{"POSNR": 40,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0'+
                '},{"POSNR": 50,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0},{"POSNR": 60,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0'+
                '},{"POSNR": 70,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0},{"POSNR": 80,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0'+
                '},{"POSNR": 90,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0}],"ORDER_CONDITIONS": [],"BILLING_PLAN": [],"MESSAGE": ""}';
            
            string materialNumber = bkList[0].Property__r.Material_No__c;
            Decimal saleableArea = bkList[0].Property__r.Carpet_Area__c;
            
            Decimal cc = 10;
            
            JSONGenerator gen = JSON.createGenerator(true);
            // Write data to the JSON string.
            gen.writeStartObject();
            gen.writeStringField('SO_NUMBER', '');
            gen.writeStringField('DOC_TYPE','ZSCE');
            
            if(bkList[0].Project__r.Sales_Organization__c != Null && bkList[0].Project__r.Sales_Organization__c !=''){
                gen.writeStringField('VKORG', bkList[0].Project__r.Sales_Organization__c);
            }else{
                gen.writeStringField('VKORG', '');
            }
            
            if(bkList[0].Booking_Through__c == 'Partner'){
                gen.writeStringField('VTWEG', '12');
                
                if(bkList[0].Vendor_Code__c != Null && bkList[0].Vendor_Code__c !=''){
                    gen.writeStringField('LIFNR',bkList[0].Vendor_Code__c);
                }else{
                    gen.writeStringField('LIFNR','');
                }
                if(bkList[0].Project__r.Broker_Percentage__c != Null && bkList[0].Project__r.Broker_Percentage__c !=0){
                    gen.writeNumberField('BROKER_PERCENT',bkList[0].Project__r.Broker_Percentage__c);
    
                }else{
                    gen.writeNumberField('BROKER_PERCENT',0);
    
                }
            }Else{
                gen.writeStringField('VTWEG', '11');
                gen.writeStringField('LIFNR','');
                gen.writeNumberField('BROKER_PERCENT',0);
            }
            
            gen.writeStringField('SPART','10');
            gen.writeStringField('VKBUR','');
            gen.writeStringField('VKGRP','');
            if(bkList[0].Quotation__r.Billing_Plan__r.Payment_Plan_Type__c != '' && bkList[0].Quotation__r.Billing_Plan__r.Payment_Plan_Type__c != Null){
                gen.writeStringField('CUST_REF_NO',bkList[0].Quotation__r.Billing_Plan__r.Payment_Plan_Type__c);
            }Else{ 
                gen.writeStringField('CUST_REF_NO','');
            }
            
            if(bkList[0].Booking_Date__c != Null){
                Date d = bkList[0].Booking_Date__c;
                String FormatBookingdate =  d.day()+'.'+ d.month()+'.'+d.year();
                gen.writeStringField('CUST_REF_DATE',FormatBookingdate);
            }else{
                gen.writeStringField('CUST_REF_DATE','');
            }
            
            if(bkList[0].Project__r.Plant__c != Null && bkList[0].Project__r.Plant__c !=''){
                gen.writeStringField('PROJECT_ID',bkList[0].Project__r.Plant__c);
            }else{
                gen.writeStringField('PROJECT_ID','');
            }
            
            if(bkList[0].Tower_Name__c != Null && bkList[0].Tower_Name__c !=''){
                gen.writeStringField('TOWER',bkList[0].Tower_Name__c);
            }else{
                gen.writeStringField('TOWER','');
            }
            
            if(bkList[0].Virtual_Account_Number__c != Null && bkList[0].Virtual_Account_Number__c !=''){
                gen.writeStringField('VAN',bkList[0].Virtual_Account_Number__c);
            }else{
                gen.writeStringField('VAN','');
            }
            
            if(customerId != Null && customerId !=''){
                gen.writeStringField('KUNNR',customerId);
            }else{
                gen.writeStringField('KUNNR','');
            }
            
            gen.writeStringField('ORDER_REASON','501');
            gen.writeStringField('NOC_BANK_NAME','');
            
            gen.writeNumberField('MARKET_VALUE',0);
            
            
            gen.writeNumberField('STAMP_DUTY',0);
            gen.writeStringField('NOC_DATE','00.00.0000');
            gen.writeStringField('REG_DATE','00.00.0000');
            
            //if(bkList[0].Id != Null && bkList[0].Id !=''){
            gen.writeStringField('SFDC_ID',bkList[0].Id);//'5000000000');
            //}Else{
            // gen.writeStringField('SFDC_ID','');//'5000000000');
            //}
            
            if(QuoteDetails[0].Total_Agreement_Value_Modified__c != Null){
                gen.writeNumberField('NET_VALUE',QuoteDetails[0].Total_Agreement_Value_Modified__c);
            }Else{
                gen.writeNumberField('NET_VALUE',0);
            }
            
            if(QuoteDetails[0].Total_SGST_Modified__c != Null && QuoteDetails[0].Total_CSGT_Modified__c != Null){
                gen.writeNumberField('TAX',QuoteDetails[0].Total_SGST_Modified__c + QuoteDetails[0].Total_CSGT_Modified__c);
            }Else{
                gen.writeNumberField('TAX',0);
            }
            
            
            if(QuoteDetails[0].Effective_Sale_Price__c != Null){
                gen.writeNumberField('SALE_VALUE',QuoteDetails[0].Effective_Sale_Price__c);
            }Else{
                gen.writeNumberField('SALE_VALUE',0);
            }
            
            gen.writeFieldName('ORDER_ITEMS');
            gen.writeStartArray();
            
            gen.writeStartObject();
            
            gen.writeNumberField('POSNR',cc);
            if(materialNumber != Null && materialNumber  !=''){
                gen.writeStringField('MATNR',materialNumber);//'OSC-E-1204');
            }Else{
                gen.writeStringField('MATNR','');//'OSC-E-1204');
            }
            
            if(saleableArea != Null){
                gen.writeNumberField('ZMENG',saleableArea);
            }Else{
                gen.writeNumberField('ZMENG',0);//'OSC-E-1204');
            }
            gen.writeStringField('ZIEME','EA');
            gen.writeNumberField('KWMENG',0);
            gen.writeEndObject();    
            for(Car_parking__c cp : cpList)
            {
                //Decimal i = 10;
                cc = cc + 10;
                gen.writeStartObject();
                gen.writeNumberField('POSNR',cc);
                if(cp.Name != Null && cp.Name !=''){
                    gen.writeStringField('MATNR',cp.Name);//cp.name);
                }else{
                    gen.writeStringField('MATNR','');//cp.name);
                }
                gen.writeNumberField('ZMENG',1.00 );
                gen.writeStringField('ZIEME','EA');
                gen.writeNumberField('KWMENG',0);
                gen.writeEndObject();
            }
            
            
            gen.writeEndArray();
            gen.writeFieldName('ORDER_CONDITIONS');
            gen.writeStartArray();
            
            gen.writeEndArray();
            gen.writeFieldName('BILLING_PLAN');
            gen.writeStartArray();
            
            gen.writeEndArray();
            gen.writeStringField('MESSAGE','');
            gen.writeEndObject();
            
            String JBody = gen.getAsString();
            system.debug('Body::'+JBody);
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
            req.setTimeout(60000);
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
            ResponceBody = '{"SO_NUMBER":"1232431","DOC_TYPE":"ZEYA","VKORG":"1131","VTWEG":"12","SPART":"10","VKBUR":"","VKGRP":"","CUST_REF_NO":"Scheme","CUST_REF_DATE":"27.5.2021","PROJECT_ID":"11AM","TOWER":"A","KUNNR":"0033500273","LIFNR":"0033101444","BROKER_PERCENT":2.00,"ORDER_REASON":"501","NOC_BANK_NAME":"","MARKET_VALUE":0,"STAMP_DUTY":0,"NOC_DATE":"00.00.0000","REG_DATE":"00.00.0000","SFDC_ID":"a00p000000AQI9IAAX","NET_VALUE":99322252.00,"TAX":4966138.00,"SALE_VALUE":0,"ORDER_ITEMS":[{"POSNR":10,"MATNR":"OEY-A-4801","ZMENG":2538.000,"ZIEME":"EA","KWMENG":0},{"POSNR":20,"MATNR":"OEY-CP-TANDEM","ZMENG":1.000,"ZIEME":"EA","KWMENG":0},{"POSNR":30,"MATNR":"OEY-CP-SINGLE","ZMENG":1.000,"ZIEME":"EA","KWMENG":0},{"POSNR":40,"MATNR":"OEY-CP-TANDEM","ZMENG":1.000,"ZIEME":"EA","KWMENG":0}],"ORDER_CONDITIONS":[],"BILLING_PLAN":[],"MESSAGE":"Sales Order created successfully"}';
            }
            JSONToApexSOCreate r = JSONToApexSOCreate.parse(ResponceBody);
            system.debug('ssss::: '+ r);
            system.debug(r.SO_NUMBER);
            if(r.SO_NUMBER !='' && r.SO_NUMBER != null){
                
                TRY{
                    if(string.isNotBlank(r.SO_NUMBER)){
                        Rest_Customer_Specific_BillingPlan CSP = new Rest_Customer_Specific_BillingPlan();
                        CSP.FLowBillinDetails(QuoteDetails[0].id , r.SO_NUMBER);
                    }
                    
                    bkList[0].Sales_Document_SAP__c = r.SO_NUMBER;
                    bkList[0].SO_JSON__c = JBody+'<br>Request End<br><br> Static Request::<br>'+request;
                    update bkList;
                    
                    SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                    SILD.API_Name__c = 'Sales Order Creation';
                    SILD.Booking__c = bkList[0].id;
                    SILD.Status__c = 'Success';
                    SILD.Request__c = jBody;
                    SILD.Response__c = ResponceBody;
                    
                    Insert SILD;
                    //return r.SO_NUMBER;
                    
                }CATCH(Exception e){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+e.getMessage()));
                    SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                    SILD.API_Name__c = 'Sales Order Creation';
                    SILD.Booking__c = bkList[0].id;
                    SILD.Status__c = 'Failed';
                    SILD.Request__c = jBody;
                    SILD.Response__c = ResponceBody;
                    SILD.Error_Message__c = e.getMessage();
                    Insert SILD; 
                    //System.debug('Your exception message here....'+e.getMessage());
                }
            }else{
                system.debug('inside SO number blank condition');
                SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                SILD.API_Name__c = 'Sales Order Creation';
                SILD.Booking__c = bkList[0].id;
                SILD.Status__c = 'Failed';
                SILD.Request__c = jBody;
                SILD.Response__c = ResponceBody;
                SILD.Error_Message__c = r.MESSAGE;
                Insert SILD; 
                if(string.isNotBlank(r.MESSAGE))
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+r.MESSAGE));
                else
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Sales Order number is blank.'));    
            }
        }
    }
    
    
}