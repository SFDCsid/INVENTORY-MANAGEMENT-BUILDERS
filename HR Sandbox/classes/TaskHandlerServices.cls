public class TaskHandlerServices {
    
    // Create Enquiry method 
   
    public static void CallHandlerServices(Set<Id> taskId, string operation, boolean count) {
        Map<Id, List<Task>> mapRollUpLead = new Map<Id, List<Task>>();
        Map<Id, List<Task>> mapRollUpOpp  = new Map<Id, List<Task>>();
        
        List<Task> taskList = [Select Id, WhoId, WhatId, CreatedDate,Date__c,Opportunity_Stage__c,Next_Action_Date__c,
                                RecordTypeId,Description,Comments__c, RecordType.Name from Task where Id IN: taskId 
                               AND (RecordType.Name = 'Meeting' OR RecordType.Name = 'Call'OR RecordType.Name = 'Whatsapp'OR RecordType.Name = 'Email')];
        system.debug('taskList: '+taskList);
        
        for(Task t: taskList) {
        
            if(t.whoId != Null  /*&& t.WhoId.getSObjectType().getDescribe().getName() == 'Lead'*/) {
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
        //if(!mapRollUpLead.isEmpty()) {
            //RollUpTaskLeadServices(mapRollUpLead,operation, count);
        //}
        system.debug('mapRollUpOpp: '+mapRollUpOpp);
        if(!mapRollUpOpp.isEmpty()) {
            RollUpTaskOpportunityServices(mapRollUpOpp,operation, count);
        }
    }
    
   /* public static void RollUpTaskLeadServices(Map<Id, List<Task>> mapRollUpLead, string operation, boolean count) {
        List<Lead> updateLeadList = new List<Lead>();
        List<Lead> leadList = [Select Id, Last_Presale_Call_Date__c, Last_Presale_Call_Stage__c, Last_Presale_Call_Sub_Stage__c,
                               Last_Presale_Call_Sub_Stage_Reason__c, Presale_Next_Follow_up_Date__c, Presale_Date_of_Visit__c, Last_Presale_Call_Comment__c,
                               Last_Sales_Call_Date__c, Last_Sales_Call_Stage__c, Last_Sales_Call_Sub_Stage__c, Last_Sales_Call_Comment__c,
                               Last_Sales_Call_Sub_Stage_Reason__c, Sales_Next_Follow_up_Date__c, Sales_Date_of_Visit__c, Status,
                               Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c, Presales_Call__c,Sales_Call_Count__c,Presales_Comment_History__c
                               from Lead where Id =: mapRollUpLead.keySet()];
        system.debug('leadList: '+leadList);
        
        for(Lead l: leadList) {
            List<Task> getLeadTaskList = mapRollUpLead.get(l.Id);
            system.debug('getLeadTaskList: '+getLeadTaskList);
            
            DateTime dT = System.now();
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
            if(!getLeadTaskList.isEmpty()) {
                for(Task t: getLeadTaskList) {
                    if(t.RecordType.Name == 'Presale Call') {
                        l.Last_Presale_Call_Date__c = t.CreatedDate;
                        l.Last_Presale_Call_Stage__c = t.Stage__c;
                        l.Last_Presale_Call_Sub_Stage__c = t.Sub_Stage__c;
                        l.Last_Presale_Call_Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        l.Presale_Next_Follow_up_Date__c = t.Next_Follow_up_Date__c;
                        l.Presale_Date_of_Visit__c = t.Date_of_Visit__c;
                        l.Last_Presale_Call_Comment__c = t.Description;
                        if(t.Stage__c != Null)
                        {
                            l.Status = t.Stage__c;
                            //if(t.Sub_Stage__c != Null)
                            l.Lead_Sub_Stage__c = t.Sub_Stage__c;
                            //if(t.Sub_Stage_Reason__c != Null)
                            l.Lead_Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        }
                        if(l.Presales_Call__c == Null)
                            l.Presales_Call__c = 0;   
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null) 
                            l.Presales_Call__c = l.Presales_Call__c + 1;
                        if(l.Last_Presale_Call_Comment__c != Null)
                        {
                            if(l.Presales_Comment_History__c == Null)
                                l.Presales_Comment_History__c = '';
                            l.Presales_Comment_History__c = l.Presales_Comment_History__c+'\n'+string.ValueOf(myDate)+': '+l.Last_Presale_Call_Comment__c;
                        }
                        updateLeadList.add(l);
                    }
                    if(t.RecordType.Name == 'Sales Call') {
                        l.Last_Sales_Call_Date__c = t.CreatedDate;
                        l.Last_Sales_Call_Stage__c = t.Stage__c;
                        l.Last_Sales_Call_Sub_Stage__c = t.Sub_Stage__c;
                        l.Last_Sales_Call_Sub_Stage_Reason__c = t.Sub_Stage_Reason__c;
                        l.Sales_Next_Follow_up_Date__c = t.Next_Follow_up_Date__c;
                        l.Sales_Date_of_Visit__c = t.Date_of_Visit__c;
                        l.Last_Sales_Call_Comment__c = t.Description;
                        if(l.Sales_Call_Count__c  == Null)
                            l.Sales_Call_Count__c  = 0;
                        if((operation == 'insert' || operation == 'update') && t.Stage__c != Null)
                            l.Sales_Call_Count__c = l.Sales_Call_Count__c + 1;
                        
                        updateLeadList.add(l);
                    }
                }
            }
        }
        system.debug('updateLeadList: '+updateLeadList);
        if(!updateLeadList.isEmpty())
            update updateLeadList;
    }*/
    
    public static void RollUpTaskOpportunityServices(Map<Id, List<Task>> mapRollUpOpp, string operation, boolean count) {
        List<Opportunity> updateOppList = new List<Opportunity>();
        List<Opportunity> oppList = [Select Id,Last_Call_Comment__c ,Last_Call_Date__c,Last_Call_Next_Action_Date__c ,Last_Call_stage__c ,Last_Meeting_Stage__c,Last_Meeting_Date__c ,Last_Meeting_Next_Action_Date__c,
                                     Last_Meeting_Comment__c,Last_Whatsapp_Comment__c,Last_Whatsapp_Date__c,Last_Whatsapp_Next_Action_Date__c,
                                     Last_Whatsapp_Stage__c,Whatsapp_Comment_History__c,Call_Comment_History__c,Meeting_Comment_History__c
                                      from Opportunity where Id =: mapRollUpOpp.keySet()];
        
        system.debug('oppList: '+oppList);
        
        for(Opportunity op: oppList) {
            List<Task> getOppTaskList = mapRollUpOpp.get(op.Id);
            system.debug('getOppTaskList: '+getOppTaskList);
            
               string s=System.now().format();
               string myDate  =s.left(10);
               system.debug(myDate);
            
            
            //DateTime dT = System.now();
            //Date myDate = date.newinstance(dT.day(), dT.month(), dT.year());
            
            if(!getOppTaskList.isEmpty()) {
                for(Task t: getOppTaskList) {
                    if(t.RecordType.Name == 'Call') 
                    {
                        op.Last_Call_Date__c= t.Date__c;
                        op.Last_Call_stage__c= t.Opportunity_Stage__c  ;
                        op.Last_Call_Next_Action_Date__c= t.Next_Action_Date__c;
                        op.Last_Call_Comment__c= t.Description;
                        
                         if(op.Last_Call_Comment__c!= Null)
                        {
                            if(op.Call_Comment_History__c== Null)
                                op.Call_Comment_History__c='';
                                op.Call_Comment_History__c= op.Call_Comment_History__c+'\n'+string.ValueOf(myDate)+': '+op.Last_Call_Comment__c;
                        }     
                        updateOppList.add(op);
                    }
                    if(t.RecordType.Name == 'Meeting') 
                    {
                        op.Last_Meeting_Date__c= t.Date__c;
                        op.Last_Meeting_Stage__c= t.Opportunity_Stage__c  ;
                        op.Last_Meeting_Next_Action_Date__c= t.Next_Action_Date__c;
                        op.Last_Meeting_Comment__c= t.Description;
                        
                        if(op.Last_Meeting_Comment__c!= Null)
                        {
                            if(op.Meeting_Comment_History__c== Null)
                                op.Meeting_Comment_History__c='';
                            op.Meeting_Comment_History__c= op.Meeting_Comment_History__c+'\n'+string.ValueOf(myDate)+': '+op.Last_Meeting_Comment__c;
                        }   
                        updateOppList.add(op);    
                    }
                          if(t.RecordType.Name == 'Whatsapp') 
                    {
                        op.Last_Whatsapp_Date__c= t.Date__c;
                        op.Last_Whatsapp_Stage__c= t.Opportunity_Stage__c  ;
                        op.Last_Whatsapp_Next_Action_Date__c= t.Next_Action_Date__c;
                        op.Last_Whatsapp_Comment__c= t.Description;
                        //op.Last_Whatsapp_Comment__c= t.Comments__c;

                        if(op.Last_Whatsapp_Comment__c!= Null)
                        {
                            if(op.Whatsapp_Comment_History__c== Null)
                                op.Whatsapp_Comment_History__c='';
                                op.Whatsapp_Comment_History__c= op.Whatsapp_Comment_History__c+'\n'+string.ValueOf(myDate)+': '+op.Last_Whatsapp_Comment__c;
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
}