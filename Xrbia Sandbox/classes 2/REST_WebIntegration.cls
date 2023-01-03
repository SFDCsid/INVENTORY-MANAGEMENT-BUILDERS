//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 10-10-2022
//-------------------------------------------//
@RestResource(urlMapping='/CreateLead/*')
global class REST_WebIntegration {
    @HttpPost
    global static REST_Result createLead(REST_Request req) {
        REST_Result r = new REST_Result();
        List<Lead__c> leadList = new List<Lead__c>();
        List<Campaign__c> cList = new List<Campaign__c>();
        
        if(String.isBlank(req.Name) || String.isBlank(req.mobile) || String.isBlank(req.LeadIdentifier)) {
            r.returnCode = 1;
            r.message = 'Please Provide Required Details.';
            return r;
        } else {
            Lead__c l = new Lead__c();
            l.Last_Name__c = req.name;
            l.MobilePhone__c = req.mobile;
            l.Email__c = req.email;
            l.URL__c = req.url;
            l.Description__c = req.remarks;
            l.UTM_Source__c = req.UTM_Source;
            l.UTM_Medium__c = req.UTM_Medium; 
            l.Lead_Created_From__c = req.LeadIdentifier;
            l.Campaign_Code__c = req.campaignCode;
            l.Apply_round_robin__c = true;
            system.debug('req.campaignCode: '+req.campaignCode);
            
            if(req.campaignCode != null && req.campaignCode != '') {
                cList = [Select Id, Campaign_Code__c, Campaign_Type__c, Project__c, Media__c from Campaign__c
                         where Campaign_Code__c =: req.campaignCode AND Active__c = true];
                system.debug('cList: '+cList);
                
                if(!cList.isEmpty() && cList != null) {
                    l.Campaign_Custom__c = cList[0].Id;
                    l.Campaign_Type__c = cList[0].Campaign_Type__c;
                    l.Project__c = cList[0].Project__c;
                    l.Media__c = cList[0].Media__c;
                }
            }
            
            if(l != Null) {
                leadList.add(l);
                
                try {
                    Map<Lead__c, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead__c, List<DuplicationHandlerServices.duplicateWrapper>>();
                    duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
                    
                    for(Lead__c newLead: leadList) {
                        if(!duplicateWrapperMap.containsKey(l)) {
                            try {
                                Database.saveResult[] srList = Database.insert(leadList);
                                for(Database.SaveResult sr: srList) {
                                    if(sr.isSuccess()) {
                                        try {
                                            task t = new task();
                                            t.Status = 'Completed';
                                            t.RecordTypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Enquiry').getRecordTypeId();
                                            t.Subject = 'New Enquiry Received From: '+ req.LeadIdentifier;
                                            t.whatId = sr.getId();
                                            
                                            if(String.isNotBlank(newLead.Name))
                                                t.Name__c = newLead.Name;
                                            if(String.isNotBlank(newLead.MobilePhone__c))
                                                t.Mobile__c = newLead.MobilePhone__c;
                                            if(String.isNotBlank(newLead.Email__c))
                                                t.Email__c = newLead.Email__c;
                                            if(l.Project__c != null)
                                                t.Project__c = newLead.Project__c;
                                            if(l.Campaign_Custom__c != null)
                                                t.Campaign__c = newLead.Campaign_Custom__c;
                                            if(String.isNotBlank(newLead.Campaign_Code__c))
                                                t.Campaign_Code__c = newLead.Campaign_Code__c;
                                            if(String.isNotBlank(newLead.Campaign_Type__c))
                                                t.Campaign_Type__c = newLead.Campaign_Type__c;
                                            if(String.isNotBlank(newLead.Media__c))
                                                t.Media__c = newLead.Media__c;
                                            if(String.isNotBlank(newLead.URL__c))
                                                t.URL__c = newLead.URL__c;
                                            if(String.isNotBlank(newLead.UTM_Medium__c))
                                                t.UTM_Medium__c = newLead.UTM_Medium__c;
                                            if(String.isNotBlank(newLead.UTM_Source__c))
                                                t.UTM_Source__c = newLead.UTM_Source__c;
                                            if(String.isNotBlank(newLead.Description__c))
                                                t.Description = newLead.Description__c;
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
                                    t.Subject = 'New Enquiry Received From:'+ req.LeadIdentifier;
                                    t.whatId = dw.dupLead.Id;
                                    
                                    if(String.isNotBlank(newLead.Name))
                                        t.Name__c = newLead.Name;
                                    if(String.isNotBlank(newLead.MobilePhone__c))
                                        t.Mobile__c = newLead.MobilePhone__c;
                                    if(String.isNotBlank(newLead.Email__c))
                                        t.Email__c = newLead.Email__c;
                                    if(l.Project__c != null)
                                        t.Project__c = newLead.Project__c;
                                    if(l.Campaign_Custom__c != null)
                                        t.Campaign__c = newLead.Campaign_Custom__c;
                                    if(String.isNotBlank(newLead.Campaign_Code__c))
                                        t.Campaign_Code__c= newLead.Campaign_Code__c;
                                    if(String.isNotBlank(newLead.Campaign_Type__c))
                                        t.Campaign_Type__c = newLead.Campaign_Type__c;
                                    if(String.isNotBlank(newLead.Media__c))
                                        t.Media__c = newLead.Media__c;
                                    if(String.isNotBlank(newLead.URL__c))
                                        t.URL__c = newLead.URL__c;
                                    if(String.isNotBlank(newLead.UTM_Medium__c))
                                        t.UTM_Medium__c = newLead.UTM_Medium__c;
                                    if(String.isNotBlank(newLead.UTM_Source__c))
                                        t.UTM_Source__c = newLead.UTM_Source__c;
                                    if(String.isNotBlank(newLead.Description__c))
                                        t.Description = newLead.Description__c;
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
                                    t.Subject = 'New Enquiry Received From:'+ req.LeadIdentifier;
                                    t.WhoId = dw.dupOpp.AccountId__r.PersonContactId;
                                    t.whatId = dw.dupOpp.Id;
                                    
                                    if(String.isNotBlank(newLead.Name))
                                        t.Name__c = newLead.Name;
                                    if(String.isNotBlank(newLead.MobilePhone__c))
                                        t.Mobile__c = newLead.MobilePhone__c;
                                    if(String.isNotBlank(newLead.Email__c))
                                        t.Email__c = newLead.Email__c;
                                    if(l.Project__c != null)
                                        t.Project__c = newLead.Project__c;
                                    if(l.Campaign_Custom__c != null)
                                        t.Campaign__c = newLead.Campaign_Custom__c;
                                    if(String.isNotBlank(newLead.Campaign_Code__c))
                                        t.Campaign_Code__c= newLead.Campaign_Code__c;
                                    if(String.isNotBlank(newLead.Campaign_Type__c))
                                        t.Campaign_Type__c = newLead.Campaign_Type__c;
                                    if(String.isNotBlank(newLead.Media__c))
                                        t.Media__c = newLead.Media__c;
                                    if(String.isNotBlank(newLead.URL__c))
                                        t.URL__c = newLead.URL__c;
                                    if(String.isNotBlank(newLead.UTM_Medium__c))
                                        t.UTM_Medium__c = newLead.UTM_Medium__c;
                                    if(String.isNotBlank(newLead.UTM_Source__c))
                                        t.UTM_Source__c = newLead.UTM_Source__c;
                                    if(String.isNotBlank(newLead.Description__c))
                                        t.Description = newLead.Description__c;
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