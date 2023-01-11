trigger ContentDocTrg on ContentVersion (before update) {

   
    if(Trigger.isBefore&&Trigger.isUpdate){
        for(ContentVersion cv:Trigger.new){
            
            if(Trigger.oldMap.get(cv.id).isApproved__c!=Trigger.newMap.get(cv.id).isApproved__c&&!Trigger.newMap.get(cv.id).IsThroughApprovalProcess__c){
               cv.addError('You do not have rights to approve this document.[It must be approved through Approval Process.]');  
            }
             if(Trigger.oldMap.get(cv.id).isDocGen__c!=Trigger.newMap.get(cv.id).isDocGen__c){
               cv.addError('You do not have rights to Change this Field.');  
            }
        }
    }
}