trigger TrgCommentSMRoll on Site_Visit__c (before insert, before update, after update, after insert) {

    if(Trigger.isUpdate) {
        
     if(Trigger.isAfter) {
         
         for(Site_Visit__c sv :Trigger.new)
         {
             
			   if(trigger.oldMap.get(sv.Id).SM_Comment__c != trigger.newMap.get(sv.Id).SM_Comment__c && sv.SM_Comment__c != Null)
                   CommentsRollup.SMCommentsRollup(sv.Opportunity_c__c, sv.SM_Comment__c);

         }
             
      
        
    }
    
    
}
}