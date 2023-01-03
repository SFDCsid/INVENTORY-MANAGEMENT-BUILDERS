//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 27-10-2022
//-------------------------------------------//
@RestResource(urlMapping='/CTI/getAgent/')
global class REST_CTIAgentServices{
    @HttpPost
    global static Rest_result getAgentId(String mobileNo, String did) {
        Rest_result r = new Rest_result();
        String campaignId;
        String campaignCode;
        String campaignMedia;
        String campaignType;
        String projectId;
        List<Campaign__c> cList = new List<Campaign__c>();
        List<Opportunity__c> oppList = new List<Opportunity__c>();
        List<Lead__c> leadList = new List<Lead__c>();
        List<User> userList = new List<User>();
        Id ownerId = null;
        
        if(String.isNotBlank(did) && did != null) {
            cList = [Select Id, Campaign_Code__c, Media__c, Campaign_Type__c, Project__c, DID_Number__c, DID_Number__r.Name from Campaign__c
                     where Active__c = true AND Is_CTI_Campaign__c = true AND DID_Number__r.Name =: did];
            system.debug('cList: '+cList);
            
            if(!cList.isEmpty() && cList != null) {
                campaignId = cList[0].Id;
                campaignCode = cList[0].Campaign_Code__c;
                campaignMedia = cList[0].Media__c;
                campaignType = cList[0].Campaign_Type__c;
                projectId = cList[0].Project__c;
            }
        	
            if(String.isNotBlank(mobileNo) && mobileNo != null) {
                if(mobileNo.length() > 10) {
                    mobileNo = mobileNo.substring(mobileNo.length()-10);
                }
                
                oppList = [Select Id, Name, AccountId__c, Project__c, ownerId from Opportunity__c 
                       where (AccountId__r.PersonMobilePhone =: mobileNo OR AccountId__r.Phone =: mobileNo) AND Project__c =: projectId];
            	system.debug('oppList: '+oppList);
                
                if(!oppList.isEmpty() && oppList != null) {
                    ownerId = oppList[0].OwnerId;
                } else {
                    leadList = [Select Id, First_Name__c, Last_Name__c, MobilePhone__c, Phone__c, ownerId from Lead__c where (MobilePhone__c =: mobileNo OR Phone__c =: mobileNo)
                                AND Project__c =: projectId AND IsConverted__c = false ORDER BY LastModifiedDate DESC];
                    system.debug('leadList: '+leadList);
                    
                    if(!leadList.isEmpty() && leadList != null) {
                        ownerId = leadList[0].OwnerId;
                    } else {
                        Lead__c l = new Lead__c();
                        l.First_Name__c = 'Incoming';
                        l.Last_Name__c = 'Customer';
                        l.MobilePhone__c = mobileNo;
                        l.Campaign_Custom__c = campaignId;
                        l.Campaign_Code__c = campaignCode;
                        l.Campaign_Type__c = campaignType;
                        l.Project__c = projectId;
                        l.Media__c = campaignMedia;
                        l.Lead_Created_From__c = 'CTI';
                        l.Apply_Round_Robin__c = true;
                        try {
                            insert l;
                            List<Lead__c> getList = [Select Id, OwnerId from Lead__c where Id =: l.Id];
                            system.debug('getList: '+getList);
                            
                            if(!getList.isEmpty() && getList != null) {
                                ownerId = getList[0].OwnerId;
                            }
                        } catch(Exception ex) {
                            system.debug('Error: '+ex.getMessage());
                        }
                    }
                }
                
                if(ownerId != null) {
                    userList = [Select Id, Ozonetel_AgentId__c from User where Id =: ownerId];
                    system.debug('userList: '+userList);
                    
                    if(!userList.isEmpty() && userList != null) {
                        if(userList[0].Ozonetel_AgentId__c != null && userList[0].Ozonetel_AgentId__c != '') {
                            r.agentId = userList[0].Ozonetel_AgentId__c;
                        } else {
                            r.agentId = null;
                        }
                    } else {
                        r.agentId = null;
                    }
                } else {
                    r.agentId = null;
                }
            } else {
                r.agentId = null;
            }
        } else {
            r.agentId = null;
        }
        return r;
    }
    global class REST_result{
        webservice String agentId;
    }
}