Public Class SyncPaymentPlan{
    public string qId {get;set;}
    public string soCode {get;set;}
    Public List<Quotation__c> qList {get;set;}
    public boolean status {get ; set ;}
    Public List<JSON2ApexSyncPaymentPlan.BILLING_PLAN> BpList {get;set;}
    //Map<String,Billing_Plan_Line_Item__c> newBillingPlanLineItems = new Map<String,Billing_Plan_Line_Item__c>();
    Public list<Quotation_Billing_Line_Item__c> QLI_List {get;set;}
    Public list<Quotation_Billing_Line_Item__c> QliToUpdate {get;set;}
    public SyncPaymentPlan(){
        qList = new List<Quotation__c>();
         if(ApexPages.currentPage().getParameters().containsKey('qId') != null){
            qId =  ApexPages.currentPage().getParameters().get('qId');
        }
        DescribeSObjectResult describeResult = Quotation__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) + ',Project__r.name,Tower__r.Name,Project__r.Effective_Sale_Price_Applicable__c,' +
                     'Property__r.name,Property__r.House_Unit_No__c,Property__r.Property_Type__c,Project__r.Terms_And_Conditions__c,'+
                     'Billing_Plan__r.Payment_Plan_Type__c,Property__r.Material_No__c, Tower__r.Tower_Name__c,Booking__r.Sales_Document_SAP__c,Booking__r.Booking_Date__c,' +
                     'Billing_Plan__r.Scheme_Specific_Clauses__c,Property__r.ITC_Benefit_Applicable__c' + 
                     ' FROM ' + describeResult.getName() + ' where id=' + '\'' + qId + '\''; 
        qList = Database.query( query );
        //QLI_List = new list<Quotation_Billing_Line_Item__c>();
    }
    Public void flow(){
        list<Quotation_Billing_Line_Item__c> QliToUpdate = new list<Quotation_Billing_Line_Item__c>();
        if(qList[0].Booking__c != null){
            soCode = qList[0].Booking__r.Sales_Document_SAP__c;
            Rest_SAP_SyncPaymentPlan ssoc = new Rest_SAP_SyncPaymentPlan();
            BpList = ssoc.createSalesOrder(soCode);
            //BpList.sort();
            System.debug('In Main class'+BpList);
            QLI_List = [Select id,name,Terms_of_Payment_Key__c,Quotation__c,Is_Milestone_Billed__c FROM Quotation_Billing_Line_Item__c WHERE Quotation__c =: qid];
         }Else{
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.Error,'No Booking Found on this Quotation.');
            ApexPages.addMessage(myMsg1);
        }
        
        if(BpList.size()>0){
            For(JSON2ApexSyncPaymentPlan.BILLING_PLAN bp : BpList){
            
                if(QLI_List.size()>0){
                    For(Quotation_Billing_Line_Item__c QLI : QLI_List){
                        
                        If(bp.ZTERM == QLI.Terms_of_Payment_Key__c){
                            System.debug('zterm in for '+bp.ZTERM);
                            System.debug('bp cha FKSAF in for '+bp.FKSAF);
                            if(bp.FKSAF =='C'){
                                System.debug('bp cha FKSAF in if '+bp.FKSAF);
                                QLI.Is_Milestone_Billed__c = True;
                                QliToUpdate.add(QLI);
                            }Else{}
                        }
                    }
                  }
            }
            System.debug('QliToUpdate Chi size:::'+QliToUpdate);
            
            If(QliToUpdate.size()>0){
                Update QliToUpdate;
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Quotation Line Items updated sucessfully.');
                ApexPages.addMessage(myMsg1);
            }Else {
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Quotation Line Items updated sucessfully.');
                ApexPages.addMessage(myMsg1);
            }
        }
    }
    public PageReference incrementCounter() 
    {       
        if(qId!= '')
        {
            pageReference P = new pageReference('/'+ qId);
            return P;
        }
        return null;
    }
    public PageReference BackToBooking(){
        pageReference P = new pageReference('/'+ qId);
        return P;
    }
}