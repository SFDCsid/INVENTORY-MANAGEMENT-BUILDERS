public with sharing class BrokerMDApprovalCont{
     public string BMDId {
        get; 
        set{
            BMDId = value;
            if(BMDId != null)
                getCreateDocList();
        }
    }//{get;set;}
     public List<ContentDistribution> cd {get;set;}
     Public List<MD_Approval__c> MDList {get;set;}
     public string BrokerageDocLink {get;set;}
     public void getCreateDocList(){
     
        BrokerageDocLink = Url.getSalesforceBaseUrl().toExternalForm()+'/'+BMDId;
        List<ContentVersion> conversion = new List<ContentVersion>();
        cd = new List<ContentDistribution>();
        List<ContentDocumentLink> CDLink = new List<ContentDocumentLink>();
        Set<id> rdlid = New Set<id>();
        Set<id> conid = New Set<id>();
       
        MDList = [select id,name,Approval_Process_Name__c from MD_Approval__c where id =: BMDId];
        CDLink = [SELECT ContentDocumentid, LinkedEntityid FROM contentDocumentLink WHERE LinkedEntityid =:BMDId];
        
        
        for(contentDocumentLink cdl : CDLink){
            rdlid.add(cdl.ContentDocumentid);
        }
        System.debug('ContentDocumentLink :: '+CDLink);
        if(!CDLink.isEmpty()){
            conversion = [SELECT Id,title, versiondata, ContentDocumentId, FileType  FROM ContentVersion WHERE ContentDocumentId IN : rdlid];
           
           System.debug('Contentconversion :: '+conversion);
           for(ContentVersion cvl : conversion){
                conid.add(cvl.id);
           }
        }    
        if(!conversion.isEmpty()){
           
            ContentTriggerHandler.createPublicLinkForFile(conid);
           
            cd = [SELECT ContentVersionId,ContentVersion.title,DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId IN : conid];
            System.debug('CD :: '+cd);
            System.debug('CD size :: '+cd.size());
           
        }        
        
     }
}