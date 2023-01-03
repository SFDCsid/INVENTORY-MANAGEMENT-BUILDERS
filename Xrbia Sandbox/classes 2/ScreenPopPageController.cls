//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 27-10-2022
//-------------------------------------------//
public class ScreenPopPageController {
    public String mobileNo {get;set;}
    public String callerId {get;set;}
    
    public ScreenPopPageController() {
        if(ApexPages.currentPage().getParameters().containsKey('phone'))  {     
            mobileNo = ApexPages.currentPage().getParameters().get('phone'); 
        }
        system.debug('mobileNo: '+mobileNo);
        if(ApexPages.currentPage().getParameters().containsKey('did'))  {     
            callerId = ApexPages.currentPage().getParameters().get('did'); 
        }
        system.debug('callerId: '+callerId);
    }
    
    public pageReference screenPop() {
        pageReference pRef;
        String projectId;
        List<Campaign__c> cList = new List<Campaign__c>();
        List<Opportunity__c> oppList = new List<Opportunity__c>();
        List<Lead__c> leadList = new List<Lead__c>();
        
        if(String.isNotBlank(callerId) && callerId != null) {
            cList = [Select Id, Campaign_Code__c, Media__c, Campaign_Type__c, Project__c, DID_Number__c, DID_Number__r.Name from Campaign__c
                     where Active__c = true AND Is_CTI_Campaign__c = true AND DID_Number__r.Name =: callerId];
            system.debug('cList: '+cList);
            
            if(!cList.isEmpty() && cList != null) {
                projectId = cList[0].Project__c;
            }
        }
        
        if(String.isNotBlank(mobileNo) && mobileNo != null) {
            if(mobileNo.length() > 10) {
                mobileNo = mobileNo.substring(mobileNo.length()-10);
            }
            
            oppList = [Select Id, Name, AccountId__c, Project__c from Opportunity__c 
                       where (AccountId__r.PersonMobilePhone =: mobileNo OR AccountId__r.Phone =: mobileNo) AND Project__c =: projectId];
            system.debug('oppList: '+oppList);
            
            if(!oppList.isEmpty() && oppList != null) {
                pRef = new PageReference('/' + oppList[0].Id);
            } else {
                leadList = [Select Id, First_Name__c, Last_Name__c, MobilePhone__c, Phone__c from Lead__c where (MobilePhone__c =: mobileNo OR Phone__c =: mobileNo)
                            AND Project__c =: projectId AND IsConverted__c = false ORDER BY LastModifiedDate DESC];
                system.debug('leadList: '+leadList);
                
                if(!leadList.isEmpty() && leadList != null) {
                    pRef = new PageReference('/' + leadList[0].Id);
                } /*else {
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
                    try {
                        insert l;
                        pRef = new PageReference('/' + l.Id);
                    } catch(Exception ex) {
                        system.debug('Error: '+ex.getMessage());
                    }
                }*/
            } 
        }
        return pRef;
    }
}