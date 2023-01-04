trigger TrgTeamMemberSeq on Team_Members__c (before insert, after insert, before update, after update) {
  if(trigger.isInsert)
    {
        if(trigger.isAfter)
        {
            for(Team_Members__c tm : trigger.new)
            {
                if(tm.Team__r.Team_Type__c == 'Presales Team')
                teamMemberSeqHandler.teamMemberSeq(tm);
            }
        }
    }
    
    if(trigger.isUpdate)
    {
        if(trigger.isAfter)
        {
            for(Team_Members__c tm : trigger.new)
            {
                if(trigger.OldMap.get(tm.id).Availability__c != trigger.NewMap.get(tm.id).Availability__c )
                  teamMemberSeqHandler.teamMemberSeq(tm);
            }
        }
    }
}