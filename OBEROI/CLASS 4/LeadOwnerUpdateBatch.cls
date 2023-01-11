global class LeadOwnerUpdateBatch implements Database.Batchable<sObject> 
{
    static list <User> salesGroupUsers;
    static Integer lastSalesCounter;
    static list<QueueSobject> queue;
    static list <Lead> ld;
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {  system.debug('In Batch1');
       /* Map<string, Project__c> ProjMap = new Map<string, Project__c>();
        for(Project__c prj :[SELECT id,recordtypeId,Project_External_Id__c,Autodistribution__c, name FROM Project__c]){
            ProjMap.put(string.ValueOf(prj.id),prj);            
        }*/ system.debug('In Batch2');
        queue = [select Id, queueId, queue.Name from QueueSobject where sobjectType =:'Lead' and 
                 queue.Name =:system.label.PMT_Team LIMIT 1];
        string queueID =  queue[0].queueId ;
        system.debug('In Batch');
        // string query = 'Select Id, Name,ownerId,project__c from Lead WHERE ownerID =  \'' + queueID + '\'+  AND  project__r.Autodistribution__c = true';  
        string query = 'Select Id, Name, ownerId, Date_of_Site_Visit__c,project__c , Status, Lead_Stage__c from Lead WHERE ownerID =  \'' + queueID  + '\''; 
        system.debug(query+'query');
        return database.getQueryLocator(query);     
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> LeadList) 
    {
    system.debug('In Execute');  
      WebLead();
     for (Lead ld : LeadList){
         ld.User_Copy__c = assignLead(); 
         ld.ownerId = ld.User_Copy__c;         
     }     
     update LeadList;
     system.debug(LeadList+'***%%%');
     creatTask(LeadList);
    }
    
    
    global void finish(Database.BatchableContext BC) {
       
    }
    
    //Method Added to create Task
    public static void creatTask(list<Lead> ldList) {
    List<task> tList = new List<task>();
     system.debug('In Method-->'+ldList);
     for(Lead ld : ldList){
    Task t = new Task();
            t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Lead').getRecordTypeId();     
            t.Ownerid = ld.OwnerId;
            t.Priority = 'Normal';
            t.Status = 'Not Started';
            t.WhoId = ld.Id;
            t.Date_of_Site_Visit__c=ld.Date_of_Site_Visit__c;
            t.ActivityDate = Date.Today().addDays(1);
            t.Completion_By_Date__c = DateTime.now().addDays(1);
            if(ld.Lead_Stage__c!='Converted to Opportunity'){
                t.Stage__c = ld.Lead_Stage__c;
                t.Lead_Status__c = ld.Status;
            }
            else{
                t.Lead_Status__c = 'Follow-up';
                t.Stage__c ='Assign to Front Desk';
            }
                        
            System.debug('t.Stage__c '+t.Stage__c+'**');
            System.debug('t.Lead_Status__c'+t.Lead_Status__c+'**');
            if(ld.Date_of_Site_Visit__c!=null){
                t.Subject='Site visit requested from web';
            }
            else {
                t.Subject='New enquiry from Web';
            }
            tList.add(t);
            }
    insert tList;
    }
    
    
    public static void WebLead() { 
        
        set<String> salesGroupIdsSet;   
        DateTime currentTime;
        list <Lead> lastAssignedUserSales;         
        
        list<GroupMember> salesGroupMembers;
        
        salesGroupMembers = new list<GroupMember>();        
        currentTime = DateTime.now();                       
        salesGroupMembers = [select id, UserOrGroupId from GroupMember where Group.Name =: system.label.PMT_Team];        
        salesGroupIdsSet = new set<String>();       
        for(GroupMember member: salesGroupMembers) {            
            salesGroupIdsSet.add(member.UserOrGroupId);         
        }   
        
        /* get Sales Group user sorted by username */
        
        salesGroupUsers = [select id, userName, isActive, Leave_Start_Date__c, Leave_End_Date__c 
                           from User 
                           where Id IN : salesGroupIdsSet and isActive = true AND On_Leave__c =False
                           order by LastName asc ];
        
        /* get last sales group userId(Owner) */
        
        lastAssignedUserSales = [select ID,OwnerId, createdDate
                                 from Lead  
                                 where OwnerId IN : salesGroupIdsSet 
                                 order by CreatedDate desc limit 1 ];    
        
        lastSalesCounter = getLastassignedUser(lastAssignedUserSales, salesGroupUsers);     
        
    }
    
    /*
* This method returns last assigned user counter of sorted user list.
* So it helps to determine next user.
*
*/
    
    public static  Integer getLastassignedUser(list<Lead> lead, list<User> user ) {
        
        if(lead.size() == 0) {
            return -1;
        }      
        else {
            return getLastAssingnedCounter(lead[0].OwnerId,user);
        }        
    }
    
    /*
* The method will return the counter of given id and given user list
*
*/
    
    public static Integer getLastAssingnedCounter(String Id , list<User> user) {        
        Integer counter = -1;        
        for(User tempUser :user) {            
            counter++;      
            if(Id == tempUser.id) {                         
                break;      
            }           
        }       
        return counter; 
    }   
    
    public static String assignLead() {
        
        String Id = null;
        
        if(salesGroupUsers.size() != 0) {            
            lastSalesCounter = assignOwnership(lastSalesCounter,salesGroupUsers);            
            Id = salesGroupUsers[lastSalesCounter].Id;
        }
        else {
            Id = queue[0].queueId;            
        }
        return Id;
    }
    
    
    /*
* This method returns the counter for next lead owner. 
* It also validates the user leave and check if user is Active 
*
*/
    
    public static Integer assignOwnership(Integer lastAssignedCounter, list<User> user) {      
        
        if(lastAssignedCounter + 1 == user.size()) {
            lastAssignedCounter = 0;
        }
        else {
            lastAssignedCounter += 1;
        }
        return lastAssignedCounter;         
        
    }
    
    
    
}