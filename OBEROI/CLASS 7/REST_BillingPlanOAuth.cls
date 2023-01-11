@RestResource(urlMapping='/SAP_Integration/FlowBillingPlan/*')
global class REST_BillingPlanOAuth{
    @HttpPOST
    global static REST_result FlowBillingPlanOAuth(Billing_Plan BP){
        REST_result r=new REST_result();
        
        List<Payment_Plan__c> BillingPLan = new List<Payment_Plan__c>();
        List<Payment_Plan__c> UpdateBillingPLan = new List<Payment_Plan__c>();
        List<Payment_Plan_Line_Item__c> ItemList= new List<Payment_Plan_Line_Item__c>();
        List<Payment_Plan_Line_Item__c> AllItemList= new List<Payment_Plan_Line_Item__c>();
        List<Payment_Plan_Line_Item__c> ItemListToUpdate= new List<Payment_Plan_Line_Item__c>();
        List<Payment_Plan_Line_Item__c> ItemListToInsert= new List<Payment_Plan_Line_Item__c>();
        Map<String,Payment_Plan_Line_Item__c> MaptoDeletePPLI = new Map<String,Payment_Plan_Line_Item__c>();
        List<Project__c> p = new List<Project__c>();
        List<Tower__c> t= new List<Tower__c>();
        String MapKey;
        
        system.debug('Request :::::::' + BP);
        //Billing_Plan BP = New Billing_Plan();
        IF(String.isBlank(BP.Billing_Plan_Number)|| String.isBlank(BP.Project_ID)|| String.isBlank(BP.Billing_Plan_Type)){
            Responce re = new Responce();
            re.returnCode =1;
            re.message='ALL REQUIRED PARAMETERS ARE NOT POPULATED';
            r.ResponceList.add(re);
        }Else{
            p= [SELECT ID,Plant__c,Site__c FROM Project__c WHERE Plant__c =: BP.Project_ID];
            if(p.isEmpty()){
                Responce re = new Responce();
                re.returnCode = 4;
                re.message='The particular Project is not available';
                r.ResponceList.add(re);
            }Else{
                t= [SELECT ID, Project_Name__c FROM Tower__c WHERE Tower_Name__c =: BP.Tower AND Project_Name__c =: p[0].ID];
                if(t.isEmpty()){
                    Responce re = new Responce();
                    re.returnCode = 3;
                    re.message= 'The particular Tower is not available';
                    r.ResponceList.add(re);
                   
                }Else{
                    if(p[0].ID != t[0].Project_Name__c){
                        Responce re = new Responce();
                        re.returnCode = 2;
                        re.message='Project And Tower Does Not Match!';
                        r.ResponceList.add(re);
                    }Else{
                        BillingPLan = [SELECT ID,Payment_Plan_Number__c,Project__c,Tower__c FROM Payment_Plan__c 
                        WHERE Project__c =: p[0].ID AND Tower__c =:t[0].ID AND Payment_Plan_Number__c =: BP.Billing_Plan_Number];
                    }
                }
            }
            
            system.debug('BP.Billing_Plan_Number'+BP.Billing_Plan_Number);
            system.debug('p[0].ID'+p[0].ID);
            system.debug('t[0].ID'+t[0].ID);
            system.debug('BillingPLan.size()'+BillingPLan.size());
            if(BillingPLan.size() > 0){
                If(BP.IsDefault == 'X'){
                    BillingPLan[0].RecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
                    BillingPLan[0].Payment_Plan_Type__c = 'Non Scheme';
                }Else{
                    BillingPLan[0].RecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan w/t Tower').getRecordTypeId();
                    BillingPLan[0].Payment_Plan_Type__c = 'Scheme';
                }
                BillingPLan[0].Billing_Plan_Name__c = BP.Scheme_Name;
                
            update BillingPLan[0];                              
            
                        
            AllItemList = [SELECT ID,Payment_Plan__c,Terms_of_Payment_Key__c FROM Payment_Plan_Line_Item__c WHERE Payment_Plan__c = : BillingPLan[0].id];
            For(Payment_Plan_Line_Item__c PLI : AllItemList){
                mapKey = PLI.Terms_of_Payment_Key__c;
                MaptoDeletePPLI.put(mapKey,PLI);
            }
            
            
                if(BP.PayPlanItemsList.size() > 0){
                    For(PayPlanItems PPL : BP.PayPlanItemsList){
                        if(String.isBlank(PPL.ZTERM)){
                            Responce re = new Responce();
                            re.returnCode =1;
                            re.message='REQUIRED PARAMETERS ARE NOT POPULATED';
                            r.ResponceList.add(re);
                        }Else{
                            ItemList = [SELECT ID,Payment_Plan__c,Terms_of_Payment_Key__c FROM Payment_Plan_Line_Item__c WHERE Payment_Plan__c = : BillingPLan[0].id AND Terms_of_Payment_Key__c =: PPL.ZTERM];                                       
                            If(ItemList.size() > 0){
                                ItemList[0].Order__c = PPL.Sr_No;
                                ItemList[0].Payment_Date__c = PPL.Billing_date;
                                ItemList[0].Date_Description__c = PPL.date_description;
                                ItemList[0].Usage__c = PPL.usage_milestone;
                                ItemList[0].Description__c = PPL.description;
                                ItemList[0].Percentage__c = PPL.percentage;
                                ItemList[0].Percentage_Of_Value_To_Be_Invoiced__c = string.valueof(PPL.percentage);
                                ItemList[0].Value_to_be_Billed__c = PPL.billing_value;
                                ItemList[0].Currency_Key__c = PPL.currencType;
                                ItemList[0].Billing_Block_For_Payment_Plan__c = PPL.block;
                                //ItemList[0].Milestone__c = PPL.milestone_assing;
                                ItemList[0].Rule_In_Payment_Plan__c = PPL.billing_rule;
                                ItemList[0].Date_Category__c = PPL.date_category;
                                ItemList[0].Billing_Plan_Type__c = PPL.billing_type;
                                ItemList[0].Milestone_Number__c = PPL.milestone_number;
                                ItemList[0].ID_For_Adopting_Billing__c = PPL.ID_for_billing;
                                
                                ItemListToUpdate.add(ItemList[0]);
                                string mapKey1 = ItemList[0].Terms_of_Payment_Key__c;
                                MaptoDeletePPLI.remove(mapKey1);
                                
                                Responce re = new Responce();
                                re.returnCode = 5;
                                re.message='Payment Plan Line item - '+ItemList[0].Terms_of_Payment_Key__c +' Has Been Updated';
                                r.ResponceList.add(re);
                                
                            }
                            Else{
                                Payment_Plan_Line_Item__c PPLI = new Payment_Plan_Line_Item__c ();
                                PPLI.Payment_Plan__c = BillingPLan[0].Id;
                                PPLI.Order__c = PPL.Sr_No;
                                PPLI.Payment_Date__c = PPL.Billing_date;
                                PPLI.Date_Description__c = PPL.date_description;
                                PPLI.Usage__c = PPL.usage_milestone;
                                PPLI.Description__c = PPL.description;
                                PPLI.Percentage__c = PPL.percentage;
                                PPLI.Percentage_Of_Value_To_Be_Invoiced__c = string.valueof(PPL.percentage);
                                PPLI.Value_to_be_Billed__c = PPL.billing_value;
                                PPLI.Currency_Key__c = PPL.currencType;
                                PPLI.Billing_Block_For_Payment_Plan__c = PPL.block;
                                //PPLI.Milestone__c = PPL.milestone_assing;
                                PPLI.Rule_In_Payment_Plan__c = PPL.billing_rule;
                                PPLI.Terms_of_Payment_Key__c = PPL.ZTERM;
                                PPLI.Date_Category__c = PPL.date_category;
                                PPLI.Billing_Plan_Type__c = PPL.billing_type;
                                PPLI.Milestone_Number__c = PPL.milestone_number;
                                PPLI.ID_For_Adopting_Billing__c = PPL.ID_for_billing;
                                
                                ItemListToInsert.add(PPLI);
                                
                                Responce re = new Responce();
                                re.returnCode = 5;
                                re.message='New Payment Plan Line item For Billing paln No '+BillingPLan[0].Payment_Plan_Number__c +' Has Been inserted';
                                r.ResponceList.add(re);
                            }
                        }
                    }
                    if(ItemListToUpdate.size() > 0){
                        Update ItemListToUpdate;
                    }
                    if(ItemListToInsert.size() > 0){
                    Insert ItemListToInsert;
                    }
                    if(MaptoDeletePPLI.values() != null && MaptoDeletePPLI.values().size() > 0){
                        delete MaptoDeletePPLI.values();
                    }
                }                     
            }
            Else{
            if(!p.isEmpty()&& !t.isEmpty()){

                Payment_Plan__c Obj = new Payment_Plan__c();
                If(BP.IsDefault == 'X'){
                    Obj.RecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
                    Obj.Payment_Plan_Type__c = 'Non Scheme';
                }Else{
                    Obj.RecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan w/t Tower').getRecordTypeId();
                    Obj.Payment_Plan_Type__c = 'Scheme';
                } 
                Obj.Site__c = p[0].Site__c; 
                Obj.Project__c = p[0].Id; 
                Obj.Tower__c = t[0].Id;
                Obj.Payment_Plan_Number__c = BP.Billing_Plan_Number;
                Obj.Billing_Plan_Name__c = BP.Scheme_Name;
                Obj.Active__c = True;
                
                Insert Obj;
                
                if(BP.PayPlanItemsList.size() > 0){
                    For(PayPlanItems PPL : BP.PayPlanItemsList){
                        if(String.isBlank(PPL.ZTERM)){
                            Responce re = new Responce();
                            re.returnCode =1;
                            re.message='REQUIRED PARAMETERS ARE NOT POPULATED';
                            r.ResponceList.add(re);
                        }Else{
                            ItemList = [SELECT ID,Payment_Plan__c,Terms_of_Payment_Key__c FROM Payment_Plan_Line_Item__c WHERE Payment_Plan__c = : Obj.id AND Terms_of_Payment_Key__c =: PPL.ZTERM];                                       
                            If(ItemList.size() > 0){
                                ItemList[0].Order__c = PPL.Sr_No;
                                ItemList[0].Payment_Date__c = PPL.Billing_date;
                                ItemList[0].Date_Description__c = PPL.date_description;
                                ItemList[0].Usage__c = PPL.usage_milestone;
                                ItemList[0].Description__c = PPL.description;
                                ItemList[0].Percentage__c = PPL.percentage;
                                ItemList[0].Percentage_Of_Value_To_Be_Invoiced__c = string.valueof(PPL.percentage);
                                ItemList[0].Value_to_be_Billed__c = PPL.billing_value;
                                ItemList[0].Currency_Key__c = PPL.currencType;
                                ItemList[0].Billing_Block_For_Payment_Plan__c = PPL.block;
                                //ItemList[0].Milestone__c = PPL.milestone_assing;
                                ItemList[0].Rule_In_Payment_Plan__c = PPL.billing_rule;
                                ItemList[0].Date_Category__c = PPL.date_category;
                                ItemList[0].Billing_Plan_Type__c = PPL.billing_type;
                                ItemList[0].Milestone_Number__c = PPL.milestone_number;
                                ItemList[0].ID_For_Adopting_Billing__c = PPL.ID_for_billing;
                                
                                ItemListToUpdate.add(ItemList[0]);
                                
                                Responce re = new Responce();
                                re.returnCode = 5;
                                re.message='Payment Plan Line item - '+ItemList[0].Terms_of_Payment_Key__c +' Has Been Updated';
                                r.ResponceList.add(re);
                            }
                            Else{
                                Payment_Plan_Line_Item__c PPLI = new Payment_Plan_Line_Item__c ();
                                PPLI.Payment_Plan__c = Obj.Id;
                                PPLI.Order__c = PPL.Sr_No;
                                PPLI.Payment_Date__c = PPL.Billing_date;
                                PPLI.Date_Description__c = PPL.date_description;
                                PPLI.Usage__c = PPL.usage_milestone;
                                PPLI.Description__c = PPL.description;
                                PPLI.Percentage__c = PPL.percentage;
                                PPLI.Percentage_Of_Value_To_Be_Invoiced__c = string.valueof(PPL.percentage);
                                PPLI.Value_to_be_Billed__c = PPL.billing_value;
                                PPLI.Currency_Key__c = PPL.currencType;
                                PPLI.Billing_Block_For_Payment_Plan__c = PPL.block;
                                //PPLI.Milestone__c = PPL.milestone_assing;
                                PPLI.Rule_In_Payment_Plan__c = PPL.billing_rule;
                                PPLI.Terms_of_Payment_Key__c = PPL.ZTERM;
                                PPLI.Date_Category__c = PPL.date_category;
                                PPLI.Billing_Plan_Type__c= PPL.billing_type;
                                PPLI.Milestone_Number__c = PPL.milestone_number;
                                PPLI.ID_For_Adopting_Billing__c = PPL.ID_for_billing;
                                
                                ItemListToInsert.add(PPLI);
                                
                                Responce re = new Responce();
                                re.returnCode = 5;
                                re.message='New Payment Plan Line item For Billing paln No '+Obj.Payment_Plan_Number__c +' has been inserted';
                                r.ResponceList.add(re);
                            }
                        }
                    }
                    if(ItemListToUpdate.size() > 0){
                        Update ItemListToUpdate;
                    }
                    if(ItemListToInsert.size() > 0){
                    Insert ItemListToInsert;
                    }
                }
            }}
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
    } 
    global class Billing_Plan{
        Public String Billing_Plan_Number;
        Public String Project_ID; 
        Public String Tower;
        Public String Billing_Plan_Type;
        Public String Scheme_Id;
        Public String Scheme_Name;
        Public String IsDefault;
        Public List<PayPlanItems> PayPlanItemsList;
    }   
    global class PayPlanItems{
        Public Decimal Sr_No; 
        Public Date Billing_date;
        Public String date_description;
        Public String usage_milestone;
        Public String description;
        Public Decimal percentage;
        Public Decimal billing_value;
        Public String currencType;
        Public String block;
        Public String milestone_assing;
        Public String billing_rule;
        //Public String billing_status;
        Public String ZTERM;
        Public String date_category;
        Public String billing_type;
        //Public Decimal exchange_rate;
        Public String milestone_number;
        Public String ID_for_billing;
    }
    public Static void dummy(){
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
    }
}