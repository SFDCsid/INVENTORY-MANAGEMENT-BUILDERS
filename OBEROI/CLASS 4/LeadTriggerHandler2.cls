public without sharing class LeadTriggerHandler2{
    
    static list <User> salesGroupUsers;
    static Integer lastSalesCounter;
    static Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
    static Id ldRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
    static Id ldLuxRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
    static list<QueueSobject> queueL = [select Id, queueId, queue.Name from QueueSobject where sobjectType =:'Lead' and 
                                        queue.Name =:system.label.PMT_Team LIMIT 1];
    
    
    public static void beforeInsertLead( list<Lead> newLead ){
        list<Project__c> pjList = new list<Project__c>(); 
        Map<string, Project__c> ProjMap = new Map<string, Project__c>();
        set<Id> LeadId = new set<Id>();
        WebLead();        
        Integer currentTime = Integer.valueOf((string.valueOf(system.now())).substring(11, 13));
        // Integer currentTime = 19;
        Boolean outOfficeHours = False;
        //Logic to check office hours
        if(currentTime > 18 || currentTime < 9){
            outOfficeHours = True ;
        }
        
        for(Project__c prj :[SELECT id,recordtypeId,Project_External_Id__c,Autodistribution__c, name FROM Project__c]){
            ProjMap.put(string.ValueOf(prj.id),prj);            
        }
        
        for(Lead lda : newLead){ 
            lda.Site_Id__c = lda.Site__c;
            
            lda.De_Dupe_Helper__c = 'Closed'.equalsIgnoreCase(lda.Lead_Stage__c) ? ''+lda.Id : 'Open';
            if(lda.Is_Legacy_Data__c == false){
                lda.Date_of_Enquiry__c = system.today() ;
            }
            
            if(lda.LeadSource =='Web' && lda.recordtypeId == ldRecordTypeId && lda.Cloned_Lead__c == false ){
                
                ID leadOwner = assignLead();                
                lda.RecordTypeId = ldRecordTypeId ;
                lda.User_Copy__c = leadOwner;
                lda.ownerId = lda.User_Copy__c;
                
                system.debug(lda.Day_of_Lead_Creation__c +'****');
                if(outOfficeHours == True )
                    lda.OwnerId = queueL[0].queueId; 
                if(!lda.OwnerId.getSObjectType().getDescribe().getName().equalsIgnoreCase('Group')){
                    lda.Original_PMT_Owner__c = lda.OwnerId;
                }
            }
            //Implemented for Luxury
            /*   if(lda.Project__c != null){
if(ProjMap.get(lda.Project__c).recordtypeId == PrRecordTypeId  )
{ 
lda.RecordTypeId = ldLuxRecordTypeId;
if(ProjMap.get(lda.Project__c).Autodistribution__c != true ){
lda.OwnerId = queueL[0].queueId; 
}else{
ID leadOwner = assignLead();  
lda.User_Copy__c = leadOwner;
lda.ownerId = lda.User_Copy__c;
if( outOfficeHours == True )
lda.OwnerId = queueL[0].queueId; 
}
}
}*/
        }
    }
    
    
    /*public static void afterInsertLead( Map<Id, Lead>NewLeadMap ){ 
system.debug('1.0');
for(lead l: NewLeadMap.values()){
if(l.LeadSource !='Virtual No.'){
sendMessage(NewLeadMap);
}
}

}
*/
    
    public static void beforeUpdateLead( list<Lead>newLead ){
        map<Id,Id> newLeadVsOwnerIdMap = new Map<Id,Id>();
        set <Id> campaignIdSet = new set<Id>();
        for(Lead lda : newLead){ 
            lda.Site_Id__c = lda.Site__c; 
            lda.De_Dupe_Helper__c = 'Closed'.equalsIgnoreCase(lda.Lead_Stage__c) ? ''+lda.Id : 'Open';
            if(lda.OwnerId != ((Lead)trigger.oldMap.get(lda.Id)).OwnerId){
                newLeadVsOwnerIdMap.put(lda.Id,lda.OwnerId);
                campaignIdSet.add(lda.Deffered_Task_Campaign__c);
            }
        }
        if(!newLeadVsOwnerIdMap.isEmpty()){
            list<GroupMember> pmtGroupMembers;        
            pmtGroupMembers = [select id, UserOrGroupId from GroupMember where Group.Name =: system.label.PMT_Team];        
            set<string> pmtUserIdsSet = new set<String>();  
            for(GroupMember member: pmtGroupMembers) {            
                pmtUserIdsSet.add(member.UserOrGroupId);         
            }
            for(Id leadId : newLeadVsOwnerIdMap.keySet()){
                if(pmtUserIdsSet.contains(newLeadVsOwnerIdMap.get(leadId))){
                    ((Lead)trigger.newMap.get(leadId)).Original_PMT_Owner__c = ((Lead)trigger.newMap.get(leadId)).OwnerId;
                }
            }
            Lead leadObj;
            map <Id, Campaign> campaignMap = new map<Id, Campaign>([select id, Number_of_Tasks__c
                                                                    from Campaign 
                                                                    where Id IN : campaignIdSet]);
            list<Task> taskList = new list<Task>();
            list <CampaignMember> campaignMembersList = new list<CampaignMember>();
            for(Id leadId : newLeadVsOwnerIdMap.keySet()){
                leadObj = (Lead)trigger.newMap.get(leadId);
                if(leadObj.Deferred_Task_for_Site_Visit__c && leadObj.ownerId.getSObjectType().getDescribe().getName().equalsIgnoreCase('User')) {
                    //create Task
                    //WebToLead.createTask(l,l.OwnerId,l.Date_of_Site_Visit__c,campaignMap.get(l.Deffered_Task_Campaign__c));
                    Task t = new Task();
                    t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Lead').getRecordTypeId();     
                    t.Ownerid = leadObj.OwnerId;
                    t.Priority = 'Normal';
                    t.Status = 'Not Started';
                    t.WhoId = leadObj.Id;
                    t.ActivityDate = Date.Today();
                    t.Completion_By_Date__c = leadObj.Deferred_Task_Completion_By__c;
                    t.Stage__c = leadObj.Status;
                    t.Lead_Status__c = leadObj.Lead_Stage__c;
                    if(leadObj.Date_of_Site_Visit__c != null){
                        t.Subject='Site visit requested from web';
                    }
                    else {
                        t.Subject='New enquiry from Web';
                    }
                    taskList.add(t);
                    if(campaignMap.containsKey(leadObj.Deffered_Task_Campaign__c)){
                        if(campaignMap.get(leadObj.Deffered_Task_Campaign__c).Number_of_Tasks__c == null){
                            campaignMap.get(leadObj.Deffered_Task_Campaign__c).Number_of_Tasks__c = 0;
                        }
                        campaignMap.get(leadObj.Deffered_Task_Campaign__c).Number_of_Tasks__c += 1;
                    }
                    system.debug('@@@@@:'+leadObj.Deffered_Task_Campaign__c );
                    if(leadObj.Deffered_Task_Campaign__c != null) {
                        campaignMembersList.add(new CampaignMember(CampaignId = leadObj.Deffered_Task_Campaign__c,
                                                                   Status = 'Sent',
                                                                   LeadId =  leadObj.Id));
                    }
                    leadObj.Deferred_Task_Completion_By__c = null;
                    leadObj.Deffered_Task_Campaign__c = null;
                    leadObj.Deferred_Task_for_Site_Visit__c = false;
                }
            }
            
            //commented to avoid duplicate task creation
            //database.insert(taskList, false);
            database.update(campaignMap.values(), false);
            database.insert(campaignMembersList,false);
        }
        
        
        
    }
    
    
    /*
//Method For SMS Confirmation
public static void sendMessage(Map<Id, Lead>NewLeadMap) {
try{
for(Lead ld : NewLeadMap.values()){
String mbNoStr = ld.Country_Code__c+ld.mobilePhone;
//String mbNoStr ='09836696777';
system.debug('1.1');
mbNoStr = mbNoStr.removeStart('+');
System.debug('mobile no...'+mbNoStr+'.....');   

String statMess = 'Thank you for registering your interest. We shall proactively get in touch with you as soon as possible.';
String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(statMess, 'UTF-8')+'&senderid=ORLCRM';
system.debug('@@@@@:'+smsURL);
EnquirySMSCtrl.sendSMS(smsURL);
//CIF_Default_Email__c deEmail =  CIF_Default_Email__c.getOrgDefaults();
//System.debug('deEmail: ' +deEmail);
system.debug('LeadTriggerHandler2: sent sms');
//  if(deEmail.Email_Address__c != null && deEmail.Email_Address__c == leadobj.Email)
//    sendOTPMail(leadobj.Email, statMess);            
//  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Your OTP is sent at entered mobile number.'));        
} }
catch(exception ex){
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Your session is out. Please try again.'));
}
}
*/
    public static void WebLead() { 
        
        String Sales_Queue = 'Sales Queue';
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
        
        salesGroupUsers = [select id, userName, isActive , On_Leave__c
                           from User 
                           where Id IN : salesGroupIdsSet and isActive = true  AND On_Leave__c = False  
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
    
    public static Integer getLastassignedUser(list<Lead> lead, list<User> user ) {
        
        if(lead.size() == 0) {
            return -1;
        }      
        else {
            system.debug('getLastAssingnedCounter'+getLastAssingnedCounter(lead[0].OwnerId,user)+'   '+lead[0].OwnerId);
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
            //  Id = queue[0].queueId;            
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