public class BillingPlanLineItemTriggerHandler{

//Method to assign Payment term key, date description and Usage
 public static void onAfterInsert(List<Billing_plan_line_Item__c> LineItemList){  
 map<string, Integer> mapGroupToCount = new map<string, integer>();
  Id customizeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
 Integer CountGroup = 1;
 Set<id> setId = new Set<Id>();
 List<Billing_Plan_Line_Item__c> listToUpdateBpli = new List<Billing_Plan_Line_Item__c>();
 Set<id> setBillingPlanId = new set<id>();
 
  for(Billing_plan_line_Item__c bpli: LineItemList)
       {
           setBillingPlanId.add(bpli.payment_Plan__c);
           }
      map<Id,payment_Plan__c> mapBillingToPlan = new map<Id,payment_Plan__c>([SELECT Id, RecordTypeId
                                                                       FROM payment_Plan__c
                                                                       WHERE Id=:setBillingPlanId]);
     for(Billing_plan_line_Item__c bpli: LineItemList){
      system.debug('@@enter');  
      system.debug('bpli.payment_Plan__c '+bpli.payment_Plan__c );
      system.debug('bpli.payment_Plan__r.RecordTypeId '+bpli.payment_Plan__r.RecordTypeId );
     if(mapBillingToPlan.get(bpli.payment_Plan__c).RecordTypeId == customizeRecordTypeId ){
             setId.add(bpli.Id);
           
     system.debug('@@setId'+setId);  
          if (mapGroupToCount.containsKey(bpli.Payment_Group__c))
            {
                Integer existingCount = mapGroupToCount.get(bpli.Payment_Group__c);
                existingCount = existingCount +1;
                mapGroupToCount.put(bpli.Payment_Group__c, existingCount);
                }
                else {
                mapGroupToCount.put(bpli.Payment_Group__c, CountGroup);
                }
           }
     }
     system.debug('@@mapGroupToCount'+mapGroupToCount);
     
     for(Billing_Plan_Line_Item__c bpliItem: [SELECT Id,Payment_Group__c, Terms_of_Payment_Key__c 
                                             FROM Billing_Plan_Line_Item__c
                                             WHERE Id=:setId order by Sequence_Number__c desc]){
         bpliItem.Terms_of_Payment_Key__c = bpliItem.Payment_Group__c +'0'+mapGroupToCount.get(bpliItem.Payment_Group__c);
         if(mapGroupToCount.get(bpliItem.Payment_Group__c) > 1){
             Integer countDecrease= mapGroupToCount.get(bpliItem.Payment_Group__c)-1;
             mapGroupToCount.put(bpliItem.Payment_Group__c, countDecrease);
           }
             if(bpliItem.Payment_Group__c !='IN'){
                bpliItem.Date_Description__c = bpliItem.Terms_of_Payment_Key__c;
               }
            else{
                bpliItem.Date_Description__c = 'SL'+bpliItem.Terms_of_Payment_Key__c.right(2);
            }
             listToUpdateBpli.add(bpliItem);
     }
     if(listToUpdateBpli.size()>0 && !listToUpdateBpli.isEmpty()){
         update listToUpdateBpli;
     }
 }
 /*
public static void handleAfterInsert(List<Billing_plan_line_Item__c> billingPlanLineItemList){
      
      System.Debug(' #### '+billingPlanLineItemList);

    Id NonSchemeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
    Set<Id> exsistingBPId = new Set<Id>();
    Map<Id,Id> mapOfNewBPLineItemToExistingBP = new Map<id,Id>();
    Map<Id,Id> mapOfExistingBPToExistingBPLineItem = new Map<Id,Id>();
    Map<Id,List<Billing_Plan_Sub_Line_Item__c>> mapExistingBPLineItemToExistingBPSubLineItem = new Map<Id,List<Billing_Plan_Sub_Line_Item__c>>();
    List<Billing_Plan_Sub_Line_Item__c> listOfNewBPSubLineItem = new List<Billing_Plan_Sub_Line_Item__c>();
    
    for(Billing_plan_line_Item__c newBillingPlanLineItemObject: billingPlanLineItemList){
        system.debug('<<<<<Inside First For Loop'+newBillingPlanLineItemObject);
        system.debug(' ppppPayment Plan value'+newBillingPlanLineItemObject.Payment_Plan__c);
      
      if(newBillingPlanLineItemObject.Payment_Group__c == 'IN' && newBillingPlanLineItemObject.Line_Item_Type__c == 'Construction Linked'){
          system.debug('Tower Value'+newBillingPlanLineItemObject.Default_Billing_Plan_test__c);
          exsistingBPId.add(newBillingPlanLineItemObject.Default_Billing_Plan_test__c);
          system.debug('$$$Existing BPID'+exsistingBPId);
          mapOfNewBPLineItemToExistingBP.put(newBillingPlanLineItemObject.id,newBillingPlanLineItemObject.Default_Billing_Plan_test__c);
          system.debug('&&Map of Single New BP Line Item to Single Existing Billing Plan'+mapOfNewBPLineItemToExistingBP);
            
        }

    }
    
    
   List<Billing_plan_line_Item__c>  exsistingBPLineItemObj1=[SELECT Id, Name,Payment_Plan__c,Payment_Group__c,Line_Item_Type__c FROM Billing_plan_line_Item__c WHERE Payment_Plan__r.id =: exsistingBPId AND Payment_Group__c = 'IN' AND Line_Item_Type__c = 'contruction linked'];
   system.debug(' %%%%% '+exsistingBPLineItemObj1);
   // for(Billing_plan_line_Item__c exsistingBPLineItemObj: [SELECT Id, Name,Payment_Plan__c,Payment_Group__c,Line_Item_Type__c FROM //Billing_plan_line_Item__c WHERE Payment_Plan__c IN: exsistingBPId LIMIT 1]){
    for(Billing_plan_line_Item__c exsistingBPLineItemObj: exsistingBPLineItemObj1){
     mapOfExistingBPToExistingBPLineItem.put(exsistingBPLineItemObj.Payment_Plan__c,exsistingBPLineItemObj.id);
     system.debug('QUATER FINAL DATA'+mapOfExistingBPToExistingBPLineItem.values());
    
    // mapOfExistingBPToExistingBPLineItem.put(exsistingBPLineItemObj.Payment_Plan__c,new List<Billing_Plan_Line_Item__c>{exsistingBPLineItemObj});
     system.debug('***Map of existing BPLI to Existing BP'+mapOfExistingBPToExistingBPLineItem);
    }

    for(Billing_Plan_Sub_Line_Item__c exsistingBPSubLineItemObj: [SELECT Id,Name,Billing_Plan_Line_Item__c,Milestone_Number__c,Terms_of_Payment_Key__c,Percentage_Of_Value_To_Be_Invoiced__c,Payment_Group__c,Order__c ,Billing_Plan_Sub_Line_Item_Name__c,Amount_Percent_BSP__c FROM Billing_Plan_Sub_Line_Item__c WHERE Billing_Plan_Line_Item__c =: mapOfExistingBPToExistingBPLineItem.values()]){
     system.debug('SEMI FINAL DATA'+exsistingBPSubLineItemObj);
        mapExistingBPLineItemToExistingBPSubLineItem.put(exsistingBPSubLineItemObj.Billing_Plan_Line_Item__c,new List<Billing_Plan_Sub_Line_Item__c>{exsistingBPSubLineItemObj});
        system.debug('FINAL DATA'+mapExistingBPLineItemToExistingBPSubLineItem);
    }


    for(Billing_plan_line_Item__c newBPLineItemObj: billingPlanLineItemList){

        for(Billing_Plan_Sub_Line_Item__c obj: mapExistingBPLineItemToExistingBPSubLineItem.get(mapOfExistingBPToExistingBPLineItem.get(mapOfNewBPLineItemToExistingBP.get(newBPLineItemObj.id)))){

            Billing_Plan_Sub_Line_Item__c bpLineItemInstance = new Billing_Plan_Sub_Line_Item__c();
            bpLineItemInstance.Billing_Plan_Line_Item__c = newBPLineItemObj.id;
            bpLineItemInstance.Milestone_Number__c = obj.Milestone_Number__c;
            bpLineItemInstance.Terms_of_Payment_Key__c=obj.Terms_of_Payment_Key__c;
            bpLineItemInstance.Percentage_Of_Value_To_Be_Invoiced__c=obj.Percentage_Of_Value_To_Be_Invoiced__c;
            bpLineItemInstance.Payment_Group__c=obj.Payment_Group__c;
            bpLineItemInstance.Order__c = obj.Order__c;
            bpLineItemInstance.Billing_Plan_Sub_Line_Item_Name__c =obj.Billing_Plan_Sub_Line_Item_Name__c;
            bpLineItemInstance.Amount_Percent_BSP__c = obj.Amount_Percent_BSP__c;
            listOfNewBPSubLineItem.add(bpLineItemInstance);
        }
    }

    if(listOfNewBPSubLineItem.size()>0 && !listOfNewBPSubLineItem.isEmpty()){
        insert listOfNewBPSubLineItem;
    }


}*/
}