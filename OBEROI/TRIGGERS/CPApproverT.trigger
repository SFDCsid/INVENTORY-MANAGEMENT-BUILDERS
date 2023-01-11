trigger CPApproverT on Account (before insert) {
    /*
    if(Trigger.isInsert && Trigger.isBefore){
        list<Account> Acc = Trigger.New;
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        List<Team_Members__c> teamMem = [select id,name,Team__c,IsActive__c,User__c from Team_Members__c where Team__r.Team_Type__c =: 'CP Approver Team' and IsActive__c=true];
        if(teamMem != null && !teamMem.isEmpty()){
            for(Account ac:Acc){
                if(accRecordTypeId == ac.RecordtypeId){
                    ac.Approver1__c = teamMem[0].User__c;
                }
            }
        }
    }
    */
    
    if(Trigger.isInsert && Trigger.isBefore){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        list<Account> AccList = new list<Account>();
        String UniqueKey = '';
        set<string> SUK = New set<string>();
        for(Account ac:Trigger.New){
                if(ac.RecordtypeId == accRecordTypeId){
                    UniqueKey = ac.name+'-'+ac.Tax_Number_1__c;
                    UniqueKey = UniqueKey.replace(' ','-');
                    SUK.add(UniqueKey);                
                }
            }
            AccList = [Select Id, Name,Tax_Number_1__c,Unique_CP_Key__c From Account Where Unique_CP_Key__c IN: SUK];
            
            If(AccList.size() > 0){
                 for(Account acc :Trigger.New){
                     acc.adderror('The Combination for Name and PAN already exists for another broker');
                 }
            }
        }
}