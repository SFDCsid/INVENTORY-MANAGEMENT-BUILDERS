public class Rest_PUT_SAP_Sales_Order_Updation {
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
    public Decimal BROKER_PERCENT {set;get;}
    public string ORDER_REASON {set;get;}
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
   
    public string MLSTN {set;get;}
    public string ZTERM {set;get;}
    public string NOC_BANK_NAME {set;get;}
    public string MARKET_VALUE {set;get;}
    public string STAMP_DUTY {set;get;}
    public string NOC_DATE {set;get;}
    public string MNOC_DATE{set;get;}
    public string ALLOTMENT_DATE{set;get;}
    public string AGREEMENT_DATE{set;get;}
    public string REG_DATE {set;get;}       
    public string REG_SR_NO{set;get;}
    public string LOAN_AMOUNT{set;get;}
    public string LOAN_ROI{set;get;}
    public string LOAN_TENURE{set;get;}
    public string PARALLEL_FUNDING{set;get;}
    public string LL_NOC_DATE{set;get;}
    public string LL_NOC_PERIOD{set;get;}
    public string PER_MONTH_RENT{set;get;}
    public string SECURITY_DEPOSIT{set;get;}
    public string FLAT_STATUS{set;get;}
    public string POSS_DATE{set;get;}
    public string POSS_DONE{set;get;}
    public string SCHEME_CHANGE_DATE{set;get;}
  
    public string customerId{set;get;}
    public string SAPSONO{set;get;}
    public string VAN{set;get;}
    
    public List < Quotation__c > QuoteDetails {get;set;}
    //public List <Channel_Partner_Project__c > CPProjetList {get;set;}
    
    public void updateSalesOrder(Id bId){
        
        List<SAP_Credentials_Master__c> listSAPCreds = [Select Id,Name, Password__c, URL__c, User_ID__c
                                                        from SAP_Credentials_Master__c 
                                                        where Name =: 'Sales Order Creation']; //Sales Order Updation
        
        List<Booking__c> bkList = [Select Id, Name,Sales_Document_SAP__c,Booking_Through__c,Provisional_NOC_Bank_Name__c,Market_Value__c,
                                   Stampduty_Charges__c,NOC_Date__c,MNOC_date__c,Allotment_Date__c,Property__r.Material_No__c,
                                   Agreement_Date__c,Registration_Date__c,Registration_Serial_Number__c,
                                   Loan_Amount__c,LOAN_ROI__c,Loan_Tenure__c,Parallel_Funding__c,Quotation__c,
                                   LL_NOC_DATE__c,LL_Noc_Period__c,Per_Month_Rent__c,Security_Deposit__c,
                                   Flat_Status__c,Possession_Date__c,Possession_Done__c,Scheme_Change_Date__c,
                                   Registration_Charge__c,Parallel_FundingP__c,ROFR_Notice_Date__c,ROFR_Notice_RA_Date__c,ROFR_Resale_Consideration__c,
                                   ROFR_TNOC_Date__c,ROFR_Sale_Consideration__c,Booking_Cancellation_Code__c,
                                   Project__r.Sales_Organization__c,Quotation__r.Billing_Plan__r.Payment_Plan_Type__c, Booking_Date__c,Project__r.Plant__c,
                                   Tower_Name__c,Vendor_Code__c,Project__r.Broker_Percentage__c,Property__r.Carpet_Area__c,
                                   Property__r.Property_Type__r.Material_No__c, Tower__r.Name,Agreement_Value__c,Customer_Code__c,Virtual_Account_Number__c                                 
                                   from Booking__c where Id =: bId]; 
        if(bkList.size() > 0){
            QuoteDetails = [SELECT id,Name,Booking__c,Effective_Sale_Price__c,Total_CSGT_Modified__c,Total_SGST_Modified__c,Total_Agreement_Value_Modified__c FROM Quotation__c WHERE Id = : bkList[0].Quotation__c];
            
            string request = '{"SO_NUMBER": "","DOC_TYPE": "ZSCE","VKORG": "4731","VTWEG": "11","SPART": "10","VKBUR": "4786","VKGRP": "131","CUST_REF_NO": "NON SCHEME","CUST_REF_DATE": "27.01.2021","PROJECT_ID": "4789","TOWER": "E",'+
                '"KUNNR": "0042001386","LIFNR": "","BROKER_PERCENT": 0,"ORDER_REASON": "501", "NOC_BANK_NAME": "003","MARKET_VALUE": .00,"STAMP_DUTY": 0,'+
                '"NOC_DATE": "00.00.0000","REG_DATE": "00.00.0000", "MNOC_DATE": "" , "ALLOTMENT_DATE": "", "AGREEMENT_DATE": "", "REG_SR_NO": "","LOAN_AMOUNT": 0,"LOAN_ROI": 0,"LOAN_TENURE": 0,"PARALLEL_FUNDING": "","LL_NOC_DATE": "","LL_NOC_PERIOD": 0,"PER_MONTH_RENT": 0,"SECURITY_DEPOSIT": 0,"FLAT_STATUS": "","POSS_DATE": "","POSS_DONE": "","SCHEME_CHANGE_DATE": "", "SFDC_ID": "5000000000","NET_VALUE": 25500000.00,"TAX": 5820029.10,"SALE_VALUE": 31320029.10,"ORDER_ITEMS": ['+
                '{"POSNR": 10,"MATNR": "OSC-E-1204","ZMENG": 1034.000,"ZIEME": "EA","KWMENG": 0},{"POSNR": 20,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0},'+
                '{"POSNR": 30,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0},{"POSNR": 40,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0'+
                '},{"POSNR": 50,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0},{"POSN30000000R": 60,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0'+
                '},{"POSNR": 70,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0},{"POSNR": 80,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0'+
                '},{"POSNR": 90,"MATNR": "OSC-CE-TANDEM","ZMENG": 1.000,"ZIEME": "EA","KWMENG": 0}],"ORDER_CONDITIONS": [],"BILLING_PLAN": [],"MESSAGE": ""}';
            
            
            // string materialNumber = bkList[0].Property__r.Material_No__c;
            // Decimal saleableArea = bkList[0].Property__r.Carpet_Area__c; 
            SAPSONO = bkList[0].Sales_Document_SAP__c;
                        
            JSONGenerator gen = JSON.createGenerator(true);
            // Write data to the JSON string.
            gen.writeStartObject();
            if(SAPSONO != ''){
                gen.writeStringField('SO_NUMBER', SAPSONO);
            }
            Else{
                gen.writeStringField('SO_NUMBER', '');
            }
            
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
                String FormatBookingdate =  DateTime.newInstance(d.year(),d.month(),d.day()).format('dd.MM.yyyy');
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
            
            /*if(customerId != Null && customerId !=''){
                gen.writeStringField('KUNNR',customerId);
            }else{
                gen.writeStringField('KUNNR','');
            }*/
            
            if(bkList[0].Customer_Code__c!= Null && bkList[0].Customer_Code__c!=''){
                gen.writeStringField('KUNNR',bkList[0].Customer_Code__c);
            }else{
                gen.writeStringField('KUNNR','');
            }
            
            if(bkList[0].Booking_Cancellation_Code__c != Null && bkList[0].Booking_Cancellation_Code__c !=''){
                gen.writeStringField('ORDER_REASON',bkList[0].Booking_Cancellation_Code__c);
            }else{
                gen.writeStringField('ORDER_REASON','');
            }
             
            gen.writeStringField('POSS_CHECKLIST_DATE','');
            gen.writeStringField('CURRENT_SCHEME','');
            gen.writeStringField('CHANGE_OF_SCHEME','');
            
            if(bkList[0].ROFR_Notice_Date__c != Null){
                Date d = bkList[0].ROFR_Notice_Date__c;
                String FormatROFR_Notice_Date =  DateTime.newInstance(d.year(),d.month(),d.day()).format('dd.MM.yyyy');
                gen.writeStringField('ROFR_NOTICE_DATE',FormatROFR_Notice_Date);
            }else{
                gen.writeStringField('ROFR_NOTICE_DATE','');
            }
            
            if(bkList[0].ROFR_Notice_RA_Date__c != Null){
                Date d = bkList[0].ROFR_Notice_RA_Date__c;
                String FormatROFR_Notice_RA =  DateTime.newInstance(d.year(),d.month(),d.day()).format('dd.MM.yyyy');
                gen.writeStringField('ROFR_NOTICE_RA_DATE',FormatROFR_Notice_RA);
            }else{
                gen.writeStringField('ROFR_NOTICE_RA_DATE','');
            }
            
            if(bkList[0].ROFR_TNOC_Date__c != Null){
                Date d = bkList[0].ROFR_TNOC_Date__c;
                String FormatROFR_TNOC_DATE =  DateTime.newInstance(d.year(),d.month(),d.day()).format('dd.MM.yyyy');
                gen.writeStringField('ROFR_TNOC_DATE',FormatROFR_TNOC_DATE);
            }else{
                gen.writeStringField('ROFR_TNOC_DATE','');
            }
            
            
            if(bkList[0].ROFR_Resale_Consideration__c != Null){ 
                gen.writeNumberField('ROFR_RESALE_CONSIDERATION',bkList[0].ROFR_Resale_Consideration__c);
            }else{
                gen.writeNumberField('ROFR_RESALE_CONSIDERATION',0);
            }
            
            if(bkList[0].ROFR_Sale_Consideration__c != Null){ 
                gen.writeNumberField('ROFR_SALE_CONSIDERATION',bkList[0].ROFR_Sale_Consideration__c);
            }else{
                gen.writeNumberField('ROFR_SALE_CONSIDERATION',0);
            }
            
            
            if(bkList[0].Parallel_Funding__c == true){
                gen.writeStringField('PARALLEL_FUNDING','X');
            }else{
                gen.writeStringField('PARALLEL_FUNDING','');
            }
            
            if(bkList[0].Parallel_FundingP__c != Null){ 
                gen.writeNumberField('PARALLEL_FUNDINGP',bkList[0].Parallel_FundingP__c);
            }else{
                gen.writeNumberField('PARALLEL_FUNDINGP',0);
            }
            
            if(bkList[0].Possession_Done__c == true){
                gen.writeStringField('POSS_DONE','X');
            }else{
                gen.writeStringField('POSS_DONE','');
            }
            
            
            //  gen.writeStringField('REG_DATE','00.00.0000');
            
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
            
            
            if(bkList[0].Provisional_NOC_Bank_Name__c != Null && bkList[0].Provisional_NOC_Bank_Name__c !=''){
                NOC_Bank_Mapping__c NocBank =  NOC_Bank_Mapping__c.getvalues(bkList[0].Provisional_NOC_Bank_Name__c );  
                string bankcode = NocBank.bank_code__c;
                if(bankcode != NULL && bankcode != ''){
                    gen.writeStringField('NOC_BANK_NAME',bankcode);
                }
                else {
                    gen.writeStringField('NOC_BANK_NAME','');
                }
                
            }else{
                gen.writeStringField('NOC_BANK_NAME','');
            }
            
            if(bkList[0].Market_Value__c != Null){ 
                gen.writeNumberField('MARKET_VALUE',bkList[0].Market_Value__c);
            }else{
                gen.writeNumberField('MARKET_VALUE',0);
            }
            
            if(bkList[0].Stampduty_Charges__c != Null){ 
                gen.writeNumberField('STAMP_DUTY',bkList[0].Stampduty_Charges__c);
            }else{
                gen.writeNumberField('STAMP_DUTY',0);
            }
            
            
            if(bkList[0].NOC_Date__c != Null){
                Date d = bkList[0].NOC_Date__c;
                String FormatNOCdate =  DateTime.newInstance(d.year(),d.month(),d.day()).format('dd.MM.yyyy');
                gen.writeStringField('NOC_DATE',FormatNOCdate);
            }else{
                gen.writeStringField('NOC_DATE','');
            }
            
            if(bkList[0].MNOC_date__c != Null){
                Date d = bkList[0].MNOC_date__c;
                String FormatMNOCdate =  DateTime.newInstance(d.year(),d.month(),d.day()).format('dd.MM.yyyy');
                gen.writeStringField('MNOC_DATE',FormatMNOCdate);
            }else{
                gen.writeStringField('MNOC_DATE','');
            }
            
            if(bkList[0].Allotment_Date__c != Null){
                Date d = bkList[0].Allotment_Date__c;
                String FormatAllotmentdate =  DateTime.newInstance(d.year(),d.month(),d.day()).format('dd.MM.yyyy');
                gen.writeStringField('ALLOTMENT_DATE',FormatAllotmentdate);
            }else{
                gen.writeStringField('ALLOTMENT_DATE','');
            }
            
            if(bkList[0].Agreement_Date__c != Null){
                Date d = bkList[0].Agreement_Date__c;
                String FormatAgreementdate =  DateTime.newInstance(d.year(),d.month(),d.day()).format('dd.MM.yyyy');
                gen.writeStringField('AGREEMENT_DATE',FormatAgreementdate);
            }else{
                gen.writeStringField('AGREEMENT_DATE','');
            }
            
            if(bkList[0].Registration_Date__c != Null){
                Date d = bkList[0].Registration_Date__c;
                String FormatRegistrationtdate =  DateTime.newInstance(d.year(),d.month(),d.day()).format('dd.MM.yyyy');
                gen.writeStringField('REG_DATE',FormatRegistrationtdate);
            }else{
                gen.writeStringField('REG_DATE','');
            }
            
            if(bkList[0].Registration_Serial_Number__c != Null && bkList[0].Registration_Serial_Number__c !=''){
                gen.writeStringField('REG_SR_NO',bkList[0].Registration_Serial_Number__c);
            }else{
                gen.writeStringField('REG_SR_NO','');
            }
            
            if(bkList[0].Registration_Charge__c != Null){ 
                gen.writeNumberField('REG_CHARGES',bkList[0].Registration_Charge__c);
            }else{
                gen.writeNumberField('REG_CHARGES',0);
            }
            
            if(bkList[0].Loan_Amount__c != Null){ 
                gen.writeNumberField('LOAN_AMOUNT',bkList[0].Loan_Amount__c);
            }else{
                gen.writeNumberField('LOAN_AMOUNT',0);
            }
            
            if(bkList[0].LOAN_ROI__c!= Null && bkList[0].Loan_Tenure__c !=''){ 
                gen.writeStringField('LOAN_ROI',bkList[0].LOAN_ROI__c);
            }else{
                gen.writeStringField('LOAN_ROI','');
            } 
            
            if(bkList[0].Loan_Tenure__c != Null && bkList[0].Loan_Tenure__c !=''){
                gen.writeStringField('LOAN_TENURE',bkList[0].Loan_Tenure__c);
            }else{
                gen.writeStringField('LOAN_TENURE','');
            }
            
            if(bkList[0].LL_NOC_DATE__c != Null ){
                Date d = bkList[0].LL_NOC_DATE__c;
                String FormatRegistrationtdate =  DateTime.newInstance(d.year(),d.month(),d.day()).format('dd.MM.yyyy');
                gen.writeStringField('LL_NOC_DATE',FormatRegistrationtdate);
            }else{
                gen.writeStringField('LL_NOC_DATE','');
            }
            
            if(bkList[0].LL_Noc_Period__c != Null && bkList[0].LL_Noc_Period__c !=''){ 
                gen.writeStringField('LL_NOC_PERIOD',bkList[0].LL_Noc_Period__c);
            }else{
                gen.writeStringField('LL_NOC_PERIOD','');
            }
            
            if(bkList[0].Per_Month_Rent__c != Null){ 
                gen.writeNumberField('PER_MONTH_RENT',bkList[0].Per_Month_Rent__c);
            }else{
                gen.writeNumberField('PER_MONTH_RENT',0);
            }
            
            if(bkList[0].Security_Deposit__c != Null){ 
                gen.writeNumberField('SECURITY_DEPOSIT',bkList[0].Security_Deposit__c);
            }else{
                gen.writeNumberField('SECURITY_DEPOSIT',0);
            }
            
            if(bkList[0].Flat_Status__c != Null && bkList[0].Flat_Status__c !=''){
                Flat_Status_Mapping__c flatStaus =  Flat_Status_Mapping__c.getvalues(bkList[0].Flat_Status__c );  
                string flatStausCode = flatStaus.Flat_Status_Code__c;
                if(flatStausCode != NULL && flatStausCode != ''){
                    gen.writeStringField('FLAT_STATUS',flatStausCode);
                }
                else {
                    gen.writeStringField('FLAT_STATUS','');
                }
                
            }else{
                gen.writeStringField('FLAT_STATUS','');
            }
            
            if(bkList[0].Possession_Date__c != Null){
                Date d = bkList[0].Possession_Date__c;
                String FormatRegistrationtdate =  DateTime.newInstance(d.year(),d.month(),d.day()).format('dd.MM.yyyy');
                gen.writeStringField('POSS_DATE',FormatRegistrationtdate);
            }else{
                gen.writeStringField('POSS_DATE','');
            }
            
            if(bkList[0].Scheme_Change_Date__c != Null){
                Date d = bkList[0].Scheme_Change_Date__c;
                String FormatRegistrationtdate =  DateTime.newInstance(d.year(),d.month(),d.day()).format('dd.MM.yyyy');
                gen.writeStringField('SCHEME_CHANGE_DATE',FormatRegistrationtdate);
            }else{
                gen.writeStringField('SCHEME_CHANGE_DATE','');
            }
            
            /*if(bkList[0].Scheme_Change_Date__c != Null){
                Date d = bkList[0].Scheme_Change_Date__c;
                String FormatRegistrationtdate =  DateTime.newInstance(d.year(),d.month(),d.day()).format('dd.MM.yyyy');
                gen.writeStringField('SCHEME_CHANGE_DATE',FormatRegistrationtdate);
            }else{
                gen.writeStringField('SCHEME_CHANGE_DATE','');
            }*/
            
            //}
            
            gen.writeFieldName('ORDER_ITEMS');
            gen.writeStartArray();
            
            gen.writeStartObject();
            
            
            gen.writeEndObject();
            
            gen.writeEndArray();
            gen.writeFieldName('ORDER_CONDITIONS');
            gen.writeStartArray();
            
            gen.writeEndArray();
            gen.writeFieldName('BILLING_PLAN');
            gen.writeStartArray();
            
            gen.writeEndArray();
            gen.writeStringField('MESSAGE','');
            gen.writeStringField('MESSAGE_TYPE','');
            
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
            req.setMethod('PUT');
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
                ResponceBody = '{"SO_NUMBER":"671900376","DOC_TYPE":"ZSCE","VKORG":"1131","VTWEG":"11","SPART":"10","VKBUR":"","VKGRP":"","CUST_REF_NO":"Non Scheme","CUST_REF_DATE":"22.09.2021","PROJECT_ID":"11AM","TOWER":"A","KUNNR":"","LIFNR":"","BROKER_PERCENT":0,"ORDER_REASON":"501","NOC_BANK_NAME":"023","SFDC_ID":"a00p000000AhNbqAAF","MARKET_VALUE":500000000.00,"STAMP_DUTY":100000.00,"NOC_DATE":"03.09.2021","MNOC_DATE":"01.09.2021","ALLOTMENT_DATE":"04.09.2021","AGREEMENT_DATE":"02.09.2021","REG_DATE":"05.09.2021","REG_SR_NO":"1234ASDWE12@12","LOAN_AMOUNT":100000.00,"LOAN_ROI":0,"LOAN_TENURE":0,"PARALLEL_FUNDING":"X","PARALLEL_FUNDINGP":0,"LL_NOC_DATE":"07.09.2021","LL_NOC_PERIOD":"36M","PER_MONTH_RENT":40000.00,"SECURITY_DEPOSIT":1000000.00,"FLAT_STATUS":"01","POSS_CHECKLIST_DATE":"","POSS_DATE":"22.09.2021","POSS_DONE":"X","CURRENT_SCHEME":"","SCHEME_CHANGE_DATE":"23.09.2021","CHANGE_OF_SCHEME":"","ROFR_NOTICE_DATE":"","ROFR_NOTICE_RA_DATE":"","ROFR_TNOC_DATE":"","ROFR_RESALE_CONSIDERATION":0,"ROFR_SALE_CONSIDERATION":0,"NET_VALUE":72336000.00,"TAX":3616818.00,"SALE_VALUE":0,"ORDER_ITEMS":[{"POSNR":0,"MATNR":"","ZMENG":0,"ZIEME":"","KWMENG":0}],"ORDER_CONDITIONS":[],"BILLING_PLAN":[],"MESSAGE":"Sales Order change successfully","MESSAGE_TYPE":"S"}';                
            }
            
            
            JSONToApexSOUpdate r = JSONToApexSOUpdate.parse(ResponceBody);
            system.debug('ssss::: '+ r);
            system.debug(r.SO_NUMBER);
            if(r.MESSAGE_TYPE !='E'){
                TRY{
                    SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                    SILD.API_Name__c = 'Sales Order Updation';   //Sales Order update
                    SILD.Booking__c =  bkList[0].id;
                    SILD.Status__c = 'Success';
                    SILD.Request__c = JBody;
                    SILD.Response__c = ResponceBody;                
                    Insert SILD;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.confirm,'Sales Order Updated Sucessfully'));
                }
                CATCH(Exception e){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+e.getMessage()));
                    SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                    SILD.API_Name__c = 'Sales Order Updation';   //Sales Order update
                    SILD.Booking__c = bkList[0].id;
                    SILD.Status__c = 'Failed';
                    SILD.Request__c = JBody;
                    SILD.Response__c = ResponceBody;
                    SILD.Error_Message__c = e.getMessage();
                    Insert SILD; 
                    //System.debug('Your exception message here....'+e.getMessage());
                }
            }else{
                system.debug('inside SO number blank condition');
                SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                SILD.API_Name__c = 'Sales Order Updation';   //Sales Order Updation
                SILD.Booking__c = bkList[0].id;
                SILD.Status__c = 'Failed';
                SILD.Request__c = JBody;
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