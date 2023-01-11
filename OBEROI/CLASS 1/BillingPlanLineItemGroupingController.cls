public class BillingPlanLineItemGroupingController{

    public static void createBillingLineItemsFuture(String billingPlanIds){
        List<Payment_Plan__c> scope = [Select Id,(Select Billing_Block_For_Payment_Plan__c,Order__c,Due_After_Days__c,Payment_Plan_Line_Item_Name__c,Amount_Percent_BSP__c,Payment_Plan__c, Date_Category__c, Date_Description__c, Milestone_Number__c, Percentage_Of_Value_To_Be_Invoiced__c, Value_to_be_Billed__c, Usage__c, Terms_of_Payment_Key__c, Payment_Group__c From Payment_Plan_Line_Items__r Order By Payment_Group__c),
                                         (Select Billing_Block_For_Payment_Plan__c,Amount_Percent_BSP__c, Date_Category__c,Payment_Plan__c, Date_Description__c, Milestone_Number__c, Order__c,Payment_Plan_Line_Item_Name__c,Percentage_Of_Value_To_Be_Invoiced__c, Value_to_be_Billed__c, Usage__c, Terms_of_Payment_Key__c, Due_After_Days__c,Payment_Group__c From Billing_Plan_Line_Items__r Order By Payment_Group__c) 
                                        ,Tower__c,Active__c From Payment_Plan__c where ID =: billingPlanIds];
        system.debug('scope ---->> ' + scope[0].Payment_Plan_Line_Items__r.size());
        system.debug('TOWER ---->> ' + scope[0].Tower__c);
        List<Billing_Plan_Line_Item__c> listToUpsert = new List<Billing_Plan_Line_Item__c>();
        Set<String> uniqueKey= new Set<String>();
        Map<String,Billing_Plan_Line_Item__c> newBillingPlanLineItems = new Map<String,Billing_Plan_Line_Item__c>();
        Map<Id,Id> mapBillPlanIdToBPliID = new Map<Id,Id>();
        Map<String,Payment_Term__c> mapPaymentTerm = new Map<String,Payment_Term__c>();
        List<Payment_Term__c> Pterm = new List<Payment_Term__c>();
        Pterm = [ SELECT Id, Name, Detailed_Description__c, Due_Days__c, Max_Occurrence__c,
            Min_Occurrence__c, Order__c, Tower__c, Type__c, Milestone_Indicator__c from Payment_Term__c WHERE Tower__c =: scope[0].Tower__c AND Billing_Plan__c =:scope[0].id ];
        If(Pterm.size() > 0){
            for(Payment_Term__c ptm :Pterm ){
                if(ptm.Name != 'PL01'){
                    mapPaymentTerm.put(ptm.Name,ptm);
                }
                else{
                    mapPaymentTerm.put(ptm.Name+ptm.Milestone_Indicator__c,ptm);
                }
                system.debug('mapPaymentTerm'+mapPaymentTerm.keyset());
            }
        }Else{
            throw new IllegalArgumentException('Payment terms foud for this tower not found');
        }
        //system.debug('mapPlinthmapPlinth'+mapPlinth.keyset());
        //system.debug('mapPlinthmapPlinth'+mapPlinth.values());
       //existing
        for(Payment_Plan__c plan : scope){
            if(plan.Billing_Plan_Line_Items__r != null && plan.Billing_Plan_Line_Items__r.size() > 0){
                for(Billing_Plan_Line_Item__c billingLineItem : plan.Billing_Plan_Line_Items__r){
                    String mapKey;
                    if(billingLineItem.Milestone_Number__c != '000000000000' && billingLineItem.Payment_Group__c == 'IN'){
                        if(mapPaymentTerm.get('IN01') != null &&
                            (billingLineItem.Terms_of_Payment_Key__c != 'INBW' ||
                            billingLineItem.Terms_of_Payment_Key__c != 'INEL' ||
                            billingLineItem.Terms_of_Payment_Key__c != 'INPS' ||
                            billingLineItem.Terms_of_Payment_Key__c != 'INPT' ||
                            billingLineItem.Terms_of_Payment_Key__c != 'INST'
                            )
                        ){
                            mapKey = billingLineItem.Payment_Group__c + '01';
                        }Else{   
                                if(billingLineItem.Terms_of_Payment_Key__c == 'INBW'){
                                mapKey = 'INBW';
                            }Else if(billingLineItem.Terms_of_Payment_Key__c == 'INEL'){
                                mapKey = 'INEL';
                            }Else if(billingLineItem.Terms_of_Payment_Key__c == 'INPS'){
                                mapKey = 'INPS';
                            }Else if(billingLineItem.Terms_of_Payment_Key__c == 'INPT'){
                                mapKey = 'INPT';
                            }Else if(billingLineItem.Terms_of_Payment_Key__c == 'INST'){
                                mapKey = 'INST';
                            }Else{}
                            //mapKey = billingLineItem.Payment_Group__c + '01';
                        }
                        billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '0';
                    }
                    else if(billingLineItem.Milestone_Number__c == '000000000000' && billingLineItem.Payment_Group__c == 'IN'){
                            if(mapPaymentTerm.get('IN00') != null &&
                               (billingLineItem.Terms_of_Payment_Key__c != 'INBW' ||
                                billingLineItem.Terms_of_Payment_Key__c != 'INEL' ||
                                billingLineItem.Terms_of_Payment_Key__c != 'INPS' ||
                                billingLineItem.Terms_of_Payment_Key__c != 'INPT' ||
                                billingLineItem.Terms_of_Payment_Key__c != 'INST'
                               )
                            ){ 
                                mapKey = billingLineItem.Payment_Group__c + '00';
                            }Else{
                                if(billingLineItem.Terms_of_Payment_Key__c == 'INBW'){
                                    mapKey = 'INBW';
                                }Else if(billingLineItem.Terms_of_Payment_Key__c == 'INEL'){
                                    mapKey = 'INEL';
                                }Else if(billingLineItem.Terms_of_Payment_Key__c == 'INPS'){
                                    mapKey = 'INPS';
                                }Else if(billingLineItem.Terms_of_Payment_Key__c == 'INPT'){
                                    mapKey = 'INPT';
                                }Else if(billingLineItem.Terms_of_Payment_Key__c == 'INST'){
                                    mapKey = 'INST';
                                }Else{}
                            }
                            billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '0';
                    }
                    if(billingLineItem.Milestone_Number__c != '000000000000' && billingLineItem.Payment_Group__c == 'PL'){
                            mapKey = billingLineItem.Terms_of_Payment_Key__c + '1';
                            billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '0';
                    }
                    else if(billingLineItem.Milestone_Number__c == '000000000000' && billingLineItem.Payment_Group__c == 'PL'){
                            mapKey = billingLineItem.Terms_of_Payment_Key__c + '0';
                            billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '0';
                    }
                    else if(billingLineItem.Payment_Group__c != 'IN' && billingLineItem.Payment_Group__c != 'PL'){
                        mapKey = billingLineItem.Terms_of_Payment_Key__c;
                        billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '0';
                    }
                    newBillingPlanLineItems.put(mapKey, billingLineItem);
                }
            }
           system.debug('newBillingPlanLineItems--'+newBillingPlanLineItems);
            if(plan.Payment_Plan_Line_Items__r != null && plan.Payment_Plan_Line_Items__r.size() > 0){
                for(Payment_Plan_Line_Item__c planLineItem : plan.Payment_Plan_Line_Items__r){
                    String mapKey;
                    if(planLineItem.Milestone_Number__c != '000000000000' && planLineItem.Payment_Group__c == 'IN'){
                        if(mapPaymentTerm.get('IN01') != null &&
                               (planLineItem.Terms_of_Payment_Key__c != 'INBW' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INEL' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INPS' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INPT' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INST'
                               )
                            ){
                            mapKey = planLineItem.Payment_Group__c + '01';
                        }Else{
                            if(planLineItem.Terms_of_Payment_Key__c == 'INBW'){
                                mapKey = 'INBW';
                            }Else if(planLineItem.Terms_of_Payment_Key__c == 'INEL'){
                                mapKey = 'INEL';
                            }Else if(planLineItem.Terms_of_Payment_Key__c == 'INPS'){
                                mapKey = 'INPS';
                            }Else if(planLineItem.Terms_of_Payment_Key__c == 'INPT'){
                                mapKey = 'INPT';
                            }Else if(planLineItem.Terms_of_Payment_Key__c == 'INST'){
                                mapKey = 'INST';
                            }Else{}
                        }
                        //mapKey = planLineItem.Payment_Group__c + '01';
                    }
                    else if(planLineItem.Milestone_Number__c == '000000000000' && planLineItem.Payment_Group__c == 'IN'){
                        if(mapPaymentTerm.get('IN00') != null &&
                               (planLineItem.Terms_of_Payment_Key__c != 'INBW' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INEL' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INPS' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INPT' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INST'
                               )
                            ){
                            mapKey = planLineItem.Payment_Group__c + '00';
                        }Else{
                            if(planLineItem.Terms_of_Payment_Key__c == 'INBW'){
                                mapKey = 'INBW';
                            }Else if(planLineItem.Terms_of_Payment_Key__c == 'INEL'){
                                mapKey = 'INEL';
                            }Else if(planLineItem.Terms_of_Payment_Key__c == 'INPS'){
                                mapKey = 'INPS';
                            }Else if(planLineItem.Terms_of_Payment_Key__c == 'INPT'){
                                mapKey = 'INPT';
                            }Else if(planLineItem.Terms_of_Payment_Key__c == 'INST'){
                                mapKey = 'INST';
                            }Else{}
                        }
                        // //mapKey = planLineItem.Payment_Group__c + '00';
                    }
                    if(planLineItem.Milestone_Number__c != '000000000000' && planLineItem.Payment_Group__c == 'PL'){
                            mapKey = planLineItem.Terms_of_Payment_Key__c + '1';
                    }
                    else if(planLineItem.Milestone_Number__c == '000000000000' && planLineItem.Payment_Group__c == 'PL'){
                            mapKey = planLineItem.Terms_of_Payment_Key__c + '0';
                    }
                    else if(planLineItem.Payment_Group__c != 'IN'){ ///&& planLineItem.Payment_Group__c != 'PL'
                        mapKey = planLineItem.Terms_of_Payment_Key__c;
                    }
                    Billing_Plan_Line_Item__c newItem = new Billing_Plan_Line_Item__c();
                    newItem.Percentage_Of_Value_To_Be_Invoiced__c = '0';
                    if(newBillingPlanLineItems.get(mapKey) != null){
                        newItem = newBillingPlanLineItems.get(mapKey);
                    }
                    system.debug('AAAAAAAAAAAAAA'+mapKey);
                    newItem.Billing_Block_For_Payment_Plan__c = planLineItem.Billing_Block_For_Payment_Plan__c;
                    newItem.Date_Category__c = planLineItem.Date_Category__c;
                    newItem.Date_Description__c = planLineItem.Date_Description__c;
                    newItem.Milestone_Number__c = planLineItem.Milestone_Number__c;
                    newItem.Value_to_be_Billed__c = planLineItem.Value_to_be_Billed__c;
                    newItem.Usage__c = planLineItem.Usage__c;
                    newItem.Payment_Plan__c = plan.Id;
                    if(planLineItem.Payment_Group__c == 'IN'){
                        if(planLineItem.Milestone_Number__c != '000000000000'){
                            newItem.Percentage_Of_Value_To_Be_Invoiced__c = String.valueof(Decimal.valueof(newItem.Percentage_Of_Value_To_Be_Invoiced__c) + Decimal.valueof(planLineItem.Percentage_Of_Value_To_Be_Invoiced__c));
                            if(mapPaymentTerm.get('IN01') != null &&
                               (planLineItem.Terms_of_Payment_Key__c != 'INBW' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INEL' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INPS' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INPT' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INST'
                               )
                            ){
                                    newItem.Order__c = mapPaymentTerm.get('IN01').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('IN01').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('IN01').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = planLineItem.Payment_Group__c + '01';
                            }else if(mapPaymentTerm.get('INBW') != null && planLineItem.Terms_of_Payment_Key__c == 'INBW'){
                                    newItem.Order__c = mapPaymentTerm.get('INBW').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('INBW').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('INBW').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = 'INBW';
                            }else if(mapPaymentTerm.get('INEL') != null && planLineItem.Terms_of_Payment_Key__c == 'INEL'){
                                    newItem.Order__c = mapPaymentTerm.get('INEL').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('INEL').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('INEL').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = 'INEL';
                            }else if(mapPaymentTerm.get('INPS') != null && planLineItem.Terms_of_Payment_Key__c == 'INPS'){
                                    newItem.Order__c = mapPaymentTerm.get('INPS').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('INPS').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('INPS').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = 'INPS';
                            }else if(mapPaymentTerm.get('INPT') != null && planLineItem.Terms_of_Payment_Key__c == 'INPT'){
                                    newItem.Order__c = mapPaymentTerm.get('INPT').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('INPT').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('INPT').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = 'INPT';
                            }else if(mapPaymentTerm.get('INST') != null && planLineItem.Terms_of_Payment_Key__c == 'INST'){
                                    newItem.Order__c = mapPaymentTerm.get('INST').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('INST').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('INST').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = 'INST';
                            }/*else {
                                    newItem.Order__c = mapPaymentTerm.get('planLineItem.Terms_of_Payment_Key__c').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('planLineItem.Terms_of_Payment_Key__c').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('planLineItem.Terms_of_Payment_Key__c').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = mapPaymentTerm.get(planLineItem.Terms_of_Payment_Key__c).Name;
                            }*/
                        }                           
                       
                        else if(planLineItem.Milestone_Number__c == '000000000000'){
                            newItem.Percentage_Of_Value_To_Be_Invoiced__c = String.valueof(Decimal.valueof(newItem.Percentage_Of_Value_To_Be_Invoiced__c) + Decimal.valueof(planLineItem.Percentage_Of_Value_To_Be_Invoiced__c));
                            if(mapPaymentTerm.get('IN00') != null &&
                               (planLineItem.Terms_of_Payment_Key__c != 'INBW' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INEL' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INPS' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INPT' ||
                                planLineItem.Terms_of_Payment_Key__c != 'INST'
                               )
                            ){
                                    newItem.Order__c = mapPaymentTerm.get('IN00').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('IN00').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('IN00').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = planLineItem.Payment_Group__c + '00';
                            }else if(mapPaymentTerm.get('INBW') != null && planLineItem.Terms_of_Payment_Key__c == 'INBW'){
                                    newItem.Order__c = mapPaymentTerm.get('INBW').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('INBW').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('INBW').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = 'INBW';
                            }else if(mapPaymentTerm.get('INEL') != null && planLineItem.Terms_of_Payment_Key__c == 'INEL'){
                                    newItem.Order__c = mapPaymentTerm.get('INEL').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('INEL').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('INEL').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = 'INEL';
                            }else if(mapPaymentTerm.get('INPS') != null && planLineItem.Terms_of_Payment_Key__c == 'INPS'){
                                    newItem.Order__c = mapPaymentTerm.get('INPS').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('INPS').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('INPS').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = 'INPS';
                            }else if(mapPaymentTerm.get('INPT') != null && planLineItem.Terms_of_Payment_Key__c == 'INPT'){
                                    newItem.Order__c = mapPaymentTerm.get('INPT').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('INPT').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('INPT').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = 'INPT';
                            }else if(mapPaymentTerm.get('INST') != null && planLineItem.Terms_of_Payment_Key__c == 'INST'){
                                    newItem.Order__c = mapPaymentTerm.get('INST').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('INST').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('INST').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = 'INST';
                            }/*else {
                                    newItem.Order__c = mapPaymentTerm.get('planLineItem.Terms_of_Payment_Key__c').Order__c;
                                    newItem.Due_After_Days__c = mapPaymentTerm.get('planLineItem.Terms_of_Payment_Key__c').Due_Days__c;
                                    newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get('planLineItem.Terms_of_Payment_Key__c').Detailed_Description__c;
                                    newItem.Terms_of_Payment_Key__c = mapPaymentTerm.get(planLineItem.Terms_of_Payment_Key__c).Name;
                            }*/
                        }
                    }
                    else if(planLineItem.Payment_Group__c != 'IN' && planLineItem.Payment_Group__c != 'PL'){
                        newItem.Percentage_Of_Value_To_Be_Invoiced__c = String.valueof(Decimal.valueof(planLineItem.Percentage_Of_Value_To_Be_Invoiced__c));                   
                            if(mapPaymentTerm != null && mapPaymentTerm.size() > 0 && 
                            mapPaymentTerm.get(planLineItem.Terms_of_Payment_Key__c) != null){
                                newItem.Order__c = mapPaymentTerm.get(planLineItem.Terms_of_Payment_Key__c).Order__c;
                                newItem.Terms_of_Payment_Key__c = mapPaymentTerm.get(planLineItem.Terms_of_Payment_Key__c).Name;
                                newItem.Due_After_Days__c = mapPaymentTerm.get(planLineItem.Terms_of_Payment_Key__c).Due_Days__c;
                                newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get(planLineItem.Terms_of_Payment_Key__c).Detailed_Description__c;
                            }
                    }
                    else if(planLineItem.Payment_Group__c == 'PL'){
                        //system.debug('mapPlinthmapPlinth--'+mapPlinth);
                        newItem.Percentage_Of_Value_To_Be_Invoiced__c = String.valueof(Decimal.valueof(planLineItem.Percentage_Of_Value_To_Be_Invoiced__c));                   
                            if(planLineItem.Milestone_Number__c == '000000000000'){
                                string plintkey = planLineItem.Terms_of_Payment_Key__c + '0';
                                if(mapPaymentTerm.get(plintkey) != null){
                                newItem.Order__c = mapPaymentTerm.get(plintkey).Order__c;
                                newItem.Terms_of_Payment_Key__c = mapPaymentTerm.get(plintkey).Name;
                                newItem.Due_After_Days__c = mapPaymentTerm.get(plintkey).Due_Days__c;
                                newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get(plintkey).Detailed_Description__c;}
                            }
                            else if(planLineItem.Milestone_Number__c != '000000000000'){
                                string plintkey = planLineItem.Terms_of_Payment_Key__c + '1';
                                if(mapPaymentTerm.get(plintkey) != null){
                                newItem.Order__c = mapPaymentTerm.get(plintkey).Order__c;
                                newItem.Terms_of_Payment_Key__c = mapPaymentTerm.get(plintkey).Name;
                                newItem.Due_After_Days__c = mapPaymentTerm.get(plintkey).Due_Days__c;
                                newItem.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get(plintkey).Detailed_Description__c;}
                            }
                    }
                    newItem.Percentage__c= Decimal.valueOf(newItem.Percentage_Of_Value_To_Be_Invoiced__c) ;
                    newBillingPlanLineItems.put(mapKey,newItem);
                    uniqueKey.add(mapKey);
                    system.debug('mapKey--'+mapKey);
                    system.debug('uniqueKey--'+uniqueKey);
                    
                }
            }
        }
        system.debug('newBillingPlanLineItemsafterloop'+newBillingPlanLineItems);
        //Logic to make billing plan invalid when new slab is casted Start
        map<String,String> mapBPlineItem = new map<String,String>();
        for(Billing_Plan_Line_Item__c pli : newBillingPlanLineItems.values()){
            if(pli.Terms_of_Payment_Key__c == 'IN01'){
                mapBPlineItem.put(pli.Payment_Group__c,pli.Percentage_Of_Value_To_Be_Invoiced__c);
            }
            else if(pli.Terms_of_Payment_Key__c == 'PL01' && pli.Milestone_Number__c == '000000000000'){
                mapBPlineItem.put(pli.Payment_Group__c,pli.Milestone_Number__c);
            }
        }
        //BillingPlanLineItemSlabController.stopBillingLineItems(mapBPlineItem,scope[0].Tower__c);
        //Logic to make billing plan invalid when new slab is casted Stop
        for(String mKey : uniqueKey){
            if(mapPaymentTerm != null && mapPaymentTerm.size()>0 && mapPaymentTerm.containskey(mKey)){
                system.debug('mKey--------------------'+mKey);
            listToUpsert.add(newBillingPlanLineItems.get(mKey));
            newBillingPlanLineItems.remove(mKey);}
        }
        system.debug('listToUpsert'+listToUpsert);
        system.debug('record to insert ---->> ' + listToUpsert.size());
        if(listToUpsert.size() > 0){
            upsert new List<Billing_Plan_Line_Item__c>(listToUpsert);
        }
        
        system.debug('@@listToUpsert-->'+listToUpsert);
        system.debug('newBillingPlanLineItems-->'+newBillingPlanLineItems.values());
        system.debug('newBillingPlanLineItemsnewBillingPlanLineItems-->'+newBillingPlanLineItems.size());
        if(newBillingPlanLineItems.values() != null && newBillingPlanLineItems.values().size() > 0){
            if(!test.isRunningTest()){
            delete newBillingPlanLineItems.values();
            }
        }
        if(scope != null && !scope.isEmpty()){
            scope[0].Active__c = true;
            update scope;
        }
    }  
}