@RestResource(urlMapping='/SAP_Integration/CancelDemand/*')
global class REST_CancelDemandOAuth{
    @HttpPOST
    global static REST_result CancelDemandOAuth(list<CancelDemandInvoiceList> CDI){
    REST_result r=new REST_result();
    List<SAP_Demands_and_Debits__c> SAPDemandaDebits = new List<SAP_Demands_and_Debits__c>();
    List<SAP_Demands_and_Debits__c> SSDListToUpdate = new List<SAP_Demands_and_Debits__c>();
    Set<String> invNo = new Set<String>();
    
    for(CancelDemandInvoiceList CDIL : CDI){
        if(String.isBlank(CDIL.INV_NO) || String.isBlank(CDIL.SO_NO) || String.isBlank(CDIL.CUST_NO)){
            Responce re = new Responce();
            re.returnCode =1;
            re.message='ALL REQUIRED PARAMETERS ARE NOT POPULATED(INV_NO/SO_NO/CUST_NO)';
            r.ResponceList.add(re);
        }else{
            SAPDemandaDebits = [Select id,name,Invoice_Number__c,Sales_Order_Number__c,Customer_No__c FROM SAP_Demands_and_Debits__c 
                                WHERE Invoice_Number__c =:CDIL.INV_NO AND Sales_Order_Number__c =: CDIL.SO_NO AND Customer_No__c =:CDIL.CUST_NO];
            If(SAPDemandaDebits.size() > 0){
                SAPDemandaDebits[0].Invoice_Number__c = CDIL.INV_NO;
                if(CDIL.CANCEL_IND == 'X'){
                   SAPDemandaDebits[0].Is_canceled__c = True;
                }Else{
                   SAPDemandaDebits[0].Is_canceled__c = False;
                }
                SAPDemandaDebits[0].Cancel_date__c = CDIL.CANCEL_DATE;
                SSDListToUpdate.add(SAPDemandaDebits[0]);
                
                Responce re = new Responce();
                re.returnCode = 2;
                re.message='Demand Invoice - '+CDIL.INV_NO +' Has Been Cancelled';
                re.Invoice_No = CDIL.INV_NO;
                r.ResponceList.add(re);
            }Else{
                Responce re = new Responce();
                re.returnCode = 3;
                re.message='Demand Invoice with No- '+CDIL.INV_NO +', SO No - '+CDIL.SO_NO+', & Customer No '+CDIL.CUST_NO+' Was Not found';
                re.Invoice_No = CDIL.INV_NO;
                r.ResponceList.add(re);
            }
        }
    }
      update SSDListToUpdate;
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
    /*global class CancelDemands{
        
        Public List<CancelDemandInvoiceList> CANCELDEMANDINVOIE;
    }*/
    global class CancelDemandInvoiceList{
        Public String SO_NO;
        Public String CUST_NO;
        Public String INV_NO;
        Public String CANCEL_IND;
        Public Date CANCEL_DATE;
    }
    }