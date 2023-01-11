Public Class SyncPaymentPlanNew{
    public string qId {get;set;}
    public string soCode {get;set;}
    Public List<Quotation__c> qList {get;set;}
    public boolean status {get ; set ;}
    Public List<JSON2ApexSyncPaymentPlan.BILLING_PLAN> BpList {get;set;}
    Public list<Quotation_Billing_Line_Item__c> QLI_List {get;set;}
    Public list<Quotation_Billing_Line_Item__c> insertQLIList {get;set;}
    Public Quotation_Billing_Line_Item__c QLI {get;set;}
    Public list<Payment_Term__c> Payterm {get;set;} 
    
    public SyncPaymentPlanNew(){
        qList = new List<Quotation__c>();
        insertQLIList = new list<Quotation_Billing_Line_Item__c>();
        Payterm = new list<Payment_Term__c>();
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
        if(qList[0].Booking__c != null){
            soCode = qList[0].Booking__r.Sales_Document_SAP__c;
            Rest_SAP_SyncPaymentPlan ssoc = new Rest_SAP_SyncPaymentPlan();
            BpList = ssoc.createSalesOrder(soCode);
            //BpList.sort();
            System.debug('In Main class'+BpList);
            QLI_List = [Select id,name,Terms_of_Payment_Key__c,Quotation__c,Is_Milestone_Billed__c,Billing_Plan__c, 
                        Booking__c FROM Quotation_Billing_Line_Item__c WHERE Quotation__c =: qid];           
            
            Payterm = [Select id,name,Billing_Plan__c,Detailed_Description__c,Due_Days__c,Max_Occurrence__c,Milestone_Indicator__c,
                       Min_Occurrence__c,Order__c,Tower__c, Type__c 
                       FROM Payment_Term__c   WHERE      //Billing_Plan__c  =: qList[0].Billing_Plan__c AND
                       Tower__c =: qList[0].Tower__c]; 
            
            Map<Boolean, List<QuotationManagmentServices.PlanDetailsWrapper>> pdMap = new Map<Boolean, List<QuotationManagmentServices.PlanDetailsWrapper>>();
            Map<string,Integer> paymentGroupMap = new Map<string,Integer>();
            
            Map<string,List<Payment_Plan_Line_Item__c>> pplMap = new Map<string,List<Payment_Plan_Line_Item__c>>();
            List<Payment_Plan_Line_Item__c> plList = [select id,name,Payment_Plan__c,Payment_Plan__r.Is_Subvention_Plan__c,Percentage__c,Order__c,
                                                      Percentage_Of_Value_To_Be_Invoiced__c,
                                                      Date_Description__c,Description__c,Terms_of_Payment_Key__c,
                                                      Payment_Group__c,Milestone_Number__c,
                                                      Payment_Date__c,Usage__c from Payment_Plan_Line_Item__c 
                                                      where Payment_Plan__c =: qList[0].Billing_Plan__c  and Usage__c != null 
                                                      and Date_Description__c = null order by Terms_of_Payment_Key__c ASC];
            system.debug('plList:: '+plList.size());
            if(plList != null && !plList.isEmpty()){    
                
                if(plList[0].Payment_Plan__r.Is_Subvention_Plan__c == True){    // Added by bhagyashri 9-3-22
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Syncing of payment plan is not allowed in case of subvention plan.');
                    ApexPages.addMessage(myMsg1);
                } else{       
                    
                    // delete old quotation line items
                    try{
                        if(QLI_List.size()>0){
                            system.debug('QLI_List :: '+QLI_List);
                            delete QLI_List; }
                        else{
                            system.debug('Nothing to delete');
                        }                     
                    }Catch(Exception e){
                        system.debug('Exception :: '+e);
                        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Quotation line item delete Failed.'+e);
                        ApexPages.addMessage(myMsg1);
                    }  
                    
                    system.debug('BpList :: '+BpList);
                    
                    for(Payment_Plan_Line_Item__c pl : plList){
                        
                        if(pplMap.containsKey(pl.Payment_Group__c)){
                            List<Payment_Plan_Line_Item__c> dummyList = pplMap.get(pl.Payment_Group__c);
                            dummyList.add(pl);
                            pplMap.put(pl.Payment_Group__c, dummyList);
                        }else{
                            List<Payment_Plan_Line_Item__c> dummyList = new List<Payment_Plan_Line_Item__c>();
                            dummyList.add(pl); 
                            pplMap.put(pl.Payment_Group__c, dummyList);
                        }
                    }
                    
                    system.debug('pplMap::: '+pplMap);
                    Integer seq1 = 0;
                    //Integer seq5;
                    decimal totalMilestonesAmount = 0;
                    decimal totalMilestonesCGST = 0;
                    decimal totalMilestonesSGST = 0;       
                    decimal totalIN01Amount_c = 0;
                    decimal totalIN01CGST_c = 0;
                    decimal totalIN01SGST_c = 0;    
                    decimal IN01_Amount = 0;
                    decimal IN01_CGST = 0;
                    decimal IN01_SGST = 0;   
                    /*if(qList[0].Billing_Plan__c != null){
                        BillingPlanLineItemGroupingController.createBillingLineItemsFuture(qList[0].Billing_Plan__c); 
                    }*/
                    if(BpList.size()>0){
                        For(JSON2ApexSyncPaymentPlan.BILLING_PLAN bp : BpList){            
                            Quotation_Billing_Line_Item__c QLI = New Quotation_Billing_Line_Item__c();
                            //bp.BILLING_BLOCK 
                            //bp.FPLNR;
                            //Decimal.ValueOf(bp.BILLING_RULE);
                            //QLI.Due_After_Days__c  = Decimal.ValueOf(bp.DATE_CATEGORY);
                            //bp.FKSAF
                            
                            if(bp.BILLING_DATE != Null){   
                                system.debug('bp.BILLING_DATE'+bp.BILLING_DATE);
                                String dateValue = bp.BILLING_DATE;
                                String token = dateValue.replace('.','/');
                                system.debug('token ::'+token);
                                date dt = date.parse(token);
                                system.debug('dt ::'+dt);
                                QLI.Due_Date__c = dt+6;//Date.valueOf(dateValue);//Date.parse(dateValue);
                                QLi.Billing_Item_Due_Date__c = dt+6;
                            }
                            
                            QLI.Sequence_Number__c   = bp.FPLTR; 
                            QLI.Milestone_Amount__c   = Decimal.ValueOf(bp.BILLING_VALUE);                        
                            QLI.Date_Description_c__c  = bp.DATE_DESCRIPTION;                        
                            QLI.Milestone_Number__c = bp.MLSTN;
                            QLI.CGST__c = 0;
                            QLI.SGST__c = 0;
                            QLI.Total_GST__c = 0;
                            QLI.Percentage_Of_Value_To_Be_Invoiced__c = Decimal.ValueOf(bp.PERCENTAGE);
                            QLI.Usage__c  = bp.USAGE_MILESTONE;
                            QLI.Terms_of_Payment_Key__c = bp.ZTERM;
                            System.debug('zterm in for '+bp.ZTERM);
                            System.debug('bp cha FKSAF in for '+bp.FKSAF);
                            if(bp.FKSAF =='C'){
                                System.debug('bp cha FKSAF in if '+bp.FKSAF);
                                QLI.Is_Milestone_Billed__c = True;
                            }Else{}
                            QLI.Quotation__c  = qId;
                            QLI.Booking__c = qList[0].booking__c;
                            QLI.Billing_Plan__c = qList[0].Billing_Plan__c;
                            QLI.Property__c = qList[0].Property__c;
                            if(QLI.Milestone_Number__c == '000000000000' && (QLI.Usage__c == null || QLI.Date_Description_c__c != null)){
                                QLI.IsCompleted_Milestone__c = true;
                            }
                            system.debug('FPLNR ::::'+bp.FPLNR);
                            system.debug('BILLING_RULE ::::'+bp.BILLING_RULE);
                            system.debug('DATE_CATEGORY ::::'+bp.DATE_CATEGORY);
                            
                            system.debug('insertQLIList ::::'+insertQLIList);
                            system.debug('Payterm ::::'+Payterm);
                            for(Payment_Term__c pt : Payterm){
                                if(pt.Name == QLI.Terms_of_Payment_Key__c){
                                    QLI.Payment_Group__c = QLI.Terms_of_Payment_Key__c.SubString(0,2) ;                             
                                    //QLI.Milestone_Type__c = pt.Type__c ;
                                    QLI.Line_Item_Name__c = pt.Detailed_Description__c;
                                    QLI.Billing_Item_Name__c = pt.Detailed_Description__c;
                                    //QLI.Billing_Plan_Line_Item__c  =bpl.id;
                                    if(QLI.Payment_Group__c == 'IN'){
                                        QLI.Is_IN00_01_Milesone__c = true; }  
                                }else{system.debug('No Payement term matched');
                                      if(QLI.Terms_of_Payment_Key__c != null){
                                          if(QLI.Terms_of_Payment_Key__c.length() > 2){
                                              QLI.Payment_Group__c = QLI.Terms_of_Payment_Key__c.SubString(0,2) ;   
                                          }}
                                      if(QLI.Payment_Group__c == 'IN'){
                                          QLI.Is_IN00_01_Milesone__c = true; }  
                                      //}
                                     }
                            }    
                            insertQLIList.add(QLI);
                            
                        }
                    }
                    
                    System.debug('insertQLIList size:::'+insertQLIList);
                    try{
                        Insert insertQLIList;
                        
                        If(insertQLIList.size()>0){
                            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Quotation Line Items updated sucessfully.');
                            ApexPages.addMessage(myMsg1);
                            qList[0].Is_Payment_Plan_Sync__c = true;
                            
                            update qList[0];
                        }
                    }Catch(Exception e){
                        system.debug('Exception :: '+e);
                        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Quotation Update Failed.'+e);
                        ApexPages.addMessage(myMsg1);
                    } 
                    
                }
            }
            
        }Else{
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.Error,'No Booking Found on this Quotation.');
            ApexPages.addMessage(myMsg1);
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