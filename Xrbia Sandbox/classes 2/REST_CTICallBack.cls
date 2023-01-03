//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 27-10-2022
//-------------------------------------------//
@RestResource(urlMapping='/CTI/CallBack/')
global class REST_CTICallBack {
    @HttpPost
    global static void createCallDetails() {
        String data = '';
        String projectId = '';
        data = RestContext.request.params.get('data');
        system.debug('Data: '+data);
        
        if(String.isNotBlank(data) && data != '') {
            List<User> uList = new List<User>();
            List<Campaign__c> cList = new List<Campaign__c>();
            List<Opportunity__c> oppList = new List<Opportunity__c>();
            List<Lead__c> leadList = new List<Lead__c>();
            Boolean isOppFound = false;
            Boolean isLeadFound = false;
            
            CTICallBackParse cbp = CTICallBackParse.parse(data);
            String customerNumber = cbp.CallerID;
            String did = cbp.DID;
            String ucid = cbp.monitorUCID; 
            String callStatus = cbp.Status;
            String callType = cbp.CallType;
            String recordingFile = cbp.AudioFile;
            String duration = cbp.Duration;
            String campaignName = cbp.CampaignName;
            String comments = cbp.Comments;
            String disposition = cbp.Disposition;
            String monitorUCID = cbp.monitorUCID;
            String agentID = cbp.AgentID;
            String hangupBy = cbp.HangupBy;
            DateTime startDateTime = DateTime.valueOf(cbp.StartTime);
            DateTime endDateTime = DateTime.valueOf(cbp.EndTime);
            Integer callDuration = 0;
            
            if(String.isNotBlank(duration) && duration != null) {
                List<String> splitList = duration.split('\\:');
                callDuration = ((Integer.valueOf(splitList[0]) * 3600) + (Integer.valueOf(splitList[1]) * 60) + Integer.valueOf(splitList[2]));
            }
            
            if(String.isNotBlank(did) && did != null) {
                cList = [Select Id, Campaign_Code__c, Media__c, Campaign_Type__c, Project__c, DID_Number__c, DID_Number__r.Name from Campaign__c
                         where Active__c = true AND Is_CTI_Campaign__c = true AND DID_Number__r.Name =: did];
                system.debug('cList: '+cList);
                
                if(!cList.isEmpty() && cList != null) {
                    projectId = cList[0].Project__c;
                }
                
                if(String.isNotBlank(customerNumber) && customerNumber != null) {
                    if(customerNumber.length() > 10) {
                      customerNumber = customerNumber.substring(customerNumber.length()-10);
                    }
                    system.debug('customerNumber: '+customerNumber);
                	
                    oppList = [Select Id, Name, AccountId__c, AccountId__r.PersonContactId, Project__c, OwnerId from Opportunity__c 
                               where (AccountId__r.PersonMobilePhone =: customerNumber OR AccountId__r.Phone =: customerNumber) AND Project__c =: projectId];
                    system.debug('oppList: '+oppList);
                    
                    if(!oppList.isEmpty() && oppList != null) {
                        isOppFound = true;
                    } else {
                        leadList = [Select Id, First_Name__c, Last_Name__c, MobilePhone__c, Phone__c, OwnerId from Lead__c where (MobilePhone__c =: customerNumber OR Phone__c =: customerNumber)
                                    AND Project__c =: projectId AND IsConverted__c = false ORDER BY LastModifiedDate DESC];
                        system.debug('leadList: '+leadList);
                        
                        if(!leadList.isEmpty() && leadList != null) {
                            isLeadFound = true;
                        }
                    }
                    
                    if(String.isNotBlank(callStatus) && callStatus != null) {
                        if(String.isNotBlank(agentID) && agentID != null) {
                            uList = [Select Id from User where Ozonetel_AgentId__c =: agentID AND IsActive = true];
                            system.debug('uList: '+uList);
                        }
                        
                        Task t = new Task();
                        if(callStatus.equalsIgnoreCase('NotAnswered')) {
                            t.Subject = 'Missed Call: '+did;
                            t.Description = 'Missed Call: ' + did;
                            if(callType.equalsIgnoreCase('InBound')) {
                            	t.CallType = 'Inbound';
                                t.Status = 'Completed';
                                t.Priority = 'High';
                            } else if(callType.equalsIgnoreCase('Manual')) {
                                t.CallType = 'Outbound';
                                t.Status = 'Open';
                                t.Priority = 'Low';
                            }
                            t.Virtual_Number__c = did;
                            t.Call_Status__c = callStatus;
                            t.Mobile__c = customerNumber;
                            t.AudioFile__c = recordingFile;
                            t.Campaign_Code__c = campaignName;
                            t.Call_Start_DateTime__c = startDateTime;
                            t.Call_End_DateTime__c = endDateTime;
                            t.Hangup_By__c = hangupBy;
                            t.AgentID__c = agentID;
                            
                            if(isOppFound) {
                                t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Call').getRecordTypeId();
                                t.WhoId = oppList[0].AccountId__r.PersonContactId;
                                t.WhatId = oppList[0].Id;
                                t.OwnerId = oppList[0].OwnerId;
                            } else if(isLeadFound) {
                                t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
                                t.WhatId = leadList[0].Id;
                                t.OwnerId = leadList[0].OwnerId;
                            }
                        } else {
                            if(callType.equalsIgnoreCase('InBound')) {
                                t.Subject = 'Inbound Call: '+did;
                            	t.CallType = 'Inbound';
                            } else if(callType.equalsIgnoreCase('Manual')) {
                                t.Subject = 'Outbound Call: '+did;
                            	t.CallType = 'Outbound';
                            }
                            t.Call_Status__c = callStatus;
                            t.Description = comments;
                            t.Mobile__c = customerNumber;
                            t.CallDurationInSeconds = callDuration;
                            t.Call_Disposition__c = disposition;
                            t.Virtual_Number__c = did;
                            t.CallObject = monitorUCID;
                            t.Call_Start_DateTime__c = startDateTime;
                            t.Call_End_DateTime__c = endDateTime;
                            t.AudioFile__c = recordingFile;
                            t.Status = 'Open';
                            t.Priority = 'Normal';
                            t.Hangup_By__c = hangupBy;
                            t.AgentID__c = agentID;
                            
                            if(!uList.isEmpty() && uList != null) {
                                t.OwnerId = uList[0].Id;
                            }
                            
                            if(isOppFound) {
                                t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Call').getRecordTypeId();
                                t.WhoId = oppList[0].AccountId__r.PersonContactId;
                                t.WhatId = oppList[0].Id;
                            } else if(isLeadFound) {
                                t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
                                t.WhatId = leadList[0].Id;
                            }
                        }
                        
                        try {
                            insert t;
                            System.debug('task created:' + t.id);
                        } catch (Exception ex) {
                            System.debug('task insert failed :' + ex.getMessage());
                        }
                    }
                }
            }
        }
    }
}