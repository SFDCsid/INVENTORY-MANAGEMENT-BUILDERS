//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class TaskTriggerHandler {
    public static void beforeInsert(List<Task> taskList) {
        Map<Id, List<Task>> taskMap = new Map<Id, List<Task>>();
        Map<Id, Task> firstTaskMap = new Map<Id, Task>();
        
        for(Task t: taskList) {
            if(Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'Presales Call') {
                if(t.whatId != null && t.whatId.getSObjectType().getDescribe().getName() == 'Lead__c') { //&& String.isBlank(t.Call_ID__c)
                    if(!taskMap.containsKey(t.whatId)) {
                        List<Task> tList = new List<Task>();
                        tList.add(t);
                        taskMap.put(t.whatId, tList);
                    } else {
                        taskMap.get(t.whatId).add(t);
                    }
                    if(String.isNotBlank(t.CallType) && String.isNotBlank(t.Call_Status__c)) {
                        if(!firstTaskMap.containskey(t.WhatId))
                            firstTaskMap.put(t.WhatId, t);
                    }
                }
            }
        }
        if(!taskMap.isEmpty() && taskMap != null)
            TaskHandlerServices.validationCheckforPresaleCall(taskMap);
        if(!firstTaskMap.isEmpty() && firstTaskMap != null)
            TaskHandlerServices.updateCTILeadInfo(firstTaskMap);
    }
    
    public static void afterInsert(List<Task> taskList) {
        Set<Id> taskIdSet = new Set<Id>();
        List<Task> enqList = new List<Task>();
        Set<Id> billingIdSet = new Set<Id>();
        
        for(Task t: taskList) {
            if(t.WhatId != null && (Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'Presales Call' || 
                                    Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'Sales Call')) 
            {
                Pagereference pg = new Pagereference('/'+t.id);
                pg.setredirect(true);
                //return pg;
            }
            if(t.Stage__c != null && (Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'Presales Call' || 
                                      Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'Sales Call' ||
                                      Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'CP Call / Meeting'))
                taskIdSet.add(t.Id);
            if(Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'Enquiry' && t.Campaign__c != null && t.Is_New_Lead_Created__c == false)
                enqList.add(t);
            if((t.Amount__c != null || t.Amount_Paid__c != null) && Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'Billing') {
                if(t.WhatId != null && t.whatId.getSObjectType().getDescribe().getName() == 'Campaign__c') {
                    billingIdSet.add(t.Id);
                }
            }
        }
        if(!taskIdSet.isEmpty() && taskIdSet != null)
            TaskHandlerServices.CallHandlerServices(taskIdSet, 'insert', true);
        if(!enqList.isEmpty() && enqList != null)
            CampaignHandlerServices.calculateCampaignPerformance('Task', null, enqList);
        if(!billingIdSet.isEmpty() && billingIdSet != null)
            TaskHandlerServices.rollupBillingDetailOnCampaign(billingIdSet);
    }
    
    public static void beforeUpdate(Map<Id, Task> oldMap, Map<Id, Task> newMap) {
        Map<Id, List<Task>> taskMap = new Map<Id, List<Task>>();
        
        for(Task oldTask: oldMap.values()) {
            Task newTask = newMap.get(oldTask.Id);
            
            if(oldTask.Stage__c != newTask.Stage__c && newTask.Stage__c != null) {
                if(Schema.SObjectType.Task.getRecordTypeInfosById().get(newTask.RecordTypeId).getName() == 'Presales Call') {
                    if(newTask.whatId != null && newTask.whatId.getSObjectType().getDescribe().getName() == 'Lead__c') {
                        if(!taskMap.containsKey(newTask.whatId)) {
                            List<Task> tList = new List<Task>();
                            tList.add(newTask);
                            taskMap.put(newTask.whatId, tList);
                        } else {
                            taskMap.get(newTask.whatId).add(newTask);
                        }
                    }
                }
            }
        }
        if(!taskMap.isEmpty() && taskMap != null)
            TaskHandlerServices.validationCheckforPresaleCall(taskMap);
    }
    
    public static void afterUpdate(Map<Id, Task> oldMap, Map<Id, Task> newMap) {
        Set<Id> taskIdSet = new Set<Id>();
        
        for(Task oldTask: oldMap.values()) {
            Task newTask = newMap.get(oldTask.Id);
            
            if(oldTask.Status != newTask.Status && newTask.Status == 'Completed' && newTask.Stage__c != null)
                taskIdSet.add(newTask.Id);
        }
        if(!taskIdSet.isEmpty() && taskIdSet != null)
            TaskHandlerServices.CallHandlerServices(taskIdSet, 'update', true);
    }
}