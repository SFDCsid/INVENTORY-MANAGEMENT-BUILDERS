@RestResource(urlMapping='/CreateLead/*')
global class REST_WebIntegration {
    @HttpPost
    global static REST_Result createLead(REST_Request req) {
        REST_Result r = new REST_Result();
        List<Lead> leadList = new List<Lead>();
        List<Campaign> cList = new List<Campaign>();
        
        if(String.isBlank(req.Name) || String.isBlank(req.mobile) || String.isBlank(req.LeadIdentifier)) {
            r.returnCode = 1;
            r.message = 'Please Provide Required Details.';
            return r;
        } else {
            Lead l = new Lead();
            l.LastName = req.name;
            l.MobilePhone = req.mobile;
            l.Email = req.email;
            l.URL__c = req.url;
            l.Description = req.remarks;
            l.UTM_Source__c = req.UTM_Source;
            l.UTM_Medium__c = req.UTM_Medium; 
            l.Lead_Created_From__c = req.LeadIdentifier;
            l.Campaign_Code__c = req.campaignCode;
            l.Apply_round_robin__c = true;
            l.Status = 'Incoming';
            l.Lead_Sub_Stage__c = 'Open';
            l.Lead_Sub_Stage_Reason__c = 'Incoming call or lead which is not serviced';
            system.debug('req.campaignCode: '+req.campaignCode);
            
            if(req.campaignCode != null && req.campaignCode != '') {
            	cList = [Select Id, SRD__c, Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Project__c, Project__r.Cluster__c from Campaign
                         where SRD__c =: req.campaignCode AND IsActive = true];
                system.debug('cList: '+cList);
                
                if(!cList.isEmpty() && cList != null) {
                    l.Campaign_Custom__c = cList[0].Id;
                    l.Master_Source__c = cList[0].Master_Source__c;
                    l.Lead_Source__c = cList[0].Lead_Source__c;
                    l.Lead_Sub_Source__c = cList[0].Lead_Sub_Source__c;
                    l.Lead_Sub_Source_Details__c = cList[0].Lead_Sub_Source_Details__c;
                    l.Project__c = cList[0].Project__c;
                    l.Cluster__c = cList[0].Project__r.Cluster__c;
                }
            }
            
            if(l != Null) {
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.DuplicateRuleHeader.AllowSave = true;
                leadList.add(l);
                
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
                                            
                                            r.returnCode = 0;
                                            r.message = 'Lead Created Successfully';
                                            r.recordId = sr.getId();
                                            return r;
                                        } catch(Exception ex) {
                                            system.debug('Error: '+ex.getMessage());
                                            r.returnCode = 1;
                                            r.message = 'Lead Creation Failed: '+ex.getMessage();
                                            return r;
                                        }
                                    } else {
                                        String msg = '';
                                        for(Database.Error err: sr.getErrors()) {
                                            msg = 'Lead Creation Failed: ' + err.getMessage();
                                        }
                                        system.debug('Error: '+msg);
                                        r.returnCode = 1;
                                        r.message = msg;
                                        return r;
                                    }
                                }
                            } catch(Exception ex) {
                                system.debug('Error: '+ex.getMessage());
                                r.returnCode = 1;
                                r.message = 'Lead Creation Failed: '+ex.getMessage();
                                return r;
                            }
                        } else {
                            DuplicationHandlerServices.duplicateWrapper dw = duplicateWrapperMap.get(newLead)[0];
                            if(dw.objectType.equalsIgnoreCase('Lead')) {
                                try {
                                    task t = new task();
                                    t.Status = 'Completed';
                                    t.RecordTypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Enquiry').getRecordTypeId();
                                    t.Subject = 'New Enquiry Received From:'+ newLead.Lead_Source__c;
                                    t.whoId = dw.dupLead.Id;
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
                                    
                                    r.returnCode = 0;
                                    r.message = 'Lead Created Successfully';
                                    r.recordId = dw.dupLead.Id;
                                    return r;
                                } catch(Exception ex) {
                                    system.debug('Error: '+ex.getMessage());
                                    r.returnCode = 1;
                                    r.message = 'Lead Creation Failed: '+ex.getMessage();
                                    return r;
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
                                    
                                    r.returnCode = 0;
                                    r.message = 'Lead Created Successfully';
                                    r.recordId = dw.dupOpp.Id;
                                    return r;
                                } catch(Exception ex) { 
                                    system.debug('Error: '+ex.getMessage());
                                    r.returnCode = 1;
                                    r.message = 'Lead Creation Failed: '+ex.getMessage();
                                    return r;
                                }
                            }
                        }
                    }
                } catch(Exception ex) {
                    system.debug('Error: '+ex.getMessage());
                    r.returnCode = 1;
                    r.message = 'Lead Creation Failed: '+ex.getMessage();
                    return r;
                }
            }
        }
        return r;
    }
    
    global class REST_Result {
        webservice Integer returnCode;
        webservice String message;
        webservice String recordId;
    }
    
    global class REST_Request {
        webservice String name;
        webservice String email;
        webservice String mobile;
        webservice String campaignCode;
        webservice String url;
        webservice String remarks;
        webservice String UTM_Medium;
        webservice String UTM_Source;
        webservice String LeadIdentifier;
    }
}