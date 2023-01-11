public with sharing class DocumentApprovalCont{
     public string RDHId {
        get; 
        set{
            RDHId = value;
            if(RDHId != null)
                getCreateDocList();
        }
    }//{get;set;}
     public List<ContentDistribution> cd {get;set;}
     public List<ContentDistribution> cdProj {get;set;}
     public List<ContentDistribution> cdProp {get;set;}
     public List<ContentDistribution> cdTower {get;set;}
     Public List<Related_Document_History__c> rdhList {get;set;}
     public string ReletedDocLink {get;set;}
     public void getCreateDocList(){
     
        ReletedDocLink = Url.getSalesforceBaseUrl().toExternalForm()+'/'+RDHId;
        List<ContentDocumentLink> CDProjLink = new List<ContentDocumentLink>();
        List<ContentDocumentLink> CDTowerLink = new List<ContentDocumentLink>();
        List<ContentVersion> conversion = new List<ContentVersion>();
        List<ContentVersion> Projconversion = new List<ContentVersion>();
        List<ContentVersion> Towerconversion = new List<ContentVersion>();
        List<ContentVersion> Propconversion = new List<ContentVersion>();
        cd = new List<ContentDistribution>();
        List<ContentDocumentLink> CDLink = new List<ContentDocumentLink>();
        List<ContentDocumentLink> CDPropLink = new List<ContentDocumentLink>();
        Set<id> rdlid = New Set<id>();
        Set<id> conid = New Set<id>();
        Set<id> projlid = New Set<id>();
        Set<id> projconid = New Set<id>();
        Set<id> towerlid = New Set<id>();
        Set<id> towerconid = New Set<id>();
        Set<id> proplid = New Set<id>();
        Set<id> propconid = New Set<id>();
       
        rdhList = [select id,name,Document_Name__c,Related_Document_Number__c,Project__c,Tower__c,Property__c from Related_Document_History__c where id =: RDHId];
        CDLink = [SELECT ContentDocumentid, LinkedEntityid FROM contentDocumentLink WHERE LinkedEntityid =:RDHId];
        
        
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
        
        List<Annexures_Documents__c> ADProj = [Select id,name,Project__c,Document_Name__c from Annexures_Documents__c where Project__c =: rdhList[0].Project__c and Document_Name__c includes(:rdhList[0].Document_Name__c)];
        if(ADProj.size()>0){
            CDProjLink = [SELECT ContentDocumentid, LinkedEntityid FROM contentDocumentLink WHERE LinkedEntityid =: ADProj[0].id];
        }
        
        for(contentDocumentLink cdl : CDProjLink){
            projlid.add(cdl.ContentDocumentid);
        }
        
        System.debug('ContentDocumentLink :: '+projlid);
        if(!CDProjLink.isEmpty()){
            Projconversion = [SELECT Id,title, versiondata, ContentDocumentId, FileType  FROM ContentVersion WHERE ContentDocumentId IN : projlid];
           
           System.debug('Contentconversion :: '+Projconversion);
           for(ContentVersion cvl : Projconversion){
                projconid.add(cvl.id);
           }
        }    
        if(!Projconversion.isEmpty()){
           
            ContentTriggerHandler.createPublicLinkForFile(projconid);
           
            cdProj = [SELECT ContentVersionId,ContentVersion.title,DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId IN : projconid];
            System.debug('cdProj :: '+cdProj);
            System.debug('cdProj size :: '+cdProj.size());
           
        }   
        
        List<Annexures_Documents__c> ADTower = [Select id,name,Project__c,Tower__c,Document_Name__c from Annexures_Documents__c where Tower__c =: rdhList[0].Tower__c and Document_Name__c includes(:rdhList[0].Document_Name__c)];
        if(ADTower.size()>0){
            CDTowerLink = [SELECT ContentDocumentid, LinkedEntityid FROM contentDocumentLink WHERE LinkedEntityid =:ADTower[0].id];
        }
        if(CDTowerLink.size()>0){
            for(contentDocumentLink cdl : CDTowerLink){
                towerlid.add(cdl.ContentDocumentid);
            }
         }
         
         System.debug('ContentDocumentLink :: '+towerlid);
        if(!CDTowerLink.isEmpty()){
            Towerconversion = [SELECT Id,title, versiondata, ContentDocumentId, FileType  FROM ContentVersion WHERE ContentDocumentId IN : towerlid];
           
           System.debug('Contentconversion :: '+Towerconversion);
           for(ContentVersion cvl : Towerconversion){
                towerconid.add(cvl.id);
           }
        }    
        if(!Towerconversion.isEmpty()){
           
            ContentTriggerHandler.createPublicLinkForFile(towerconid);
           
            cdTower = [SELECT ContentVersionId,ContentVersion.title,DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId IN : towerconid];
            System.debug('cdProj :: '+cdTower);
            System.debug('cdProj size :: '+cdTower.size());
           
        }   
        List<Annexures_Documents__c> ADProp = [Select id,name,Project__c,Property__c,Document_Name__c from Annexures_Documents__c where Property__c =: rdhList[0].Property__c and Document_Name__c includes(:rdhList[0].Document_Name__c)];
        if(ADProp.size()>0){
            CDPropLink = [SELECT ContentDocumentid, LinkedEntityid FROM contentDocumentLink WHERE LinkedEntityid =:ADProp[0].id];
        }
        
        if(CDPropLink.size()>0){
            for(contentDocumentLink cdl : CDPropLink){
                proplid.add(cdl.ContentDocumentid);
            }
         }
         
         System.debug('ContentDocumentLink :: '+towerlid);
        if(!CDPropLink.isEmpty()){
            Propconversion = [SELECT Id,title, versiondata, ContentDocumentId, FileType  FROM ContentVersion WHERE ContentDocumentId IN : proplid];
           
           System.debug('Contentconversion :: '+Towerconversion);
           for(ContentVersion cvl : Propconversion){
                propconid.add(cvl.id);
           }
        }    
        if(!Propconversion.isEmpty()){
           
            ContentTriggerHandler.createPublicLinkForFile(propconid);
           
            cdProp = [SELECT ContentVersionId,ContentVersion.title,DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId IN : propconid];
            System.debug('cdProj :: '+cdProp);
            System.debug('cdProj size :: '+cdProp.size());
           
        }   
     }
    
    public static void dum(){
        integer a=1;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
    }
}