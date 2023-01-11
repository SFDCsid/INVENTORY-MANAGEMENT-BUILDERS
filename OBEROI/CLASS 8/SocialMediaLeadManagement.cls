public class SocialMediaLeadManagement {
    
    public static void CreateLead(Set <ID> smlId){
        String finalReturnJson = '';
        String projectId = null;
        String siteId = null;
        String PhoneCountryCode = null;
        String PhoneNumber = null;
        Campaign sourceAdvertisement = null;
        String Email = null;
        boolean hasError = false;
        
        list <Social_Media_Lead__c> SML= [select id,Name,SF_Advertisement_ID__c,Phone__c,Tracking_Code__c,Email__c from Social_Media_Lead__c where Id In: smlId];
        if(SML.Size()>0){
            list <Campaign> advList = [select id,createdDate , Marketing_Channel__r.Marketing_Campaign__r.Marketing_Plan__r.Site__c,
            Tracking_Code__c, Project__c,Project__r.Site__c, Number_of_Tasks__c from Campaign where Tracking_Code__c =: sml[0].Tracking_Code__c];
            PhoneNumber = SML[0].Phone__c;
            Email = SML[0].Email__c;
            if(advList.Size()>0){
                sourceAdvertisement = advList[0];
                projectId = advList[0].Project__c;
                siteId = advList[0].Project__r.Site__c;
            }else{
                hasError = True;
            }
            
            if(!hasError){
                System.debug('proj id '+projectId );
                System.debug('site id '+siteId);
                System.debug(PhoneNumber);
                System.debug(email); 
                system.debug('sourceAdvertisement  '+sourceAdvertisement );
                list <Lead> leadList = [select id, OwnerId, Status, Lead_Stage__c from Lead
                                      where Site__c =: siteId
                                      and (Lead_Stage__c != 'Closed' and Lead_Stage__c !='Booked')
                                      and ((Country_Code_for_Phone__c =: PhoneCountryCode and Phone =: PhoneNumber)
                                           or (Country_Code__c =: PhoneCountryCode and MobilePhone =: PhoneNumber)
                                           or (Country_Code_for_Other_Mobile_Number__c =: PhoneCountryCode and Other_Mobile_Number__c =: PhoneNumber)
                                           or email =: email)];
                if(leadList.isEmpty()){
                    Lead l = new Lead();
                    l.LeadSource = 'DIgital';
                    //l.Website = website;
                    //l.Salutation = salutation;
                    //l.firstName = firstName;
                    //l.middleName = middleName;
                    l.lastname = SML[0].Name;
                    l.Country_Code__c = PhoneCountryCode;
                    l.MobilePhone = PhoneNumber;
                    l.Project__c = projectId;
                    l.Site__c = siteId;
                    //l.Tracking_No__c = trackingCode;
                    l.email = email;
                    //l.Remarks_Comments__c = comments;
                    l.Status = 'Open';
                    l.Lead_Stage__c = 'Open';
                    System.debug('********* leadStatus during insert'+l.Lead_Stage__c);
                    try{
                      insert l;
                      list <Lead> leadList1 = [Select id, OwnerId, Status, Lead_Stage__c from Lead where id =: l.Id];
                      createTask(leadList1[0], leadList1[0].OwnerId,  sourceAdvertisement);
                    }catch(Exception ex){
                      system.debug('^^^^'+ex.getMessage());
                    }
                }
                else{
                    createTask(leadList[0], leadList[0].OwnerId, sourceAdvertisement);
                    /// Opprtunity Task creation
                    try{
                        id opportunityid =[SELECT ConvertedOpportunityId FROM Lead where id=:leadList[0].id].ConvertedOpportunityId;
                        id frontDeskUser = [select project__r.Front_Desk_User__c FROM Lead where id=:leadList[0].id].project__r.Front_Desk_User__c;
                        createTaskOpty(opportunityid,frontDeskUser);
                    }
                    catch(Exception e){
                        system.debug('^^^^@:'+e.getMessage());
                    }
                }
            }
        }    
    }
    public static void createTaskOpty(id opportunityid, Id ownerId){
        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Opportunity').getRecordTypeId();     
        t.Ownerid = ownerId;
        t.Priority = 'Normal';
        t.Status = 'Not Started';
        t.ActivityDate = Date.Today().addDays(1);
        t.Completion_By_Date__c = DateTime.now().addDays(1);
        t.subject='New enquiry from LinkedIn';
        t.WhatId=opportunityid;
        insert t;
    }
    public static void createTask(Lead l, Id ownerId, Campaign sourceAdvertisement){
        if(ownerId.getSObjectType().getDescribe().getName().equalsIgnoreCase('Group')){
            Lead leadObj = new lead(Id=l.Id);
            leadObj.Deferred_Task_for_Site_Visit__c = true;
            leadObj.Deffered_Task_Campaign__c = sourceAdvertisement == null ? null : sourceAdvertisement.Id;
            leadObj.Deferred_Task_Completion_By__c = DateTime.now().addDays(1);
            update leadObj;
        }
        else {
            Task t = new Task();
            t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Lead').getRecordTypeId();     
            t.Ownerid = ownerId;
            t.Priority = 'Normal';
            t.Status = 'Not Started';
            t.WhoId = l.Id;
            //t.Date_of_Site_Visit__c=siteVisitDateTime;
            t.ActivityDate = Date.Today().addDays(1);
            t.Completion_By_Date__c = DateTime.now().addDays(1);
            if(l.Lead_Stage__c!='Converted to Opportunity'){
                t.Stage__c = l.Lead_Stage__c;
                t.Lead_Status__c = l.Status;
            }
            else{
                t.Lead_Status__c = 'Follow-up';
                t.Stage__c ='Assign to Front Desk';
            }
            
            
            System.debug('t.Stage__c '+t.Stage__c+'**');
            System.debug('t.Lead_Status__c'+t.Lead_Status__c+'**');
            t.Subject='New enquiry from LinkedIn';
            
            insert t;
            System.debug('my source adv: '+sourceAdvertisement );
            if(sourceAdvertisement != null){
                if(sourceAdvertisement.Number_of_Tasks__c == null)
                    sourceAdvertisement.Number_of_Tasks__c = 0;
                sourceAdvertisement.Number_of_Tasks__c += 1;
                
                update sourceAdvertisement;
                CampaignMember cm = new CampaignMember();
                cm.CampaignId = sourceAdvertisement.Id;
                cm.Status ='Sent';
                cm.LeadId= l.id;
                database.insert(cm, false);
                
            } 
        }   
    }
}