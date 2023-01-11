trigger userTrigger on User (before insert, before update, after update,after insert) {
    
    //Added by Ravi Kumar K
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            UserTriggerHandler.onAfterUpdate(Trigger.new,Trigger.OldMap); 
        }
        if(Trigger.isInsert){
            UserTriggerHandler.onAfterInsert(Trigger.new);      
        }
    }
    else {
        UserTriggerHandler.onBefore(trigger.new);
    }

}