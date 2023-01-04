//-------------------------------------------//
//  Project: Raunak Developers
//  Created By: Exceller Consultancy
//  Created Date: 17-11-2022
//-------------------------------------------//
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
        String campaignLeadSubSourceDetails;
        String projectId;
        List<Campaign__c> cList = new List<Campaign__c>();
        List<Account> accList = new List<Account>();
        List<Lead_c__c> leadList = new List<Lead_c__c>();
        List<User> userList = new List<User>();
        Id ownerId = null;
        
        if(String.isNotBlank(did) && did != null) {
            cList = [Select Id, SRD_Code__c, Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Project__c from Campaign__c
                     where Active__c = true AND Is_CTI_Campaign__c = true AND SRD_Code__c =: did];
            system.debug('cList: '+cList);
            
            if(!cList.isEmpty() && cList != null) {
                campaignId = cList[0].Id;
                campaignCode = cList[0].SRD_Code__c;
                campaignMasterSource = cList[0].Master_Source__c;
                campaignLeadSource = cList[0].Lead_Source__c;
                campaignLeadSubSource = cList[0].Lead_Sub_Source__c;
                campaignLeadSubSourceDetails = cList[0].Lead_Sub_Source_Details__c;
                projectId = cList[0].Project__c;
            }
            
            if(String.isNotBlank(mobileNo) && mobileNo != null) {
                if(mobileNo.length() > 10) {
                    mobileNo = mobileNo.substring(mobileNo.length()-10);
                }
                accList = [Select Id, FirstName, LastName, ownerId from Account 
                       where (PersonMobilePhone =: mobileNo OR Phone =: mobileNo) AND IsPersonAccount = True];
            	system.debug('accList: '+accList);
                if(!accList.isEmpty() && accList != null) {
                    ownerId = accList[0].OwnerId;
                } else {
                    leadList = [Select Id, First_Name__c, Last_Name__c, Mobile__c, Alternate_Mobile_No__c, ownerId from Lead_c__c where (Mobile__c =: mobileNo OR Alternate_Mobile_No__c =: mobileNo)
                                AND IsConverted__c = false ORDER BY LastModifiedDate DESC];
                    system.debug('leadList: '+leadList);
                    
                    if(!leadList.isEmpty() && leadList != null) {
                        ownerId = leadList[0].OwnerId;
                    } else {
                        Lead_c__c l = new Lead_c__c();
                        l.First_Name__c = 'Incoming';
                        l.Last_Name__c = 'Customer';
                        l.Mobile__c = mobileNo;
                        l.Campaign_Custom__c = campaignId;
                        l.SRD_Code__c = campaignCode;
                        l.Project_Name__c = projectId;
                        l.Lead_Created_From__c = 'CTI';
                        l.Is_Round_Robin_Apply__c = true;
                        l.Master_Source_Category__c = campaignMasterSource;
                        l.Lead_Source__c = campaignLeadSource;
                        l.Lead_Sub_Source__c = campaignLeadSubSource;
                        l.Sub_Source_Details__c = campaignLeadSubSourceDetails;
                        try {
                            insert l;
                            List<Lead_c__c> getList = [Select Id, OwnerId from Lead_c__c where Id =: l.Id];
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