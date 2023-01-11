trigger EOIUnblockCheckTrg on Property__c (before Update) {
    if(Trigger.isbefore && Trigger.isUpdate){
        List<Property__c> updateProp = new List<Property__c>();
        String profileName = [select Name from profile where id = :UserInfo.getProfileId()].Name;
        for(Property__c prop : Trigger.New){
            if(UserInfo.getUserId() != prop.EOI_Blocked_By__c && profileName != 'System Administrator'){
                if(trigger.oldmap.get(prop.Id).Status__c == 'EOI Blocked' && (prop.Status__c != Trigger.oldmap.get(prop.id).Status__c && prop.Status__c == 'Available')){
                    prop.addError('You Cannot unblock this Unit.');   
                }
            }
            else {
                if(trigger.oldmap.get(prop.Id).Status__c == 'EOI Blocked' && (prop.Status__c != Trigger.oldmap.get(prop.id).Status__c && prop.Status__c == 'Available')){
                
                    prop.EOI_Blocked_Date__c = Null;
                    prop.EOI_Blocked_By__c = Null;
                    prop.EOI_Block__c = false;
                    prop.EOI_Blocked_for__c = Null;
                }    
            }
        }
    }
}