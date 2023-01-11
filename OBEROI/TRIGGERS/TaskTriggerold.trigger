trigger TaskTriggerold on Task (after insert, after update) {
    
    Set<id> enqid = new Set<id>();
    Set<id> optid = new Set<id>();
    Set<id> tskId = new Set<id>();
    String enqKeyPrefix = Lead.sObjectType.getDescribe().getKeyPrefix();
    String optKeyPrefix = Opportunity.sObjectType.getDescribe().getKeyPrefix();
    Boolean copyLeadData = False;
    
    for(Task tsk : trigger.new){
        tskId.add(tsk.id);
        if(tsk.WhoId != null && String.valueOf(tsk.WhoId).startsWith(enqKeyPrefix)){
            enqid.add(tsk.WhoId);
           if(tsk.Copy_Lead_Data__c == true)
                copyLeadData =True;           
        }
        if(trigger.isAfter && trigger.isInsert ){
            if(tsk.WhatId != null && String.valueOf(tsk.WhatId).startsWith('006')){
                TaskTriggerHandler.UpdateTaskOnOpportunity(tsk.id);
            }
        }
        if(tsk.WhatId != null && String.valueOf(tsk.WhatId).startsWith(optKeyPrefix))
            optid.add(tsk.WhatId);
    } 
    
    if(trigger.isBefore && trigger.isInsert ){
        if(enqid != null && enqid.size()>0){
            // TaskTriggerHandler.updateCommercialLead(Trigger.new);
        }
    }
    
    
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate){
            if(tskId != null && tskId.size()>0){
                if(enqid != null && enqid.size()>0){
                    if(!System.isFuture() && !System.isBatch()){
                        TaskTriggerHandler.updateLeadManagerDetails(tskId, enqid);
                        // TaskTriggerHandler.updateCommercialLead(tskId);
                        if(!copyLeadData)
                        TaskTriggerHandler.updateCommercialLead(tskId);
                       // if(copyLeadData){}
                       // TaskTriggerHandler.copyLeadDetails(tskId, enqid);
                    }
                }
                else if(optid != null && optid.size()>0){
                    if(!System.isFuture() && !System.isBatch())
                        TaskTriggerHandler.updateOpportunityManagerDetails(tskId, optid);
                }
            }
        }
    }
    
}