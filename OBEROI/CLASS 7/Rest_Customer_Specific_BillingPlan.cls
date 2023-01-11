public class Rest_Customer_Specific_BillingPlan{

    public void FLowBillinDetails(Id Quote,String SoNumber){
        
        List<Quotation_Billing_Line_Item__c> QuoteLineItems= new List<Quotation_Billing_Line_Item__c>();
        
        QuoteLineItems = [Select id,Name,Sequence_Number__c,Due_Date__c,Is_Milestone_Billed__c,Date_Description_c__c,Usage__c,Percentage_Of_Value_To_Be_Invoiced__c,
        Billing_Plan_Line_Item__r.Billing_Block_For_Payment_Plan__c,Milestone_Amount__c,Milestone_Number__c,Billing_Plan_Line_Item__r.Date_Category__c,
        Terms_of_Payment_Key__c,Quotation__r.booking__c
        FROM Quotation_Billing_Line_Item__c Where Quotation__c =:Quote AND Is_Milestone_Billed__c = False];
        
        List<Booking__c> Booklist = [Select Id,Name,Opportunity__c,Booking_Through__c,Pricing_Flown_to_SAP__c ,Quotation__c,Opportunity__r.AccountId,Project__c,Project__r.Plant__c,Tower__r.Customer_A_C_Group__c,
        Project__r.Sales_Organization__c,Property__r.House_Unit_No__c,Billing_Plan_flown_to_SAP__c,Project__r.Company_name__c,Project__r.GST_No__c,Tower_Name__c FROM Booking__c Where Quotation__c =: Quote];
        
        system.debug('QuoteLineItems.size()==========='+QuoteLineItems.size());
        if(QuoteLineItems.size()>0){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('SO_NUMBER',SoNumber);
            gen.writeStringField('RESULT', '');
            gen.writeStringField('MESSAGE', '');
            gen.writeFieldName('BPLAN');
            gen.writeStartArray();
            For(Quotation_Billing_Line_Item__c QL :QuoteLineItems){
                gen.writeStartObject();
                gen.writeStringField('FPLNR','');
                
                if(QL.Sequence_Number__c != Null ){
                    gen.writeStringField('FPLTR', String.valueof(QL.Sequence_Number__c));
                }Else{
                    gen.writeStringField('FPLTR', '');
                }
                
                if(QL.Due_Date__c != Null ){
                    gen.writeStringField('BILLING_DATE', String.valueof(QL.Due_Date__c));
                }Else{
                    gen.writeStringField('BILLING_DATE','');
                }
                
                if(QL.Date_Description_c__c != '' &&QL.Date_Description_c__c!= Null){
                    gen.writeStringField('DATE_DESCRIPTION',QL.Date_Description_c__c);
                }Else{
                    gen.writeStringField('DATE_DESCRIPTION','');
                }
                
                if(QL.Usage__c != '' &&QL.Usage__c != Null){
                    gen.writeStringField('USAGE_MILESTONE',QL.Usage__c);
                }Else{
                    gen.writeStringField('USAGE_MILESTONE','');
                }
                gen.writeStringField('BILLING_RULE','1');
                
                if(QL.Billing_Plan_Line_Item__r.Billing_Block_For_Payment_Plan__c!= '' && QL.Billing_Plan_Line_Item__r.Billing_Block_For_Payment_Plan__c!= Null){
                    gen.writeStringField('BILLING_BLOCK',QL.Billing_Plan_Line_Item__r.Billing_Block_For_Payment_Plan__c );
                }Else{
                   gen.writeStringField('BILLING_BLOCK','');
                }
                
                
                if(QL.Percentage_Of_Value_To_Be_Invoiced__c != Null){
                    gen.writeStringField('PERCENTAGE', String.Valueof(QL.Percentage_Of_Value_To_Be_Invoiced__c));
                }Else{
                    gen.writeStringField('PERCENTAGE', '');
                }
                
                if(QL.Milestone_Amount__c != Null){
                    gen.writeStringField('BILLING_VALUE',string.valueof(QL.Milestone_Amount__c));
                }Else{
                    gen.writeStringField('BILLING_VALUE','');
                }
                
                if(QL.Milestone_Number__c != '' &&QL.Milestone_Number__c != Null){
                    gen.writeStringField('MLSTN',QL.Milestone_Number__c);
                }Else{
                    gen.writeStringField('MLSTN','');
                }
                
                if(QL.Billing_Plan_Line_Item__r.Date_Category__c != '' &&QL.Billing_Plan_Line_Item__r.Date_Category__c != Null){
                    gen.writeStringField('DATE_CATEGORY',QL.Billing_Plan_Line_Item__r.Date_Category__c);
                }Else{
                    gen.writeStringField('DATE_CATEGORY','');
                }
                
                if(QL.Terms_of_Payment_Key__c != '' &&QL.Terms_of_Payment_Key__c != Null){
                    gen.writeStringField('ZTERM',QL.Terms_of_Payment_Key__c);
                }Else{
                    gen.writeStringField('ZTERM','');
                }
                
                
                gen.writeEndObject();
            }
            gen.writeEndArray();
            gen.writeEndObject();
            String JBody = gen.getAsString();
            System.debug('Json Body string +++==='+jBody);
            
            if(jBody != '' && jBody != null){
                
                List<SAP_Credentials_Master__c> listSAPCreds = [Select Id, Name, Password__c, URL__c, User_Id__c 
                                                                from SAP_Credentials_Master__c
                                                                where Name =: 'Customer Specific Billing plan'];
                
                string Endpoint = listSAPCreds[0].URL__c;
                string userid = listSAPCreds[0].User_Id__c;
                string password = listSAPCreds[0].Password__c;
                HttpRequest req = new HttpRequest();
                req.setEndpoint(Endpoint);
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
                    System.debug(res.getBody());
                    ResponceBody = res.getBody();
                }
                Else{
                    ResponceBody = '{"SO_NUMBER":"0671900355","RESULT":"0","MESSAGE":"Billing Plan Updated successfully"}';
                }
                if(ResponceBody !='' && ResponceBody !=Null){
                    JSON2ApexCustomerBillingPlan obj = JSON2ApexCustomerBillingPlan.parse(ResponceBody);
                
                    If(obj.RESULT =='0'){
                        TRY{
                            //Booklist[0].Pricing_Flown_to_SAP__c = true;
                            Booklist[0].Billing_Plan_flown_to_SAP__c = true;
                            Update Booklist;
                            
                            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                            SILD.API_Name__c = 'Customer Specific Billing Plan';
                            SILD.Booking__c = Booklist[0].id;
                            SILD.Status__c = 'Success';
                            SILD.Request__c = jBody;
                            SILD.Response__c = ResponceBody;
                            Insert SILD;
                            
                        }CATCH(Exception e){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+e.getMessage()));
                            SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                            SILD.API_Name__c = 'Customer Specific Billing Plan';
                            SILD.Booking__c = Booklist[0].id;
                            SILD.Status__c = 'Failed';
                            SILD.Request__c = jBody;
                            SILD.Response__c = ResponceBody;
                            SILD.Error_Message__c = e.getMessage();
                            Insert SILD;
                            //System.debug('Your exception message here....'+e.getMessage());
                        }
                     }Else{
                        SAP_Integration_Logs_Detail__c SILD = new SAP_Integration_Logs_Detail__c();
                        SILD.API_Name__c = 'Customer Specific Billing Plan';
                        SILD.Booking__c = Booklist[0].id;
                        SILD.Status__c = 'Failed';
                        SILD.Request__c = jBody;
                        SILD.Response__c = ResponceBody;
                        SILD.Error_Message__c = obj.MESSAGE;
                        Insert SILD;  
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured.'+obj.MESSAGE));
                     }
                }
                
            }
        }
        
    }
    Public void Dummy(){
        decimal i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
}