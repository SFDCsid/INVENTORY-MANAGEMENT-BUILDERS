public class UserTriggerHandler {
    //Do not allow duplicate virtual number
    public static void onBefore(list<User> newUserList){
       for(User u : newUserList){
            if(u.Virtual_Number__c == null){
                u.Unique_Virtual_Number__c = u.Id;
            }
            else {
                u.Unique_Virtual_Number__c = u.Virtual_Number__c;
            }
        }
    }
    
    public static void onAfterInsert(list<User> newUserList){
        Map<String,Id> virtualNumberMap = new Map<String,Id>();
        for(User u : newUserList){
            if(u.Virtual_Number__c!=null){
                virtualNumberMap.put(u.Virtual_Number__c,u.Id);
            }
        }
        
        if(!virtualNumberMap.isEmpty()){
            List<Virtual_Number__c> virtualNumberList = [SELECT User__c,Name 
                                                         FROM Virtual_Number__c 
                                                         WHERE Name IN : virtualNumberMap.keySet()];
            for(Virtual_Number__c sinlgeVirtualNumber : virtualNumberList){
                sinlgeVirtualNumber.User__c = virtualNumberMap.get(sinlgeVirtualNumber.Name);
            }
            update virtualNumberList;                 
        }
    }
    
    public static void onAfterUpdate(list<User> newUserList, map<Id, User> oldUserMap){
        Set<String> virtualNumberSet = new Set<String>();
        
        for(User u : newUserList){
            if(u.Virtual_Number__c != oldUserMap.get(u.Id).Virtual_Number__c){
                virtualNumberSet.add(u.Virtual_Number__c);
                virtualNumberSet.add(oldUserMap.get(u.Id).Virtual_Number__c);
            }
        }
        
        virtualNumberSet.remove(null);
        
        if(!virtualNumberSet.isEmpty()){
            
            map <String, Virtual_Number__c> virtualNumberMap = new map<String, Virtual_Number__c>();
            for(Virtual_Number__c vn : [SELECT User__c,Name 
                                         FROM Virtual_Number__c 
                                         WHERE Name IN : virtualNumberSet]){
                virtualNumberMap.put(vn.Name, vn);
            }
            //first remove all old mappings
            for(User u : newUserList){
                if(u.Virtual_Number__c != oldUserMap.get(u.Id).Virtual_Number__c && virtualNumberMap.containsKey(oldUserMap.get(u.Id).Virtual_Number__c)){
                    virtualNumberMap.get(oldUserMap.get(u.Id).Virtual_Number__c).User__c = null;
                }
            }
            //then, add new mappings, intentionally used two separate for loops, do not club into into one, else will produce unexpected results
            for(User u : newUserList){
                if(u.Virtual_Number__c != oldUserMap.get(u.Id).Virtual_Number__c &&  virtualNumberMap.containsKey(u.Virtual_Number__c)){
                    virtualNumberMap.get(u.Virtual_Number__c).User__c = u.Id;
                }
            }
            update virtualNumberMap.values();                 
        }
    }
}