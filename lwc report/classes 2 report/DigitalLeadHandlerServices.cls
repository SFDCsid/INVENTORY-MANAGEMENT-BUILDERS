public with sharing class DigitalLeadHandlerServices {
    public static void fbLeadProcess(Set<Id> digLeadId) {
        string mobile = '';
        List<Digital_Lead__c> digLeadList = [Select Id, Name, Lead_Id__c, Full_Name__c, Form_Id__c, Mobile__c, Email__c, Ad_Id__c, Ad_Name__c,
                                             Configuration__c, Adset_Id__c, Adset_Name__c, Platform__c, Campaign_Id__c, Campaign_Name__c,
                                             Retailer_Item_Id__c, Executed__c, Result__c, Lead__c, Account__c, Opportunity__c
                                             from Digital_Lead__c
                                             where Id IN: digLeadId];
        system.debug('digLeadList: '+digLeadList);
        system.debug('digLeadList: '+digLeadList[0].Form_Id__c);
        if(!digLeadList.isEmpty() && digLeadList.size() == 1) {
            List<Lead> leadList = new List<Lead>();
            List<Digital_Lead__c> updateDigitalLeadList = new List<Digital_Lead__c>();
            
            mobile = digLeadList[0].Mobile__c;
            system.debug('Before substring:: '+mobile);
            if(mobile.length() > 10)
            {
                mobile = mobile.substring(mobile.length() - 10);
            }
            system.debug('After substring:: '+mobile);
            
            String details = 'Full Name: '+digLeadList[0].Full_Name__c+ '\n'
                             +'Mobile No: '+digLeadList[0].Mobile__c+ '\n'
                             +'Email Id: '+digLeadList[0].Email__c+ '\n'
                             +'Form Id: '+digLeadList[0].Form_Id__c+ '\n'
                             +'Configuration: '+digLeadList[0].Configuration__c+ '\n'
                             +'Ad Id: '+digLeadList[0].Ad_Id__c+ '\n'
                             +'Ad Name: '+digLeadList[0].Ad_Name__c+ '\n'
                             +'Adset Id: '+digLeadList[0].Adset_Id__c+ '\n'
                             +'Adset Name: '+digLeadList[0].Adset_Name__c+ '';
                             
            String cMasterSource;
            String cSource ;
            String cSubSource;
            String cSubSourceDetails;
            String projectId;
            String campaignID;
            String projectCluster;
            
            if(digLeadList[0].Form_Id__c != Null && !String.isEmpty(digLeadList[0].Form_Id__c)) {
                system.debug('In side campaign query:: '+digLeadList[0].Form_Id__c);
                string formId = digLeadList[0].Form_Id__c;
                List<Campaign >cList = [select Id, Name, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Master_Source__c,
                                        Project__c,Project__r.id, Project__r.Cluster__c, SRD__c from Campaign where SRD__c =: formId];
                system.debug('cList: '+cList);
                 
                if(!cList.isEmpty()) {
                    cMasterSource = cList[0].Master_Source__c;
                    cSource = cList[0].Lead_Source__c;
                    cSubSource = cList[0].Lead_Sub_Source__c;
                    cSubSourceDetails = cList[0].Lead_Sub_Source_Details__c;
                    projectId = cList[0].Project__r.id;
                    campaignID = cList[0].ID;
                    projectCluster = cList[0].Project__r.Cluster__c;
                 }
            }
            Lead l = new Lead(
                LastName = digLeadList[0].Full_Name__c,
                MobilePhone = mobile,
                Email = digLeadList[0].Email__c,
                Configuration_Required__c = digLeadList[0].Configuration__c,
                Lead_Created_From__c = digLeadList[0].Platform__c,
                Master_Source__c = cMasterSource,
                Lead_Source__c = cSource,
                Lead_Sub_Source__c = cSubSource,
                Lead_Sub_Source_Details__c = cSubSourceDetails,
                Project__c = projectId,
                Cluster__c = projectCluster,
                Campaign_Code__c = digLeadList[0].Form_Id__c,
                Campaign_Custom__c = campaignID,
                Description = details,
                Adset_Id__c = digLeadList[0].Adset_Id__c,
                Adset_Name__c = digLeadList[0].Adset_Name__c,
                Ad_Name__c = digLeadList[0].Ad_Name__c,
                Apply_Round_Robin__c = true,
                Status = 'Incoming',
                Lead_Sub_Stage__c = 'Open',
                Lead_Sub_Stage_Reason__c = 'Incoming call or lead which is not serviced'
            );
            
            if(l != Null) {
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.DuplicateRuleHeader.AllowSave = true;
                leadList.Add(l);
                System.debug('leadList: '+leadList);
                
                try {
                    Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>>();
                    duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
                    
                    for(Lead newLead: leadList) {
                        if(!duplicateWrapperMap.containsKey(l)) {
                            try {
                                Database.saveResult[] srList = Database.insert(leadList, dml);
                                for(Database.SaveResult sr: srList) {
                                    if(sr.isSuccess()) {
                                        try {
                                            task t = new task();
                                            t.Status = 'Completed';
                                            t.RecordTypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Enquiry').getRecordTypeId();
                                            t.Subject = 'New Enquiry Received From:'+ newLead.Lead_Source__c;
                                            t.whoId = sr.getId();
                                            if(String.isNotBlank(newLead.LastName))
                                                t.Name__c = newLead.LastName;
                                            if(String.isNotBlank(newLead.MobilePhone))
                                                t.Mobile__c = newLead.MobilePhone;
                                            if(String.isNotBlank(newLead.Email))
                                                t.Email__c = newLead.Email;
                                            if(l.Project__c != null)
                                                t.Project__c = newLead.Project__c;
                                            if(l.Campaign_Custom__c != null)
                                                t.Campaign__c = newLead.Campaign_Custom__c;
                                            if(String.isNotBlank(newLead.Campaign_Code__c))
                                                t.Campaign_Code__c= newLead.Campaign_Code__c;
                                            if(String.isNotBlank(newLead.URL__c))
                                                t.URL__c = newLead.URL__c;
                                            if(String.isNotBlank(newLead.UTM_Medium__c))
                                                t.UTM_Medium__c = newLead.UTM_Medium__c;
                                            if(String.isNotBlank(newLead.UTM_Source__c))
                                                t.UTM_Source__c = newLead.UTM_Source__c;
                                            if(String.isNotBlank(newLead.Description))
                                                t.Description = newLead.Description;
                                            if(String.isNotBlank(newLead.Lead_Created_From__c))
                                                t.Task_Created_From__c = newLead.Lead_Created_From__c;
                                            t.Is_New_Lead_Created__c = true;
                                            insert t;
                                            
                                            List<Lead> lList = [select Id, Name, OwnerId from Lead where Id =: t.whoId];
                                            if(!lList.isEmpty() && t != Null) { 
                                                t.OwnerId = lList[0].OwnerId;
                                                update t;
                                            }
                                            
                                            //Update Digital Lead
                                            digLeadList[0].Executed__c = True;
                                            digLeadList[0].Result__c = 'New Lead';
                                            digLeadList[0].Lead__c = leadList[0].Id;
                                            update digLeadList[0];
                                        } catch(Exception ex) {
                                            system.debug('Error: '+ex);
                                            //Update Digital Lead
                                            digLeadList[0].Executed__c = True;
                                            digLeadList[0].Result__c = 'Error';
                                            digLeadList[0].Error__c = ex.getMessage();
                                            update digLeadList[0];
                                        }
                                    } else {
                                        String msg = '';
                                        for(Database.Error err: sr.getErrors()) {
                                            msg = 'Lead Creation Failed: ' + err.getMessage();
                                        }
                                        system.debug('Error: '+msg);
                                        //Update Digital Lead
                                        digLeadList[0].Executed__c = True;
                                        digLeadList[0].Result__c = 'Error';
                                        digLeadList[0].Error__c = msg;
                                        update digLeadList[0];
                                    }
                                }
                            } catch(Exception ex) {
                                system.debug('Error: '+ex);
                                //Update Digital Lead
                                digLeadList[0].Executed__c = True;
                                digLeadList[0].Result__c = 'Error';
                                digLeadList[0].Error__c = ex.getMessage();
                                update digLeadList[0];
                            }
                        } else {
                    		DuplicationHandlerServices.duplicateWrapper dw = duplicateWrapperMap.get(newLead)[0];
                    		if(dw.objectType.equalsIgnoreCase('Lead')) {
                        		try {
                                    task t = new task();
                                    t.status = 'Completed';
                                    t.whoId = dw.dupLead.Id;
                                    t.RecordTypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Enquiry').getRecordTypeId();
                                    t.Subject = 'New Enquiry Received From:'+ leadList[0].Lead_Source__c;
                                                            
                                    if(String.isNotBlank(leadList[0].lastName))
                                        t.Name__c = leadList[0].lastName;
                                    if (String.isNotBlank(leadList[0].MobilePhone))
                                        t.Mobile__c = leadList[0].MobilePhone;
                                    if (String.isNotBlank(leadList[0].Email))
                                        t.Email__c = leadList[0].Email;
                                    if (String.isNotBlank(leadList[0].Campaign_Code__c))
                                        t.Campaign_Code__c = leadList[0].Campaign_Code__c;
                                    if (String.isNotBlank(leadList[0].Campaign_Custom__c))
                                        t.Campaign__c = leadList[0].Campaign_Custom__c;
                                    if (String.isNotBlank(leadList[0].Project__c))
                                        t.Project__c = leadList[0].Project__c;
                                    if (String.isNotBlank(leadList[0].Description))
                                        t.Description = leadList[0].Description;
                                    if (String.isNotBlank(digLeadList[0].Adset_Id__c))
                                        t.Adset_Id__c = digLeadList[0].Adset_Id__c;
                                    if (String.isNotBlank(digLeadList[0].Adset_Name__c))
                                        t.Adset_Name__c = digLeadList[0].Adset_Name__c;
                                    if (String.isNotBlank(digLeadList[0].Ad_Name__c))
                                       t.Ad_Name__c = digLeadList[0].Ad_Name__c;
                            		insert t;
                            
                                    //Update Digital Lead
                                    digLeadList[0].Executed__c = True;
                                    digLeadList[0].Result__c = 'New Enquiry Against Lead';
                                    digLeadList[0].Lead__c = dw.dupLead.Id; 
                                    update digLeadList[0];
                                } catch(Exception ex) {
                                    system.debug('Error: '+ex);
                                    //Update Digital Lead
                                    digLeadList[0].Executed__c = True;
                                    digLeadList[0].Result__c = 'Error';
                                    digLeadList[0].Error__c = ex.getMessage();
                                    update digLeadList[0];
                                }
                    		} else if(dw.objectType.equalsIgnoreCase('Opportunity')) {
                        		try {
                                    task t = new task();
                                    t.Status = 'Completed';
                                    t.RecordTypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Enquiry').getRecordTypeId();
                                    t.Subject = 'New Enquiry Received From:'+ newLead.Lead_Source__c;
                                    t.WhoId = dw.dupOpp.Account.PersonContactId;
                                    if(dw.dupOpp.Project__c == newLead.Project__c)
                                    	t.whatId = dw.dupOpp.Id;
                                    if(String.isNotBlank(newLead.LastName))
                                        t.Name__c = newLead.LastName;
                                    if(String.isNotBlank(newLead.MobilePhone))
                                        t.Mobile__c = newLead.MobilePhone;
                                    if(String.isNotBlank(newLead.Email))
                                        t.Email__c = newLead.Email;
                                    if(l.Project__c != null)
                                        t.Project__c = newLead.Project__c;
                                    if(l.Campaign_Custom__c != null)
                                        t.Campaign__c = newLead.Campaign_Custom__c;
                                    if(String.isNotBlank(newLead.Campaign_Code__c))
                                        t.Campaign_Code__c= newLead.Campaign_Code__c;
                                    if(String.isNotBlank(newLead.URL__c))
                                        t.URL__c = newLead.URL__c;
                                    if(String.isNotBlank(newLead.UTM_Medium__c))
                                        t.UTM_Medium__c = newLead.UTM_Medium__c;
                                    if(String.isNotBlank(newLead.UTM_Source__c))
                                        t.UTM_Source__c = newLead.UTM_Source__c;
                                    if(String.isNotBlank(newLead.Description))
                                        t.Description = newLead.Description;
                                    if(String.isNotBlank(newLead.Lead_Created_From__c))
                                        t.Task_Created_From__c = newLead.Lead_Created_From__c;
                                    insert t;
                                    
                                    if(dw.dupOpp.Project__c == newLead.Project__c) {
                                    	digLeadList[0].Result__c = 'New Enquiry Against Opportunity';
                                        digLeadList[0].Opportunity__c = dw.dupOpp.Id;
                                    } else {
                                        digLeadList[0].Result__c = 'New Enquiry Against Account';
                                    }
                                    digLeadList[0].Executed__c = True;
                                    digLeadList[0].Account__c = dw.dupOpp.AccountId;
                                    update digLeadList[0];
                                } catch(Exception ex) { 
                                    system.debug('Error: '+ex);
                                    //Update Digital Lead
                                    digLeadList[0].Executed__c = True;
                                    digLeadList[0].Result__c = 'Error';
                                    digLeadList[0].Error__c = ex.getMessage();
                                    update digLeadList[0];
                                }
                    		}
                		}
            		}
                } catch(Exception ex) {
                    system.debug('Error: '+ex);
                    //Update Digital Lead
                    digLeadList[0].Executed__c = True;
                    digLeadList[0].Result__c = 'Error';
                    digLeadList[0].Error__c = ex.getMessage();
                    update digLeadList[0];
                }
            } 
        }
    }
}