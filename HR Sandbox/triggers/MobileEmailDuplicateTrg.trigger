trigger MobileEmailDuplicateTrg on Candidate__c (before insert ,before update) {
    if(trigger.isbefore && trigger.isinsert ){
         MobileEailDuplicateHandlerclss.MobileEmailDuplicate(trigger.new);
    }
    if(trigger.isbefore && trigger.isupdate ){
         MobileEailDuplicateHandlerclss.MobileEmailDuplicateExists(trigger.new);
    }
 
    
}