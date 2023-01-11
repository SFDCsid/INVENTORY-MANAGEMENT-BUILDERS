@RestResource(urlMapping='/SAP_Integration/FlowDemands/*')
global class REST_FlowDemandsOAuth{
    @HttpPOST
    global static REST_result FlowDemandsOAuth(List<DEMANDINVOICEList> DEMANDINVOICE){
    REST_result r=new REST_result();
    list<Booking__c> Booklist = new list<Booking__c>();
    List<SAP_Demands_and_Debits__c> SAPDemandaDebits = new List<SAP_Demands_and_Debits__c>();
    List<SAP_Demands_and_Debits__c> SSDListToInsert = new List<SAP_Demands_and_Debits__c>();
    List<SAP_Demands_and_Debits__c> SSDListToUpdate = new List<SAP_Demands_and_Debits__c>();
    
    if(DEMANDINVOICE.size() > 0){
        For(DEMANDINVOICEList DIL : DEMANDINVOICE){
        
        IF(String.isBlank(DIL.SO_NO)|| String.isBlank(DIL.CUST_NO)){
            Responce re = new Responce();
            re.returnCode =1;
            re.message='ALL REQUIRED PARAMETERS ARE NOT POPULATED(SO_NO/CUST_NO)';
            re.Invoice_No = DIL.INV_NO;
            r.ResponceList.add(re);
        }Else{
            Booklist = [Select Id,name,Customer_Code__c,Sales_Document_SAP__c FROM Booking__c WHERE Customer_Code__c =: DIL.CUST_NO AND Sales_Document_SAP__c =: DIL.SO_NO];
            
            if(Booklist.isEmpty()){
                Responce re = new Responce();
                re.returnCode = 1;
                re.message= 'Booking With SalesOrder No - '+DIL.SO_NO+' and Customer No - '+DIL.CUST_NO+' Was Not Found';
                re.Invoice_No = DIL.INV_NO;
                r.ResponceList.add(re);
            }Else{
                if(String.isBlank(DIL.INV_NO)){
                            Responce re = new Responce();
                            re.returnCode = 2;
                            re.message='REQUIRED PARAMETERS ARE NOT POPULATED(INV_NO)';
                            re.Invoice_No = DIL.INV_NO;
                            r.ResponceList.add(re);
                }Else{
                    SAPDemandaDebits = [Select id,name,Invoice_Number__c,Booking__c FROM SAP_Demands_and_Debits__c WHERE Booking__c =:Booklist[0].id AND Invoice_Number__c =: DIL.INV_NO];
                        
                        If(SAPDemandaDebits.size() > 0){
                            SAPDemandaDebits[0].Invoice_Number__c = DIL.INV_NO;
                            if(DIL.INV_DATE != '0000-00-00'){
                                SAPDemandaDebits[0].Invoice_Date__c = Date.valueof(DIL.INV_DATE);
                            }
                            SAPDemandaDebits[0].Company_Code__c = DIL.CC;
                            if(DIL.DUE_DATE != '0000-00-00'){
                                SAPDemandaDebits[0].Due_Date__c = Date.valueof(DIL.DUE_DATE);
                            }
                            SAPDemandaDebits[0].Milestone__c = DIL.MILESTONE;
                            SAPDemandaDebits[0].Amount_Billed_Principle__c = DIL.NET_AMOUNT;
                            SAPDemandaDebits[0].Amount_Billed_Taxes__c = DIL.TAX_AMOUNT;
                            SAPDemandaDebits[0].Amount_Billed_Total__c = DIL.TOTAL_AMOUNT;
                            SAPDemandaDebits[0].Previous_outstanding__c = DIL.PRE_OS;
                            if(DIL.BOOK_DATE != '0000-00-00'){
                                SAPDemandaDebits[0].Booking_date__c = Date.valueof(DIL.BOOK_DATE);
                            }
                            if(DIL.ALLOT_DATE != '0000-00-00'){
                                SAPDemandaDebits[0].Allotment_Agreement_date__c = Date.valueof(DIL.ALLOT_DATE);
                            }
                            SAPDemandaDebits[0].Demand_pdf_url__c = DIL.URL;
                            SAPDemandaDebits[0].Doc_Type_Description__c = 'DEMAND';
                            SAPDemandaDebits[0].Refrence_Number__c = DIL.REFERENE_NO;
                            SSDListToUpdate.add(SAPDemandaDebits[0]);
                            
                            Responce re = new Responce();
                            re.returnCode = 3;
                            re.message='Demand Invoice - '+DIL.INV_NO +' Has Been Updated';
                            re.Invoice_No = DIL.INV_NO;
                            r.ResponceList.add(re);
                        }Else {
                            SAP_Demands_and_Debits__c SDD = new SAP_Demands_and_Debits__c();
                            SDD.Booking__c = Booklist[0].id;
                            SDD.Sales_Order_Number__c = DIL.SO_NO;
                            SDD.Customer_No__c = DIL.CUST_NO;
                            SDD.Invoice_Number__c = DIL.INV_NO;
                            if(DIL.INV_DATE != '0000-00-00'){
                                SDD.Invoice_Date__c = Date.valueof(DIL.INV_DATE);
                            }
                            SDD.Company_Code__c = DIL.CC;
                            if(DIL.DUE_DATE != '0000-00-00'){
                                SDD.Due_Date__c = Date.valueof(DIL.DUE_DATE);
                            }
                            SDD.Milestone__c = DIL.MILESTONE;
                            SDD.Amount_Billed_Principle__c = DIL.NET_AMOUNT;
                            SDD.Amount_Billed_Taxes__c = DIL.TAX_AMOUNT;
                            SDD.Amount_Billed_Total__c = DIL.TOTAL_AMOUNT;
                            SDD.Previous_outstanding__c = DIL.PRE_OS;
                            if(DIL.BOOK_DATE != '0000-00-00'){
                                SDD.Booking_date__c = Date.valueof(DIL.BOOK_DATE);
                            }
                            if(DIL.ALLOT_DATE != '0000-00-00'){
                                SDD.Allotment_Agreement_date__c = Date.valueof(DIL.ALLOT_DATE);
                            }
                            SDD.Doc_Type_Description__c = 'DEMAND';
                            SDD.Demand_pdf_url__c = DIL.URL;
                            SDD.Refrence_Number__c = DIL.REFERENE_NO;
                            SSDListToInsert.add(SDD);  
                            
                            Responce re = new Responce();
                            re.returnCode = 4;
                            re.message='New Demand Invoice No '+DIL.INV_NO+' Has Been inserted';
                            re.Invoice_No = DIL.INV_NO;
                            r.ResponceList.add(re);                          
                        }
                        }
                    }
                }        
            }
            Update SSDListToUpdate;
            Insert SSDListToInsert;
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
        webservice String Invoice_No;
    } 
    /*global class Demands{
         
        Public List<DEMANDINVOICEList> DEMANDINVOICE;
    }*/
    global class DEMANDINVOICEList{
        Public String SO_NO;
        Public String CUST_NO;
        Public String INV_NO;
        Public String INV_DATE;
        //Public String CANCEL_IND;
        //Public Date CANCEL_DATE;
        Public String CC;
        Public String PROP_DTL;
        Public String DUE_DATE;
        Public String MILESTONE;
        Public Decimal NET_AMOUNT;
        Public Decimal TAX_AMOUNT;
        Public Decimal TOTAL_AMOUNT;
        Public Decimal PRE_OS;
        Public String BOOK_DATE;
        Public string ALLOT_DATE;
        Public String URL;
        Public String REFERENE_NO;
    }
    
}