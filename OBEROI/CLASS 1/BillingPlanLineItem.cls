public class BillingPlanLineItem {
    
    public static void createBillingLineItemsFuture(String billingPlanIds){
        List<Payment_Plan__c> scope = [Select Id,(Select Billing_Block_For_Payment_Plan__c,Order__c,Due_After_Days__c,Payment_Plan_Line_Item_Name__c,Amount_Percent_BSP__c,Payment_Plan__c, Date_Category__c, Date_Description__c, Milestone_Number__c, Percentage_Of_Value_To_Be_Invoiced__c, Value_to_be_Billed__c, Usage__c, Terms_of_Payment_Key__c, Payment_Group__c From Payment_Plan_Line_Items__r Order By Payment_Group__c),
                                         (Select Billing_Block_For_Payment_Plan__c,Amount_Percent_BSP__c, Date_Category__c,Payment_Plan__c, Date_Description__c, Milestone_Number__c, Order__c,Payment_Plan_Line_Item_Name__c,Percentage_Of_Value_To_Be_Invoiced__c, Value_to_be_Billed__c, Usage__c, Terms_of_Payment_Key__c, Due_After_Days__c,Payment_Group__c From Billing_Plan_Line_Items__r Order By Payment_Group__c) 
                                         From Payment_Plan__c where ID =: billingPlanIds];
        System.debug('scope : Payment_Plan_Line_Items__r : ' + scope[0].Payment_Plan_Line_Items__r);
         System.debug('scope : Billing_Plan_Line_Items__r : ' + scope[0].Billing_Plan_Line_Items__r);
        system.debug('scope ---->> ' + scope[0].Payment_Plan_Line_Items__r.size());
        List<Billing_Plan_Line_Item__c> listToUpsert = new List<Billing_Plan_Line_Item__c>();
        Set<String> uniqueKey= new Set<String>();
        Map<String,Billing_Plan_Line_Item__c> newBillingPlanLineItems = new Map<String,Billing_Plan_Line_Item__c>();
        Map<Id,Id> mapBillPlanIdToBPliID = new Map<Id,Id>();
       //existing
        for(Payment_Plan__c plan : scope){
            if(plan.Billing_Plan_Line_Items__r != null && plan.Billing_Plan_Line_Items__r.size() > 0){
                for(Billing_Plan_Line_Item__c billingLineItem : plan.Billing_Plan_Line_Items__r){
                    String mapKey;
                    if(billingLineItem.Milestone_Number__c == '0'){
                        mapKey = billingLineItem.Payment_Group__c + '-' + '0';
                        billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '0';
                    }else{
                        mapKey = billingLineItem.Payment_Group__c + '-' + '1';
                        billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '0';
                    }
                    newBillingPlanLineItems.put(mapKey, billingLineItem);
                }
            }
            
            if(plan.Payment_Plan_Line_Items__r != null && plan.Payment_Plan_Line_Items__r.size() > 0){
                for(Payment_Plan_Line_Item__c planLineItem : plan.Payment_Plan_Line_Items__r){
                    String mapKey;
                    if(planLineItem.Milestone_Number__c == '0'){
                        mapKey = planLineItem.Payment_Group__c + '-' + '0';
                    }else{
                        mapKey = planLineItem.Payment_Group__c + '-' + '1';
                    }
                    Billing_Plan_Line_Item__c newItem = new Billing_Plan_Line_Item__c();
                    newItem.Percentage_Of_Value_To_Be_Invoiced__c = '0';
                    if(newBillingPlanLineItems.get(mapKey) != null){
                        newItem = newBillingPlanLineItems.get(mapKey);
                    }
                    newItem.Billing_Block_For_Payment_Plan__c = planLineItem.Billing_Block_For_Payment_Plan__c;
                    newItem.Date_Category__c = planLineItem.Date_Category__c;
                    newItem.Date_Description__c = planLineItem.Date_Description__c;
                    newItem.Milestone_Number__c = '1';
                    newItem.Value_to_be_Billed__c = planLineItem.Value_to_be_Billed__c;
                    newItem.Usage__c = planLineItem.Usage__c;
                    newItem.Terms_of_Payment_Key__c = planLineItem.Terms_of_Payment_Key__c;
                    newItem.Payment_Plan__c = plan.Id;
                    newItem.Order__c = planLineItem.Order__c;
                    newItem.Due_After_Days__c=planLineItem.Due_After_Days__c;
                    
                    if(planLineItem.Payment_Group__c== 'IN' ){
                        
                        newItem.Payment_Plan_Line_Item_Name__c = 'Proportionate N instalments upon casting of relevant slabs.Out of which * relevant slabs have been casted and the relevant amount of Rs. * towards the Sale Price is payable as below';
                        
                    }
                    
                    else{
                        newItem.Payment_Plan_Line_Item_Name__c = planLineItem.Payment_Plan_Line_Item_Name__c;
                    }
                    
                    if(planLineItem.Milestone_Number__c != '0'){
                        newItem.Percentage_Of_Value_To_Be_Invoiced__c = String.valueof(Decimal.valueof(newItem.Percentage_Of_Value_To_Be_Invoiced__c) + Decimal.valueof(planLineItem.Percentage_Of_Value_To_Be_Invoiced__c));
                        newItem.Terms_of_Payment_Key__c = planLineItem.Payment_Group__c + '01';
                        
                    }else{
                        newItem.Percentage_Of_Value_To_Be_Invoiced__c = String.valueof(Decimal.valueof(newItem.Percentage_Of_Value_To_Be_Invoiced__c) + Decimal.valueof(planLineItem.Percentage_Of_Value_To_Be_Invoiced__c));
                        newItem.Terms_of_Payment_Key__c = planLineItem.Payment_Group__c + '01';
                    }
                    newItem.Percentage__c= Decimal.valueOf(newItem.Percentage_Of_Value_To_Be_Invoiced__c) ;
                    newBillingPlanLineItems.put(mapKey,newItem);
                    uniqueKey.add(mapKey);
                    system.debug('newItem: '+newItem);
                    if(newItem.Payment_Plan_Line_Item_Name__c.contains('Proportionate') && !newItem.Milestone_Number__c.contains('1') && !planLineItem.Milestone_Number__c.contains('2') &&
                    !newItem.Milestone_Number__c.contains('3') && !newItem.Milestone_Number__c.contains('4') &&
                    !newItem.Milestone_Number__c.contains('5') && !newItem.Milestone_Number__c.contains('6') &&
                    !newItem.Milestone_Number__c.contains('7') && !newItem.Milestone_Number__c.contains('8') &&
                    !newItem.Milestone_Number__c.contains('9') ){
                    Billing_Plan_Line_Item__c newItem_new = newItem.clone();
                    newItem_new.Payment_Plan_Line_Item_Name__c = 'To Be paid on or before <Date>';
                    newItem_new.Milestone_Number__c = '0';
                    newItem_new.Percentage__c= 12;
                    newItem_new.Percentage_Of_Value_To_Be_Invoiced__c = string.valueOf(12);
                    newItem.Milestone_Number__c = planLineItem.Milestone_Number__c;
                    newBillingPlanLineItems.put('IN001',newItem_new);
                    uniqueKey.add('IN001');
                }
                    system.debug('uniqueKey--'+uniqueKey);
                }
            }
        }
        system.debug('newBillingPlanLineItemsafterloop'+newBillingPlanLineItems);
        for(String mKey : uniqueKey){
            listToUpsert.add(newBillingPlanLineItems.get(mKey));
            newBillingPlanLineItems.remove(mKey);
        }
        system.debug('listToUpsert'+listToUpsert);
        system.debug('record to insert ---->> ' + listToUpsert.size());
        if(listToUpsert.size() > 0){
            upsert new List<Billing_Plan_Line_Item__c>(listToUpsert);
        }
        
        system.debug('@@listToUpsert-->'+listToUpsert);
        if(newBillingPlanLineItems.values() != null && newBillingPlanLineItems.values().size() > 0){
            delete newBillingPlanLineItems.values();
        }
      //  system.debug('@@scope[0].Billing_Plan_Line_Items__r-->'+scope[0].Billing_Plan_Line_Items__r);
        for(Billing_Plan_Line_Item__c bpliObj: listToUpsert){
        system.debug('@@bpliObj.Payment_Group__c'+bpliObj.Payment_Group__c);
          //  if(bpliObj.Terms_of_Payment_Key__c.contains('IN')){
            if(bpliObj.Terms_of_Payment_Key__c.contains('IN') && bpliObj.Milestone_number__c >'0'){
                mapBillPlanIdToBPliID.put(bpliObj.Payment_Plan__c,bpliObj.Id);
            }
        }
        system.debug('@@mapBillPlanIdToBPliID'+mapBillPlanIdToBPliID);
            // Copy IN Payment Plan Line Item into Billing Plan Sub Line Item
            List<Billing_Plan_Sub_Line_Item__c> existingBillSubLineItem = new List<Billing_Plan_Sub_Line_Item__c>();
            for(Billing_Plan_Line_Item__c u: [SELECT Id,Name,(SELECT Id,Name FROM Billing_Plan_Sub_Line_Items__r) 
                                               FROM Billing_Plan_Line_Item__c 
                                               WHERE ID=:listToUpsert])
                {   
                    for(Billing_Plan_Sub_Line_Item__c c:u.Billing_Plan_Sub_Line_Items__r)
                         existingBillSubLineItem.add(c);
                }

            if(existingBillSubLineItem.size()>0 && !existingBillSubLineItem.isEmpty()){
                delete existingBillSubLineItem;
            } 
         //To insert sublineitem with respect to IN payment Group   
            system.debug('mapBillPlanIdToBPliIDmapBillPlanIdToBPliID'+mapBillPlanIdToBPliID);
            List<Billing_Plan_Sub_Line_Item__c> bpSubLineItemList = new List<Billing_Plan_Sub_Line_Item__c>();
                //for(Payment_Plan_Line_Item__c ppliIn: scope[0].Payment_Plan_Line_Items__r){
                for(Payment_Plan_Line_Item__c ppliIn: [select id,Payment_Plan__c,Amount_Percent_BSP__c,
                Payment_Plan_Line_Item_Name__c,Percentage_Of_Value_To_Be_Invoiced__c,Order__c,
                Terms_of_Payment_Key__c,Payment_Group__c,Milestone_Number__c
                from Payment_Plan_Line_Item__c where Payment_Plan__c IN : mapBillPlanIdToBPliID.keyset()]){
                  //   if(ppliIn.Payment_Group__c == 'IN' && ppliIn.Milestone_Number__c!= '0'){
                    if(ppliIn.Payment_Group__c == 'IN' && ppliIn.Milestone_Number__c > '0' &&
                    mapBillPlanIdToBPliID != null && mapBillPlanIdToBPliID.size() > 0){
                      system.debug('mapBillPlanIdToBPliIDmapBillPlanIdToBPliID'+mapBillPlanIdToBPliID.get(ppliIn.Payment_Plan__c));
                      Billing_Plan_Sub_Line_Item__c newBpsli = new Billing_Plan_Sub_Line_Item__c();
                      newBpsli.Billing_Plan_Line_Item__c = mapBillPlanIdToBPliID.get(ppliIn.Payment_Plan__c);
                      newBpsli.Amount_Percent_BSP__c = ppliIn.Amount_Percent_BSP__c;
                      newBpsli.Billing_Plan_Sub_Line_Item_Name__c = ppliIn.Payment_Plan_Line_Item_Name__c;
                      newBpsli.Percentage_Of_Value_To_Be_Invoiced__c = ppliIn.Percentage_Of_Value_To_Be_Invoiced__c;
                      newBpsli.Order__c = ppliIn.Order__c;
                      newBpsli.Terms_of_Payment_Key__c = ppliIn.Terms_of_Payment_Key__c;
                      newBpsli.Payment_Group__c = ppliIn.Payment_Group__c;
                      newBpsli.Milestone_Number__c = ppliIn.Milestone_Number__c;
                      bpSubLineItemList.add(newBpsli);
                    }
                }
                if(bpSubLineItemList.size()>0 && !bpSubLineItemList.isEmpty()){
                        insert bpSubLineItemList;
                }
        
        for(Billing_Plan_Line_Item__c bpliObj: listToUpsert){
            if(bpliObj.Terms_of_Payment_Key__c.contains('IN') && bpliObj.Milestone_number__c >'0'){
                mapBillPlanIdToBPliID.put(bpliObj.Payment_Plan__c,bpliObj.Id);
            }
        }
    }  

}