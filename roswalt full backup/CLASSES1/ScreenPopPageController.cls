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
        List<Campaign> cList = new List<Campaign>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Lead> leadList = new List<Lead>();
        
        if(String.isNotBlank(callerId) && callerId != null) {
            cList = [Select Id, Campaign_Code__c, Project__c from Campaign
                     where IsActive = true AND Is_CTI_Campaign__c = true AND Virtual_Number__c =: callerId];
            system.debug('cList: '+cList);
            
            if(!cList.isEmpty() && cList != null) {
                projectId = cList[0].Project__c;
            }
        }
        
        if(String.isNotBlank(mobileNo) && mobileNo != null) {
            if(mobileNo.length() > 10) {
                mobileNo = mobileNo.substring(mobileNo.length()-10);
            }
            
            oppList = [Select Id, Name, AccountId, Project__c from Opportunity
                       where (Account.PersonMobilePhone =: mobileNo OR Account.Phone =: mobileNo) AND Project__c =: projectId];
            system.debug('oppList: '+oppList);
            
            if(!oppList.isEmpty() && oppList != null) {
                pRef = new PageReference('/' + oppList[0].Id);
            } else {
                leadList = [Select Id, FirstName, LastName, MobilePhone, Phone from Lead where (MobilePhone =: mobileNo OR Phone =: mobileNo)
                            AND Project__c =: projectId AND IsConverted = false ORDER BY LastModifiedDate DESC];
                system.debug('leadList: '+leadList);
                
                if(!leadList.isEmpty() && leadList != null) {
                    pRef = new PageReference('/' + leadList[0].Id);
                }
            } 
        }
        return pRef;
    }
}