public class TaskHandlerServices {
    
   /* public static void ValidationforPresalecallStages(Map<Id, List<Task>> taskmap){
        List<Lead_c__c> leadlists= new List<Lead_c__c>();
        Map<Id,Lead_c__c> leadmap=new Map<Id,Lead_c__c>();
      // List<Task> tasklists=new List<Task>();
        
        leadlists=[Select id,Name,Lead_Stage__c, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c, Presales_Call_Count__c,Call_Not_Answered__c	
                   from Lead_c__c where Id IN:taskmap.keySet()];
        
      //  tasklists=[Select Id,whatId,Stage__c,Sub_Stage__c,Sub_Stage_Reason__c,Created_Date__c,Date_of_Visit__c, Next_Follow_up_date__c from task];
        
        for(Lead_c__c ld:leadlists){
           leadmap.put(ld.Id, ld);
            if(ld.Lead_Stage__c=='Contact' && ld.Lead_Stage__c=='Unserviced'){
                
            } 
            
        }
       
        
    } */
    
   /* public static void validationCheckforPresaleCall(Map<Id, List<Task>> taskMap) {
        List<Lead_c__c> leadList = new List<Lead_c__c>();
        Map<Id, Lead_c__c> leadMap = new Map<Id, Lead_c__c>();
     //   Map<String, String> stageMap = getStagesMap();
        //Map<String, Integer> stageNoMap = getLeadStageMap();
        system.debug('taskMap: '+taskMap);
        leadList = [Select Id, Name, Lead_Stage__c 
                        from Lead_c__c 
                        where Id IN: taskMap.keySet()];
        system.debug('leadList: '+leadList);
        
        if(!leadList.isEmpty()) {
            for(Lead_c__c l: leadList) {
                leadMap.put(l.Id, l);
            }
        }
        
        if(!leadMap.isEmpty() && leadMap != null) {
            for(Id lId: taskMap.keySet()) {
                for(Task t: taskMap.get(lId)) {
                    RecordType rt = new RecordType();
                        System.debug('Record Type:: '+t.RecordTypeId);
                    if(leadMap.containsKey(lId)) {
                        if(String.isNotBlank(leadMap.get(lId).Lead_Stage__c)) {
                      //      if(stageMap.containsKey(leadMap.get(lId).Lead_Stage__c)) 
                           {
                                 if(t.RecordTypeId != Null)
                                        rt = [Select Id, DeveloperName, Name from RecordType where Id =: t.RecordTypeId];
                                if(rt.Name != 'Site Visit')
                                {
                            //        if(stageMap.get(leadMap.get(lId).Lead_Stage__c).containsIgnoreCase(t.Stage__c) == false )
                                     {
                                        
                                    if (!test.isRunningTest())
                                        t.addError('You can not create the task with Stage: '+t.Stage__c+' where Lead stage is: '+leadMap.get(lId).Lead_Stage__c);
                                    }
                                }
                                else
                                {
                                   if(stageMap.get(leadMap.get(lId).Lead_Stage__c).containsIgnoreCase(t.Site_Visit_Stage__c) == false ) {
                                        
                                    if (!test.isRunningTest())
                                        t.addError('You can not create the task with Stage: '+t.Site_Visit_Stage__c+' where Lead stage is: '+leadMap.get(lId).Lead_Stage__c);
                                    } 
                                }
                                
                            }
                        }
                    }
                }
            }
        } 
    }*/

 /*   public static Map<String, String> getStagesMap() {
        Map<String, String> stageMap = new Map<String, String>();
        
        List<Stage_Management__c> stageList = [Select Name, Allowed_Stages__c 
                                                from Stage_Management__c];
        system.debug('stageList: '+stageList);
        
        if(!stageList.isEmpty()) {
            for(Stage_Management__c st: stageList) {
                stageMap.put(st.Name, st.Allowed_Stages__c);
            }
        }
        return stageMap;
    }  */
    
    // Create Enquiry method 
   
    public static void CallHandlerServices(Set<Id> taskId, string operation, boolean count) {
        Map<Id, List<Task>> mapRollUpLead = new Map<Id, List<Task>>();
        Map<Id, List<Task>> mapRollUpOpp  = new Map<Id, List<Task>>();
        Map<Id, List<Task>> mapRollUpcpproject = new Map<Id, List<Task>>();
        
        List<Task> taskList = [Select Id, WhoId, WhatId, CreatedDate, Stage__c,Call_Status__c, Created_Date__c,Sub_Stage__c, Sub_Stage_Reason__c, Next_Follow_up_Date__c,
                               Date_of_Visit__c, Description, RecordTypeId,CP_Call_Next_Action_Date__c,CP_Meeting_Next_Action_Date__c,
                               CP_Stage__c,CP_Sub_Stage__c,
                               RecordType.Name from Task where Id IN: taskId 
                               AND (RecordType.Name = 'Presale Call' OR RecordType.Name = 'Sales Call' OR RecordType.Name = 'Site Visit' OR RecordType.Name = 'CP Call' OR RecordType.Name = 'CP Meeting')];
        system.debug('taskList: '+taskList);
        
        for(Task t: taskList) {
        
            if(t.WhatId != Null && t.WhatId.getSObjectType().getDescribe().getName() == 'Lead_c__c') {
                if(!mapRollUpLead.containsKey(t.WhatId)) {
                    List<Task> newTaskList = new List<Task>();
                    newTaskList.add(t);
                    mapRollUpLead.put(t.WhatId, newTaskList);
                } else {
                    mapRollUpLead.get(t.WhatId).add(t);
                }
            } else if(t.whatId != Null && t.WhatId.getSObjectType().getDescribe().getName() == 'Opportunity_c__c') {
                if(!mapRollUpOpp.containsKey(t.WhatId)) {
                    List<Task> newTaskList = new List<Task>();
                    newTaskList.add(t);
                    mapRollUpOpp.put(t.WhatId, newTaskList);
                } else {
                    mapRollUpOpp.get(t.WhatId).add(t);
                }                
            } else if(t.whatId != Null && t.WhatId.getSObjectType().getDescribe().getName() == 'CP_Project__c') {
                if(!mapRollUpcpproject.containsKey(t.WhatId)) {
                    List<Task> newTaskList = new List<Task>();
                    newTaskList.add(t);
                    mapRollUpcpproject.put(t.WhatId, newTaskList);
                } else {
                    mapRollUpcpproject.get(t.WhatId).add(t);
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
        if(!mapRollUpcpproject.isEmpty()) {
           RollUpTaskCpprojectServices(mapRollUpcpproject,operation, count);
        }
    }
    
    public static void RollUpTaskLeadServices(Map<Id, List<Task>> mapRollUpLead, string operation, boolean count) {
        List<Lead_c__c> updateLeadList = new List<Lead_c__c>();
        List<Lead_c__c> leadList = [Select Id, Follow_up_Date__c,Last_Comment__c,Comment_History__c,
                                Presales_Call_Count__c, Call_Not_Answered__c,Proposed_Visit_Date__c,Lead_Stage__c,
                                Lead_Sub_Stage__c,Lead_Sub_Stage_Reason__c, Last_Call_Date__c, First_Call_Date__c 
                                from Lead_c__c 
                                where Id =: mapRollUpLead.keySet()];
        system.debug('leadList: '+leadList);
        
        for(Lead_c__c l: leadList) {
            List<Task> getLeadTaskList = mapRollUpLead.get(l.Id);
            system.debug('getLeadTaskList: '+getLeadTaskList);
            
            DateTime dT = System.Now();
             
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
           
            if(!getLeadTaskList.isEmpty()) {
                for(Task t: getLeadTaskList) {
                    if(t.RecordType.Name == 'Presale Call') {
                        l.Last_Call_Date__c = Date.valueOf(t.CreatedDate);
                        l.Lead_Stage__c = t.Stage__c;
                        l.Lead_Sub_Stage__c = t.Sub_Stage__c;
                        l.Lead_Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        l.Follow_up_Date__c = t.Next_Follow_up_Date__c;
                        l.Proposed_Visit_Date__c = t.Date_of_Visit__c;
                        l.Last_Comment__c = t.Description;
                        if (l.First_Call_Date__c == Null) {
                            l.First_Call_Date__c = Date.valueOf(t.CreatedDate);
                        }
                        if(t.Stage__c != Null)
                        {
                            l.Lead_Stage__c= t.Stage__c;
                            if(t.Sub_Stage__c != Null)
                            l.Lead_Sub_Stage__c = t.Sub_Stage__c;
                            if(t.Sub_Stage_Reason__c != Null)
                            l.Lead_Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        }
                        
                        
                        if(l.Presales_Call_Count__c == Null)
                            l.Presales_Call_Count__c = 0;   
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null) 
                            l.Presales_Call_Count__c = l.Presales_Call_Count__c + 1;
                        if(l.Last_Comment__c != Null)
                        {
                            if(l.Comment_History__c == Null)
                           l.Comment_History__c = '';
                           l.Comment_History__c = l.Comment_History__c+'\n'+string.ValueOf(myDate)+': '+l.Last_Comment__c;
                        }
                         updateLeadList.add(l);
                        
                        
                        if (l.Call_Not_Answered__c == Null)
                            l.Call_Not_Answered__c = 0;
                        if((operation == 'insert' || operation == 'update') && t.Call_Status__c == 'Call Not Complete' || t.Call_Status__c == 'Ringing/Disconnected' ||t.Call_Status__c == 'Invalid/Wrong Number'||t.Call_Status__c == 'Not Reachable / Switch off')
                            l.Call_Not_Answered__c =  l.Call_Not_Answered__c + 1;
                        if((operation == 'insert' || operation == 'update') && t.Call_Status__c == 'Call Complete' || t.Call_Status__c == 'Call Back' ||t.Call_Status__c == 'Not Interested')    
                            l.Call_Not_Answered__c =  0;
                         } 
               /*     if(t.RecordType.Name == 'Sales Call') {
                        l.Last_Call_Date__c = t.CreatedDate;
                        l.Last_Sales_Call_Stage__c = t.Stage__c;
                        l.Last_Sales_Call_Sub_Stage__c = t.Sub_Stage__c;
                        l.Last_Sales_Call_Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;

                        if(t.Stage__c != Null)
                        {
                            l.Lead_Status__c= t.Stage__c;
                            //if(t.Sub_Stage__c != Null)
                            l.Lead_Sub_Stage__c = t.Sub_Stage__c;
                            //if(t.Sub_Stage_Reason__c != Null)
                            l.Lead_Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        }

                        l.Next_Follow_up_Date__c = t.Next_Follow_up_Date__c;
                        l.Date_of_Visit__c= t.Date_of_Visit__c;
                        l.Last_Sales_Call_Comment__c = t.Description;
                        if(l.Last_Sales_Call_Comment__c != Null)
                        {
                            if(l.Sales_Comment_History__c == Null)
                                l.Sales_Comment_History__c = '';
                            l.Sales_Comment_History__c = l.Sales_Comment_History__c+'\n'+string.ValueOf(myDate)+': '+l.Last_Sales_Call_Comment__c;
                        }
                        if(l.Sales_Call_Count__c  == Null)
                            l.Sales_Call_Count__c  = 0;
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null)
                            l.Sales_Call_Count__c = l.Sales_Call_Count__c + 1;
                        
                        updateLeadList.add(l);
                    } */
                    
               /*     if(t.RecordType.Name == 'Site Visit') {
                        l.Visit_DateTime__c = t.Date_of_Visit__c;
                        l.Next_Follow_up_Date__c = t.Next_Follow_up_Date__c;
                        l.Site_Visit_Stage__c = t.Site_Visit_Stage__c;
                        l.Site_Visit_Sub_Stage__c = t.Site_Visit_Sub_Stage__c;
                        l.Site_Visit_Sub_Stage_Reason__c = t.Site_Visit_Sub_Stage_Reason__c;
                        if(t.Site_Visit_Stage__c != Null)
                        {
                            l.Lead_Status__c= t.Site_Visit_Stage__c;
                            //if(t.Sub_Stage__c != Null)
                            l.Lead_Sub_Stage__c = t.Site_Visit_Sub_Stage__c;
                            //if(t.Sub_Stage_Reason__c != Null)
                            l.Lead_Sub_Stage_Reason__c = t.Site_Visit_Sub_Stage_Reason__c;
                        }
                        
                        l.Visit_Type__c = t.Visit_Type__c;
                        l.Last_SV_Comments__c = t.Description;
                        if(l.Last_SV_Comments__c != Null)
                      {
                             if(l.SV_Comment_History__c == Null)
                                l.SV_Comment_History__c = '';
                            l.SV_Comment_History__c = l.SV_Comment_History__c+'\n'+string.ValueOf(myDate)+': '+l.Last_SV_Comments__c;
                        }
                        if(l.SV_Count__c == Null)
                            l.SV_Count__c = 1;
                        if((operation == 'insert' || operation == 'update'))
                            l.SV_Count__c = l.SV_Count__c + 1;
                        updateLeadList.add(l);
                    } */
                }
            }
        }
        system.debug('updateLeadList: '+updateLeadList);
        if(!updateLeadList.isEmpty())
            update updateLeadList;
    }
    
    public static void RollUpTaskOpportunityServices(Map<Id, List<Task>> mapRollUpOpp, string operation, boolean count) {
        List<Opportunity_c__c> updateOppList = new List<Opportunity_c__c>();
        List<Opportunity_c__c> oppList = [Select Id,Last_Call_Date__c,Next_Follow_up_Date__c,Proposed_Visit_Date__c,Last_Comment__c,Comment_History__c,Sales_Call_Count__c from Opportunity_c__c where Id =: mapRollUpOpp.keySet()];
        system.debug('oppList: '+oppList);
        
        for(Opportunity_c__c op: oppList) {
            List<Task> getOppTaskList = mapRollUpOpp.get(op.Id);
            system.debug('getOppTaskList: '+getOppTaskList);
            
            DateTime dT = System.now();
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
            if(!getOppTaskList.isEmpty()) {
                for(Task t: getOppTaskList) {
                 /*   if(t.RecordType.Name == 'Presale Call') {
                        op.Last_Presale_Call_Date__c = t.CreatedDate;
                        op.Last_Presale_Call_Stage__c = t.Stage__c;
                        op.Last_Presale_Call_Sub_Stage__c = t.Sub_Stage__c;
                        op.Last_Presale_Call_Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        op.Presale_Next_Follow_up_Date__c = t.Next_Follow_up_Date__c;
                        op.Presale_Date_of_Visit__c = t.Date_of_Visit__c;
                        op.Last_Presale_Call_Comment__c = t.Description;
                        if(op.Presales_Call__c == Null)
                            op.Presales_Call__c = 0;
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null)
                            op.Presales_Call__c = op.Presales_Call__c + 1;
                        updateOppList.add(op);
                    } */
                    if(t.RecordType.Name == 'Sales Call') {
                       // op.Last_Sales_Call_Date__c = t.CreatedDate;
                        op.Opportunity_Stage__c = t.Stage__c;
                        op.Opportunity_Sub_Stage__c = t.Sub_Stage__c;
                     //   op.Last_Sales_Call_Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        op.Next_Follow_up_Date__c = t.Next_Follow_up_Date__c;
                        op.Proposed_Visit_Date__c = t.Date_of_Visit__c;
                        op.Last_Comment__c = t.Description;
                        if(t.Stage__c != Null)
                        {
                            op.Opportunity_Stage__c = t.Stage__c;
                            //if(t.Sub_Stage__c != Null)
                            op.Opportunity_Sub_Stage__c = t.Sub_Stage__c;
                            //if(t.Sub_Stage_Reason__c != Null)
                            // op.Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        }
                        if(op.Sales_Call_Count__c  == Null)
                            op.Sales_Call_Count__c  = 0;
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null)
                            op.Sales_Call_Count__c = op.Sales_Call_Count__c + 1;
                        if(op.Last_Comment__c != Null)
                        {
                            if(op.Comment_History__c == Null)
                                op.Comment_History__c ='';
                            op.Comment_History__c = op.Comment_History__c+'\n'+string.ValueOf(myDate)+': '+op.Last_Comment__c;
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
    
    public static void RollUpTaskCpprojectServices(Map<Id, List<Task>> mapRollUpcpproject, string operation, boolean count) {
        List<CP_Project__c> updateCpist = new List<CP_Project__c>();
        List<CP_Project__c> CpList = [Select Id,CP_Call_Next_Action_Date__c,Last_CP_Call_Date__c,Last_CP_Call_Remarks__c,Last_CP_Call_Stage__c,Last_CP_Call_Status__c,Last_CP_Call_Sub_Stage__c,
                                       CP_Meeting_Next_Action_Date__c,Meeting_Call_Count__c,Meeting_Comment_History__c, Last_CP_Meeting_Date__c,Last_CP_Meeting_Remarks__c,Last_CP_Meeting_Stage__c,Last_CP_Meeting_Status__c,
                                       Last_CP_Meeting_Sub_Stage__c,Call_Comment_History__c,CP_Call_Count__c  from CP_Project__c where Id =: mapRollUpcpproject.keySet()];
        system.debug('CpList: '+CpList);
        
        for(CP_Project__c cp: CpList) {
            List<Task> getcpprojectTaskList = mapRollUpcpproject.get(cp.Id);
            system.debug('getcpprojectTaskList: '+getcpprojectTaskList);
            
            DateTime dT = System.now();
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
            if(!getcpprojectTaskList.isEmpty()) {
                for(Task t: getcpprojectTaskList) {
                 /*   if(t.RecordType.Name == 'Presale Call') {
                        op.Last_Presale_Call_Date__c = t.CreatedDate;
                        op.Last_Presale_Call_Stage__c = t.Stage__c;
                        op.Last_Presale_Call_Sub_Stage__c = t.Sub_Stage__c;
                        op.Last_Presale_Call_Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        op.Presale_Next_Follow_up_Date__c = t.Next_Follow_up_Date__c;
                        op.Presale_Date_of_Visit__c = t.Date_of_Visit__c;
                        op.Last_Presale_Call_Comment__c = t.Description;
                        if(op.Presales_Call__c == Null)
                            op.Presales_Call__c = 0;
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null)
                            op.Presales_Call__c = op.Presales_Call__c + 1;
                        updateOppList.add(op);
                    } */
                    if(t.RecordType.Name == 'CP Meeting') {
                        cp.Last_CP_Meeting_Date__c = t.CreatedDate;
                        cp.Last_CP_Meeting_Stage__c = t.CP_Stage__c;
                        cp.Last_CP_Meeting_Sub_Stage__c = t.CP_Sub_Stage__c;
                        cp.CP_Meeting_Next_Action_Date__c = t.CP_Meeting_Next_Action_Date__c;
                        cp.Last_CP_Meeting_Remarks__c = t.Description;
                        cp.Last_CP_Meeting_Status__c = t.Call_Status__c;
                        
                        if(t.CP_Stage__c != Null)
                        {
                            cp.CP_Stage__c = t.CP_Stage__c;
                            //if(t.Sub_Stage__c != Null)
                            cp.CP_Sub_Stage__c = t.CP_Sub_Stage__c;
                            //if(t.Sub_Stage_Reason__c != Null)
                            // op.Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        }
                        if(cp.Meeting_Call_Count__c  == Null)
                            cp.Meeting_Call_Count__c  = 0;
                        if((operation == 'insert' || operation == 'update') && t.CP_Stage__c != Null)
                            cp.Meeting_Call_Count__c = cp.Meeting_Call_Count__c + 1;
                        if(cp.Last_CP_Meeting_Remarks__c != Null)
                        {
                            if(cp.Meeting_Comment_History__c == Null)
                                cp.Meeting_Comment_History__c ='';
                            cp.Meeting_Comment_History__c = cp.Meeting_Comment_History__c+'\n'+string.ValueOf(myDate)+': '+cp.Last_CP_Meeting_Remarks__c;
                        }    
                        updateCpist.add(cp);    
                    }
                    
                    
                    
                    if(t.RecordType.Name == 'CP Call') {
                        cp.Last_CP_Call_Date__c = t.CreatedDate;
                        cp.Last_CP_Call_Stage__c = t.CP_Stage__c;
                        cp.Last_CP_Call_Sub_Stage__c = t.CP_Sub_Stage__c;
                        cp.CP_Call_Next_Action_Date__c = t.CP_Call_Next_Action_Date__c;
                        cp.Last_CP_Call_Remarks__c = t.Description;
                        cp.Last_CP_Call_Status__c = t.Call_Status__c;
                        
                        if(t.CP_Stage__c != Null)
                        {
                            cp.CP_Stage__c = t.CP_Stage__c;
                            //if(t.Sub_Stage__c != Null)
                            cp.CP_Sub_Stage__c = t.CP_Sub_Stage__c;
                            //if(t.Sub_Stage_Reason__c != Null)
                            // op.Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        }
                        if(cp.CP_Call_Count__c  == Null)
                            cp.CP_Call_Count__c  = 0;
                        if((operation == 'insert' || operation == 'update') && t.CP_Stage__c != Null)
                            cp.CP_Call_Count__c = cp.CP_Call_Count__c + 1;
                        if(cp.Last_CP_Call_Remarks__c != Null)
                        {
                            if(cp.Call_Comment_History__c == Null)
                                cp.Call_Comment_History__c ='';
                            cp.Call_Comment_History__c = cp.Call_Comment_History__c+'\n'+string.ValueOf(myDate)+': '+cp.Last_CP_Call_Remarks__c;
                        }    
                        updateCpist.add(cp);    
                    }
                }
            }
        }
        system.debug('updateCpist: '+updateCpist);
        if(!updateCpist.isEmpty())
            update updateCpist;
    }
}