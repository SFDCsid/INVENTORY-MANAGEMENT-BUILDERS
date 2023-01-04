public class teamMemberSeqHandler {
  public static void teamMemberSeq(Team_Members__c tm)
    {
        List<Team_Members__c> lstTM = new List<Team_Members__c>();
        List<Team_Members__c> updateTM = new List<Team_Members__c>();
        lstTM = [Select Id, Team__c from Team_Members__c where Team__c =: tm.Team__c and Availability__c =: true];
        if(!lstTM.isEMpty())
        {
            system.debug('lst member: '+ lstTM);
            system.debug('lst size: '+ lstTM.size());
            Decimal i = 0;
            
            for(Team_Members__c tm1 : lstTM)
            {
                tm1.Sequence_Number__c = i;
                i++;
                updateTM.add(tm1);
            }
            
            if(!updateTM.isEmpty())
            {
                update updateTM;
            }
        }
        else
        {
            tm.Sequence_Number__c = 0;
            updateTM.add(tm);
            update updateTM;
        }
    }
}