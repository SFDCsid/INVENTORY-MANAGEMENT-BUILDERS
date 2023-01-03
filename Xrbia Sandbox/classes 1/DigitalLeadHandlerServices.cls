//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 16-11-2022
//-------------------------------------------//
public class DigitalLeadHandlerServices {
    public static void fbLeadProcess(Set<Id> dLeadId) {
        String mobile = '';
        List<Digital_Lead__c> dLeadList = [Select Id, Name, Lead_Id__c, Full_Name__c, Form_Id__c, Mobile__c, Email__c, Ad_Id__c, Ad_Name__c,
                                             Configuration__c, Adset_Id__c, Adset_Name__c, Platform__c, Campaign_Id__c, Campaign_Name__c,
                                             Retailer_Item_Id__c, Executed__c, Result__c, Lead__c, Account__c, Opportunity__c
                                             from Digital_Lead__c
                                             where Id IN: dLeadId];
        system.debug('dLeadList: '+dLeadList);
        
        if(!dLeadList.isEmpty() && dLeadList.size() == 1) {
            List<Lead__c> leadList = new List<Lead__c>();
            List<Digital_Lead__c> updateDigitalLeadList = new List<Digital_Lead__c>();
            
            mobile = dLeadList[0].Mobile__c;
            system.debug('Before substring:: '+mobile);
            if(mobile.length() > 10) {
                mobile = mobile.substring(mobile.length() - 10);
            }
            system.debug('After substring:: '+mobile);
            
            String details = 'Full Name: '+dLeadList[0].Full_Name__c+ '\n'
                             +'Mobile No: '+dLeadList[0].Mobile__c+ '\n'
                             +'Email Id: '+dLeadList[0].Email__c+ '\n'
                             +'Form Id: '+dLeadList[0].Form_Id__c+ '\n'
                             +'Configuration: '+dLeadList[0].Configuration__c+ '\n'
                             +'Ad Id: '+dLeadList[0].Ad_Id__c+ '\n'
                             +'Ad Name: '+dLeadList[0].Ad_Name__c+ '\n'
                             +'Adset Id: '+dLeadList[0].Adset_Id__c+ '\n'
                             +'Adset Name: '+dLeadList[0].Adset_Name__c+ '';
                             
            String projectId;
            String campaignId;
            String campaignType;
            String campaignMedia;
            
            if(dLeadList[0].Form_Id__c != Null && !String.isEmpty(dLeadList[0].Form_Id__c)) {
                String formId = dLeadList[0].Form_Id__c;
                List<Campaign__c> cList = [Select Id, Campaign_Code__c, Campaign_Type__c, Project__c, Media__c from Campaign__c
                         				where Campaign_Code__c =: formId AND Active__c = true];
                system.debug('cList: '+cList);
                 
                if(!cList.isEmpty() && cList != null) {
                    campaignId = cList[0].Id;
                    campaignType = cList[0].Campaign_Type__c;
                    projectId = cList[0].Project__c;
                    campaignMedia = cList[0].Media__c;
                 }
            }
            Lead__c l = new Lead__c(
                Last_Name__c = dLeadList[0].Full_Name__c,
                MobilePhone__c = mobile,
                Email__c = dLeadList[0].Email__c,
                Configuration_Required__c = dLeadList[0].Configuration__c,
                Lead_Created_From__c = 'Facebook',
                Project__c = projectId,
                Campaign_Code__c = dLeadList[0].Form_Id__c,
                Campaign_Custom__c = campaignId,
                Campaign_Type__c = campaignType,
                Media__c = campaignMedia,
                Description__c = details,
                Adset_Id__c = dLeadList[0].Adset_Id__c,
                Adset_Name__c = dLeadList[0].Adset_Name__c,
                Ad_Name__c = dLeadList[0].Ad_Name__c,
                Apply_Round_Robin__c = true
            );
            
            if(l != Null) {
                leadList.Add(l);
                
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
                                            t.Subject = 'New Enquiry Received From:'+ newLead.Media__c;
                                            t.whatId = sr.getId();
                                            
                                            if(String.isNotBlank(newLead.Last_Name__c))
                                                t.Name__c = newLead.Last_Name__c;
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
                                            if(String.isNotBlank(newLead.Description__c))
                                                t.Description = newLead.Description__c;
                                            if(String.isNotBlank(newLead.Lead_Created_From__c))
                                                t.Task_Created_From__c = newLead.Lead_Created_From__c;
                                            t.Is_New_Lead_Created__c = true;
                                            insert t;
                                            
                                            //Update Digital Lead
                                            dLeadList[0].Executed__c = True;
                                            dLeadList[0].Result__c = 'New Lead';
                                            dLeadList[0].Lead__c = leadList[0].Id;
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
                                        String msg = '';
                                        for(Database.Error err: sr.getErrors()) {
                                            msg = 'Lead Creation Failed: ' + err.getMessage();
                                        }
                                        system.debug('Error: '+msg);
                                        //Update Digital Lead
                                        dLeadList[0].Executed__c = True;
                                        dLeadList[0].Result__c = 'Error';
                                        dLeadList[0].Error__c = msg;
                                        update dLeadList[0];
                                    }
                                }
                            } catch(Exception ex) {
                                system.debug('Error: '+ex);
                                //Update Digital Lead
                                dLeadList[0].Executed__c = True;
                                dLeadList[0].Result__c = 'Error';
                                dLeadList[0].Error__c = ex.getMessage();
                                update dLeadList[0];
                            }
                        } else {
                    		DuplicationHandlerServices.duplicateWrapper dw = duplicateWrapperMap.get(newLead)[0];
                    		if(dw.objectType.equalsIgnoreCase('Lead')) {
                        		try {
                                    task t = new task();
                                    t.status = 'Completed';
                                    t.whatId = dw.dupLead.Id;
                                    t.RecordTypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Enquiry').getRecordTypeId();
                                    t.Subject = 'New Enquiry Received From:'+ leadList[0].Media__c;
                                                            
                                    if(String.isNotBlank(leadList[0].Last_Name__c))
                                        t.Name__c = leadList[0].Last_Name__c;
                                    if(String.isNotBlank(leadList[0].MobilePhone__c))
                                        t.Mobile__c = leadList[0].MobilePhone__c;
                                    if(String.isNotBlank(leadList[0].Email__c))
                                        t.Email__c = leadList[0].Email__c;
                                    if(leadList[0].Project__c != null)
                                        t.Project__c = leadList[0].Project__c;
                                    if(leadList[0].Campaign_Custom__c != null)
                                        t.Campaign__c = leadList[0].Campaign_Custom__c;
                                    if(String.isNotBlank(leadList[0].Campaign_Code__c))
                                        t.Campaign_Code__c= leadList[0].Campaign_Code__c;
                                    if(String.isNotBlank(leadList[0].Campaign_Type__c))
                                        t.Campaign_Type__c = leadList[0].Campaign_Type__c;
                                    if(String.isNotBlank(leadList[0].Media__c))
                                        t.Media__c = leadList[0].Media__c;
                                    if(String.isNotBlank(leadList[0].Description__c))
                                        t.Description = leadList[0].Description__c;
                                    if(String.isNotBlank(leadList[0].Lead_Created_From__c))
                                        t.Task_Created_From__c = leadList[0].Lead_Created_From__c;
                            		insert t;
                            
                                    //Update Digital Lead
                                    dLeadList[0].Executed__c = True;
                                    dLeadList[0].Result__c = 'New Enquiry Against Lead';
                                    dLeadList[0].Lead__c = dw.dupLead.Id; 
                                    update dLeadList[0];
                                } catch(Exception ex) {
                                    system.debug('Error: '+ex);
                                    //Update Digital Lead
                                    dLeadList[0].Executed__c = True;
                                    dLeadList[0].Result__c = 'Error';
                                    dLeadList[0].Error__c = ex.getMessage();
                                    update dLeadList[0];
                                }
                    		} else if(dw.objectType.equalsIgnoreCase('Opportunity')) {
                        		try {
                                    task t = new task();
                                    t.Status = 'Completed';
                                    t.RecordTypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Enquiry').getRecordTypeId();
                                    t.Subject = 'New Enquiry Received From:'+ leadList[0].Media__c;
                                    t.WhoId = dw.dupOpp.AccountId__r.PersonContactId;
                                    t.whatId = dw.dupOpp.Id;
                                    
                                    if(String.isNotBlank(leadList[0].Last_Name__c))
                                        t.Name__c = leadList[0].Last_Name__c;
                                    if(String.isNotBlank(leadList[0].MobilePhone__c))
                                        t.Mobile__c = leadList[0].MobilePhone__c;
                                    if(String.isNotBlank(leadList[0].Email__c))
                                        t.Email__c = leadList[0].Email__c;
                                    if(leadList[0].Project__c != null)
                                        t.Project__c = leadList[0].Project__c;
                                    if(leadList[0].Campaign_Custom__c != null)
                                        t.Campaign__c = leadList[0].Campaign_Custom__c;
                                    if(String.isNotBlank(leadList[0].Campaign_Code__c))
                                        t.Campaign_Code__c= leadList[0].Campaign_Code__c;
                                    if(String.isNotBlank(leadList[0].Campaign_Type__c))
                                        t.Campaign_Type__c = leadList[0].Campaign_Type__c;
                                    if(String.isNotBlank(leadList[0].Media__c))
                                        t.Media__c = leadList[0].Media__c;
                                    if(String.isNotBlank(leadList[0].Description__c))
                                        t.Description = leadList[0].Description__c;
                                    if(String.isNotBlank(leadList[0].Lead_Created_From__c))
                                        t.Task_Created_From__c = leadList[0].Lead_Created_From__c;
                            		insert t;
                                    
                                    dLeadList[0].Executed__c = True;
                                    dLeadList[0].Result__c = 'New Enquiry Against Opportunity';
                                    dLeadList[0].Account__c = dw.dupOpp.AccountId__c;
                                    dLeadList[0].Opportunity__c = dw.dupOpp.Id;
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
                		}
            		}
                } catch(Exception ex) {
                    system.debug('Error: '+ex);
                    //Update Digital Lead
                    dLeadList[0].Executed__c = True;
                    dLeadList[0].Result__c = 'Error';
                    dLeadList[0].Error__c = ex.getMessage();
                    update dLeadList[0];
                }
            } 
        }
    }
}