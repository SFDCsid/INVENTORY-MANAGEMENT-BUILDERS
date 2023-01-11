trigger campaignTrigger on Campaign (before insert, before update, before delete,after delete,after update,after insert) {
   /* 
    if(Trigger.isInsert || Trigger.isUpdate){
        if(Trigger.isAfter ){
            for(campaign c: Trigger.new){
                CampaignTriggerHandler.UpdateRemaining(c.ParentId);
            }
        }
    }
    */
    if(Trigger.isInsert){        
        if(Trigger.isBefore ){
            CampaignTriggerHandler.beforeInsertValidation(Trigger.new); 
           // CampaignTriggerHandler.beforeInsertCampaign(Trigger.new); 
        }
    }
    
    if(Trigger.isUpdate){        
        if(Trigger.isBefore ){ 
            CampaignTriggerHandler.beforeUpdateValidation(Trigger.newMap , Trigger.OldMap);
            //CampaignTriggerHandler.beforeUpdateCampaign(Trigger.newMap , Trigger.OldMap);
            
        }
    }
    
    
    
     if(Trigger.isAfter){
        if(Trigger.isDelete){
            CampaignTriggerHandler.afterDeleteCampaign(Trigger.Old); 
        }   
    }
    
    
    
    //Added by Ravi Kumar K
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            CampaignTriggerHandler.updateCampaingonVirtualNumber(Trigger.new,Trigger.OldMap,'update'); 
            CampaignTriggerHandler.bookingCountlogic(Trigger.new,Trigger.OldMap); 
        }
        if(Trigger.isInsert){
            CampaignTriggerHandler.updateCampaingonVirtualNumber(Trigger.new,Trigger.OldMap,'insert');      
        }
    }
    
}