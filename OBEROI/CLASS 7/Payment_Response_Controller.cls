public class Payment_Response_Controller {
    Public String paymentSubInstType {get;set;}
    Public String paymentMode {get;set;}
    Public String amount {get;set;}
    Public String responseCode {get;set;}
    Public String respDescription {get;set;}
    Public String merchantId {get;set;}
    Public String merchantTxnNo {get;set;}
    Public String txnID {get;set;}
    Public String paymentDateTime {get;set;}
    Public String paymentID {get;set;}
    Public String secureHash {get;set;}
    Public String peoinum {get;set;}
    Public String upeoinum {get;set;}
    Public Boolean ispayFail {get;set;}
    Public Boolean iscp {get;set;}
    Public Boolean isrp {get;set;}
    Public String contemail {get;set;}
    
    Public List<EOI__c> eo = new List<EOI__c>();
    Public List<Opportunity> optyList = new List<Opportunity>();
    
    public Payment_Response_Controller(){
        iscp = false;
        isrp = false;
        ispayFail = false;
    }
    
    public void insertPayment(){
        try{
            Map<String, String> parametersMap=new Map<String, String>();             
            if (ApexPages.currentPage() != null && ApexPages.currentPage().getParameters()!=null && ApexPages.currentPage().getParameters().size()>0)
            {                  
                parametersMap=ApexPages.currentPage().getParameters();  
            }
            system.debug('parametersMap::::'+parametersMap);
            
            if(parametersMap != NULL){
                
                for(String d:parametersMap.keySet()){
                    System.debug('d==>'+d);
                    if(d == 'paymentSubInstType'){
                        paymentSubInstType = parametersMap.get(d);
                    }
                    if(d == 'paymentMode'){
                        paymentMode = parametersMap.get(d);
                    }
                    if(d == 'amount'){
                        amount = parametersMap.get(d);
                    }
                    if(d == 'responseCode'){
                        responseCode = parametersMap.get(d);
                    }
                    if(d == 'respDescription'){
                        respDescription = parametersMap.get(d);
                    }
                    if(d == 'merchantId'){
                        merchantId = parametersMap.get(d);
                    }
                    if(d == 'merchantTxnNo'){
                        merchantTxnNo = parametersMap.get(d);
                        system.debug('merchantTxnNo--'+merchantTxnNo);
                    }
                    if(d == 'txnID'){
                        txnID = parametersMap.get(d);
                    }
                    if(d == 'paymentDateTime'){
                        paymentDateTime = parametersMap.get(d);
                    }
                    if(d == 'paymentID'){
                        paymentID = parametersMap.get(d);
                    }
                    if(d == 'secureHash'){
                        secureHash = parametersMap.get(d);
                    }
                }
                
                System.debug('merchantTxnNo==>'+merchantTxnNo);
                System.debug('respDescription==>'+respDescription);
                if(merchantTxnNo != NULL && respDescription == 'Transaction successful'){
                    System.debug('merchantTxnNo==>'+merchantTxnNo);
                    eo = [SELECT Id,Name,Country_Code_Mobile_1__c,Is_Channel_Partner_EOI__c,UniqueEOInumber__c,Project__c, 
                          Country_Code_Property_Consultant_Mobile__c,Property_Consultant_s_Telephone_Mobile__c, 
                          Property_Consultant_s_Firm_Name__c,Opportunity__c,Mobile_No_1__c,Property_Consultant_s_Email__c
                          FROM EOI__c WHERE Id=:merchantTxnNo AND Project__c != NULL];
                    
                    Payment__c p = new Payment__c();
                    
                    if(eo != NULL && eo.size()>0){
                        p.EOI__c = eo[0].id;
                        p.Amount__c = Decimal.valueOf(amount);
                        peoinum = 'P-'+eo[0].Name;
                        insert p;
                        if(eo[0].Is_Channel_Partner_EOI__c == true){
                            iscp = true;
                        }else{
                            isrp = true;
                        }
                    }
                }else if(merchantTxnNo != NULL && respDescription == 'Transaction rejected'){
                    eo = [SELECT Id,Opportunity__r.Project_Contact_Us_Email_Id__c
                          FROM EOI__c WHERE Id=:merchantTxnNo AND Project__c != NULL];
                    System.debug('merchantTxnNo==>'+merchantTxnNo);
                    ispayFail = true;
                    if(eo != null){
                        contemail = eo[0].Opportunity__r.Project_Contact_Us_Email_Id__c;
                    }
                }
            }
        }Catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }
}