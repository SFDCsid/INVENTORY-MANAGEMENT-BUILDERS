@RestResource(urlMapping='/WebToLead/*')
global without sharing class WebToLead{
    @HttpPost
    global static void doPost(String salutation, String firstName, String middleName, String lastname, 
                              String email, String callerPhoneCountryCode, String callerPhoneNumber, String projectCode,
                              String residentialStatus, String yourBudget, String requirementType, DateTime siteVisitDateTime, String comments, 
                              String trackingCode, String website,String lsubSource, String source, String medium, String term, String campaign,
                              String targeting, String creativetype, String ad, String sitesource, String placement, String dimensions ){
                                  String finalReturnJson = '';
                                  String projectId = null;
                                  String siteId = null;
                                  Campaign sourceAdvertisement = null;
                                  boolean hasError = false;
                                  system.debug('@@@@@:'+projectCode);
                                  system.debug('######:'+trackingCode);
                                  if(String.isBlank(lastName) || String.isBlank(email) || (String.isBlank(projectCode) && String.isBlank(trackingCode))){
                                      WebToLeadResponse w2LResponse = new WebToLeadResponse();
                                      w2LResponse.status = 'ERROR';
                                      w2LResponse.message = 'Please specify, Last Name, Email and Project Code/Tracking Code';
                                      finalReturnJson = json.Serialize(w2LResponse);     
                                      hasError = true;            
                                  }
                                  
                                  //Facebook leadGen
                                  if(!String.isBlank(trackingCode ) && !hasError){
                                      System.debug('Hello tracking code');
                                      list <Campaign> advList = [select id,createdDate , Marketing_Channel__r.Marketing_Campaign__r.Marketing_Plan__r.Site__c, Tracking_Code__c, Project__c, Number_of_Tasks__c
                                                                 from Campaign
                                                                 where Tracking_Code__c =: trackingCode
                                                                 order by createdDate DESC
                                                                 LIMIT 1];
                                       
                                      
                                      if(advList.isEmpty()){
                                          WebToLeadResponse w2LResponse = new WebToLeadResponse();
                                          w2LResponse.status = 'ERROR';
                                          w2LResponse.message = 'Advertisement Not Found';
                                          finalReturnJson= json.Serialize(w2LResponse);
                                          hasError = true;    
                                      }   
                                      else {                            
                                          //siteId = advList[0].Marketing_Channel__r.Marketing_Campaign__r.Marketing_Plan__r.Site__c;
                                         // projectId = advList[0].Project__c;
                                          sourceAdvertisement = advList[0];
                                      }
                                  }
                                  
                                  //Web to Lead or HO Common, project code given
                                  if(!String.isBlank(projectCode) && !hasError){
                                      System.debug('Hello project code');
                                      list <Project__c> projList = [select id, Project_Code__c, Site__c
                                                                    from Project__c
                                                                    where Project_Code__c =: projectCode
                                                                    LIMIT 1];
                                      if(projList.isEmpty()){
                                          WebToLeadResponse w2LResponse = new WebToLeadResponse();
                                          w2LResponse.status = 'ERROR';
                                          w2LResponse.message = 'Project Not Found';
                                          finalReturnJson= json.Serialize(w2LResponse);
                                          hasError = true;
                                      }
                                      else {
                                          siteId = projList[0].Site__c;
                                          projectId = projList[0].Id;   
                                      }
                                  }
                                  
                                  if(!hasError) {
                                      System.debug('proj id '+projectId );
                                      System.debug('site id '+siteId);
                                      System.debug(callerPhoneCountryCode );
                                      System.debug(callerPhoneNumber);
                                      System.debug(email);
                                      system.debug('sourceAdvertisement  '+sourceAdvertisement );
                                      list <Lead> leadList = [select id, OwnerId, Status,ConvertedOpportunityId,IsConverted, Lead_Stage__c
                                                              from Lead
                                                              where Site__c =: siteId
                                                              and (Lead_Stage__c != 'Closed' and Lead_Stage__c !='Booked')
                                                              and ((Country_Code_for_Phone__c =: callerPhoneCountryCode and Phone =: callerPhoneNumber)
                                                                   or (Country_Code__c =: callerPhoneCountryCode and MobilePhone =: callerPhoneNumber)
                                                                   or (Country_Code_for_Other_Mobile_Number__c =: callerPhoneCountryCode and Other_Mobile_Number__c =: callerPhoneNumber)
                                                                   or email =: email)];
                                      //and (Lead_Stage__c != 'Closed' or Lead_Stage__c != 'Converted to Opportunity')
                                      System.debug('leadList --> '+leadList);
                                      
                                      
                                      
                                      if(leadList.isEmpty()){
                                          try {
                                              Lead l = new Lead();
                                              l.LeadSource = 'Web';
                                              l.Website = website;
                                              l.Lead_Sub_Soure__c = lsubSource;
                                              l.Salutation = salutation;
                                              l.firstName = firstName;
                                              l.middleName = middleName;
                                              l.lastname = lastName;
                                              l.Country_Code__c = callerPhoneCountryCode;
                                              l.MobilePhone = callerPhoneNumber;
                                              l.Project_Code__c = projectCode;
                                              l.Resident_Status__c = residentialStatus;
                                              l.Budget__c = yourBudget;
                                              l.Requirement__c = requirementType;
                                              l.Project__c = projectId;
                                              l.Site__c = siteId;
                                              l.Tracking_No__c = trackingCode;
                                              l.email = email;
                                              l.Date_of_Site_Visit__c = siteVisitDateTime;
                                              l.Remarks_Comments__c = comments;
                                              l.Status = 'Open';
                                              l.Lead_Stage__c = siteVisitDateTime == null ? 'Open' : 'Site Visit Scheduled from Website';
                                              //l.Lead_Stage__c = String.isBlank(siteVisitDateTime) ? 'Open' : 'Site Visit Scheduled from Website';
                                              l.Date_of_site_visit_from_Website__c = DateTime.now();
                                              l.Source__c = source;
                                              l.Medium__c = medium;
                                              l.Term__c = term;
                                              l.Campaign1__c = campaign;
                                              l.Targeting__c = targeting;
                                              l.Creative_Type__c = creativetype;
                                              l.Ad__c = ad;
                                              l.Site_Source__c = sitesource;
                                              l.Placement__c = placement;
                                              l.Dimensions__c = dimensions;
                                              System.debug('********* leadStatus during insert'+l.Lead_Stage__c);
                                              try{
                                                  insert l;
                                              }catch(Exception ex){
                                                  system.debug('^^^^'+ex.getMessage());
                                              }
                                              list <Lead> leadList1 = [Select id, OwnerId, Status, Lead_Stage__c
                                                                       from Lead
                                                                       where id =: l.Id];
                                              
                                              createTask(leadList1[0], leadList1[0].OwnerId, siteVisitDateTime, sourceAdvertisement);
                                              
                                              WebToLeadResponse w2LResponse = new WebToLeadResponse();
                                              w2LResponse.status = 'SUCCESS';
                                              w2LResponse.message = 'lead inserted';
                                              finalReturnJson= json.Serialize(w2LResponse);
                                          }
                                          catch(Exception e){
                                              WebToLeadResponse w2LResponse = new WebToLeadResponse();
                                              w2LResponse.status = 'ERROR';
                                              w2LResponse.message = ''+e.getMessage();
                                              finalReturnJson= json.Serialize(w2LResponse);
                                          }
                                      }
                                      else {
                                          try {
                                              //existing Lead
                                              Lead l = new Lead(Id=leadList[0].Id);
                                              //l.Salutation = salutation;
                                              //l.firstName = firstName;
                                              //l.middleName = middleName;
                                              //l.lastname = lastName;
                                              //l.Country_Code_for_Phone__c = callerPhoneCountryCode == null ? l.Country_Code_for_Phone__c : callerPhoneCountryCode;
                                              //l.Phone = callerPhoneNumber == null ? l.Phone : callerPhoneNumber;
                                              //l.email = email;
                                              l.Resident_Status__c = residentialStatus;
                                              l.Budget__c = yourBudget;
                                              l.Requirement__c = requirementType;
                                              l.Lead_Sub_Soure__c = lsubSource;
                                              //Added by Vaidehi
                                              //Changes started
                                              system.debug('in Method w2L'+l.Resent_SMS_Email__c);
                                              l.Resent_SMS_Email__c = true;
                                              l.Date_of_Site_Visit__c = siteVisitDateTime;
                                              l.Lead_Stage__c = siteVisitDateTime == null ? leadList[0].Lead_Stage__c : 'Site Visit Scheduled from Website';
                                              //changes finished
                                              //if(projectId!=null)
                                              //    l.Project__c = projectId;
                                              //l.Project_Code__c = projectCode;
                                              l.Tracking_No__c = trackingCode == null ? l.Tracking_No__c : trackingCode;
                                              l.Date_of_Site_Visit__c = siteVisitDateTime;
                                              l.Remarks_Comments__c = comments;
                                              l.Source__c = source;
                                              l.Medium__c = medium;
                                              l.Term__c = term;
                                              l.Campaign1__c = campaign;
                                              l.Targeting__c = targeting;
                                              l.Creative_Type__c = creativetype;
                                              l.Ad__c = ad;
                                              l.Site_Source__c = sitesource;
                                              l.Placement__c = placement;
                                              l.Dimensions__c = dimensions;
                                              update l;
                                              system.debug('Update Lead:'+l);
                  
                                              /// Opprtunity Task creation
                                              try{
                                                  if(leadList[0].IsConverted == true){
                                                  id opportunityid =[SELECT ConvertedOpportunityId FROM Lead where id=:leadList[0].id].ConvertedOpportunityId;
                                                  system.debug('opportunityid::::::::::::'+leadList[0].ConvertedOpportunityId);
                                                  if(opportunityid != null){
                                                      id frontDeskUser = [select project__r.Front_Desk_User__c FROM Lead where id=:leadList[0].id].project__r.Front_Desk_User__c;
                                                      createTaskOpty(opportunityid,frontDeskUser);
                                                  }    
                                                  }else{
                                                      createTask(leadList[0],leadList[0].OwnerId, siteVisitDateTime, sourceAdvertisement);
                                                  }
                                              }
                                              catch(Exception e){
                                                  system.debug('^^^^@:'+e.getMessage());
                                              }
                                              
                                              WebToLeadResponse w2LResponse = new WebToLeadResponse();
                                              w2LResponse.status = 'SUCCESS';
                                              w2LResponse.message = 'lead updated';
                                              finalReturnJson= json.Serialize(w2LResponse);
                                          }
                                          catch(Exception e){
                                              WebToLeadResponse w2LResponse = new WebToLeadResponse();
                                              w2LResponse.status = 'ERROR';
                                              w2LResponse.message = ''+e.getMessage();
                                              finalReturnJson= json.Serialize(w2LResponse);
                                          }
                                      }
                                  }
                                  
                                  RestContext.response.addHeader('Content-Type', 'application/json');
                                  RestContext.response.responseBody = Blob.valueOf(finalReturnJson);
                              }
    public static void createTaskOpty(id opportunityid, Id ownerId){
        Task t = new Task();
        //t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Opportunity').getRecordTypeId();     
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Front Desk Residential Opp').getRecordTypeId();     
        t.Ownerid = ownerId;
        t.Priority = 'Normal';
        t.Status = 'Not Started';
        //t.WhoId = opportunityid;
        t.ActivityDate = Date.Today().addDays(1);
        t.Completion_By_Date__c = DateTime.now().addDays(1);
        //t.Opportunity_Stage__c = 'Follow-up';
        //t.Opportunity_Status__c ='Assigned to Front Desk';
        t.subject='New enquiry from Web';
        t.WhatId=opportunityid;
        insert t;
    }
    
    public static void createTask(Lead l, Id ownerId, Datetime siteVisitDateTime, Campaign sourceAdvertisement){
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
            t.Date_of_Site_Visit__c=siteVisitDateTime;
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
            if(siteVisitDateTime!=null){
                t.Subject='Site visit requested from web';
            }
            else {
                t.Subject='New enquiry from Web';
            }
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