public class ViewFilesComponentController {
    
    public Boolean isAdmin{get;set;}
    public Boolean isApproved{get;set;}
    public Boolean isNotForApproval{get;set;}
    public String relatedId{get;set;}
    
    public List< Related_Document_History__c> rdList{get;set;} 
    public List< ContentDocumentLink> cdlinkList{get;set;} 
    public List< ContentVersion> contentVersionList{get;set;} 
    public List< ContentVersion> contentApprovedVersionList{get;set;} 
    public List< ContentVersion> contentUnApprovedVersionList{get;set;} 
    public Map<Id,Id> docIdMap{get; set;}
    public transient String base64;
    public String fileName {get; set;}
    public Profile p{get; set;}
    public  set<id> linkidSet{get; set;}
    public List<Profile> profiles{get; set;}
    public String getBase64() 
    {
        return base64;
    }
    public void setbase64(String base64)
    {
        this.base64 = base64;
    }
    
    public ViewFilesComponentController(){
        relatedId = '';
        rdList = new List<Related_Document_History__c>();
        cdlinkList = new List<ContentDocumentLink>();
        contentVersionList = new List<ContentVersion>();
        contentApprovedVersionList = new List< ContentVersion>();
        contentUnApprovedVersionList = new List< ContentVersion>();
        docIdMap = new Map<Id,Id>();
        isAdmin = false;
        isApproved = false;
        isNotForApproval = false;
        p = new Profile();
        profiles = new List<Profile>();
         
        relatedId = ApexPages.currentPage().getParameters().get('id');
       list<ProcessInstanceWorkitem> piwi = [select id,ProcessInstanceid from ProcessInstanceWorkitem where id =:relatedId ];
        if(piwi.size()>0){
            list<ProcessInstance > pi=[SELECT ID,TargetObjectId FROM ProcessInstance where id =: piwi[0].ProcessInstanceid];
        	system.debug('pi=' + pi);
            relatedId = pi[0].TargetObjectId;
        }   
        
        
        system.debug('relatedId=' + relatedId);
        linkidSet = new set<id>();
        profiles = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId() AND Name =: 'System Administrator'];
        if(profiles.size() > 0){
            isAdmin = true; 
        }
        
        if (relatedId != null) {
            p = [select id,Name from Profile where id=:Userinfo.getProfileid()];
            system.debug('p.Name'+p.Name);
            rdList = [Select Id, Name , Customer_Email_Id__c, Document_Generated_By__c, Document_Generated_Date_Time__c, 
                      Document_Name__c,Document_Approved__c, Document_Send_To_Customer_By__c, Opportunity__c,Opportunity__r.Name,Booking__r.Opportunity__r.id,
                      Opportunity__r.Property__r.name,Booking__r.id,Booking__r.Acceptance_Form_Template__c,Booking__r.Agreement_Form_Template__c,
                      Booking__r.Allotment_Form_Template__c,Booking__r.NRI_Declaration_Template__c,Booking__r.Mortgage_Release_Request_Letter__c,
                      Booking__r.Agreement_Signing_undertaking__c,Booking__r.Annexure_B_Nomination_Form__c,Booking__r.TPA__c,Booking__r.Bank_NOC__c,Booking__r.Provisional_NOC__c,Booking__r.L_L_NOC__c,
                      Booking__r.Car_Park_Allotment_Letter__c,Booking__r.Possession_Undertaking_Letter__c,Booking__r.Possession_Letter__c,Booking__r.Electricity_Meter_transfer_NOC__c,
                      Booking__r.Rejection_Notice_Pre_Possession__c,Booking__r.Rejection_Notice_Post_Possession__c,Booking__r.ROFR_NOC_Loan_case__c,
                      Approval_Stage__c,Document_Rejected__c,Submitted_for_Approval__c,createdDate
                      from Related_Document_History__c where Id =: relatedId];
            system.debug('rdList=' + rdList);
            
            DocumentApprovalList__c dA = DocumentApprovalList__c.getInstance(rdList[0].Document_Name__c);
            system.debug('dA::'+dA);
            if(dA==null){
             isNotForApproval = true;    
            }
            
            cdlinkList = [SELECT Id, LinkedEntityId, ContentDocumentId,ContentDocument.LatestPublishedVersionId,Visibility, IsDeleted, ShareType,ContentDocument.Title,ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:relatedId Order By ContentDocument.createdDate Desc];
            system.debug('cdl=' + cdlinkList);
            for(ContentDocumentLink link:cdlinkList){
                linkidSet.add(link.ContentDocument.LatestPublishedVersionId);
                docIdMap.put(link.ContentDocument.LatestPublishedVersionId,link.ContentDocumentId);
            }
            
            if(rdList[0].createdDate < Date.valueOf('2022-08-27')&&rdList[0].Submitted_for_Approval__c){
                system.debug('RDCreatedDateComparedWith2022-08-27::'+(rdList[0].createdDate < Date.valueOf('2022-08-27')));
                contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet Order By createdDate Desc];
                if(!rdList[0].Document_Approved__c){
                    isApproved = false;
                }
            }else{
                if(rdList[0].Document_Approved__c){
                    isApproved = true;
                }
                
                if(p.Name=='System Administrator'){
                    //   contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet Order By createdDate Desc];
                    
                    if(rdList[0].Document_Approved__c){
                        contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet Order By createdDate Desc];
                    }else{
                        if(rdList[0].Submitted_for_Approval__c&&!rdList[0].Document_Rejected__c){
                            contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet AND IsSecondDocGenerated__c=:false Order By createdDate Desc];
                        }else{
                            if(rdList[0].Document_Rejected__c){
                                contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet AND IsSecondDocGenerated__c=:false And isApproved__c=: false Order By createdDate Desc];
                            }else{
                                contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet Order By createdDate Desc];
                            }             
                        }
                    }
                    system.debug('contentVersionList='+contentVersionList);
                }else{
                    if(rdList[0].Document_Approved__c){
                        contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet AND IsInitialDocGenerated__c=:false Order By createdDate Desc];
                    }else{
                        if(rdList[0].Submitted_for_Approval__c&&!rdList[0].Document_Rejected__c){
                            contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet AND IsSecondDocGenerated__c=:false Order By createdDate Desc];
                        }else{
                            if(rdList[0].Document_Rejected__c){
                                contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet AND IsSecondDocGenerated__c=:false And isApproved__c=: false Order By createdDate Desc];
                            }else{
                                contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet Order By createdDate Desc];
                            }
                        }
                    }
                }
            }
        }
        
    }//contructor ends
    
    public void refreshView(){
        cdlinkList = [SELECT Id, LinkedEntityId, ContentDocumentId,ContentDocument.LatestPublishedVersionId,Visibility, IsDeleted, ShareType,ContentDocument.Title,ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:relatedId Order By ContentDocument.createdDate Desc];
        system.debug('cdl=' + cdlinkList);
        system.debug('title=' + cdlinkList[0].ContentDocument.Title);
        for(ContentDocumentLink link:cdlinkList){
            linkidSet.add(link.ContentDocument.LatestPublishedVersionId);
            docIdMap.put(link.ContentDocument.LatestPublishedVersionId,link.ContentDocumentId);
        }   
        if(rdList[0].createdDate < Date.valueOf('2022-08-27')&&rdList[0].Submitted_for_Approval__c){
            system.debug('RDCreatedDateComparedWith2022-08-27::'+(rdList[0].createdDate < Date.valueOf('2022-08-27')));
            contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet Order By createdDate Desc];
            if(!rdList[0].Document_Approved__c){
                isApproved = false;
            }
        }else{
            if(rdList[0].Document_Approved__c){
                isApproved = true; 
            }
            
            if(p.Name=='System Administrator'){
                //  contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet Order By createdDate Desc];
                
                if(rdList[0].Document_Approved__c){
                    contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet Order By createdDate Desc];
                }else{
                    if(rdList[0].Submitted_for_Approval__c&&!rdList[0].Document_Rejected__c){
                        contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet AND IsSecondDocGenerated__c=:false Order By createdDate Desc];
                    }else{
                        if(rdList[0].Document_Rejected__c){
                            contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet AND IsSecondDocGenerated__c=:false And isApproved__c=: false Order By createdDate Desc];
                        }else{
                            contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet Order By createdDate Desc];
                        }             
                    }
                }
                system.debug('contentVersionList='+contentVersionList);
            }else{
                if(rdList[0].Document_Approved__c){
                    contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet AND IsInitialDocGenerated__c=:false Order By createdDate Desc];
                }else{
                    if(rdList[0].Submitted_for_Approval__c&&!rdList[0].Document_Rejected__c){
                        contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet AND IsSecondDocGenerated__c=:false Order By createdDate Desc];
                    }else{
                        if(rdList[0].Document_Rejected__c){
                            contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet AND IsSecondDocGenerated__c=:false And isApproved__c=: false Order By createdDate Desc];
                        }else{
                            contentVersionList = [SELECT Id, FileType,isApproved__c,IsDocGen__c,Title,FileExtension,IsInitialDocGenerated__c,IsSecondDocGenerated__c,CreatedDate FROM ContentVersion Where id IN: linkidSet Order By createdDate Desc];
                        }
                    }
                }
            }
        }
    }   
    public void saveFile()
    {
        
        ContentVersion cv = new ContentVersion();
        cv.versionData = EncodingUtil.base64decode(this.base64);
        cv.title = fileName+System.today();
        cv.pathOnClient = fileName;
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = relatedId; // <----- put your record id here, example: an account tid
        cdl.ShareType = 'V';
        insert cdl;
        
        cdlinkList = [SELECT Id, LinkedEntityId, ContentDocumentId,Visibility, IsDeleted, ShareType,ContentDocument.Title,ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:relatedId Order By ContentDocument.createdDate asc];
        refreshView();  
    }
    
    public void RemoveFile(){
        
        
    }
}