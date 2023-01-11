trigger RM_Update_Trg on Property__c (After insert,After Update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        if(checkRecursion.isFirstRunA()){
        Set<Id> pId = new Set<Id>();
            for(Property__c p : Trigger.New){
                if(p.Original_RM_Name__c != Trigger.oldmap.get(p.id).Original_RM_Name__c && p.Original_RM_Name__c != Null){
                    pId.add(p.Id);
                 }
            }
            if(pId != null){
                Rest_RM_Update.UpdateRM(pId);
            }
       }
    }
    if(Trigger.isAfter && Trigger.isInsert){
        if(checkRecursion.isFirstRunA()){
            Set<Id> pId = new Set<Id>();
            for(Property__c p : Trigger.New){
                if(p.Original_RM_Name__c != Null){
                    pId.add(p.Id);
                }
            }
            if(pId != null){
                Rest_RM_Update ru = new Rest_RM_Update();
                Rest_RM_Update.UpdateRM(pId);
            }
        }
    }
}