trigger TrgRelatedDocumentHistory on Related_Document_History__c (after update) {

    Set<Id> rdIdList = new Set<Id>();
    Set<Id> rdApprovedIdList = new Set<Id>();
    Set<Id> rdRejectedIdList = new Set<Id>();
    
    if(Trigger.isAfter&&Trigger.isUpdate){ 
        
      for(Related_Document_History__c rd:Trigger.new){

       if(Trigger.OldMap.get(rd.id).Submitted_for_Approval__c!=Trigger.NewMap.get(rd.id).Submitted_for_Approval__c&&Trigger.NewMap.get(rd.id).Submitted_for_Approval__c==true){            
            rdIdList.add(rd.id);
        }
        if(Trigger.OldMap.get(rd.id).Document_Approved__c!=Trigger.NewMap.get(rd.id).Document_Approved__c&&Trigger.NewMap.get(rd.id).Document_Approved__c==true){            
            rdApprovedIdList.add(rd.id);
        }
        if(Trigger.OldMap.get(rd.id).Document_Rejected__c!=Trigger.NewMap.get(rd.id).Document_Rejected__c&&Trigger.NewMap.get(rd.id).Document_Rejected__c==true){            
            rdRejectedIdList.add(rd.id);
        }   
      }
        if(!rdIdList.isEmpty()){
            RelatedDocumentHelper.GenerateApprovalDocPdf(rdIdList);
        }
         if(!rdApprovedIdList.isEmpty()){
             //Approve all related docs except isGenDoc [Only manually uploaded]
           RelatedDocumentHelper.ApproveAllRelatedDocs(rdApprovedIdList);
        }
        if(!rdRejectedIdList.isEmpty()){
            RelatedDocumentHelper.RemoveRejectedApprovedDocPdf(rdRejectedIdList);
        }
    }
}