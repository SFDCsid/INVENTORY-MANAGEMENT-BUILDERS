trigger QVApproverT on Project__c (before insert) {
	if(Trigger.isInsert && Trigger.isBefore){
        list<Project__c> Proj = Trigger.New;
        List<Team_Members__c> teamMem = [select id,name,Team__c,IsActive__c,User__c from Team_Members__c where Team__r.Team_Type__c =: 'QV Approver Team' and IsActive__c=true];
        if(teamMem != null && !teamMem.isEmpty()){
            for(Project__c P:Proj){
                    p.Approver1__c = teamMem[0].User__c;
                }
            }
        }
}