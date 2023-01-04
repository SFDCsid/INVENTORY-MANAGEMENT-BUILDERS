@RestResource(urlMapping = '/unileads/*')
global class universalWebToLead {
	global class REST_Request {
        webservice String name;
        webservice String email;
        webservice String mobile;
        webservice String did;
        webservice String company;
        webservice string remarks;
        webservice String LeadIdentifier;
    }
   
    global class result {
        Integer returnCode;
        String message;
        Id recordId;
    }
   
    @HttpPost
    global static result doPost(REST_Request req) {
        List < Lead_c__c > leadList = new List < Lead_c__c > ();
        Map < Id, Lead_c__c > enquiryMap = new Map < Id, Lead_c__c > ();
        List<Campaign__c> cList = new List<Campaign__c>();
       
        result r = new result();
        
        
        if (String.isBlank(req.name) || String.isBlank(req.mobile)) {
            System.debug('Missing Required Parameters');
            r.returnCode = 1;
            r.message = 'Error';
            r.recordId = null;
            return r;
        } else {
            String cMasterSource;
            String cSource ;
            String cSubSource;
            String campaignError;
            String campaignErrorSubject;
            String campaignCodeTagged;
            String projectId;
            String campaignID;
            string subSourceDetails;
                
            if(req.did != null && String.isNotBlank(req.did)) {
                cList  = [Select Id,Name,Master_Source__c,Lead_Source__c,Lead_Sub_Source__c,SRD_Code__c,Project__c 
                          from Campaign__c WHERE SRD_Code__c =: req.did and Active_Campaign__c =: true];
                System.debug('Clist::' +cList);
                if(cList != null && clist.size() == 1) {
                     projectId=cList[0].Project__c;
                    cMasterSource=cList[0].Master_Source__c;
                    cSource = cList[0].Lead_Source__c;
                    cSubSource = cList[0].Lead_Sub_Source__c;
                    campaignID = cList[0].Id;
                    campaignCodeTagged = cList[0].SRD_Code__c;
                } else {
                    cMasterSource = '';
                    cSource = '';
                    cSubsource = '';
                    campaignError = 'Invalid Campaign Code: '+ req.did;
                    campaignErrorSubject = 'Invalid Campaign Code On Received(Digital)';
                }
            } else {
                campaignErrorSubject = 'Invalid Campaign Code On Received(Digital)';
            }
            Lead_c__c l = new Lead_c__c(
                Last_Name__c = req.Name,
                Mobile__c = req.mobile,
                Email__c = req.email,
                SRD_Code__c = req.did,
                Lead_Created_From__c = req.LeadIdentifier,
                Master_Source_Category__c=cMasterSource,
                //LeadSource= cSource,
                Project_Name__c= projectId,
          		Lead_Source__c = cSource,
                Lead_Sub_Source__c = cSubSource,
                Campaign_Custom__c = campaignID,
                Is_Round_Robin_Apply__c = true
            );
                            // Description = req.remarks,

            if(l != Null) {
                
                leadList.Add(l);
                System.debug('--Lead List--'+leadList);
                 
                try {
                    CustomDuplicationHandlerServices dcl = new CustomDuplicationHandlerServices();
                    List<CustomDuplicationHandlerServices.duplicateWrapper> dupeWrapperList = new List<CustomDuplicationHandlerServices.duplicateWrapper>();
                    dupeWrapperList = dcl.masterduplicateCalling(leadList);
                     
                    if (dupeWrapperList.isEmpty()) {
                        try {
                            insert leadList;
                            List<Task> taskList = new List<Task>();
                            //List<CampaignMember> listCM = new List<CampaignMember>();
                            for(Lead_c__c newLead: leadList) {
                                task t = new task();
                                t.status = 'Completed';
                                t.RecordTypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Enquiry').getRecordTypeId();
                                t.Subject = 'New Enquiry Received';
                                t.whatId = newLead.ID;
                              //  t.ownerId = newLead.OwnerId;
                                if (String.isNotBlank(newLead.Last_Name__c))
                                    t.Name__c = newLead.Last_Name__c;
                                if (String.isNotBlank(newLead.Mobile__c))
                                    t.Mobile__c = newLead.Mobile__c;
                                if (String.isNotBlank(newLead.Email__c))
                                    t.Email__c = newLead.Email__c;
                                if (String.isNotBlank(campaignCodeTagged))
                                    t.SRD_Code__c = campaignCodeTagged;
                               
                                if (String.isNotBlank(campaignID))
                                    t.Campaign_Custom__c = campaignID;
                                
                               if(String.isNotBlank(newLead.Project_Name__c))
                                   t.Project__c=newLead.Project_Name__c;
                                
                                if (String.isNotBlank(req.remarks))
                                    t.Description = req.remarks;
                                if(String.isNotBlank(req.LeadIdentifier))
                                t.Task_Created_From__c = req.LeadIdentifier;
                                t.Is_New_Lead_Created__c = true;
                                taskList.add(t);
                            }
                            insert taskList;
                            
                            List<Lead_c__c> lList = [select id,name,ownerId from lead_c__c where id =: taskList[0].whatid];
                            if(!lList.isEmpty() && !taskList.isEmpty())
                            { 
                                taskList[0].OwnerId = lList[0].OwnerId;
                             	update taskList;
                            }
                            if(!taskList.isEmpty()) {
                                r.recordId = taskList[0].Id;
                                r.returnCode = 0;
                                r.message = 'SUCCESS';
                                return r;
                            }
                         } catch(Exception ex) {
                            String msg = null;
                            msg = 'Lead Insert Failed :' + ex;                                    
                            r.returnCode = 1;
                            r.message = msg;
                            r.recordId = null;
                            return r;
                         }
                     } else {
                         Set<string> strDW = new Set<string>();
                         Set<string> setLeadId = new Set<string>();
                         Set<string> setContactId = new Set<string>();
                         //List<Lead> listLead = new List<Lead>();
                         List<Account> listAccount = new List<Account>();
                         List<task> listTask = new List<Task>();
                         List<Opportunity_c__c> lstOpportunity = new List<Opportunity_c__c>();
                         //List<CampaignMember> listCamp = new List<CampaignMember>();
                         
                         for(CustomDuplicationHandlerServices.duplicateWrapper dw : dupeWrapperList) {
                             strDW.add(dw.recordId);
                         }
                         
                         for(Id recordId : strDW) {
                             String sObjName = recordId.getSObjectType().getDescribe().getName();
                             system.debug('lead object: '+ sObjName);
                             string rec = recordId;    
                             if(sObjName == 'Lead_c__c') {
                                 setLeadId.add(recordId);
                             } else if(rec.startsWith('001')) {
                                 setContactId.add(recordId);
                             }
                         }
                         
                         List<Lead_c__c> listLead1 = [Select id, name, ownerId, last_Name__c, Mobile__c, 
                                                 Email__c,Master_Source_Category__c,Lead_Source__c,Lead_Sub_Source__c,Campaign_Custom__c,Project_Name__c
                                                 from lead_c__c where Id IN: setLeadId];
                         system.debug('Lead: '+ listLead1);
                            listAccount = [Select id, PersonContactId, isPersonAccount, ownerId 
                                        from Account 
                                        where 
                                        Id IN: setContactId];
                         system.debug('Account: '+ listAccount);
                         if(!listAccount.isEmpty())
                         {
                            lstOpportunity = [Select Id, Name, Account_Name__c, Is_Active__c from Opportunity_c__c
                                            where Is_Active__c =: true and Account_Name__c =: listAccount[0].Id];
                         } 
                         
                         if(!listLead1.isEmpty()) {
                         
                             System.debug('In Side Lead check');
                             for(Lead_c__c existingLead : listLead1) {
                                 task t = new task();
                                 t.status = 'Completed';
                                 t.RecordTypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Enquiry').getRecordTypeId();
                                 t.Subject = 'New Enquiry Received From:'+ cSource;
                                 t.whatId = existingLead.ID;
                                 t.ownerId = existingLead.OwnerId;
                                 if (String.isNotBlank(existingLead.Last_Name__c))
                                     t.Name__c = existingLead.Last_Name__c;
                                 
                                 if (String.isNotBlank(existingLead.Mobile__c))
                                     t.Mobile__c = existingLead.Mobile__c;
                                 
                                 if (String.isNotBlank(existingLead.Email__c))
                                     t.Email__c = existingLead.Email__c;
                                 
                                 if(String.isNotBlank(existingLead.Project_Name__c))
                                     t.Project__c=existingLead.Project_Name__c;
                                 
                                 if (String.isNotBlank(campaignCodeTagged))
                                     t.SRD_Code__c = campaignCodeTagged;
                                 
                                 if (String.isNotBlank(campaignID))
                                     t.Campaign_Custom__c = campaignID;
                                 
                                 if (String.isNotBlank(req.remarks))
                                     t.Description = req.remarks;
                                 if (String.isNotBlank(req.LeadIdentifier))
                                     t.Task_Created_From__c = req.LeadIdentifier; 
                                     
                                 listTask.add(t);
                                 
                             }
                             insert listTask;
                             
                             if(!listTask.isEmpty()) {
                                 r.recordId = listTask[0].Id;
                                 r.returnCode = 0;
                                 r.message = 'SUCCESS';
                                 return r;
                             }
                         }
                         
                         // If Account is present
                         if(!listAccount.isEmpty())// && !listLead.isEmpty()
                         {   
                             system.debug('In Side Account check');
                             system.debug('Lead Account:: '+listAccount);
                             string opId = ''; 
                             if(lstOpportunity.isEmpty())
                             {
                                Opportunity_c__c oppNew = new Opportunity_c__c();
                                oppNew.Account_Name__c = listAccount[0].Id;
                                oppNew.Last_Name__c = req.Name;
                                oppNew.Opportunity_Stage__c = 'Created';
                                oppNew.CloseDate__c = system.today();
                                oppNew.Campaign_Custom__c = campaignID;
                                oppNew.Opportunity_Source__c = cSource;
                                oppNew.Opportunity_Sub_Source__c = cSubSource;
                                insert oppNew;
                                 
                                /*if(cList[0].Direct_Opportunity_Count__c == Null)
                                    cList[0].Direct_Opportunity_Count__c = 0;
                                    cList[0].Direct_Opportunity_Count__c = cList[0].Direct_Opportunity_Count__c + 1;
                                update cList[0];*/
                                opId = oppNew.Id;
                             } 
                             
                             for(Account existingAcc : listAccount) {
                                 task t = new task();
                                 t.status = 'Completed';
                                 t.RecordTypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Enquiry').getRecordTypeId();
                                 t.Subject = 'New Enquiry Received From:'+ cSource;
                                 t.whoId = existingAcc.PersonContactId ;
                                 if (opId != '') {
                                    t.whatId = opId;   
                                 }
                                 
                                 t.OwnerId = existingAcc.OwnerId;
                                 if (String.isNotBlank(req.Name))
                                     t.Name__c = req.Name;
                                 if (String.isNotBlank(req.mobile))
                                     t.Mobile__c = req.mobile;
                                 if (String.isNotBlank(req.Email))
                                     t.Email__c = req.Email;
                                 if (String.isNotBlank(campaignCodeTagged))
                                     t.SRD_Code__c = campaignCodeTagged;
                                 
                                 if (String.isNotBlank(campaignID))
                                     t.Campaign_Custom__c = campaignID;
                                 
                                 if (String.isNotBlank(req.remarks))
                                     t.Description = req.remarks;
                                 if (String.isNotBlank(req.LeadIdentifier))
                                     t.Task_Created_From__c = req.LeadIdentifier;
                                     
                                 listTask.add(t);
                                 
                             }
                             insert listTask;
                             
                             if(!listTask.isEmpty()) {
                                 r.recordId = listTask[0].Id;
                                 r.returnCode = 0;
                                 r.message = 'SUCCESS';
                                 return r;
                             }
                         }
                     }
                } catch(Exception ex) {
                    system.debug('Error: '+ex.getMessage());
                    r.returnCode = 0;
                    r.message = 'Error: '+ex.getMessage();
                    return r;
                }
            }
        }  
        return r;
    }  
}