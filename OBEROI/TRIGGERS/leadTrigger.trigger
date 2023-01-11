// Version v1.1 - AKohakade - 3-5-2019 - Added Site Visit date validation, commented SiteVisitDateValidator code.

trigger leadTrigger on Lead (before insert,after insert, before update, after update) {
    
    if(Trigger.isInsert ){
        
        if(Trigger.isBefore){
            LeadTriggerHandler2.beforeInsertLead(Trigger.new);
            LeadTriggerHandler.beforeInsertLead(Trigger.new);//For Email and SMS Alert
            LeadTriggerHandler.populateCountryName(Trigger.new);
            /* v1.1 SiteVisitDateValidator.validateSiteVisitDate(Trigger.new);*/
        }
        
        if(Trigger.isAfter){
           // LeadTriggerHandler2.afterInsertLead(Trigger.NewMap);
            LeadTriggerHandler.afterInsertLead(Trigger.newMap);
            //LeadTriggerHandler.beforeInsertLead(Trigger.new);//For Email and SMS Alert
            
        }
    }
    
    if((Trigger.isUpdate && Trigger.isBefore)){
        LeadTriggerHandler2.beforeUpdateLead(Trigger.new);
        LeadTriggerHandler.beforeUpdateLead(Trigger.newMap , Trigger.oldMap);//For Email and SMS Alert
        LeadTriggerHandler.populateCountryName(Trigger.new);
        /* v1.1*/ SiteVisitDateValidator.validateSiteVisitDate(Trigger.new);
    } 
     
    if((Trigger.isUpdate && Trigger.isAfter)){
         LeadTriggerHandler.afterUpdateLead(Trigger.newMap , Trigger.oldMap);
    }
    
    if(Trigger.isAfter ){
        
        if(Trigger.isUpdate){
            ////////////////////////
            
            ///////////////////////
        }
    }  
}