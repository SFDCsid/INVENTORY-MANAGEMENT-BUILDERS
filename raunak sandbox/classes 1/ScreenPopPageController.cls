//-------------------------------------------//
//  Project: Raunak Developers
//  Created By: Exceller Consultancy
//  Created Date: 17-11-2022
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
        
        List<Account> accList = new List<Account>();
        List<Lead_c__c> leadList = new List<Lead_c__c>();
        
        if(String.isNotBlank(mobileNo) && mobileNo != null) {
            if(mobileNo.length() > 10) {
                mobileNo = mobileNo.substring(mobileNo.length()-10);
            }
            accList = [Select Id, FirstName, LastName, ownerId from Account 
                       where (PersonMobilePhone =: mobileNo OR Phone =: mobileNo) AND IsPersonAccount = True];
            system.debug('accList: '+accList);
            
            if(!accList.isEmpty() && accList != null) {
                pRef = new PageReference('/' + accList[0].Id);
            } else {
                leadList = [Select Id, First_Name__c, Last_Name__c, Mobile__c, Alternate_Mobile_No__c from Lead_c__c where (Mobile__c =: mobileNo OR Alternate_Mobile_No__c =: mobileNo)
                            AND IsConverted__c = false ORDER BY LastModifiedDate DESC];
                system.debug('leadList: '+leadList);
                
                if(!leadList.isEmpty() && leadList != null) {
                    pRef = new PageReference('/' + leadList[0].Id);
                } 
            } 
        }
        return pRef;
    }
}