trigger trgPaymentPlanLineItem on Payment_Plan_Line_Item__c (after update, after insert, after delete) {

    if(Trigger.isafter){
        if(Trigger.isUpdate){
            set<Id> bpId = new Set<Id>();
            set<Id> billingPlanId = new Set<Id>();
            for(Payment_Plan_Line_Item__c p : trigger.New){
              /*if(trigger.oldMap.get(p.id).Date_Description__c != trigger.newMap.get(p.id).Date_Description__c && 
                   p.Date_Description__c != null && p.Milestone_Number__c == '000000000000'){
                   bpId.add(p.id);
               }*/
               if(trigger.oldMap.get(p.id) != trigger.newMap.get(p.id)){
                   billingPlanId.add(p.Payment_Plan__c); 
                   bpId.add(p.Payment_Plan__c);
               }
           }
           PropertyManagementServices.InactivePaymentPlan(billingPlanId);
           if(!bpId.isEmpty()){
               system.debug('inside bpID condition');
               PropertyManagementServices.InactiveQuotation(null,bpId,null,null);
           }
        }
        else if(Trigger.isInsert){
            set<Id> bpID = new set<Id>();
            for(Payment_Plan_Line_Item__c p : trigger.New){
                bpID.add(p.Payment_Plan__c); 
            }
            PropertyManagementServices.InactivePaymentPlan(bpId);
            if(!bpId.isEmpty())
                PropertyManagementServices.InactiveQuotation(null,bpId,null,null);
        }else if(Trigger.isDelete){
            set<Id> bpID = new set<Id>();
            for(Payment_Plan_Line_Item__c p : trigger.Old){
                bpID.add(p.Payment_Plan__c); 
            }
            PropertyManagementServices.InactivePaymentPlan(bpId);
            if(!bpId.isEmpty())
                PropertyManagementServices.InactiveQuotation(null,bpId,null,null);
        }
    }
}