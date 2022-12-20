@RestResource(urlMapping='/CTI/getAgent/')
global class REST_CTIAgentServices{
    @HttpPost
    global static Rest_result getAgentId(String mobileNo, String did) {
        Rest_result r = new Rest_result();
        String campaignId;
        String campaignCode;
        String campaignMasterSource;
        String campaignLeadSource;
        String campaignLeadSubSource;
        String campaignLeadSubSourceDetail;
        String projectId;
        List<Campaign> cList = new List<Campaign>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Lead> leadList = new List<Lead>();
        List<User> userList = new List<User>();
        Id ownerId = null;
        
        if(String.isNotBlank(did) && did != null) {
            cList = [Select Id, Campaign_Code__c, Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c,
                     Project__c, Virtual_Number__c from Campaign
                     where IsActive = true AND Is_CTI_Campaign__c = true AND Virtual_Number__c =: did];
            system.debug('cList: '+cList);
            
            if(!cList.isEmpty() && cList != null) {
                campaignId = cList[0].Id;
                campaignCode = cList[0].Campaign_Code__c;
                campaignMasterSource = cList[0].Master_Source__c;
                campaignLeadSource = cList[0].Lead_Source__c;
                campaignLeadSubSource = cList[0].Lead_Sub_Source__c;
                campaignLeadSubSourceDetail = cList[0].Lead_Sub_Source_Details__c;
                projectId = cList[0].Project__c;
            }
        	
            if(String.isNotBlank(mobileNo) && mobileNo != null) {
                if(mobileNo.length() > 10) {
                    mobileNo = mobileNo.substring(mobileNo.length()-10);
                }
                
                oppList = [Select Id, Name, AccountId, Project__c, OwnerId from Opportunity 
                       		where (Account.PersonMobilePhone =: mobileNo OR Account.Phone =: mobileNo) AND Project__c =: projectId];
            	system.debug('oppList: '+oppList);
                
                if(!oppList.isEmpty() && oppList != null) {
                    ownerId = oppList[0].OwnerId;
                } else {
                    leadList = [Select Id, FirstName, LastName, MobilePhone, Phone, OwnerId from Lead where (MobilePhone =: mobileNo OR Phone =: mobileNo)
                                AND Project__c =: projectId AND IsConverted = false ORDER BY LastModifiedDate DESC];
                    system.debug('leadList: '+leadList);
                    
                    if(!leadList.isEmpty() && leadList != null) {
                        ownerId = leadList[0].OwnerId;
                    } else {
                        Lead l = new Lead();
                        l.FirstName = 'Incoming';
                        l.LastName = 'Customer';
                        l.MobilePhone = mobileNo;
                        l.Campaign_Custom__c = campaignId;
                        l.Campaign_Code__c = campaignCode;
                        l.Master_Source__c = campaignMasterSource;
                        l.Lead_Source__c = campaignLeadSource;
                        l.Lead_Sub_Source__c = campaignLeadSubSource;
                        l.Lead_Sub_Source_Details__c = campaignLeadSubSourceDetail;
                        l.Project__c = projectId;
                        l.Lead_Created_From__c = 'CTI';
                        l.Apply_Round_Robin__c = true;
                        try {
                            insert l;
                            List<Lead> getList = [Select Id, OwnerId from Lead where Id =: l.Id];
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
                    userList = [Select Id, Ozonetel_AgentId__c, isOnlineAgent__c from User where Id =: ownerId];
                    system.debug('userList: '+userList);
                    
                    if(!userList.isEmpty() && userList != null) {
                        if(userList[0].Ozonetel_AgentId__c != null && userList[0].Ozonetel_AgentId__c != '') {
                            if(userList[0].isOnlineAgent__c)
                            {
                                r.phoneName = userList[0].Ozonetel_AgentId__c;
                            }
                            else
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
        webservice String phoneName;
    }
}