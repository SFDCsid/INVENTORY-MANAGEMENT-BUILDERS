trigger TestAttached on Related_Document_History__c (After Update) {
    
    if(Trigger.isAfter && Trigger.isUpdate){
    List<Related_Document_History__c> RDHList = Trigger.new;
    Id RDH_Id = RDHList[0].id;
    List<ContentDocumentLink> CDOPLink = new List<ContentDocumentLink>();
        //List<ContentDocumentLink> CDTowerLink = new List<ContentDocumentLink>();
    List<ContentVersion> conversion = new List<ContentVersion>();
    List<ContentDistribution> cd = new List<ContentDistribution>();
    List<ContentDocumentLink> CDLink = new List<ContentDocumentLink>();
       
        CDLink = [SELECT ContentDocumentid, LinkedEntityid FROM contentDocumentLink WHERE LinkedEntityid =:RDH_Id];
       
        System.debug('ContentDocumentLink :: '+CDLink);
        if(!CDLink.isEmpty()){
            conversion = [SELECT Id,title, versiondata, ContentDocumentId, FileType  FROM ContentVersion WHERE ContentDocumentId =:CDLink[0].ContentDocumentId];
           
        }    
        if(!conversion.isEmpty()){
           
            ContentTriggerHandler.createPublicLinkForFile(conversion);
           
            cd = [SELECT ContentVersionId,DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId =:conversion[0].Id LIMIT 1];
            System.debug('CD :: '+cd);
           
        }        
        if(!cd.isEmpty()){
           
           
            try{
                Related_Document_History__c rdh = new Related_Document_History__c();
            rdh.Id = RDH_Id;
            rdh.Document_link__c = cd[0].DistributionPublicUrl;
            update rdh;
            }catch(Exception e){
                System.debug('Exception :: '+e);
            }
           
           
        }
        }
}