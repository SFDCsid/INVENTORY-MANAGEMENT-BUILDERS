@RestResource(urlMapping='/SAP_Integration/DemandAgeing/*')
global class REST_DemandAgeingOAuth{
    @HttpPOST
    global static REST_result DemandAgeingOAuth(list<DemandAgeingList> DA){
        REST_result r=new REST_result();
        List<SAP_Demands_and_Debits__c> SAPDemandaDebits = new List<SAP_Demands_and_Debits__c>();
        List<SAP_Demands_and_Debits__c> SSDListToUpdate = new List<SAP_Demands_and_Debits__c>();
        for(DemandAgeingList DAL : DA){
            if(String.isBlank(DAL.INV_NO)){
                Responce re = new Responce();
                re.returnCode =1;
                re.message='(INV_NO) is Required';
                r.ResponceList.add(re);
            }else{
                SAPDemandaDebits = [Select id,name,Invoice_Number__c,Ageing_0_3_Days__c,Ageing_4_22_Days__c,Ageing_23_52_Days__c,Ageing_53_82_Days__c,Ageing_83_112_Days__c,Ageing_112_Days__c,Billing_Stage__c FROM SAP_Demands_and_Debits__c 
                                WHERE Invoice_Number__c =: DAL.INV_NO];
                
                 If(SAPDemandaDebits.size() > 0){
                     SAPDemandaDebits[0].Invoice_Number__c = DAL.INV_NO;
                     SAPDemandaDebits[0].Ageing_0_3_Days__c = Decimal.valueof(DAL.Ageing_0_3);
                     SAPDemandaDebits[0].Ageing_4_22_Days__c = Decimal.valueof(DAL.Ageing_4_22);
                     SAPDemandaDebits[0].Ageing_23_52_Days__c = Decimal.valueof(DAL.Ageing_23_52);
                     SAPDemandaDebits[0].Ageing_53_82_Days__c = Decimal.valueof(DAL.Ageing_53_82);
                     SAPDemandaDebits[0].Ageing_83_112_Days__c = Decimal.valueof(DAL.Ageing_83_112);
                     SAPDemandaDebits[0].Ageing_112_Days__c = Decimal.valueof(DAL.Ageing_112);
                     SAPDemandaDebits[0].Billing_Stage__c = DAL.Billing_stage;
                     
                     
                     SSDListToUpdate.add(SAPDemandaDebits[0]);
                
                     Responce re = new Responce();
                     re.returnCode = 2;
                     re.message='Demand Ageing Invoice - '+DAL.INV_NO +' Has Been Updated';
                     r.ResponceList.add(re);
                  }Else{
                    Responce re = new Responce();
                    re.returnCode = 3;
                    re.message='Demand Invoice No- '+DAL.INV_NO +' Was Not found';
                    r.ResponceList.add(re);
                }
              }
            }
        update SSDListToUpdate;                       
        Return r;
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
    }
    global class DemandAgeingList{
        
        Public String INV_NO;
        Public String AGEING_0_3;
        Public String AGEING_4_22;
        Public String AGEING_23_52;
        Public String AGEING_53_82;
        Public String AGEING_83_112;
        Public String AGEING_112;
        Public String BILLING_STAGE;
    } 
}