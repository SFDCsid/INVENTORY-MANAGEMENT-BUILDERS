@RestResource(urlMapping='/SAP_Integration/FlowDebits/*')
global class REST_FlowDebitsOAuth{
    @HttpPOST
    global static REST_result FlowReceiptsOAuth(List<ReceiptsCreditList> RECEIPTLIST){
    REST_result r=new REST_result();
    list<Booking__c> Booklist = new list<Booking__c>();
    List<SAP_Demands_and_Debits__c> SAPReceiptsCredit = new List<SAP_Demands_and_Debits__c>();
    List<SAP_Demands_and_Debits__c> SRCListToInsert = new List<SAP_Demands_and_Debits__c>();
    List<SAP_Demands_and_Debits__c> SRCListToUpdate = new List<SAP_Demands_and_Debits__c>();
    
    if(RECEIPTLIST.size() > 0){
        for(ReceiptsCreditList RCL : RECEIPTLIST){
            
        IF(String.isBlank(RCL.SO_NO)|| String.isBlank(RCL.CUST_NO)){
            Responce re = new Responce();
            re.returnCode =1;
            re.message='ALL REQUIRED PARAMETERS ARE NOT POPULATED(SO_NO/CUST_NO)';
            re.Doc_Num = RCL.BELNR;
            re.CUST_NUM = RCL.CUST_NO;
            r.ResponceList.add(re);
        }Else{
            Booklist = [Select Id,name,Customer_Code__c,Sales_Document_SAP__c FROM Booking__c WHERE Customer_Code__c =: RCL.CUST_NO AND Sales_Document_SAP__c =: RCL.SO_NO];
            
            if(Booklist.isEmpty()){
                Responce re = new Responce();
                re.returnCode = 1;
                re.message= 'Booking With SalesOrder No - '+RCL.SO_NO+' and Customer No - '+RCL.CUST_NO+' Was Not Found';
                re.Doc_Num = RCL.BELNR;
                re.CUST_NUM = RCL.CUST_NO;
                r.ResponceList.add(re);
            }Else{
                if(String.isBlank(RCL.BELNR)){
                            Responce re = new Responce();
                            re.returnCode = 2;
                            re.message='REQUIRED PARAMETERS ARE NOT POPULATED(BELNR)';
                            re.Doc_Num = RCL.BELNR;
                            re.CUST_NUM = RCL.CUST_NO;
                            r.ResponceList.add(re);
                }Else{
                    SAPReceiptsCredit = [Select id,name,Invoice_Number__c,Booking__c FROM SAP_Demands_and_Debits__c WHERE booking__c =: Booklist[0].id AND Invoice_Number__c =: RCL.BELNR];
                    if(SAPReceiptsCredit.Size() > 0){
                        SAPReceiptsCredit[0].Invoice_Number__c = RCL.BELNR;
                        SAPReceiptsCredit[0].Company_Code__c = RCL.BUKRS;
                        SAPReceiptsCredit[0].Sales_Order_Number__c = RCL.SO_NO;
                        SAPReceiptsCredit[0].Customer_No__c = RCL.CUST_NO;
                        SAPReceiptsCredit[0].Doc_Type_Description__c = RCL.LTEXT;
                        //SAPReceiptsCredit[0].Status__c = RCL.STATUS;
                        if(RCL.STATUS == 'CANCEL'){
                            SAPReceiptsCredit[0].Is_canceled__c = TRUE;
                            SAPReceiptsCredit[0].Cancel_date__c = System.today();
                        }
                        if(RCL.BLDAT != '0000-00-00'){
                            SAPReceiptsCredit[0].Invoice_Date__c = Date.valueof(RCL.BLDAT);
                        }
                        if(RCL.DUE_DATE != '0000-00-00'){
                            SAPReceiptsCredit[0].Due_date__c = Date.valueof(RCL.DUE_DATE);
                        }
                        
                        if(RCL.DMBTR != ''){
                            SAPReceiptsCredit[0].Amount_Billed_Total__c = Decimal.valueof(RCL.DMBTR);
                        }else{
                            SAPReceiptsCredit[0].Amount_Billed_Total__c = 0;
                        }
                        
                        if(RCL.TAX_AMOUNT != ''){
                            SAPReceiptsCredit[0].Amount_Billed_Taxes__c = Decimal.valueof(RCL.TAX_AMOUNT);
                        }Else{
                            SAPReceiptsCredit[0].Amount_Billed_Taxes__c = 0;
                        }
                        SAPReceiptsCredit[0].Amount_Billed_Principle__c = SAPReceiptsCredit[0].Amount_Billed_Total__c - SAPReceiptsCredit[0].Amount_Billed_Taxes__c;
                        //SAPReceiptsCredit[0].Amount_Billed_Principle__c = Decimal.valueof(RCL.DMBTR) - Decimal.valueof(RCL.TAX_AMOUNT);
                        SAPReceiptsCredit[0].Milestone__c = RCL.SGTXT;
                        SAPReceiptsCredit[0].Credit_Type__c = RCL.DC_TYPE;
                        if(RCL.BOOK_DATE != '0000-00-00'){
                            SAPReceiptsCredit[0].Booking_date__c = Date.valueof(RCL.BOOK_DATE);
                        }
                        if(RCL.ALLOT_DATE != '0000-00-00'){
                            SAPReceiptsCredit[0].Allotment_Agreement_date__c = Date.valueof(RCL.ALLOT_DATE);
                        }
                        SRCListToUpdate.add(SAPReceiptsCredit[0]);
                        
                         Responce re = new Responce();
                         re.returnCode = 3;
                         re.message='Accounting Document Number - '+RCL.BELNR +' Has Been Updated';
                         re.Doc_Num = RCL.BELNR;
                         re.CUST_NUM = RCL.CUST_NO;
                         r.ResponceList.add(re);
                    }Else{
                        SAP_Demands_and_Debits__c SRCN = new SAP_Demands_and_Debits__c();
                        SRCN.Invoice_Number__c = RCL.BELNR;
                        SRCN.Company_Code__c = RCL.BUKRS;
                        //SRCN.Fiscal_Year__c = RCL.GJAHR;
                        SRCN.Sales_Order_Number__c = RCL.SO_NO;
                        SRCN.Customer_No__c = RCL.CUST_NO;
                        //SRCN.Doc_Type__c = RCL.BLART;
                        SRCN.Doc_Type_Description__c = RCL.LTEXT;
                        //SRCN.Status__c = RCL.STATUS;
                        
                        if(RCL.STATUS == 'CANCEL'){
                            SRCN.Is_canceled__c = TRUE;
                            SRCN.Cancel_date__c = System.today();
                        }
                        if(RCL.BLDAT != '0000-00-00'){
                            SRCN.Invoice_Date__c = Date.valueof(RCL.BLDAT);
                        }
                        if(RCL.DUE_DATE != '0000-00-00'){
                            SRCN.Due_date__c = Date.valueof(RCL.DUE_DATE);
                        }
                        /*SRCN.Amount_Billed_Total__c = Decimal.valueof(RCL.DMBTR);
                        SRCN.Amount_Billed_Taxes__c = Decimal.valueof(RCL.TAX_AMOUNT);
                        SRCN.Amount_Billed_Principle__c = Decimal.valueof(RCL.DMBTR) - Decimal.valueof(RCL.TAX_AMOUNT);*/
                        if(RCL.DMBTR != ''){
                            SRCN.Amount_Billed_Total__c = Decimal.valueof(RCL.DMBTR);
                        }else{
                            SRCN.Amount_Billed_Total__c = 0;
                        }
                        
                        if(RCL.TAX_AMOUNT != ''){
                            SRCN.Amount_Billed_Taxes__c = Decimal.valueof(RCL.TAX_AMOUNT);
                        }Else{
                            SRCN.Amount_Billed_Taxes__c = 0;
                        }
                        SRCN.Amount_Billed_Principle__c = SRCN.Amount_Billed_Total__c - SRCN.Amount_Billed_Taxes__c;
                        SRCN.Milestone__c = RCL.SGTXT;
                        SRCN.Credit_Type__c = RCL.DC_TYPE;
                        SRCN.Booking__c = Booklist[0].id;
                        if(RCL.BOOK_DATE != '0000-00-00'){
                            SRCN.Booking_date__c = Date.valueof(RCL.BOOK_DATE);
                        }
                        if(RCL.ALLOT_DATE != '0000-00-00'){
                            SRCN.Allotment_Agreement_date__c = Date.valueof(RCL.ALLOT_DATE);
                        }
                        SRCListToInsert.add(SRCN);
                        
                        Responce re = new Responce();
                        re.returnCode = 4;
                        re.message='New Accounting Document Number '+RCL.BELNR+' Has Been inserted';
                        re.Doc_Num = RCL.BELNR;
                        re.CUST_NUM = RCL.CUST_NO;
                        r.ResponceList.add(re);   
                    }
                }
              }
            }
          }
        Update SRCListToUpdate;
        Insert SRCListToInsert;
      }
      return r;
    }
    
    global class REST_result {
        webservice List<Responce> ResponceList;
        global Rest_result(){
            ResponceList = new List<Responce>();
        }
    } 
    global class Responce{
        webservice Integer returnCode;
        webservice String message;
        webservice String Doc_Num;
        webservice String CUST_NUM;
    } 
    global class ReceiptsCreditList{
        Public String SO_NO;
        Public String CUST_NO;
        Public String BELNR;
        Public String BUKRS;
        Public String GJAHR;
        Public String BLART;
        Public String LTEXT;
        Public String STATUS;
        Public String BLDAT;
        Public String BUDAT;
        Public String CPUDT;
        Public String AUGDT;
        Public String ZTERM;
        Public String DUE_DATE;
        Public String ZUONR;
        Public String DMBTR;
        Public String TAX_AMOUNT;
        Public String SGTXT;
        Public String DC_TYPE;
        Public String PROP_DTL;
        Public String BOOK_DATE;
        Public String ALLOT_DATE;
        Public String URL;
        Public String MODE_OF_PAY;
        Public String UMSKZ;
    }
}