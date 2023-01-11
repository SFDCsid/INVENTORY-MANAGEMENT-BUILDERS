trigger ECRTrigger on ECR__c (before insert) {
    Map<Id,Id> oppProjMap = new Map<Id,Id>();
    Map<Id,Id> ecrProjMap = new Map<Id,Id>();
    Map<Id,List<Team_Members__c>> projectOppMap = new Map<Id,List<Team_Members__c>>();
    Set<Id> projectSet = new Set<Id>();
    Set<Id> opSet = new Set<Id>();
    List<ECR__c> ecrList = new List<ECR__c>();
    
    for(Ecr__c e: Trigger.new){
        if(e.Opportunity__c != null){
            opSet.add(e.Opportunity__c);
        }
    }
    
    if(opSet != null){    
        for(Opportunity op: [Select Id,Name,Project__c From Opportunity Where Id IN: opSet]){
            System.debug('opProject==>'+op.Project__c);
            if(op.Project__c != null){
                projectSet.add(op.Project__c);
                oppProjMap.put(op.Id, op.Project__c);
            }
        }
    }
    for(ECR__c e: trigger.new){
        if(!ecrProjMap.containsKey(e.Id)){
            ecrProjMap.put(e.Id, oppProjMap.get(e.Opportunity__c));
        }
    }
    
    for(Id proj:oppProjMap.keySet()){
        System.debug('proj==>'+proj);
        for(Team_Members__c tm: [Select Id,Name,User__c,Team__c,Team__r.Project__c,User_Active__c,IsActive__c,Approver_Type__c 
                                 From Team_Members__c Where Team__r.Project__c IN:projectSet And 
                                 IsActive__c = true AND User_Active__c = true AND Team__r.Team_Type__c = 'EOI Approver Team']){
                                     System.debug('tm==>'+tm);
                                     if(projectOppMap.containsKey(tm.Team__r.Project__c)){
                                         projectOppMap.get(tm.Team__r.Project__c).add(tm);
                                     }
                                     if(!projectOppMap.containsKey(tm.Team__r.Project__c)){
                                         projectOppMap.put(tm.Team__r.Project__c,new List<Team_Members__c>());
                                         projectOppMap.get(tm.Team__r.Project__c).add(tm);
                                     }                       
                                 }
        
        for(Ecr__c e: trigger.new){
            List<Team_Members__c> tmList = projectOppMap.get(ecrProjMap.get(e.Id));
            if(tmList != null && tmList.size()>0){
                for(Team_Members__c tm: tmList){
                    if(tm.Approver_Type__c == 'First Level'){
                        e.Approver_1__c = tm.User__c;
                        system.debug('e.Approver_1__c'+e.Approver_1__c);
                    }
                    else if(tm.Approver_Type__c == 'Second Level'){
                        e.Approver_2__c = tm.User__c;
                        system.debug('e.Approver_2__c'+e.Approver_2__c);
                    }
                    else if(tm.Approver_Type__c == 'Third Level'){
                        e.Approver_3__c = tm.User__c;
                        system.debug('e.Approver_3__c'+e.Approver_3__c);
                    } 
                    ecrList.add(e);
                }
            }
        }
    }
}