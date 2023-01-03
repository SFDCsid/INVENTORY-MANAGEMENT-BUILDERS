//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class TaskHandlerServices {
    public static void validationCheckforPresaleCall(Map<Id, List<Task>> taskMap) {
        List<Lead__c> leadList = new List<Lead__c>();
        Map<Id, Lead__c> leadMap = new Map<Id, Lead__c>();
        Map<String, String> stageMap = getStagesMap();
        
        leadList = [Select Id, Name, Status__c from Lead__c where Id IN: taskMap.keySet()];
        system.debug('leadList: '+leadList);
        
        if(!leadList.isEmpty()) {
            for(Lead__c l: leadList) {
                leadMap.put(l.Id, l);
            }
        }
        
        if(!leadMap.isEmpty() && leadMap != null) {
            for(Id lId: taskMap.keySet()) {
                for(Task t: taskMap.get(lId)) {
                    if(leadMap.containsKey(lId)) {
                        if(String.isNotBlank(leadMap.get(lId).Status__c)) {
                            if(stageMap.containsKey(leadMap.get(lId).Status__c)) {
                                if(stageMap.get(leadMap.get(lId).Status__c).containsIgnoreCase(t.Stage__c) == false) {
                                    if (!test.isRunningTest())
                                        t.addError('You can not create the task with Stage: '+t.Stage__c+' where Lead stage is: '+leadMap.get(lId).Status__c);
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
        Map<Id, List<Task>> mapRollUpCp   = new Map<Id, List<Task>>(); /*Changes done by Prasad Alamwar on 21-10-2022*/
        
        List<Task> taskList = [Select Id, WhoId, WhatId, CreatedDate, Stage__c, Sub_Stage__c, Call_Status__c, Next_Follow_up_Date__c, CallType, CallDurationInSeconds,
                               Date_of_Visit__c, Description,Subject, Next_Action_Date__c, RecordTypeId, RecordType.Name from Task where Id IN: taskId 
                               AND (RecordType.Name = 'Presales Call' OR RecordType.Name = 'Sales Call' OR RecordType.Name = 'CP Call / Meeting' )];
        system.debug('taskList: '+taskList);
        
        for(Task t: taskList) {
        	if(t.whatId != Null && t.whatId.getSObjectType().getDescribe().getName() == 'Lead__c') {
                if(!mapRollUpLead.containsKey(t.whatId)) {
                    List<Task> newTaskList = new List<Task>();
                    newTaskList.add(t);
                    mapRollUpLead.put(t.whatId, newTaskList);
                } else {
                    mapRollUpLead.get(t.whatId).add(t);
                }
            } else if(t.whatId != Null && t.whatId.getSObjectType().getDescribe().getName() == 'Opportunity__c') {
                if(!mapRollUpOpp.containsKey(t.whatId)) {
                    List<Task> newTaskList = new List<Task>();
                    newTaskList.add(t);
                    mapRollUpOpp.put(t.whatId, newTaskList);
                } else {
                    mapRollUpOpp.get(t.whatId).add(t);
                }                
            }
            /*Changes done by Prasad Alamwar on 21-10-2022*/
            else if(t.WhatId != Null && t.WhatId.getSObjectType().getDescribe().getName() == 'Channel_Partner__c'){
                if(!mapRollUpCp.containsKey(t.WhatId)){
                    List<Task> newTaskList = new List<Task>();
                    newTaskList.add(t);
                    mapRollUpCp.put(t.WhatId,newTaskList);
                }else{
                    mapRollUpCp.get(t.WhatId).add(t);
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
        /*Changes done by Prasad Alamwar on 21-10-2022*/
        system.debug('mapRollUpCp: ' +mapRollUpCp);
        if(!mapRollUpCp.isEmpty()){
            RollUpTaskChannelPartnerServices(mapRollUpCp,operation, count);
        }
    }
    
    public static void RollUpTaskLeadServices(Map<Id, List<Task>> mapRollUpLead, string operation, boolean count) {
        List<Lead__c> updateLeadList = new List<Lead__c>();
        List<Lead__c> leadList = [Select Id, Last_Presale_Call_Date__c, Last_Presales_Call_Status__c, Presale_Next_Follow_up_Date__c, Presale_Date_of_Visit__c, Last_Presale_Call_Comment__c, Status__c,
                               Lead_Sub_Stage__c, Presales_Comment_History__c, Presales_Call_Count__c, Not_Responding_Count__c, CNR_Counter__c, Call_Received__c,Call_Type__c, Call_Status__c, Total_Call_Duration__c
                               from Lead__c where Id =: mapRollUpLead.keySet()];
        system.debug('leadList: '+leadList);
        
        for(Lead__c l: leadList) {
            List<Task> getLeadTaskList = mapRollUpLead.get(l.Id);
            system.debug('getLeadTaskList: '+getLeadTaskList);
            
            DateTime dT = System.now();
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
            if(!getLeadTaskList.isEmpty()) {
                for(Task t: getLeadTaskList) {
                    if(t.RecordType.Name == 'Presales Call') {
                        l.Last_Presale_Call_Date__c = t.CreatedDate;
                        l.Presale_Next_Follow_up_Date__c = t.Next_Follow_up_Date__c;
                        l.Presale_Date_of_Visit__c = t.Date_of_Visit__c;
                        l.Last_Presales_Call_Status__c = t.Call_Status__c;
                        l.Presale_Date_of_Visit__c = t.Date_of_Visit__c;
                        l.Last_Presale_Call_Comment__c = t.Description;
                        l.Call_Status__c = t.Call_Status__c; //Added By Prasad On 21/12/2022
                        l.Call_Type__c = t.CallType; //Added By Prasad On 21/12/2022
                        
                        if(t.Stage__c != Null) {
                            l.Status__c = t.Stage__c;
                            l.Lead_Sub_Stage__c = t.Sub_Stage__c;
                        } 
                        if(l.Presales_Call_Count__c  == Null)
                            l.Presales_Call_Count__c  = 0;  
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null ) 
                            l.Presales_Call_Count__c  = l.Presales_Call_Count__c + 1;
                        if(l.Not_Responding_Count__c == Null)
                            l.Not_Responding_Count__c = 0;
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null && t.Sub_Stage__c == 'Not Responding') 
                        {
                            l.Not_Responding_Count__c  = l.Not_Responding_Count__c + 1;
                        }
                        else
                            l.Not_Responding_Count__c = 0;
                        if(l.Last_Presale_Call_Comment__c != Null) {
                            if(l.Presales_Comment_History__c == Null)
                                l.Presales_Comment_History__c = '';
                            l.Presales_Comment_History__c = l.Presales_Comment_History__c + '\n' + string.ValueOf(myDate)+': '+l.Last_Presale_Call_Comment__c;
                        }
                        if(l.CNR_Counter__c == null)
                            l.CNR_Counter__c = 0;
                        if(String.isNotBlank(t.CallType) && t.CallType.equalsIgnoreCase('Outbound')) {
                            if(t.Call_Status__c.equalsIgnoreCase('NotAnswered') && !l.Call_Received__c)
                            	l.CNR_Counter__c = l.CNR_Counter__c + 1;
                        	else if(t.Call_Status__c.equalsIgnoreCase('Answered') && !l.Call_Received__c)
                            	l.Call_Received__c = true;
                        }
                        if(l.Total_Call_Duration__c == null)
                            l.Total_Call_Duration__c = 0;
                        if(t.CallDurationInSeconds != null)
                            l.Total_Call_Duration__c = l.Total_Call_Duration__c + t.CallDurationInSeconds;
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
        List<Opportunity__c> updateOppList = new List<Opportunity__c>();
            List<Opportunity__c> oppList = [Select Id,Last_Sales_Call_Date__c, Last_Sales_Call_Comment__c, Sales_Next_Follow_up_Date__c, Sales_Date_of_Visit__c, StageName__c,
                                     Sub_Stage__c,Sales_Call_Count__c, Sales_Comment_History__c
                                     from Opportunity__c where Id =: mapRollUpOpp.keySet()];
        system.debug('oppList: '+oppList);
        
        for(Opportunity__c op: oppList) {
            List<Task> getOppTaskList = mapRollUpOpp.get(op.Id);
            system.debug('getOppTaskList: '+getOppTaskList);
            
           	DateTime dT = System.now();
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
            if(!getOppTaskList.isEmpty()) {
                for(Task t: getOppTaskList) {
                    if(t.RecordType.Name == 'Sales Call') {
                        op.Last_Sales_Call_Date__c = t.CreatedDate;
                        op.Sales_Next_Follow_up_Date__c = t.Next_Follow_up_Date__c;
                        op.Sales_Date_of_Visit__c = t.Date_of_Visit__c;
                        op.Last_Sales_Call_Status__c = t.Call_Status__c;
                        op.Last_Sales_Call_Comment__c = t.Description;
                        if(t.Stage__c != Null) {
                            op.StageName__c = t.Stage__c;
                            op.Sub_Stage__c = t.Sub_Stage__c;
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
    
    /*Changes done by Prasad Alamwar on 21-10-2022*/
    public static void RollUpTaskChannelPartnerServices(Map<Id, List<Task>> mapRollUpCp, string operation,boolean count) {
        List<Channel_Partner__c> updateCpList = new List<Channel_Partner__c>();
        List<Channel_Partner__c> cpList = [Select Id,Last_CP_Call_Meeting_Subject__c,Last_CP_Call_Meeting_Date__c,Last_CP_Call_Meeting_Status__c,Last_CP_Call_Meeting_Remarks__c,Last_CP_Call_Meeting_Stage__c,
                                     Last_CP_Call_Meeting_Sub_Stage__c,CP_Next_Action_Date__c
                                     from Channel_Partner__c where Id =: mapRollUpCp.keySet()];
        system.debug('cpList: '+cpList);
        
        for(Channel_Partner__c cp: cpList) {
            List<Task> getCpTaskList = mapRollUpCp.get(cp.Id);
            system.debug('getCpTaskList: '+getCpTaskList);
            
           	DateTime dT = System.now();
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
          
            if(!getCpTaskList.isEmpty()) {
                for(Task t: getCpTaskList) {
                    if(t.RecordType.Name == 'CP Call / Meeting') {
                        cp.Last_CP_Call_Meeting_Subject__c = t.Subject;
                        cp.Last_CP_Call_Meeting_Date__c = t.CreatedDate;
                        cp.Last_CP_Call_Meeting_Status__c = t.Call_Status__c;
                        cp.Last_CP_Call_Meeting_Remarks__c = t.Description;
                        //cp.Last_CP_Call_Meeting_Stage__c  ;
                        //cp.Last_CP_Call_Meeting_Sub_Stage__c  ;
                        cp.CP_Next_Action_Date__c = t.Next_Action_Date__c;
                        if(t.Stage__c != Null) {
                            cp.Last_CP_Call_Meeting_Stage__c = t.Stage__c;
                            cp.Last_CP_Call_Meeting_Sub_Stage__c = t.Sub_Stage__c;
                            cp.Stage__c = t.Stage__c;
                            cp.Sub_Stage__c = t.Sub_Stage__c;
                        }
                        /*if(op.Sales_Call_Count__c == Null)
                            op.Sales_Call_Count__c = 0;
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null)
                            op.Sales_Call_Count__c = op.Sales_Call_Count__c + 1;
                        if(op.Last_Sales_Call_Comment__c != Null) {
                            if(op.Sales_Comment_History__c == Null)
                                op.Sales_Comment_History__c ='';
                            op.Sales_Comment_History__c = op.Sales_Comment_History__c + '\n' + string.ValueOf(myDate)+': '+op.Last_Sales_Call_Comment__c;
                        }*/    
                        updateCpList.add(cp);    
                    }
                }
            }
        }
        system.debug('updateCpList: '+updateCpList);
        if(!updateCpList.isEmpty())
            update updateCpList;
    }
 	  
    public static void updateCTILeadInfo(Map<Id, Task> firstTaskMap) {
        List<Lead__c> leadList = new List<Lead__c>();
        Map<Id, Lead__c> leadMap = new Map<Id, Lead__c>();
        List<Task> taskList = new List<Task>();
        Set<Id> leadIdSet = new Set<Id>();
        List<Lead__c> updateLeadList = new List<Lead__c>();
        
        leadList = [Select Id, Name, CTI_Lead_Created_From__c from Lead__c where Id IN: firstTaskMap.keySet() AND Lead_Created_From__c = 'CTI'];
        system.debug('leadList: '+leadList);
        
        if(!leadList.isEmpty()) {
            for(Lead__c l: leadList) {
                leadMap.put(l.Id, l);
            }
        }
        
        if(!leadMap.isEmpty() && leadMap != null) {
            taskList = [Select Id, WhatId, RecordTypeId from Task where WhatId IN: leadMap.keySet()];
            system.debug('taskList: '+taskList);
            
            if(!taskList.isEmpty()) {
                for(Task t: taskList) {
                    if(Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'Presales Call') {
                        leadIdSet.add(t.WhatId);
                    }
                }
            }
            
            for(Id lId: firstTaskMap.keySet()) {
                Task t = firstTaskMap.get(lId);
                if(leadMap.containsKey(t.WhatId)) {
                    Lead__c l = leadMap.get(t.WhatId);
                    if(!leadIdSet.contains(t.WhatId)) {
                        if((t.CallType.equalsIgnoreCase('Inbound') || t.CallType.equalsIgnoreCase('Outbound')) && t.Call_Status__c.equalsIgnoreCase('NotAnswered')) {
                            l.CTI_Lead_Created_From__c = 'Missed';
                            updateLeadList.add(l);
                        } else if(t.CallType.equalsIgnoreCase('Inbound') && t.Call_Status__c.equalsIgnoreCase('Answered')) {
                            l.CTI_Lead_Created_From__c = 'Inbound';
                            updateLeadList.add(l);
                        } else if(t.CallType.equalsIgnoreCase('Outbound') && t.Call_Status__c.equalsIgnoreCase('Answered')) {
                            l.CTI_Lead_Created_From__c = 'Outbound';
                            updateLeadList.add(l);
                        }
                        t.Is_New_Lead_Created__c = true;
                    }
                }
            }
        }
        if(!updateLeadList.isEmpty() && updateLeadList != null)
            update updateLeadList;
    }
    
    public static void rollupBillingDetailOnCampaign(Set<Id> billingIdSet) {
        List<Task> taskList = new List<Task>();
        Map<Id, List<Task>> taskMap = new Map<Id, List<Task>>();
        List<Campaign__c> cList = new List<Campaign__c>();
        List<Campaign__c> updateCampaignList = new List<Campaign__c>();
        
        taskList = [Select Id, WhatId, Amount__c, GST__c, GST_Amount__c, Discount__c, Amount_Paid__c from Task where Id IN: billingIdSet];
        system.debug('taskList: '+taskList);
        
        if(!taskList.isEmpty()) {
            for(Task t: taskList) {
                if(taskMap.containsKey(t.WhatId)) {
                    taskMap.get(t.WhatId).add(t);
                } else {
                    List<Task> newList = new List<Task>();
                    newList.add(t);
                    taskMap.put(t.WhatId, newList);
                }
            }
        }
        
        cList = [Select Id, Amount__c, GST_Amount__c, Discount__c, Amount_Paid__c from Campaign__c where Id IN: taskMap.keySet()];
        system.debug('cList: '+cList);
        
        if(!cList.isEmpty() && cList != null) {
            for(Campaign__c c: cList) {
                if(taskMap.containsKey(c.Id)) {
                    for(Task t: taskMap.get(c.Id)) {
                        if(t.Amount__c != null && t.Amount__c > 0) {
                            if(c.Amount__c == null)
                                c.Amount__c = 0;
                            c.Amount__c = c.Amount__c + t.Amount__c;
                            if(String.isNotBlank(t.GST__c) && t.GST__c != '') {
                                if(c.GST_Amount__c == null)
                                    c.GST_Amount__c = 0;
                                c.GST_Amount__c = c.GST_Amount__c + t.GST_Amount__c;
                            }
                            if(t.Discount__c != null && t.Discount__c > 0) {
                                if(c.Discount__c == null)
                                    c.Discount__c = 0;
                                c.Discount__c = c.Discount__c + t.Discount__c;
                            }
                            updateCampaignList.add(c);
                        }
                        if(t.Amount_Paid__c != null && t.Amount_Paid__c > 0) {
                            if(c.Amount_Paid__c == null)
                                c.Amount_Paid__c = 0;
                            c.Amount_Paid__c = c.Amount_Paid__c + t.Amount_Paid__c;
                            updateCampaignList.add(c);
                        }
                    }
                }
            }
        }
        if(!updateCampaignList.isEmpty() && updateCampaignList != null)
            update updateCampaignList;
    }
    
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