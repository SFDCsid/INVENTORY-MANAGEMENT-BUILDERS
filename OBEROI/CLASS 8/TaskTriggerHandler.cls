/**********************************************************************************************************************
Version v1.1 - AKohakade - 6-5-2019 - Added debug log
Version v1.2 - Vaidehi HEda - 6-5-2019 - Added debug log
*********************************************************************************************************************/

Public class TaskTriggerHandler{
    
    
    // Update Lead(Residential Lead), once task is updateed
    // Track the next steps on Tasks, post completion and based on task status, automatically update 
    // the Lead status, stage, Comments, Category, Enquiry Description and Enquiry description comments as per task updated. 
    // LM-031
    /*Public static void updateResidentialOpty(Set<id> tskId){
Id taskOptyRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Opportunity').getRecordTypeId();
List<Task> tsklst = new List<Task>([SELECT ActivityDate,Date_of_Site_Visit__c,Category__c,Completion_by_Date__c,RecordTypeId,CreatedDate,
Description_Other_Comments__c,Description__c,
Id,IsClosed,LastModifiedDate,Priority,Stage__c,Status,Subject,WhoId,whatid,Description,Opportunity_Stage__c,Opportunity_Status__c,
Lead_Status__c,OwnerId FROM Task WHERE id=:tskid]);
list<opportunity> opList = new list<opportunity>();
for(Task tk : tsklst){
if(tk.RecordTypeId ==taskOptyRecordTypeId ){
//system.debug('####1.1:'+tk.RecordTypeId);
Opportunity op = new Opportunity(id=tk.WhatId);
op.Rating__c=tk.Category__c;
op.Description_Other_Comments__c=tk.Description_Other_Comments__c;
op.Description__c=tk.Description__c;
op.Internal_Comments__c=tk.Description;
//op.StageName=tk.Opportunity_Stage__c;
//system.debug('#####1.3:'+tk.Opportunity_Status__c);
if(tk.Opportunity_Status__c=='Site Visit Scheduled' || tk.Opportunity_Status__c=='Site Visit Rescheduled' ){
op.Date_of_Site_Visit__c=tk.Date_of_Site_Visit__c; //system.NOW();
}

op.Opportunity_Status__c=tk.Opportunity_Status__c;
op.Last_interaction_Date__c=tk.LastModifiedDate+90;
op.id=tk.WhatId ;                    

opList.add(op);

}
}
if(opList.size()>0){
update opList;
}
}*/
    @future
    Public static void updateResidentialLead(Set<id> tskId){
        list<Lead> ldList = new list<Lead>();
        list<opportunity> opList = new list<opportunity>();
        list<Site_Visit__c> svList = new list<Site_Visit__c>();
        Id taskLeadRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Lead').getRecordTypeId();    
        Id taskOptyRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Opportunity').getRecordTypeId();
        Id taskFrontDeskRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Front Desk Residential Lead').getRecordTypeId();    
        Id taskFrontDeskRTopp = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Front Desk Residential Opp').getRecordTypeId();
        
        system.debug('&&&');
        Id LeadId =[select WhoId from Task where id=:tskid LIMIT 1].id;
        system.debug('@@@@:'+LeadId);
        //Id LeadOwnerId = [select ownerid from task where whoid=:LeadId order by lastmodifieddate desc limit 1].id;
        system.debug('####test 1');
        //Lead Map
        Map<id, Lead> ldComMap = new Map<id, Lead>([SELECT Id,Category__c,Rating__c,Enquiry_Description_Other_Comment__c,
                                                    Enquiry_Description__c,Internal_Comments__c,Last_interaction_Date__c,
                                                    Lead_Stage__c,Description,Status FROM Lead where id=:LeadId]);
        //Id PMTUser=[select id from user where name='PMT 1'].id;
        
        List<Task> originalPmtUsr = new List<Task>([SELECT ownerid FROM Task WHERE WhoId = :LeadId order by lastmodifieddate desc]);
        Id PmtQueId = [SELECT Id, DeveloperName, Name, Type FROM Group where type='Queue' and Name='PMT Team'].id;
        MAP<Id,GroupMember > userID = New MAP<id,GroupMember >([select UserOrGroupId,GroupId from GroupMember where GroupId =:PmtQueId ]);
        //for(List<Task> uid : originalPmtUsr){
        //if(userID.containkey(uid.ownerid )){
        //   Id QriginalPMTUsr = uid.ownerid;
        // }
        
        // }
        
        //Task List
        /*v1.1*/system.debug('####tskid:'+tskid);
        
        List<Task> tsklst = new List<Task>([SELECT Lost_Reason__c,ActivityDate,Date_of_Site_Visit__c,Category__c,
                                            Completion_by_Date__c,RecordTypeId,CreatedDate,Description_Other_Comments__c,
                                            Description__c,Id,IsClosed,LastModifiedDate,Priority,Stage__c,Status,
                                            Subject,WhoId,whatid,Description,Opportunity_Stage__c,Opportunity_Status__c,
                                            Lead_Status__c,OwnerId,Site_Visit__c,Site_Visit__r.Sales_Manager_s_Feedback__c,
                                            Site_Visit__r.Rating__c,Site_Visit__r.Description__c,Site_Visit__r.Sales_Manager_s_Other_Feedback__c	
                                            ,Site_Visit__r.Opportunity_Stage__c,Site_Visit__r.Opportunity_Status__c
                                            FROM Task 
                                            WHERE id=:tskid]);
        for(Task tk : tsklst){
            //if(ldComMap.containsKey(tk.WhoId) ){
            if((tk.RecordTypeId ==taskLeadRecordTypeId || tk.RecordTypeId == taskFrontDeskRT) && tk.Status == 'Completed'){
                
                
                
                Lead lda = new Lead(id=tk.WhoId);                  
                lda.Rating__c = tk.Category__c;                    
                lda.Internal_Comments__c = tk.Description;
                lda.Enquiry_Description__c =tk.Description__c;
                lda.Enquiry_Description_Other_Comment__c = tk.Description_Other_Comments__c; 
                lda.Last_interaction_Date__c = tk.LastModifiedDate+90;
                lda.id = tk.WhoId ;
                lda.Lead_Stage__c = tk.Stage__c;
                //if(tk.Stage__c=='Push Back to PMT'){
                //lda.Original_PMT_Owner__c=PMTUser;
                //}
                //lda.OwnerId=tk.OwnerId;
                if(tk.Stage__c=='Site Visit Scheduled' || tk.Stage__c=='Site Visit Rescheduled' ){
                    system.debug('test task'+tk.Stage__c);
                    lda.Date_of_Site_Visit__c =tk.Date_of_Site_Visit__c; //system.NOW();
                }
                //lda.ownerid=LeadOwnerId;
                lda.Description = tk.Description;
                lda.Status =tk.Lead_Status__c ;
                
                ldList.add(lda);
                //}
            }  
            else if((tk.RecordTypeId ==taskOptyRecordTypeId || tk.RecordTypeId ==taskFrontDeskRTopp ) && tk.Status == 'Completed'){
                Opportunity op = new Opportunity(id=tk.WhatId);
                op.Rating__c=tk.Category__c;
                op.Description_Other_Comments__c=tk.Description_Other_Comments__c;
                op.Description__c=tk.Description__c;
                op.Internal_Comments__c=tk.Description;
                op.StageName=tk.Opportunity_Stage__c;
                if(tk.Opportunity_Status__c=='Site Visit Scheduled' || tk.Opportunity_Status__c=='Site Visit Rescheduled' ){
                    op.Date_of_Site_Visit__c=tk.Date_of_Site_Visit__c; //system.NOW();
                }//Changes Added By Vaidehi
                if(tk.Opportunity_Status__c == 'Others' && tk.Opportunity_Stage__c == 'Lost'){
                    op.Lost_Reason__c = tk.Lost_Reason__c;
                } //Changes Finished                   
                op.Opportunity_Status__c=tk.Opportunity_Status__c;
                op.Last_interaction_Date__c=tk.LastModifiedDate+90;
                op.id=tk.WhatId ;                    
                
                opList.add(op);
                
            }
            if( (tk.RecordTypeId ==taskLeadRecordTypeId || 
                 tk.RecordTypeId == taskFrontDeskRT || 
                 tk.RecordTypeId ==taskOptyRecordTypeId || tk.RecordTypeId ==taskFrontDeskRTopp) && 
               tk.Site_Visit__c!=null && tk.Status != 'Completed') 
            {
                Site_Visit__c sv= new Site_Visit__c();
                sv.id = tk.Site_Visit__c;
                sv.OwnerId = tk.OwnerId;
                svList.add(sv);
            }
            else if( (tk.RecordTypeId ==taskLeadRecordTypeId || 
                      tk.RecordTypeId == taskFrontDeskRT || 
                      tk.RecordTypeId ==taskOptyRecordTypeId || 
                      tk.RecordTypeId ==taskFrontDeskRTopp
                     ) && 
                    tk.Site_Visit__c!=null && 
                    tk.Status == 'Completed' 
                   ) 
            {
                Site_Visit__c sv= new Site_Visit__c();
                sv.id = tk.Site_Visit__c;
                sv.OwnerId = tk.OwnerId;
                if(String.isNotBlank(tk.Category__c) && String.isBlank(tk.Site_Visit__r.Rating__c))
                    sv.Rating__c = tk.Category__c;   
                if(String.isNotBlank(tk.Description)  && String.isBlank(tk.Site_Visit__r.Sales_Manager_s_Feedback__c))
                {    
                    Opportunity opp = [SELECT id,Owner.Email 
                                       FROM Opportunity 
                                       where id =:tk.whatid  
                                      ];
                    sv.Sales_Manager_s_Feedback__c = tk.Description;
                    sv.Opportunity_Stage__c = tk.Opportunity_Stage__c;
                    sv.Opportunity_Status__c = tk.Opportunity_Status__c;
                    sv.Opportunity_Owner_Email__c =opp.Owner.Email;
                }
                if(String.isNotBlank(tk.Description__c)  && String.isBlank(tk.Site_Visit__r.Description__c))
                    sv.Description__c = tk.Description__c;
                if(String.isNotBlank(tk.Description_Other_Comments__c)  && String.isBlank(tk.Site_Visit__r.Sales_Manager_s_Other_Feedback__c))
                    sv.Sales_Manager_s_Other_Feedback__c = tk.Description_Other_Comments__c;
                
                
                svList.add(sv);
            }
            
        }
        if(ldList.size()>0){
            update ldList;
        }
        else if(opList.size()>0){
            update opList;
        }
        if(svList.size()>0){
            update svList;
        }
    }
    
    
    ////////////
    
    
    /* 
@future
Public static void updateCommercialLead(Set<id> tskId){
list<Lead> lList = new list<Lead>();
Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Commercial').getRecordTypeId();
Id taskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Commercial Lead').getRecordTypeId();      
Map<id, Lead> ldComMap = new Map<id, Lead>([SELECT id,Concerned_Person_Name__c,Broker_IPC__c, activity_date__c,name,Industry,company,
recordtypeId FROM Lead where recordtypeId =: leadRecordTypeId ]);

for(Task tk : [Select id, WhoId,Client_Name__c,Concerned_Person_Name__c,Broker_IPC__c,Approximate_Area_Requirement__c,
Sector_Industry__c,Description,Rate__c,recordtypeId,IsReminderSet,ActivityDate from Task where id in: tskId]){
if(ldComMap.containsKey(tk.WhoId) && tk.recordtypeId == taskRecordTypeId ){
Lead lda = new Lead();
lda.FirstName = tk.Client_Name__c.Substring(0,tk.Client_Name__c.indexOf(' '));
lda.LastName = tk.Client_Name__c.Substring(tk.Client_Name__c.indexOf(' '),tk.Client_Name__c.length());               
lda.Internal_Comments__c =tk.description;
lda.Industry = tk.Sector_Industry__c;
lda.Rate__c = tk.Rate__c;

lda.id = tk.WhoId ;
lda.activity_date__c = tk.ActivityDate;
lda.Carpet_Area__c = tk.Approximate_Area_Requirement__c;
lda.Concerned_Person_Name__c =tk.Concerned_Person_Name__c;
lda.Broker_IPC__c = tk.Broker_IPC__c;
lList.add(lda);
}            
}
update lList;
}

*/
    /*  @future
Public static void copyLeadDetails(Set<id> tskId, Set<id> enqid){
Map<id,Lead> enqMap = new Map<id,Lead>(); 
List<Task> tskLst = new List<Task>();  

if(enqid != null && enqid.size()>0)
enqMap = new Map<id, Lead>([SELECT id,Concerned_Person_Name__c,Broker_IPC__c, activity_date__c,name,Industry,company,
recordtypeId FROM Lead where id in: enqid]);

if(enqid != null && enqid.size()>0){
for(Task tsk : [Select id, WhoId,ReminderDateTime,IsReminderSet,ActivityDate from Task where id in: tskId]){
if(enqMap.containsKey(tsk.WhoId)){
tsk.owner_Manager_Email__c = enqMap.get(tsk.WhoId).Owner_Manager_Email__c!=null?enqMap.get(tsk.WhoId).Owner_Manager_Email__c:'';
tsk.Owner_Manager_Name__c = enqMap.get(tsk.WhoId).Owner_Manager_Name__c!=null?enqMap.get(tsk.WhoId).Owner_Manager_Name__c:'';
tskLst.add(tsk);
}  
}   
}  
if(tskLst !=null && tskLst.size()>0)
update tskLst;
}
*/  
    
    
    @future
    Public static void updateLeadManagerDetails(Set<id> tskId, Set<id> enqid){
        Map<id,Lead> enqMap = new Map<id,Lead>(); 
        List<Task> tskLst = new List<Task>();  
        
        if(enqid != null && enqid.size()>0)
            enqMap = new Map<id, Lead>([Select id, Owner_Manager_Name__c, owner_Manager_Email__c from Lead where id in: enqid]);
        
        if(enqid != null && enqid.size()>0){
            for(Task tsk : [Select id, WhoId,ReminderDateTime,IsReminderSet,ActivityDate from Task where id in: tskId]){
                if(enqMap.containsKey(tsk.WhoId)){
                    tsk.owner_Manager_Email__c = enqMap.get(tsk.WhoId).Owner_Manager_Email__c!=null?enqMap.get(tsk.WhoId).Owner_Manager_Email__c:'';
                    tsk.Owner_Manager_Name__c = enqMap.get(tsk.WhoId).Owner_Manager_Name__c!=null?enqMap.get(tsk.WhoId).Owner_Manager_Name__c:'';
                    tskLst.add(tsk);
                }  
            }   
        }  
        if(tskLst !=null && tskLst.size()>0)
            update tskLst;
    }
    
    @future
    Public static void updateOpportunityManagerDetails(Set<id> tskId, Set<id> optid){
        Map<id,Opportunity> optMap = new Map<id,Opportunity>(); 
        List<Task> tskLst = new List<Task>();  
        
        if(optid != null && optid.size()>0)
            optMap = new Map<id, Opportunity>([Select id, Owner_Manager_Name__c, owner_Manager_Email__c from Opportunity where id in: optid]);
        
        if(optid != null && optid.size()>0){
            for(Task tsk : [Select id, WhatId,ReminderDateTime,IsReminderSet,ActivityDate from Task where id in: tskId]){
                if(optMap.containsKey(tsk.WhatId)){
                    tsk.owner_Manager_Email__c = optMap.get(tsk.WhatId).Owner_Manager_Email__c!=null?optMap.get(tsk.WhatId).Owner_Manager_Email__c:'';
                    tsk.Owner_Manager_Name__c = optMap.get(tsk.WhatId).Owner_Manager_Name__c!=null?optMap.get(tsk.WhatId).Owner_Manager_Name__c:'';
                    tskLst.add(tsk);
                }  
            }   
        }  
        if(tskLst !=null && tskLst.size()>0)
            update tskLst;
    }
    @future
    public static void UpdateTaskOnOpportunity(id tskids){
        id optyid=[Select whatid from task where id =:tskids].whatid;
        List<task> tsklst = new List<task>();
        try{
            for(opportunity op: [select id,Opportunity_Status__c, Project__r.Front_Desk_User__c,Date_of_Site_Visit__c 
                                 from opportunity where id = :optyid ]){
                                     Task tsk = new Task(id=tskids);
                                     tsk.OwnerId=op.Project__r.Front_Desk_User__c;
                                     tsk.Date_of_Site_Visit__c=op.Date_of_Site_Visit__c;
                                     //tsk.Stage__c=op.Opportunity_Status__c;
                                     tsklst.add(tsk);
                                 }
            update tsklst;
        }
        catch(exception e){
            system.debug(e.getMessage());
        }
    }
    //Auto Complete Task on Opportunity
    public static void autoCompleteTaskOnOpportunity(List<Task> taskList, map<id,Task> oldtaskMap){
        List<Task> lstTask = new List<Task>();
        Set<Task> stTask = new Set<Task>();
        for(Task tsk : taskList){
            String s1 = String.valueof(tsk.WhatId);
            System.debug('RecordTypeName'+Label.Task_Lead_RecordType);
            if(!String.isBlank(s1) && s1.startsWith('006') && tsk.RecordTypeid == Label.Task_Lead_RecordType){
                tsk.Status = 'Completed';}
        }   
    }
    
    
    
}