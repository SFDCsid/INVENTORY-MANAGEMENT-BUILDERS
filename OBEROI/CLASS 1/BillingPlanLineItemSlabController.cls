/*
*  Author: Aditya Bhasin
*  Description: Handler Class for SAPInterfaceTrigger. 
*  Created: 27/07/2019
*  Change Log: Logic to make billing plan invalid when new slab is casted
*/
public class BillingPlanLineItemSlabController{

    public static void stopBillingLineItems(Map<String,String> mapBPlineItem, String tower){
        Set<Id> stBillingPlan = new Set<Id>();
        Id customRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId(); 
        Id nonSchemeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId(); 
        map<string,BillingPlan> billPlanObjs = new map<string,BillingPlan>();
        //map<String,String> mapBPlineItem = new map<String,String>();
        for(Payment_Plan__c pp : [select id,Property__r.Booking__c from Payment_Plan__c where Tower__c =: tower and (RecordTypeId =: customRecordTypeId OR RecordTypeId =: nonSchemeRecordTypeId) and Status__c != 'Invalid']){
            if(String.isBlank(pp.Property__r.Booking__c)){
            stBillingPlan.add(pp.Id);}
        }
        system.debug('stBillingPlanstBillingPlan'+stBillingPlan);
        for(Billing_Plan_Line_Item__c bpli : [select id,Milestone_Number__c, Payment_Group__c,Terms_of_Payment_Key__c,Percentage_Of_Value_To_Be_Invoiced__c,Payment_Plan__c from Billing_Plan_Line_Item__c where Payment_Plan__c IN : stBillingPlan]){
            system.debug('aaaaaaaaaaaaaaaaaaaaaaaaaa');
            if((bpli.Payment_Group__c == 'IN' && bpli.Milestone_Number__c != '000000000000') 
                || (bpli.Terms_of_Payment_Key__c == 'PL01' && bpli.Milestone_Number__c != '000000000000')){
                BillingPlan bPlanObj;
                if(billPlanObjs.containsKey(bpli.Payment_Plan__c)){
                    bPlanObj = billPlanObjs.get(bpli.Payment_Plan__c);           
                }else{
                    bPlanObj = new BillingPlan();
                    billPlanObjs.put(bpli.Payment_Plan__c,bPlanObj);
                } 
                bPlanObj.billPlanItems.add(bpli);
                //bPlanObj.billPlanObj = bpli.Payment_Plan__c;
            }
        }
        system.debug('billPlanObjsbillPlanObjs'+billPlanObjs);
        system.debug('billPlanObjsbillPlanObjs'+billPlanObjs.keyset());
        system.debug('billPlanObjsbillPlanObjs'+billPlanObjs.values());
        /*system.debug('defaultBPLineItemsdefaultBPLineItems'+defaultBPLineItems.keyset());
        system.debug('defaultBPLineItemsdefaultBPLineItems'+defaultBPLineItems.values());
        for(Billing_Plan_Line_Item__c pli : defaultBPLineItems.values()){
            if(pli.Terms_of_Payment_Key__c == 'IN01'){
                mapBPlineItem.put(pli.Payment_Group__c,pli.Percentage_Of_Value_To_Be_Invoiced__c);
            }
        }*/
        system.debug('mapBPlineItemmapBPlineItem'+mapBPlineItem.keyset());
        system.debug('mapBPlineItemmapBPlineItem'+mapBPlineItem.values());
        Set<Id> stPplan = new Set<Id>();
        for(BillingPlan bPlns: billPlanObjs.values()){
            
            for(Billing_Plan_Line_Item__c bPln : bPlns.billPlanItems){
                //system.debug('Payment_Group__c'+bPln.billPlanItems);
                system.debug('Payment_Group__c'+bPln.Payment_Group__c);
                system.debug('Milestone_Number__c'+bPln.Milestone_Number__c);
                system.debug('keykeykeykeyley'+mapBPlineItem.keyset());
                system.debug('valuevaluevlaue'+mapBPlineItem.values());
                system.debug('mapBPlineItemmapBPlineItem'+mapBPlineItem.get('IN'));
                system.debug('mapBPlineItemmapBPlineItem'+mapBPlineItem.get(bPln.Payment_Group__c));
                
                if(bPln.Payment_Group__c == 'IN' && bPln.Milestone_Number__c != '000000000000'){
                    system.debug('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+bPln.Percentage_Of_Value_To_Be_Invoiced__c);
                    if(bPln.Percentage_Of_Value_To_Be_Invoiced__c != mapBPlineItem.get(bPln.Payment_Group__c)){
                        stPplan.add(bPln.Payment_Plan__c);
                    }
                }
                else if(bPln.Payment_Group__c == 'PL'){// && bPln.Milestone_Number__c != '000000000000'){
                    //system.debug('BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'+bPln.Percentage_Of_Value_To_Be_Invoiced__c);
                    if(bPln.Milestone_Number__c != mapBPlineItem.get(bPln.Payment_Group__c)){
                        stPplan.add(bPln.Payment_Plan__c);
                    }
                }
            }
        }
        system.debug('stPplanstPplanstPplan'+stPplan);
        List<Payment_Plan__c> lstPaymentPlan = new List<Payment_Plan__c>();
        for(Payment_Plan__c pp : [select id, Status__c, Active__c from Payment_Plan__c where ID IN : stPplan]){
            pp.Status__c = 'Invalid';
            pp.Active__c = false;
            lstPaymentPlan.add(pp);
        }
        if(!lstPaymentPlan.isEmpty()){
            update lstPaymentPlan;
        }
    }  
public class BillingPlan{
    public Payment_Plan__c billPlanObj;
    public list<Billing_Plan_Line_Item__c> billPlanItems = new list<Billing_Plan_Line_Item__c>();
}
}