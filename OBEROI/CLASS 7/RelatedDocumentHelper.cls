public class RelatedDocumentHelper {
    
    @future(callout = true)
    public static void GenerateApprovalDocPdf(Set<Id> rdIdList){
         List < Related_Document_History__c> rdList = [Select Id, Name , Customer_Email_Id__c, Document_Generated_By__c, Document_Generated_Date_Time__c, 
                                                      Document_Name__c,Document_Approved__c, Document_Send_To_Customer_By__c, Opportunity__c,Opportunity__r.Name,Booking__r.Opportunity__r.id,
                                                      Opportunity__r.Property__r.name,Booking__r.id,Booking__r.Acceptance_Form_Template__c,Booking__r.Agreement_Form_Template__c,
                                                      Booking__r.Allotment_Form_Template__c,Booking__r.NRI_Declaration_Template__c,Booking__r.Mortgage_Release_Request_Letter__c,
                                                      Booking__r.Agreement_Signing_undertaking__c,Booking__r.Annexure_B_Nomination_Form__c,Booking__r.TPA__c,Booking__r.Bank_NOC__c,Booking__r.Provisional_NOC__c,Booking__r.L_L_NOC__c,
                                                      Booking__r.Car_Park_Allotment_Letter__c,Booking__r.Possession_Undertaking_Letter__c,Booking__r.Possession_Letter__c,Booking__r.Electricity_Meter_transfer_NOC__c,
                                                      Booking__r.Rejection_Notice_Pre_Possession__c,Booking__r.Rejection_Notice_Post_Possession__c,Booking__r.ROFR_NOC_Loan_case__c  
                                                      from Related_Document_History__c where Id IN: rdIdList];
 
        for(Related_Document_History__c rd:rdList){
            
            String docName = rd.Document_Name__c;
            string bDocName = '';
             system.debug('Document_Name__c'+rd.Document_Name__c);
            
             if(docName == 'Acceptance Form'){
            bDocName = rd.Booking__r.Acceptance_Form_Template__c;
        }else if(docName == 'Agreement Form'){
            bDocName = rd.Booking__r.Agreement_Form_Template__c;
        }else if(docName == 'Allotment Form'){
            bDocName = rd.Booking__r.Allotment_Form_Template__c;
        }else if(docName == 'NRI Declaration Form'){
            bDocName = rd.Booking__r.NRI_Declaration_Template__c;
        }else if(docName == 'Mortgage Release Request Letter'){
            bDocName = rd.Booking__r.Mortgage_Release_Request_Letter__c;
        }else if(docName == 'Agreement signing undertaking'){
            bDocName = rd.Booking__r.Agreement_Signing_undertaking__c;
        }else if(docName == 'Annexure B - Nomination Form'){
            bDocName = rd.Booking__r.Annexure_B_Nomination_Form__c;
        }else if(docName == 'TPA'){
            bDocName = rd.Booking__r.TPA__c;
        }else if(docName == 'Bank NOC'){
            bDocName = rd.Booking__r.Bank_NOC__c;
        }else if(docName == 'Provisional NOC'){
            bDocName = rd.Booking__r.Provisional_NOC__c;
        }else if(docName == 'L&L NOC'){
            bDocName = rd.Booking__r.L_L_NOC__c;
        }else if(docName == 'Car Park Allotment Letter'){  bDocName = rd.Booking__r.Car_Park_Allotment_Letter__c;}else 
                if(docName == 'Possession Undertaking Letter'){ bDocName = rd.Booking__r.Possession_Undertaking_Letter__c; }else 
                if(docName == 'Possession Letter'){    bDocName = rd.Booking__r.Possession_Letter__c;        }else 
            if(docName == 'Electricity Meter transfer NOC'){ bDocName = rd.Booking__r.Electricity_Meter_transfer_NOC__c;  }else 
                if(docName == 'Rejection Notice - Pre Possession'){ bDocName = rd.Booking__r.Rejection_Notice_Pre_Possession__c;}else 
            if(docName == 'Rejection Notice - Post Possession'){ bDocName = rd.Booking__r.Rejection_Notice_Post_Possession__c;
        }else if(docName == 'ROFR NOC Loan case'){bDocName = rd.Booking__r.ROFR_NOC_Loan_case__c; }
          
            Blob body;
            
            try {
                // returns the output of the page as a PDF
                //body = pageRef.getContentAsPDF();
                if(docName == 'Agreement Form'){    // Added for margin purpose.
                    PageReference pageRef = new PageReference('/apex/View_Document_Schedule11');    
                    pageRef.getParameters().put('oppId', rd.Opportunity__c);
                    pageRef.getParameters().put('docType', rd.Document_Name__c);
                    pageRef.getParameters().put('docName', bDocName);
                    pageRef.getParameters().put('rdId', rd.Id);
                    body = pageRef.getContentAsPDF();   
                    system.debug('body: '+body);
                }else{  
                    PageReference pageRef = new PageReference('/apex/View_Document');   
                    pageRef.getParameters().put('oppId', rd.Opportunity__c);
                    pageRef.getParameters().put('docType', rd.Document_Name__c);
                    pageRef.getParameters().put('docName', bDocName);
                    pageRef.getParameters().put('rdId', rd.Id); 
                    body = pageRef.getContentAsPDF();   
                    system.debug('body: '+body);
                }
            } catch (VisualforceException e) {
                system.debug('exception::'+e);
                body = Blob.valueOf('Some Text');
            }
            if(!Test.isRunningTest()){
              ContentVersion cont = DocumentGenerationServices.generateNewApprovedContentVersion(body, rd, rd.Document_Name__c);
              DocumentGenerationServices.createFeedItem(cont.Id, rd);    
            }
             
        }
    }//Generate After Approval Pdf Method Ends
    
    @future(callout = true)
    public static void ApproveAllRelatedDocs(Set<Id> rdApprovedIdSet){
        Set<Id> linkidSet = new Set<Id>(); 
        List< ContentDocumentLink> cdlinkList = new List< ContentDocumentLink>();
        List< ContentVersion> contentVersionList = new List< ContentVersion>();
        cdlinkList = [SELECT Id, LinkedEntityId, ContentDocumentId,ContentDocument.LatestPublishedVersionId,Visibility, IsDeleted, ShareType,ContentDocument.Title,ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:rdApprovedIdSet Order By ContentDocument.createdDate Desc];
        for(ContentDocumentLink link:cdlinkList){
            linkidSet.add(link.ContentDocument.LatestPublishedVersionId);
        }
        
        contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,CreatedDate FROM ContentVersion Where id IN: linkidSet AND isApproved__c =: false AND IsDocGen__c=:false AND IsInitialDocGenerated__c=:false AND IsSecondDocGenerated__c=:false];
        
        for(ContentVersion cv:contentVersionList){
            cv.isApproved__c = true;
            cv.IsThroughApprovalProcess__c = true;
        }
        try{
            if(!contentVersionList.isEmpty()){
                update contentVersionList;
            }
        }catch(Exception e){
            system.debug('Exception=='+e); 
        }
    }
    
     @future(callout = true)
    public static void RemoveRejectedApprovedDocPdf(Set<Id> rdIdList){
       Set<Id> linkidSet = new Set<Id>(); 
        List< ContentDocumentLink> cdlinkList = new List< ContentDocumentLink>();
        List< ContentVersion> contentVersionList = new List< ContentVersion>();
        cdlinkList = [SELECT Id, LinkedEntityId, ContentDocumentId,ContentDocument.LatestPublishedVersionId,Visibility, IsDeleted, ShareType,ContentDocument.Title,ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:rdIdList Order By ContentDocument.createdDate Desc];
        for(ContentDocumentLink link:cdlinkList){
            linkidSet.add(link.ContentDocument.LatestPublishedVersionId);
        }
          List<ContentDocument> listToDelete = new List<ContentDocument>();

        contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,CreatedDate,ContentDocumentId FROM ContentVersion Where id IN: linkidSet AND isApproved__c =: true AND IsDocGen__c=:true  AND IsSecondDocGenerated__c=:true];
        
        
        try{
            if(!contentVersionList.isEmpty()){
                for(ContentVersion c:contentVersionList){
                listToDelete.add(new ContentDocument( Id = c.ContentDocumentId)); 
                }
            }
            if(!listToDelete.isEmpty()){
                delete listToDelete;
            }
        }catch(Exception e){
            system.debug('Exception=='+e); 
        }
    }
}