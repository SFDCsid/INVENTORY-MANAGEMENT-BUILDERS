//-------------------------------------------//
//  Project: Raunak Developers
//  Created By: Exceller Consultancy
//  Created Date: 17-11-2022
//-------------------------------------------//
public class DigitalLeadHandlerServices {
    public static void fbLeadProcess(Set<Id> dLeadId) {
        String mobile = '';
        List<Opportunity_c__c> lstOpportunity = new List<Opportunity_c__c>();
        List<Digital_Lead__c> dLeadList = [Select Id, Name, Lead_Id__c, Full_Name__c, Form_Id__c, Mobile__c, Email__c, Ad_Id__c, Ad_Name__c,
                                             Configuration__c, Adset_Id__c, Adset_Name__c, Platform__c, Campaign_Id__c, Campaign_Name__c,
                                             Retailer_Item_Id__c, Executed__c, Result__c, Lead_c__c, Account__c, Opportunity_c__c
                                             from Digital_Lead__c
                                             where Id IN: dLeadId];
        system.debug('dLeadList: '+dLeadList);
        
        if(!dLeadList.isEmpty() && dLeadList.size() == 1) {
            List<Lead_c__c> leadList = new List<Lead_c__c>();
            List<Digital_Lead__c> updateDigitalLeadList = new List<Digital_Lead__c>();
            
            mobile = dLeadList[0].Mobile__c;
            system.debug('Before substring:: '+mobile);
            if(mobile.length() > 10) {
                mobile = mobile.substring(mobile.length() - 10);
            }
            system.debug('After substring:: '+mobile);
            
            String details = 'Full Name: '+dLeadList[0].Full_Name__c+ '\n';
                           /*  +'Mobile No: '+dLeadList[0].Mobile__c+ '\n'
                             +'Email Id: '+dLeadList[0].Email__c+ '\n'
                             +'Form Id: '+dLeadList[0].Form_Id__c+ '\n'
                             +'Configuration: '+dLeadList[0].Configuration__c+ '\n'
                             +'Ad Id: '+dLeadList[0].Ad_Id__c+ '\n'
                             +'Ad Name: '+dLeadList[0].Ad_Name__c+ '\n'
                             +'Adset Id: '+dLeadList[0].Adset_Id__c+ '\n'
                             +'Adset Name: '+dLeadList[0].Adset_Name__c+ ''; */
                             
            String cMasterSource;
            String cSource ;
            String cSubSource;
            String campaignError;
            String campaignErrorSubject;
            String campaignCodeTagged;
            String projectId;
            String campaignID;
            string csubSourceDetails;
            
            if(dLeadList[0].Form_Id__c != Null && !String.isEmpty(dLeadList[0].Form_Id__c)) {
                String formId = dLeadList[0].Form_Id__c;
                List<Campaign__c> cList = [Select Id,Name,Master_Source__c,Lead_Source__c,Lead_Sub_Source__c,Lead_Sub_Source_Details__c,SRD_Code__c,Project__c 
                                            from Campaign__c 
                                            WHERE SRD_Code__c =: dLeadList[0].Form_Id__c 
                                            and Active_Campaign__c =: true];
                system.debug('cList: '+cList);
                 
                System.debug('Clist::' +cList);
                if(cList != null && clist.size() == 1) {
                    projectId=cList[0].Project__c;
                    cMasterSource=cList[0].Master_Source__c;
                    cSource = cList[0].Lead_Source__c;
                    cSubSource = cList[0].Lead_Sub_Source__c;
                    csubSourceDetails = cList[0].Lead_Sub_Source_Details__c;
                    campaignID = cList[0].Id;
                    campaignCodeTagged = cList[0].SRD_Code__c;
                } else {
                    cMasterSource = '';
                    cSource = '';
                    cSubsource = '';
                    csubSourceDetails = '';
                    campaignError = 'Invalid Campaign Code: '+ dLeadList[0].Form_Id__c;
                    campaignErrorSubject = 'Invalid Campaign Code On Received(Digital)';
                }
            }
            Lead_c__c l = new Lead_c__c(
                Last_Name__c = dLeadList[0].Full_Name__c,
                Mobile__c = mobile,
                Email__c = dLeadList[0].Email__c,
                Configuration_Required__c = dLeadList[0].Configuration__c,
                Lead_Created_From__c = 'Facebook',
                Project_Name__c = projectId,
                Campaign_Code__c = dLeadList[0].Form_Id__c,
                Campaign_Custom__c = campaignId,
                Description__c = details,
                Adset_Id__c = dLeadList[0].Adset_Id__c,
                Adset_Name__c = dLeadList[0].Adset_Name__c,
                Ad_Name__c = dLeadList[0].Ad_Name__c,
                Is_Round_Robin_Apply__c = true,
                Master_Source_Category__c = cMasterSource,
                Lead_Source__c = cSource,
                Lead_Sub_Source__c = cSubSource,
                Sub_Source_Details__c = csubSourceDetails
			
            );
            
            if(l != Null) {
                
                leadList.Add(l);
                System.debug('leadList: '+leadList);
                
               
                try {
                    CustomDuplicationHandlerServices dcl = new CustomDuplicationHandlerServices();
                    List<CustomDuplicationHandlerServices.duplicateWrapper> dupeWrapperList = new List<CustomDuplicationHandlerServices.duplicateWrapper>();
                    dupeWrapperList = dcl.masterduplicateCalling(leadList);
                     
                    if (dupeWrapperList.isEmpty()) {
                        try {
                            insert leadList;
                            List<Task> taskList = new List<Task>();
                             System.debug('leadList: '+leadList[0].id);
                            for(Lead_c__c newLead: leadList) {
                                task t = new task();
                                t.status = 'Completed';
                                t.RecordTypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Enquiry').getRecordTypeId();
                                t.Subject = 'New Enquiry From Facebook:';
                                t.WhatId = leadList[0].Id;
                                
                                if(String.isNotBlank(leadList[0].Last_Name__c))
                                    t.Name__c = leadList[0].Last_Name__c;
                                if (String.isNotBlank(leadList[0].Mobile__c))
                                    t.Mobile__c = leadList[0].Mobile__c;
                                if (String.isNotBlank(leadList[0].Email__c))
                                    t.Email__c = leadList[0].Email__c;
                                if (String.isNotBlank(leadList[0].Campaign_Code__c))
                                    t.Campaign_Code__c = leadList[0].Campaign_Code__c;
                                if (String.isNotBlank(leadList[0].Campaign_Custom__c))
                                    t.Campaign_Custom__c = leadList[0].Campaign_Custom__c;
                                if (String.isNotBlank(leadList[0].Project_Name__c))
                                    t.Project__c = leadList[0].Project_Name__c;
                                if (String.isNotBlank(leadList[0].Description__c))
                                    t.Description = leadList[0].Description__c;
                                if(String.isNotBlank(newLead.Lead_Created_From__c))
                                    t.Task_Created_From__c = newLead.Lead_Created_From__c;
                                t.Is_New_Lead_Created__c = true;
                                taskList.add(t);
                            }
                            insert taskList;
                            List<Lead_c__c> lList = [select id, name, ownerId from Lead_c__c where id =: taskList[0].WhatId];
                            if(!lList.isEmpty() && !taskList.isEmpty())
                            { 
                                taskList[0].OwnerId = lList[0].OwnerId;
                                update taskList;
                            }
                            
                            //Update Digital Lead
                            dLeadList[0].Executed__c = True;
                            dLeadList[0].Result__c = 'New Lead';
                           // dLeadList[0].Lead_c__c = leadList[0].Id;
                            dLeadList[0].Lead_c__c = lList[0].Id;
                            update dLeadList[0];
                            
                        } catch(Exception ex) {
                            system.debug('Error: '+ex);
                            //Update Digital Lead
                            dLeadList[0].Executed__c = True;
                            dLeadList[0].Result__c = 'Error';
                            dLeadList[0].Error__c = ex.getMessage();
                            update dLeadList[0];
                        }
                    } else {
                        try {
                            task t = new task();
                            t.status = 'Completed';
                            t.RecordTypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Enquiry').getRecordTypeId();
                            t.Subject = 'New Enquiry From Facebook:';
                            for(Lead_c__c newLead: leadList) {                        
                            if(String.isNotBlank(leadList[0].Last_Name__c))
                                t.Name__c = leadList[0].Last_Name__c;
                            if (String.isNotBlank(leadList[0].Mobile__c))
                                t.Mobile__c = leadList[0].Mobile__c;
                            if (String.isNotBlank(leadList[0].Email__c))
                                t.Email__c = leadList[0].Email__c;
                            if (String.isNotBlank(leadList[0].Campaign_Code__c))
                                t.Campaign_Code__c = leadList[0].Campaign_Code__c;
                            if (String.isNotBlank(leadList[0].Campaign_Custom__c))
                                t.Campaign_Custom__c = leadList[0].Campaign_Custom__c;
                            if (String.isNotBlank(leadList[0].Project_Name__c))
                                t.Project__c = leadList[0].Project_Name__c;
                            if (String.isNotBlank(leadList[0].Description__c))
                                t.Description = leadList[0].Description__c;
                            if(String.isNotBlank(newLead.Lead_Created_From__c))
                                t.Task_Created_From__c = newLead.Lead_Created_From__c;
                            }
                            Id recId = dupeWrapperList[0].recordId;
                        	system.debug('Lead Record ID: '+ recId);
                            Schema.SObjectType objname = recId.getSobjectType();
                            string strObjName = string.valueOf(objname);
                            system.debug('Lead Obj Name: '+ strObjName);
                            if(strObjName == 'Lead_c__c') {
                                List<Lead_c__c> exLead = [Select Id, Name,OwnerId 
                                                            from Lead_c__c 
                                                            where Id =: dupeWrapperList[0].recordId];
                                system.debug('exLead: '+exLead);
                                
                                if(!exLead.isEmpty()) {
                                    t.whatID = exLead[0].Id;
                                    t.OwnerId = exLead[0].OwnerId;
                                    dLeadList[0].Result__c = 'New Enquiry Against Lead';
                                    dLeadList[0].Lead_c__c = exLead[0].Id;
                                } else {
                                    t.whatID = dupeWrapperList[0].recordId;
                                    dLeadList[0].Result__c = 'New Enquiry Against Lead';
                                    dLeadList[0].Lead_c__c = dupeWrapperList[0].recordId;   
                                }
                            } else if(String.ValueOf(dupeWrapperList[0].recordId).startsWith('001')){
                                List<Account> exAccount = [Select id,OwnerId, PersonContactId 
                                                            from Account 
                                                            where Id =: dupeWrapperList[0].recordId];
                                system.debug('exAccount: '+exAccount);

                                system.debug('Account: '+ exAccount);
                                if(!exAccount.isEmpty())
                                {
                                    lstOpportunity = [Select Id, Name, Account_Name__c, Is_Active__c 
                                                        from Opportunity_c__c
                                                        where Is_Active__c =: true and Account_Name__c =: exAccount[0].Id and Project__c =: projectId];
                                } 
                                
                                if(!exAccount.isEmpty()) {
                                    t.whoId = exAccount[0].PersonContactId;
                                    t.OwnerId = exAccount[0].OwnerId;
                                    string opId = '';
                                    if(lstOpportunity.isEmpty())
                                    {
                                        Opportunity_c__c oppNew = new Opportunity_c__c();
                                        oppNew.Account_Name__c = exAccount[0].Id;
                                        oppNew.Last_Name__c = dLeadList[0].Full_Name__c;
                                        oppNew.Opportunity_Stage__c = 'Created';
                                        oppNew.CloseDate__c = system.today();
                                        oppNew.Campaign_Custom__c = campaignID;
                                        oppNew.Opportunity_Source__c = cSource;
                                        oppNew.Opportunity_Sub_Source__c = cSubSource;
                                        insert oppNew;
                                        
                                        opId = oppNew.Id;
                                    } 
                                    if (opId != '') {
                                        t.whatId = opId;   
                                     }
                                    dLeadList[0].Result__c = 'New Enquiry Against Account';
                                    dLeadList[0].Account__c = exAccount[0].Id;   
                                }
                            }
                            
                            insert t;
                            
                            //Update Digital Lead
                            dLeadList[0].Executed__c = True;
                            update dLeadList[0];
                        } catch(Exception ex) {
                            system.debug('Error: '+ex);
                            //Update Digital Lead
                            dLeadList[0].Executed__c = True;
                            dLeadList[0].Result__c = 'Error';
                            dLeadList[0].Error__c = ex.getMessage();
                            update dLeadList[0];
                        }
                    }
               	} catch(Exception ex) {
                   system.debug('Error: '+ex);
                  // Update Digital Lead
                  dLeadList[0].Executed__c = True;
                  dLeadList[0].Result__c = 'Error';
                  dLeadList[0].Error__c = ex.getMessage();
                  update dLeadList[0];
                }
            } 
        }
    }
}