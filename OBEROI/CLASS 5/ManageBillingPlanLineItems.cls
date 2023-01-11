public class ManageBillingPlanLineItems implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('Select Id,(Select Billing_Block_For_Payment_Plan__c, Date_Category__c, Date_Description__c, Milestone_Number__c, Percentage_Of_Value_To_Be_Invoiced__c, Value_to_be_Billed__c, Usage__c, Terms_of_Payment_Key__c, Payment_Group__c From Payment_Plan_Line_Items__r Order By Payment_Group__c), (Select Billing_Block_For_Payment_Plan__c, Date_Category__c, Date_Description__c, Milestone_Number__c, Percentage_Of_Value_To_Be_Invoiced__c, Value_to_be_Billed__c, Usage__c, Terms_of_Payment_Key__c, Payment_Group__c From Billing_Plan_Line_Items__r Order By Payment_Group__c) From Payment_Plan__c where Active__c = true AND Id = \'a0tp0000002g8x5\'');
    }
    
    public void execute(Database.BatchableContext BC, List<Payment_Plan__c> scope){
        system.debug('scope ---->> ' + scope[0].Payment_Plan_Line_Items__r.size());
        List<Billing_Plan_Line_Item__c> listToUpsert = new List<Billing_Plan_Line_Item__c>();
        Set<String> uniqueKey= new Set<String>();
        Map<String,Billing_Plan_Line_Item__c> newBillingPlanLineItems = new Map<String,Billing_Plan_Line_Item__c>();
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
        system.debug('newBillingPlanLineItems--'+newBillingPlanLineItems);
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
                    newItem.Milestone_Number__c = planLineItem.Milestone_Number__c;
                    newItem.Value_to_be_Billed__c = planLineItem.Value_to_be_Billed__c;
                    newItem.Usage__c = planLineItem.Usage__c;
                    newItem.Terms_of_Payment_Key__c = planLineItem.Terms_of_Payment_Key__c;
                    newItem.Payment_Plan__c = plan.Id;
                    if(planLineItem.Milestone_Number__c != '0'){
                        newItem.Percentage_Of_Value_To_Be_Invoiced__c = String.valueof(Decimal.valueof(newItem.Percentage_Of_Value_To_Be_Invoiced__c) + Decimal.valueof(planLineItem.Percentage_Of_Value_To_Be_Invoiced__c));
                        newItem.Terms_of_Payment_Key__c = planLineItem.Payment_Group__c + '00';
                    }else{
                        newItem.Percentage_Of_Value_To_Be_Invoiced__c = String.valueof(Decimal.valueof(newItem.Percentage_Of_Value_To_Be_Invoiced__c) + Decimal.valueof(planLineItem.Percentage_Of_Value_To_Be_Invoiced__c));
                        newItem.Terms_of_Payment_Key__c = planLineItem.Payment_Group__c + '01';
                    }
                    newBillingPlanLineItems.put(mapKey,newItem);
                    uniqueKey.add(mapKey);
                    system.debug('uniqueKey--'+uniqueKey);
                }
            }
        }
        system.debug('newBillingPlanLineItems--'+newBillingPlanLineItems);
        for(String mKey : uniqueKey){
            listToUpsert.add(newBillingPlanLineItems.get(mKey));
            newBillingPlanLineItems.remove(mKey);
        }
        system.debug('listToUpsert'+listToUpsert);
        system.debug('record to insert ---->> ' + listToUpsert.size());
        if(listToUpsert.size() > 0){
            upsert new List<Billing_Plan_Line_Item__c>(listToUpsert);
        }
        if(newBillingPlanLineItems.values() != null && newBillingPlanLineItems.values().size() > 0){
            delete newBillingPlanLineItems.values();
        }

    }
    
    public void finish(Database.BatchableContext BC){
    }
}