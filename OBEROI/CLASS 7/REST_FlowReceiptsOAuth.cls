@RestResource(urlMapping='/SAP_Integration/FlowReceipts/*')
global class REST_FlowReceiptsOAuth{
    @HttpPOST
    global static REST_result FlowReceiptsOAuth(List<ReceiptsCreditList> RECEIPTLIST){
    REST_result r=new REST_result();
    list<Booking__c> Booklist = new list<Booking__c>();
    List<SAP_Receipts_and_Credit_Note__c> SAPReceiptsCredit = new List<SAP_Receipts_and_Credit_Note__c>();
    List<SAP_Receipts_and_Credit_Note__c> SRCListToInsert = new List<SAP_Receipts_and_Credit_Note__c>();
    List<SAP_Receipts_and_Credit_Note__c> SRCListToUpdate = new List<SAP_Receipts_and_Credit_Note__c>();
    
    if(RECEIPTLIST.size() > 0){
    
        System.debug('RECEIPTLIST::::'+RECEIPTLIST);
        for(ReceiptsCreditList RCL : RECEIPTLIST){
            
        IF(String.isBlank(RCL.CUST_NO)){ //String.isBlank(RCL.SO_NO)||
            Responce re = new Responce();
            re.returnCode =1;
            re.message='ALL REQUIRED PARAMETERS ARE NOT POPULATED(CUST_NO)';
            re.Doc_Num = RCL.BELNR;
            re.CUST_NUM = RCL.CUST_NO;
            r.ResponceList.add(re);
        }Else{
            Booklist = [Select Id,name,Customer_Code__c,Sales_Document_SAP__c FROM Booking__c WHERE Customer_Code__c =: RCL.CUST_NO];// AND Sales_Document_SAP__c =: RCL.SO_NO];
            
            if(Booklist.isEmpty()){
                Responce re = new Responce();
                re.returnCode = 1;
                re.message= 'Booking With and Customer No - '+RCL.CUST_NO+' Was Not Found';//SalesOrder No - '+RCL.SO_NO+'
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
                    SAPReceiptsCredit = [Select id,name,Accounting_Document_Number__c,Booking__c FROM SAP_Receipts_and_Credit_Note__c WHERE booking__c =: Booklist[0].id AND Accounting_Document_Number__c =: RCL.BELNR];
                    if(SAPReceiptsCredit.Size() > 0){
                        SAPReceiptsCredit[0].Accounting_Document_Number__c = RCL.BELNR;
                        SAPReceiptsCredit[0].Company_Code__c = RCL.BUKRS;
                        SAPReceiptsCredit[0].Fiscal_Year__c = RCL.GJAHR;
                        SAPReceiptsCredit[0].Sales_Order_Number__c = RCL.SO_NO;
                        SAPReceiptsCredit[0].Customer_No__c = RCL.CUST_NO;
                        SAPReceiptsCredit[0].Doc_Type__c = RCL.BLART;
                        SAPReceiptsCredit[0].Doc_Type_Description__c = RCL.LTEXT;
                        SAPReceiptsCredit[0].Status__c = RCL.STATUS;
                        if(RCL.BLDAT != '0000-00-00'){
                            SAPReceiptsCredit[0].Doc_Date__c = Date.valueof(RCL.BLDAT);
                        }
                        if(RCL.BUDAT != '0000-00-00'){
                            SAPReceiptsCredit[0].Posting_date__c = Date.valueof(RCL.BUDAT);
                        }
                        if(RCL.CPUDT != '0000-00-00'){
                            SAPReceiptsCredit[0].Entry_date__c = Date.valueof(RCL.CPUDT);
                        }
                        if(RCL.AUGDT != '0000-00-00'){
                            SAPReceiptsCredit[0].Clearing_Date__c = Date.valueof(RCL.AUGDT);
                        }
                        SAPReceiptsCredit[0].Payment_term_key__c = RCL.ZTERM;
                        if(RCL.DUE_DATE != '0000-00-00'){
                            SAPReceiptsCredit[0].Due_date__c = Date.valueof(RCL.DUE_DATE);
                        }
                        SAPReceiptsCredit[0].Assignment_Number__c = RCL.ZUONR;
                        SAPReceiptsCredit[0].Mode_of_payment__c = RCL.MODE_OF_PAY;
                        //SAPReceiptsCredit[0].Amount_received__c = RCL.DMBTR;
                        //SAPReceiptsCredit[0].Amount_Billed_Taxes__c = RCL.TAX_AMOUNT;
                        if(RCL.DMBTR != ''){
                            SAPReceiptsCredit[0].Amount_received__c = Decimal.valueof(RCL.DMBTR);
                        }else{
                            SAPReceiptsCredit[0].Amount_received__c = 0;
                        }
                        
                        if(RCL.TAX_AMOUNT != ''){
                            SAPReceiptsCredit[0].Amount_Billed_Taxes__c = Decimal.valueof(RCL.TAX_AMOUNT);
                        }Else{
                            SAPReceiptsCredit[0].Amount_Billed_Taxes__c = 0;
                        }
                        //SAPReceiptsCredit[0].Amount_Billed_Principle__c = SAPReceiptsCredit[0].Amount_Billed_Total__c - SAPReceiptsCredit[0].Amount_Billed_Taxes__c;
                        SAPReceiptsCredit[0].Details_of_Bank__c = RCL.SGTXT;
                        SAPReceiptsCredit[0].Credit_Type__c = RCL.DC_TYPE;
                        //SAPReceiptsCredit[0].Property_Details__c = RCL.PROP_DTL;
                        if(RCL.BOOK_DATE != '0000-00-00'){
                            SAPReceiptsCredit[0].Booking_date__c = Date.valueof(RCL.BOOK_DATE);
                        }
                        if(RCL.ALLOT_DATE != '0000-00-00'){
                            SAPReceiptsCredit[0].Allotment_Agreement_date__c = Date.valueof(RCL.ALLOT_DATE);
                        }
                        SAPReceiptsCredit[0].Special_GL_Indicator__c = RCL.UMSKZ;
                        if(RCL.SUB_AMT != ''){
                            SAPReceiptsCredit[0].Subvention_Amt__c = Decimal.valueof(RCL.SUB_AMT);
                        }else{
                            SAPReceiptsCredit[0].Subvention_Amt__c = 0;
                        }
                        if(RCL.CUST_LINE_ITEM != ''){
                            SAPReceiptsCredit[0].Customer_Line_item_Gross_received__c = Decimal.valueof(RCL.CUST_LINE_ITEM);
                        }else{
                            SAPReceiptsCredit[0].Customer_Line_item_Gross_received__c = 0;
                        }
                        SAPReceiptsCredit[0].Contain_Bank_Name__c = RCL.CONT_BANK_NAME;
                        if(RCL.BANK_AMT != ''){
                            SAPReceiptsCredit[0].Bank_Amount__c = Decimal.valueof(RCL.BANK_AMT);
                        }else{
                            SAPReceiptsCredit[0].Bank_Amount__c = 0;
                        }
                        SAPReceiptsCredit[0].Profit_Centre__c = RCL.PROFIT_CENTER;
                        SAPReceiptsCredit[0].Assignment__c = RCL.ASSIGNMENT;
                        if(RCL.VALUT != '0000-00-00'){
                            SAPReceiptsCredit[0].Value_Date__c = Date.valueof(RCL.VALUT);
                        }
                        SRCListToUpdate.add(SAPReceiptsCredit[0]);
                        
                         Responce re = new Responce();
                         re.returnCode = 3;
                         re.message='Accounting Document Number - '+RCL.BELNR +' Has Been Updated';
                         re.Doc_Num = RCL.BELNR;
                         re.CUST_NUM = RCL.CUST_NO;
                         r.ResponceList.add(re);
                    }Else{
                        SAP_Receipts_and_Credit_Note__c SRCN = new SAP_Receipts_and_Credit_Note__c();
                        SRCN.Accounting_Document_Number__c = RCL.BELNR;
                        SRCN.Company_Code__c = RCL.BUKRS;
                        SRCN.Fiscal_Year__c = RCL.GJAHR;
                        SRCN.Sales_Order_Number__c = RCL.SO_NO;
                        SRCN.Customer_No__c = RCL.CUST_NO;
                        SRCN.Doc_Type__c = RCL.BLART;
                        SRCN.Doc_Type_Description__c = RCL.LTEXT;
                        SRCN.Status__c = RCL.STATUS;
                        if(RCL.BLDAT != '0000-00-00'){
                            SRCN.Doc_Date__c = Date.valueof(RCL.BLDAT);
                        }
                        if(RCL.BUDAT != '0000-00-00'){
                            SRCN.Posting_date__c = Date.valueof(RCL.BUDAT);
                        }
                        if(RCL.CPUDT != '0000-00-00'){
                            SRCN.Entry_date__c = Date.valueof(RCL.CPUDT);
                        }
                        if(RCL.AUGDT != '0000-00-00'){
                            SRCN.Clearing_Date__c = Date.valueof(RCL.AUGDT);
                        }
                        SRCN.Payment_term_key__c = RCL.ZTERM;
                        if(RCL.DUE_DATE != '0000-00-00'){
                            SRCN.Due_date__c = Date.valueof(RCL.DUE_DATE);
                        }
                        SRCN.Assignment_Number__c = RCL.ZUONR;
                        SRCN.Mode_of_payment__c = RCL.MODE_OF_PAY;
                        
                        /*SRCN.Amount_received__c = RCL.DMBTR;
                        SRCN.Amount_Billed_Taxes__c = RCL.TAX_AMOUNT;*/ 
                        if(RCL.DMBTR != ''){
                            SRCN.Amount_received__c = Decimal.valueof(RCL.DMBTR);
                        }else{
                            SRCN.Amount_received__c = 0;
                        }
                        
                        if(RCL.TAX_AMOUNT != ''){
                            SRCN.Amount_Billed_Taxes__c = Decimal.valueof(RCL.TAX_AMOUNT);
                        }Else{
                            SRCN.Amount_Billed_Taxes__c = 0;
                        }
                        //SAPReceiptsCredit[0].Amount_Billed_Principle__c = SRCN.Amount_Billed_Total__c - SRCN.Amount_Billed_Taxes__c;
                        SRCN.Details_of_Bank__c = RCL.SGTXT;
                        SRCN.Credit_Type__c = RCL.DC_TYPE;
                        SRCN.Booking__c = Booklist[0].id;
                        //SRCN.Property_Details__c = RCL.PROP_DTL;
                        if(RCL.BOOK_DATE != '0000-00-00'){
                            SRCN.Booking_date__c = Date.valueof(RCL.BOOK_DATE);
                        }
                        if(RCL.ALLOT_DATE != '0000-00-00'){
                            SRCN.Allotment_Agreement_date__c = Date.valueof(RCL.ALLOT_DATE);
                        }
                        SRCN.Special_GL_Indicator__c = RCL.UMSKZ;
                        if(RCL.SUB_AMT != ''){
                            SRCN.Subvention_Amt__c = Decimal.valueof(RCL.SUB_AMT);
                        }else{
                            SRCN.Subvention_Amt__c = 0;
                        }
                        if(RCL.CUST_LINE_ITEM != ''){
                            SRCN.Customer_Line_item_Gross_received__c = Decimal.valueof(RCL.CUST_LINE_ITEM);
                        }else{
                            SRCN.Customer_Line_item_Gross_received__c = 0;
                        }
                        SRCN.Contain_Bank_Name__c = RCL.CONT_BANK_NAME;
                        if(RCL.BANK_AMT != ''){
                            SRCN.Bank_Amount__c = Decimal.valueof(RCL.BANK_AMT);
                        }else{
                            SRCN.Bank_Amount__c = 0;
                        }
                        SRCN.Profit_Centre__c = RCL.PROFIT_CENTER;
                        SRCN.Assignment__c = RCL.ASSIGNMENT;
                        if(RCL.VALUT != '0000-00-00'){
                            SRCN.Value_Date__c = Date.valueof(RCL.VALUT);
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
        Public string DMBTR;
        Public string TAX_AMOUNT;
        Public String SGTXT;
        Public String DC_TYPE;
        Public String PROP_DTL;
        Public String BOOK_DATE;
        Public String ALLOT_DATE;
        Public String URL;
        Public String MODE_OF_PAY;
        Public String UMSKZ;
        Public String SUB_AMT;
        Public String CUST_LINE_ITEM;
        Public String CONT_BANK_NAME;
        Public string BANK_AMT;
        Public String PROFIT_CENTER;
        Public String ASSIGNMENT;
        Public String VALUT;
        }
}