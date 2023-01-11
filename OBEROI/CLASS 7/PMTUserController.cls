public class PMTUserController {
    
    @AuraEnabled
    public static List<User> getPMTUsers(){
        Id pmtQueueId = [Select Id from Group where type='Queue' and Name='PMT Team'].Id;
            
        Id pmtProfileId = [select Id from Profile where Name = 'PMT Users'].Id;
        
        List<User> users = [select Id,Name,On_Leave__c from User 
                            where Id in (Select UserOrGroupId From GroupMember where GroupId =: pmtQueueId) and
                            profileId =: pmtProfileId and IsActive = true];
        return users;
    }
    
    @AuraEnabled
    public static string getLastAssignedId(){
        Id pmtQueueId = [select id from queuesobject where queue.name='PMT Team'].Id; 
        List<Lead> lastAssigned = [SELECT Original_PMT_Owner__c FROM Lead where LeadSource = 'web' 
                             and ownerId !=: pmtQueueId order by createdDate desc limit 1];
       
        if(lastAssigned!=null && lastAssigned.size()>0){          
            return String.valueOf(lastAssigned[0].Original_PMT_Owner__c);
        }
        return null;
    }
    
    @AuraEnabled
    public static void savePMTUserRecords(string inputUsers){
        List<User> users = (List<User>) JSON.deserialize(inputUsers,List<User>.class);
        update users;
    }

}