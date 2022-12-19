public class LeadConversionAuraController {
      
    @AuraEnabled
    public static leadConversionWrapper convertSelectedLead(String recordId){
        system.debug('rec::'+recordId);
        Boolean isAccount = false;
        Lead leadObj = new Lead();
        List<Account> accList = new List<Account>();
        
        leadObj = [Select Id, Name, MobilePhone, Email, Phone, Alternate_Email__c, Company, Status, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c from Lead 
                   where Id =: recordId AND IsConverted =: false limit 1];
        system.debug('leadObj::'+leadObj);
        
        if(leadObj != null) {
            if(leadObj.MobilePhone != '' && leadObj.MobilePhone != null) {
                accList = [Select Id, PersonContactId, PersonMobilePhone, PersonEmail, Phone, Alternate_Email__c from Account
                           where (PersonMobilePhone =: leadObj.MobilePhone OR Phone =: leadObj.MobilePhone) AND IsPersonAccount = true];
                system.debug('accList Mobile: '+accList);
                
                if(!accList.isEmpty()) {
                    isAccount = true;
                } else {
                    if(leadObj.Email != '' && leadObj.Email != null) {
                        accList = [Select Id, PersonContactId, PersonMobilePhone, PersonEmail, Phone, Alternate_Email__c from Account
                                   where (PersonEmail =: leadObj.Email OR Alternate_Email__c =: leadObj.Email) AND IsPersonAccount = true];
                        system.debug('accList Email: '+accList);
                        
                        if(!accList.isEmpty()) {
                            isAccount = true;
                        } else {
                            if(leadObj.Phone != '' && leadObj.Phone != null) {
                                accList = [Select Id, PersonContactId, PersonMobilePhone, PersonEmail, Phone, Alternate_Email__c from Account
                                           where (PersonMobilePhone =: leadObj.Phone OR Phone =: leadObj.Phone) AND IsPersonAccount = true];
                                system.debug('accList Phone: '+accList);
                                
                                if(!accList.isEmpty()) {
                                    isAccount = true;
                                } else {
                                    if(leadObj.Alternate_Email__c != '' && leadObj.Alternate_Email__c != null) {
                                        accList = [Select Id, PersonContactId, PersonMobilePhone, PersonEmail, Phone, Alternate_Email__c from Account
                                                   where (PersonEmail =: leadObj.Alternate_Email__c OR Alternate_Email__c =: leadObj.Alternate_Email__c) AND IsPersonAccount = true];
                                        system.debug('accList Alternate Email: '+accList);
                                        
                                        if(!accList.isEmpty())
                                            isAccount = true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            try {
                //Convert Lead
                leadObj.Status = 'Visit Done';
                leadObj.Lead_Sub_Stage__c = 'Visit Done';
                leadObj.Lead_Sub_Stage_Reason__c = '';
                update leadObj;
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(leadObj.id);
                if(isAccount) {
                    lc.setAccountId(accList[0].Id);
                    lc.setContactId(accList[0].PersonContactId);
                }
                LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus where IsConverted = true LIMIT 1];
                lc.setConvertedStatus(convertStatus.MasterLabel);
                Database.LeadConvertResult lcr = Database.convertLead(lc);
                Lead convertedLead = [SELECT ConvertedAccountId, ConvertedOpportunityId from Lead where Id =: leadObj.Id];
                system.debug('Converted Lead: '+convertedLead);
                
                leadConversionWrapper lcWrapper = new leadConversionWrapper(true, convertedLead.ConvertedOpportunityId, 'Lead Converted Successfully!');
                return lcWrapper;
            } catch(Exception ex) {
                system.debug('Error: '+ex.getMessage());
                leadConversionWrapper lcWrapper = new leadConversionWrapper(false, null, 'Error Occured While Conversion. Please Contact Your System Administrator.');
                return lcWrapper;
            }
        } else {
            leadConversionWrapper lcWrapper = new leadConversionWrapper(false, null, 'Unknown Error Occured. Please Contact Your System Administrator.');
            return lcWrapper;
        }
        //return null;
    } 

    Public class leadConversionWrapper {
        @AuraEnabled
        public Boolean isSuccess {get;set;}
        @AuraEnabled
        public String redirectId {get;set;}
        @AuraEnabled
        public String message {get;set;}
        
        public leadConversionWrapper(Boolean result,String redirectId,String msg){
            this.isSuccess = result;
            this.redirectId = redirectId;
            this.message = msg;
        }
    }
}