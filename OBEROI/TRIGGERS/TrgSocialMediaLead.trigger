trigger TrgSocialMediaLead on Social_Media_Lead__c (After insert) {
    Set <ID> smlId = new Set <Id>();
    
    for(Social_Media_Lead__c s: trigger.new){
        if(s.Name != null || s.Name != ''){
           smlId.add(s.Id);            
        }
    }
    system.debug('smlId::' + smlId);
    
    if(!smlId.isEmpty()){}
      SocialMediaLeadManagement.CreateLead(smlId);  
}