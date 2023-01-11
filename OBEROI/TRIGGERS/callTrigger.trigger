trigger callTrigger on Call__c (before insert,before update,after update,after insert) {
    
    //Added by Ravi Kumar K
    if(Trigger.isBefore){
    
        if(Trigger.isUpdate){
              CallTriggerHandler.updateLeadEmail(Trigger.new , Trigger.OldMap, 'Update' );
           // CallTriggerHandler.updateLeadonCall(Trigger.new,Trigger.OldMap,'update'); 
          //  CallTriggerHandler.missedUpdatecomingCall(Trigger.new,Trigger.OldMap);
        }
        if(Trigger.isInsert){
               CallTriggerHandler.updateLeadEmail(Trigger.new , Trigger.OldMap, 'Insert');
           // CallTriggerHandler.updateLeadonCall(Trigger.new,Trigger.OldMap,'insert');                 
        }
    }if(Trigger.isAfter){
        if(Trigger.isUpdate){
            CallTriggerHandler.missedIncomingCall(Trigger.new,Trigger.OldMap,'update');
        }if(Trigger.isInsert){
            CallTriggerHandler.missedIncomingCall(Trigger.new,Trigger.OldMap,'insert');
        }
    }

}