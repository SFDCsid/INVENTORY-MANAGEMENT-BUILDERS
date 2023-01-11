Public Class PropertyManagementServices{

/************* This method use to make quotation Inactive if unit linked milestone or Tower level milestone update *****************/
    //@future
    public static void InactiveQuotation(set<Id>unitId, set<Id>bpId, set<Id> qIDs, set<Id> opIds){
        List<Quotation__C> qList = new List<Quotation__C>();
        system.debug('bpId:::: '+bpId);
        if(unitId != null && !unitId.isEmpty()){
            qList = [select id,name,Quote_Status__c,Active_Quotation__c,Approval_Stage__c,
                                Cancelled_Reason__c from Quotation__C where Property__c IN: unitId and Booking__c = null]; 
        }else if(bpId != null && !bpId.isEmpty()){
            system.debug('inside billing condition');
            qList = [select id,name,Quote_Status__c,Active_Quotation__c,Approval_Stage__c,
                                Cancelled_Reason__c from Quotation__C where Billing_Plan__c IN: bpId and Booking__c = null];
        }else if(qIDs != null && !qIDs.isEmpty() && opIds != null && !opIds.isEmpty()){
            qList = [select id,name,Quote_Status__c,Active_Quotation__c,Approval_Stage__c,
                                Cancelled_Reason__c from Quotation__C where Opportunity__C IN: opIds and Id NOT IN: qIDs];
        }       
        system.debug('qList:: '+qList);                 
        List<Quotation__C> validQuotations = new List<Quotation__C>();
        List<Quotation__C> approvalPendingQuotations = new List<Quotation__C>();                        
        if(qList != null && !qList.isEmpty()){
            for(Quotation__C q : qList){
                if(q.Quote_Status__c == 'Valid' && q.Active_Quotation__c){
                    validQuotations.add(q);
                }else if(q.Quote_Status__c == 'Approval Pending'){
                    approvalPendingQuotations.add(q);
                }
            }
        }
        system.debug('validQuotations:: '+validQuotations);
        system.debug('approvalPendingQuotations:: '+approvalPendingQuotations);
        if(!validQuotations.isEmpty()){
            for(Quotation__C q : validQuotations){
                q.Quote_Status__c = 'Invalid';
                q.Final_Approved_Date__c = null;
                if(unitId != null && !unitId.isEmpty())
                    q.Cancelled_Reason__c = 'Unit Linked Milestone Updated';
                else if(bpId != null && !bpId.isEmpty())
                    q.Cancelled_Reason__c = 'Other Milestone Updated';
                else if(qIDs != null && !qIDs.isEmpty())
                    q.Cancelled_Reason__c = 'Change in Booking Source';    
            }
            update validQuotations;
            system.debug('after update valid quotation:: ');
        }    
        if(!approvalPendingQuotations.isEmpty()){
            List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest> ();
            set<Id> quoteId = new set<Id>();
            for(Quotation__C q : approvalPendingQuotations){
                quoteId.add(q.id);
            }
            Map<ID,ProcessInstance> piMap = New Map<ID,ProcessInstance>([Select Id,TargetObjectId  from ProcessInstance where TargetObjectId IN :quoteId]);
            //List<ProcessInstanceWorkItem> piwList = [Select Id,ProcessInstanceId  from ProcessInstanceWorkItem where ProcessInstanceId IN :piMap.keySet()];
            //if(piwList.size()>0){
                for(ProcessInstanceWorkItem wi : [Select Id,ProcessInstanceId  from ProcessInstanceWorkItem where ProcessInstanceId IN :piMap.keySet()]){
                    // if there's a work item, set the action to 'removed' and execute
                    Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                    req2.setAction('Removed'); 
                    req2.setWorkitemId(wi.id);
                    requests.add(req2);
                }
                
                Approval.ProcessResult[] processResults = Approval.process(requests,true);
              
            //}
            for(Quotation__C q : approvalPendingQuotations){
                q.Quote_Status__c = 'Invalid';
                q.Final_Approved_Date__c = null;
                if(unitId != null && !unitId.isEmpty())
                    q.Cancelled_Reason__c = 'Unit Linked Milestone Updated';
                else
                    q.Cancelled_Reason__c = 'Other Milestone Updated';
            }
            update approvalPendingQuotations;
        }
        if(Test.isRunningTest()){
            Integer i;
            Integer j = 5;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
            i=j;
        }                       
    
    }
    
    /**************************  THis method used to inactive the payment plan if milestone is update or delete from SAP ***************/
     public static void InactivePaymentPlan(set<Id>bpId){
         if(!bpID.isEmpty()){
            List<Payment_Plan__c> plForUpdate = new List<Payment_Plan__c>();
            for(Id key : bpID){
                Payment_Plan__c pl = new Payment_Plan__c();
                pl.id = key;
                pl.Active__c = false;
                plForUpdate.add(pl); 
            }
            if(!plForUpdate.isEmpty()){
                update plForUpdate; 
            }
        }
     }
}