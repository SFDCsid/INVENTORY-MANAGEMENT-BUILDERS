public class TaskHandlerServices {
    
    public static void validationCheckforPresaleCall(Map<Id, List<Task>> taskMap) {
        List<Lead> leadList = new List<Lead>();
        Map<Id, Lead> leadMap = new Map<Id, Lead>();
        
        
        leadList = [Select Id, Name,Status,Lead_Stage__c from Lead where Id IN: taskMap.keySet()];
        system.debug('leadList: '+leadList);
        
        if(!leadList.isEmpty()) {
            for(Lead l: leadList) {
                leadMap.put(l.Id, l);
            }
        }
        
        
    }
    public static void CallHandlerServices(Set<Id> taskId)
    {
       Map<Id, List<Task>> mapRollUpcp  = new Map<Id, List<Task>>();
        List<Task> taskList = [Select Id, WhoId, WhatId, CreatedDate,Stage__c,Next_Followup_date__c,CP_Stage__c,CP_Sub_stage__c,Subject,Call_Meeting_Date__c,
                               Call_Meeting_Status__c,Remarks__c,Call_Status__c,Next_Action_Date__c, Description, RecordTypeId, RecordType.Name from Task where Id IN: taskId 
                               AND RecordType.Name = 'CP Log A Call' ];
        system.debug('taskList: '+taskList);
        for(Task t: taskList) 
        {
            if(t.whatId != Null && t.WhatId.getSObjectType().getDescribe().getName() == 'Account')
            {
                if(!mapRollUpcp.containsKey(t.WhatId)) {
                    List<Task> newTaskList = new List<Task>();
                    newTaskList.add(t);
                    mapRollUpcp.put(t.WhatId, newTaskList);
                } else {
                    mapRollUpcp.get(t.WhatId).add(t);
                }   
        }
        system.debug('mapRollUpcp: '+mapRollUpcp);
        if(!mapRollUpcp.isEmpty()) {
            RollUpTaskChannelPartnerServices(mapRollUpcp);
        }    
       }
    }
    
    public static void CallHandlerServices(Set<Id> taskId, string operation, boolean count) {
        Map<Id, List<Task>> mapRollUpLead = new Map<Id, List<Task>>();
        Map<Id, List<Task>> mapRollUpOpp  = new Map<Id, List<Task>>();
        
        List<Task> taskList = [Select Id, WhoId, WhatId, CreatedDate,Stage__c,Next_Followup_date__c,
                               Proposed_Date_of_Visit__c,Call_Status__c, Description, RecordTypeId, RecordType.Name from Task where Id IN: taskId 
                               AND (RecordType.Name = 'Presales Call' OR RecordType.Name = 'Sales Call' )];
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
            }else if(t.whatId != Null && t.WhatId.getSObjectType().getDescribe().getName() == 'Opportunity') {
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
        List<Lead> leadList = [Select Id, Last_Presale_Call_Date__c, Last_Presale_Call_Stage__c,
                               Presale_Next_Follow_up_Date__c, Presale_Date_of_Visit__c,Lead_Stage__c, Last_Presale_Call_Comment__c, Status,
                               Presales_Call_Count__c, Presales_Comment_History__c 
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
                        l.Presale_Next_Follow_up_Date__c = t.Next_Followup_date__c;
                        l.Presale_Date_of_Visit__c = t.Proposed_Date_of_Visit__c;
                        l.Last_Presale_Call_Comment__c = t.Description;
                        if(t.Stage__c != Null) {
                            l.Lead_Stage__c = t.Stage__c;
                           
                        }
                        if(l.Presales_Call_Count__c == Null)
                            l.Presales_Call_Count__c = 0;   
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null) 
                            l.Presales_Call_Count__c = l.Presales_Call_Count__c + 1;
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
        List<Opportunity> oppList = [Select Id,Last_Sales_Call_Comment__c,Opportunity_Stage__c,Last_Sales_Call_Date__c,Last_Sales_Call_Stage__c,Sales_Call_Count__c
                                     ,Sales_Comment_History__c,Sales_Date_of_Visit__c,Sales_Next_Follow_up_Date__c
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
                        op.Sales_Next_Follow_up_Date__c = t.Next_Followup_date__c;
                        op.Sales_Date_of_Visit__c = t.Proposed_Date_of_Visit__c;
                        op.Last_Sales_Call_Comment__c = t.Description;
                        if(t.Stage__c != Null) {
                            op.Opportunity_Stage__c = t.Stage__c;
                            
                        } 
                        if(op.Sales_Call_Count__c == Null)
                            op.Sales_Call_Count__c = 0;
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null)
                            op.Sales_Call_Count__c = op.Sales_Call_Count__c + 1;
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
    
	
    public static void RollUpTaskChannelPartnerServices(Map<Id, List<Task>> mapRollUpcp) {
        RecordType rt = new RecordType();
		rt = [Select Id, DeveloperName, Name from RecordType where Name =: 'Channel Partner'];      
        List<Account> updateCPList = new List<Account>();
        List<Account> cpList = [Select Id, 	Last_CP_Call_Date__c/*,Last_CP_Meeting_Date__c*/, Last_CP_Call_Remarks__c,Last_CP_Meeting_Remarks__c,Last_CP_Call_Stage__c,
								Last_CP_Meeting_Stage__c,Last_CP_Call_Status__c,Last_CP_Meeting_Status__c, Last_CP_Call_Sub_Stage__c,
								Last_CP_Meeting_Sub_Stage__c,Last_CP_Call_Subject__c,Last_CP_Meeting_Subject__c,CP_Call_Next_Action_Date__c,RecordTypeId,
                                CP_Meeting_Next_Action_Date__c
                               from Account where Id =: mapRollUpcp.keySet() and RecordTypeId=:rt.id];
        system.debug('cpList: '+cpList);
        
        for(Account a: cpList) {
            List<Task> getcpTaskList = mapRollUpcp.get(a.Id);
            system.debug('getcpTaskList: '+getcpTaskList);
            
            DateTime dT = System.now();
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
            if(!getcpTaskList.isEmpty()) {
                for(Task t: getcpTaskList) {
                    if(t.RecordType.Name == 'CP Log A Call' &&  t.Subject == 'CP Call') 
						{
						a.Last_CP_Call_Subject__c = t.Subject;
                        a.Last_CP_Call_Date__c = t.Call_Meeting_Date__c;
						if(t.CP_Stage__c != Null)
							{
							 a.Last_CP_Call_Stage__c = t.CP_Stage__c;
							 a.Last_CP_Call_Sub_Stage__c = t.CP_Sub_stage__c;
							}
						if(t.Call_Meeting_Status__c != Null)
							{
							a.Last_CP_Call_Status__c = t.Call_Meeting_Status__c;
							}
                        if(t.Remarks__c!= Null)
							{
							a.Last_CP_Call_Remarks__c = t.Remarks__c;
						    }
                        a.CP_Call_Next_Action_Date__c = t.Next_Action_Date__c;
                        updateCPList.add(a);
                    }
                    else if(t.RecordType.Name == 'CP Log A Call' &&  t.Subject == 'CP Meeting')
                    {
                        a.Last_CP_Meeting_Subject__c = t.Subject;
                        a.Last_CP_Meeting_Date__c  = t.Call_Meeting_Date__c;
                        a.CP_Meeting_Next_Action_Date__c = t.Next_Action_Date__c;
                        if(t.CP_Stage__c != Null)
                        {
                          a.Last_CP_Meeting_Stage__c = t.CP_Stage__c;
						  a.Last_CP_Meeting_Sub_Stage__c = t.CP_Sub_stage__c;
                        }
                        if(t.Call_Meeting_Status__c != Null)
							{
							a.Last_CP_Meeting_Status__c = t.Call_Meeting_Status__c;
							}
                        if(t.Remarks__c!= Null)
							{
							a.Last_CP_Meeting_Remarks__c = t.Remarks__c;
						    }
                         updateCPList.add(a);
                    }
                }
            }
        }
        system.debug('updateCPList: '+updateCPList);
        if(!updateCPList.isEmpty())
            update updateCPList;
    }
        
    
 }