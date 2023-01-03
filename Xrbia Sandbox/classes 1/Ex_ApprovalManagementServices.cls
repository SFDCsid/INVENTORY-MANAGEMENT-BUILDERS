//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class Ex_ApprovalManagementServices {
	@AuraEnabled
    public static List<approvalWrapper> getApprovalList(Integer list_size, Integer counter, String type) {
        List<approvalWrapper> approvalWrapperList = new List<approvalWrapper>();
        List<Campaign__c> cList = new List<Campaign__c>();
        List<ProcessInstanceWorkitem> workItemList = new List<ProcessInstanceWorkitem>();
        Map<Id, Campaign__c> cIdMap = new Map<Id, Campaign__c>();
        Map<Id, ProcessInstanceWorkitem> cIdWorkItemMap = new Map<Id, ProcessInstanceWorkitem>();

        if(type.equalsIgnoreCase('Total')) {
            cList = getAllCampaignInfo();
        } else {
            cList = getCampaignInfo(list_size, counter);
        }
        system.debug('cList: '+cList.size());

        if(!cList.isEmpty() && cList != null) {
            for(Campaign__c c: cList) {
                cIdMap.put(c.Id, c);
            }
        }
        if(!cIdMap.isEmpty() && cIdMap != null) {
            workItemList = [Select Id, ProcessInstanceId, ProcessInstance.TargetObjectId from ProcessInstanceWorkitem 
                            where ProcessInstance.TargetObjectId IN: cIdMap.keySet()
                            AND OriginalActorId =: UserInfo.getUserId()];
            system.debug('workItemList: '+workItemList);

            if(!workItemList.isEmpty() && workItemList != null) {
                for(ProcessInstanceWorkitem pw : workItemList) {
                    cIdWorkItemMap.put(pw.ProcessInstance.TargetObjectId, pw);
                }
            }
            system.debug('cIdWorkItemMap: '+cIdWorkItemMap);

            for(Id cId : cIdMap.keySet()) {
                if(cIdWorkItemMap.containsKey(cId)) {
                    approvalWrapperList.add(new approvalWrapper(cIdMap.get(cId), cIdWorkItemMap.get(cId).Id));
                }
            }
        }
        return approvalWrapperList;
    }
    
    @AuraEnabled
    public static Boolean approveCampaign(List<Id> processItemList) {
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        for(Id workItem: processItemList) {
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setWorkitemId(workItem);
            //Valid values are: Approve, Reject, or Removed. 
            //Only system administrators can specify Removed.
            req.setAction('Approve');
            req.setComments('Accepted Through Dashboard.');
            requests.add(req);
        }
        try {
            Approval.ProcessResult[] processResults = Approval.process(requests);
            return true;
        } catch (Exception e) {
            system.debug('Error: '+e.getMessage());
            return false;
        }
    }

    @AuraEnabled
    public static Boolean rejectCampaign(List<Id> processItemList) {
        List<Approval.ProcessWorkitemRequest> allReq = new List<Approval.ProcessWorkitemRequest>();
        for(Id pInstanceWorkitemsId: processItemList) {
            system.debug('pInstanceWorkitemsId: '+pInstanceWorkitemsId);
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Rejected Through Dashboard.');
            req2.setAction('Reject');
    
            // Use the ID from the newly created item to specify the item to be worked
            req2.setWorkitemId(pInstanceWorkitemsId);
            // Add the request for approval
            allReq.add(req2);
        }
        try {
            Approval.ProcessResult[] result2 =  Approval.process(allReq);
            return true;
        } catch (Exception e) {
            system.debug('Error: '+e.getMessage());
            return false;
        }
    }

    public static List<Campaign__c> getCampaignInfo(Integer list_size, Integer counter) {
        List<Campaign__c> cList = new List<Campaign__c>();
        String[] types = new String[]{'Campaign__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ', Project__r.Name, DID_Number__r.Name, Marketing_Brief__r.Name from Campaign__c where Approver__c != null AND Status__c = \'Sent for Approval\' ORDER BY CreatedDate DESC LIMIT :list_size offset :counter'; 
        system.debug(soqlQuery);
        cList = Database.query(soqlQuery);
        if (cList.size() > 0) {
            return cList;
        } else {
            return null;
        }
    }

    public static List<Campaign__c> getAllCampaignInfo() {
        List<Campaign__c> cList = new List<Campaign__c>();
        String[] types = new String[]{'Campaign__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ', Project__r.Name, DID_Number__r.Name, Marketing_Brief__r.Name from Campaign__c where Approver__c != null AND Status__c = \'Sent for Approval\' ORDER BY CreatedDate DESC'; 
        system.debug(soqlQuery);
        cList = Database.query(soqlQuery);
        if (cList.size() > 0) {
            return cList;
        } else {
            return null;
        }
    }

    public class approvalWrapper {
        @AuraEnabled
        public Campaign__c c {get;set;}
        @AuraEnabled
        public Id workItemId {get;set;}

        public approvalWrapper(Campaign__c newCam, Id workId) {
            this.c = newCam;
            this.workItemId = workId;
        }
    }
}