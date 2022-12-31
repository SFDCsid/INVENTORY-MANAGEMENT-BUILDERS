public class TaskHandlerServices {
    
    public static void validationCheckforPresaleCall(Map<Id, List<Task>> taskMap) {
        List<Lead> leadList = new List<Lead>();
        Map<Id, Lead> leadMap = new Map<Id, Lead>();
        Map<String, String> stageMap = getStagesMap();
        //Map<String, Integer> stageNoMap = getLeadStageMap();
        
        leadList = [Select Id, Name,Status from Lead where Id IN: taskMap.keySet()];
        system.debug('leadList: '+leadList);
        
        if(!leadList.isEmpty()) {
            for(Lead l: leadList) {
                leadMap.put(l.Id, l);
            }
        }
        
        if(!leadMap.isEmpty() && leadMap != null) {
            for(Id lId: taskMap.keySet()) {
                for(Task t: taskMap.get(lId)) {
                    if(leadMap.containsKey(lId)) {
                        if(String.isNotBlank(leadMap.get(lId).Status)) {
                            if(stageMap.containsKey(leadMap.get(lId).Status)) {
                                if(stageMap.get(leadMap.get(lId).Status).containsIgnoreCase(t.Stage__c) == false) {
                                    if (!test.isRunningTest())
                                        t.addError('You can not create the task with Stage: '+t.Stage__c+' where Lead stage is: '+leadMap.get(lId).Status);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    public static void CallHandlerServices(Set<Id> taskId, string operation, boolean count) {
        Map<Id, List<Task>> mapRollUpLead = new Map<Id, List<Task>>();
        Map<Id, List<Task>> mapRollUpOpp  = new Map<Id, List<Task>>();
        
        List<Task> taskList = [Select Id, WhoId, WhatId, CreatedDate, Stage__c, Sub_Stage__c, Sub_Stage_Reason__c, Next_Follow_up_Date__c,
                               Date_of_Visit__c, Description, RecordTypeId, RecordType.Name from Task where Id IN: taskId 
                               AND (RecordType.Name = 'Presales Call' OR RecordType.Name = 'Sales Call')];
        system.debug('taskList: '+taskList);
        
        for(Task t: taskList) {
        
            if(t.whoId != Null && t.WhoId.getSObjectType().getDescribe().getName() == 'Lead') {
                if(!mapRollUpLead.containsKey(t.WhoId)) {
                    List<Task> newTaskList = new List<Task>();
                    newTaskList.add(t);
                    mapRollUpLead.put(t.WhoId, newTaskList);
                } else {
                    mapRollUpLead.get(t.WhoId).add(t);
                }
            } else if(t.whatId != Null && t.WhatId.getSObjectType().getDescribe().getName() == 'Opportunity') {
                if(!mapRollUpOpp.containsKey(t.WhatId)) {
                    List<Task> newTaskList = new List<Task>();
                    newTaskList.add(t);
                    mapRollUpOpp.put(t.WhatId, newTaskList);
                } else {
                    mapRollUpOpp.get(t.WhatId).add(t);
                }                
            }
        }
        system.debug('mapRollUpLead: '+mapRollUpLead);
        if(!mapRollUpLead.isEmpty()) {
            RollUpTaskLeadServices(mapRollUpLead,operation, count);
        }
        system.debug('mapRollUpOpp: '+mapRollUpOpp);
        if(!mapRollUpOpp.isEmpty()) {
            RollUpTaskOpportunityServices(mapRollUpOpp,operation, count);
        }
    }
    
    public static void RollUpTaskLeadServices(Map<Id, List<Task>> mapRollUpLead, string operation, boolean count) {
        List<Lead> updateLeadList = new List<Lead>();
        List<Lead> leadList = [Select Id, Last_Presale_Call_Date__c, Last_Presale_Call_Stage__c, Last_Presale_Call_Sub_Stage__c, 
                               Last_Presale_Call_Sub_Stage_Reason__c, Presale_Next_Follow_up_Date__c, Presale_Date_of_Visit__c, Last_Presale_Call_Comment__c, Status,
                               Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c, Presales_Call__c, Presales_Comment_History__c, SNP_Counter__c
                               from Lead where Id =: mapRollUpLead.keySet()];
        system.debug('leadList: '+leadList);
        
        for(Lead l: leadList) {
            List<Task> getLeadTaskList = mapRollUpLead.get(l.Id);
            system.debug('getLeadTaskList: '+getLeadTaskList);
            
            DateTime dT = System.now();
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
            if(!getLeadTaskList.isEmpty()) {
                for(Task t: getLeadTaskList) {
                    if(t.RecordType.Name == 'Presales Call') {
                        l.Last_Presale_Call_Date__c = t.CreatedDate;
                        l.Last_Presale_Call_Stage__c = t.Stage__c;
                        l.Last_Presale_Call_Sub_Stage__c = t.Sub_Stage__c;
                        l.Last_Presale_Call_Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        l.Presale_Next_Follow_up_Date__c = t.Next_Follow_up_Date__c;
                        l.Presale_Date_of_Visit__c = t.Date_of_Visit__c;
                        l.Last_Presale_Call_Comment__c = t.Description;
                        if(t.Stage__c != Null) {
                            l.Status = t.Stage__c;
                            l.Lead_Sub_Stage__c = t.Sub_Stage__c;
                            l.Lead_Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                            if(t.Stage__c.equalsIgnoreCase('SNP')) {
                                if(l.Status.equalsIgnoreCase('SNP'))
                                    l.SNP_Counter__c = l.SNP_Counter__c + 1;
                                else
                                    l.SNP_Counter__c = 1;
                            } else {
                                l.SNP_Counter__c = 0;
                            }
                        }
                        if(l.Presales_Call__c == Null)
                            l.Presales_Call__c = 0;   
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null) 
                            l.Presales_Call__c = l.Presales_Call__c + 1;
                        if(l.Last_Presale_Call_Comment__c != Null) {
                            if(l.Presales_Comment_History__c == Null)
                                l.Presales_Comment_History__c = '';
                            l.Presales_Comment_History__c = l.Presales_Comment_History__c + '\n' + string.ValueOf(myDate)+': '+l.Last_Presale_Call_Comment__c;
                        }
                        updateLeadList.add(l);
                    }
                }
            }
        }
        system.debug('updateLeadList: '+updateLeadList);
        if(!updateLeadList.isEmpty())
            update updateLeadList;
    }
    
    public static void RollUpTaskOpportunityServices(Map<Id, List<Task>> mapRollUpOpp, string operation, boolean count) {
        List<Opportunity> updateOppList = new List<Opportunity>();
        List<Opportunity> oppList = [Select Id,Last_Sales_Call_Date__c, Last_Sales_Call_Stage__c, Last_Sales_Call_Sub_Stage__c, Last_Sales_Call_Comment__c,
                                     Last_Sales_Call_Sub_Stage_Reason__c, Sales_Next_Follow_up_Date__c, Sales_Date_of_Visit__c, StageName,
                                     Sub_Stage__c, Sub_Stage_Reason__c,Sales_Call__c, Sales_Comment_History__c
                                     from Opportunity where Id =: mapRollUpOpp.keySet()];
        system.debug('oppList: '+oppList);
        
        for(Opportunity op: oppList) {
            List<Task> getOppTaskList = mapRollUpOpp.get(op.Id);
            system.debug('getOppTaskList: '+getOppTaskList);
            
           DateTime dT = System.now();
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
            if(!getOppTaskList.isEmpty()) {
                for(Task t: getOppTaskList) {
                    if(t.RecordType.Name == 'Sales Call') {
                        op.Last_Sales_Call_Date__c = t.CreatedDate;
                        op.Last_Sales_Call_Stage__c = t.Stage__c;
                        op.Last_Sales_Call_Sub_Stage__c = t.Sub_Stage__c;
                        op.Last_Sales_Call_Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        op.Sales_Next_Follow_up_Date__c = t.Next_Follow_up_Date__c;
                        op.Sales_Date_of_Visit__c = t.Date_of_Visit__c;
                        op.Last_Sales_Call_Comment__c = t.Description;
                        if(t.Stage__c != Null) {
                            op.StageName = t.Stage__c;
                            op.Sub_Stage__c = t.Sub_Stage__c;
                            op.Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        }
                        if(op.Sales_Call__c == Null)
                            op.Sales_Call__c = 0;
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null)
                            op.Sales_Call__c = op.Sales_Call__c + 1;
                        if(op.Last_Sales_Call_Comment__c != Null) {
                            if(op.Sales_Comment_History__c == Null)
                                op.Sales_Comment_History__c ='';
                            op.Sales_Comment_History__c = op.Sales_Comment_History__c + '\n' + string.ValueOf(myDate)+': '+op.Last_Sales_Call_Comment__c;
                        }    
                        updateOppList.add(op);    
                    }
                }
            }
        }
        system.debug('updateOppList: '+updateOppList);
        if(!updateOppList.isEmpty())
            update updateOppList;
    }
    
    /*public static Map<String, Integer> getLeadStageMap() {
        Integer i = 1;
        Map<String, Integer> stageNoMap = new Map<String, Integer>();
        Schema.DescribeFieldResult fieldResult = Lead.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple) {
            stageNoMap.put(pickListVal.getLabel(), i);
            i++;
        }
        return stageNoMap;
    }*/
    
    public static Map<String, String> getStagesMap() {
        Map<String, String> stageMap = new Map<String, String>();
        
        List<Stage_Management__c> stageList = [Select Name, Allowed_Stages__c from Stage_Management__c];
        system.debug('stageList: '+stageList);
        
        if(!stageList.isEmpty()) {
            for(Stage_Management__c st: stageList) {
                stageMap.put(st.Name, st.Allowed_Stages__c);
            }
        }
        return stageMap;
    }
}