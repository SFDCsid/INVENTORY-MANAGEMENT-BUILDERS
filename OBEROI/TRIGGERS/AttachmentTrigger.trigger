trigger AttachmentTrigger on Attachment (before insert, after insert, before update) {
    if(trigger.isafter && trigger.isInsert){
        AttachmentTriggerHandler.afterInsertHandler (Trigger.NewMap);        
    }
    
}