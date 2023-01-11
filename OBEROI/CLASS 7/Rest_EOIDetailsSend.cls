@RestResource(urlMapping='/DigitalQueue/EOIDetails/*')
global without sharing class Rest_EOIDetailsSend{
    @HttpPost
    global static REST_result EOIDetails(String Customer_EOI_NO){
        REST_result r = new REST_result();
        if(String.isBlank(Customer_EOI_NO)){
            r.status = 'ERROR';
            r.message = 'Please specify the Customer EOI_NO';
            return r;    
        }
        
            List<EOI__c> eoiList = [select id,name,Applicant_Name_1__c,
                                   UniqueEOInumber__c,Email__c,Mobile_No_1__c
                                   from EOI__c where UniqueEOInumber__c =: Customer_EOI_NO];
            if(eoiList.size()>0){
                
                r.status = 'SUCCESS';
                r.message = 'EOI found successfully';
                r.Customer_NAME = eoiList[0].Applicant_Name_1__c;
                r.Customer_Mobile = eoiList[0].Mobile_No_1__c;
                r.Customer_EMAIL = eoiList[0].Email__c;
                r.Customer_EOI_NO = eoiList[0].UniqueEOInumber__c;
                return r; 
                
            }else{
                r.status = 'ERROR';
                r.message = 'Customer EOI_NO Not Found';
                return r;
            }
        
    }
    
global class REST_result {
   global String status;
   global String message;
   global String Customer_NAME;
   global string Customer_Mobile;
   global string Customer_EMAIL;
   global string Customer_EOI_NO;
}

}