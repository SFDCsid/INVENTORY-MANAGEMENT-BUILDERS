public with sharing class MDApprovalTemplate {
    public string mdApproverId {
        get;
        set{
            mdApproverId = value;
            if(mdApproverId != null)
                createApprovalList();
        }
    }
    public list<wrapperclass> approvalList          {get; set;}
    public string rejectName                        {get;set;}
    public string rejectreason                      {get;set;}
    public string mdApproverlLink                   {get;set;}
    public  MD_Approval__c mdApp                    {get;set;}
    
    public void createApprovalList() {
        approvalList = new list<wrapperclass>();
        mdApproverlLink = Url.getSalesforceBaseUrl().toExternalForm()+'/'+mdApproverId;
        //query the offers approval status
        Set<Id> processInstanceIds = new set<Id>();
        String tempcomments = '';//WHERE ProcessDefinition.DeveloperName ='offer_approval_processs'
        for (MD_Approval__c invs : [SELECT Comments__c,Department__c,Name,Approval_Name__c,Project__r.Name, Property__c,Property__r.Name,(SELECT ID FROM ProcessInstances  ORDER BY CreatedDate DESC)
                                            FROM MD_Approval__c WHERE ID  =:mdApproverId])
        {
            mdApp = invs;
            if(invs.ProcessInstances.size() > 0)
                for(ProcessInstance pi :invs.ProcessInstances)
                    processInstanceIds.add(pi.Id);
        }
      
        // Now that we have the most recent process instances, we can check
        // the moRst recent process steps for comments.  
        for (ProcessInstance pi : [SELECT TargetObjectId,LastActorId,LastActor.Name,(SELECT Id, ActorId,OriginalActor.Name,Comments, ProcessInstanceId FROM StepsAndWorkitems WHERE StepStatus != 'Started' AND StepStatus != 'Pending' Order BY ID DESC), (SELECT Id, StepStatus, Comments  FROM Steps ORDER BY CreatedDate DESC LIMIT 1 )
                                   FROM ProcessInstance WHERE Id IN :processInstanceIds ORDER BY CreatedDate DESC])
        {
            //approvalMap.put(pi.LastActor.Name,'');
          // If no comment exists, then prevent the object from saving.                 
            if (pi.StepsAndWorkitems.size() > 0)
                for(ProcessInstanceHistory pih :pi.StepsAndWorkitems)
                    approvalList.add(new wrapperclass(pih.OriginalActor.Name,pih.Comments));
            else
                approvalList.add(new wrapperclass(pi.LastActor.Name,''));
        
        }
        
        if(approvalList.size() > 1) {
            rejectName = approvalList[0].userName;
            rejectreason = approvalList[0].comments;
        }
    }
    
    Public ProcessInstanceStep pStep{get;set;}
    
     public ProcessInstanceStep getApprovalSteps() {
          if (mdApproverId != null) {
            pStep = [Select SystemModstamp, StepStatus, ProcessInstanceId, OriginalActorId,OriginalActor.Name,
            Comments, ActorId,Actor.Name From ProcessInstanceStep where ProcessInstance.TargetObjectId=:mdApproverId order by SystemModstamp desc Limit 1];  
            
          }
          return pStep ;
        }
    
    
    public class wrapperclass{
        
        public string userName      {get;set;}
        public string comments      {get;set;}
        
        public wrapperclass(string userNamestr, string commentsstr){
            userName = userNameStr;
            comments = commentsStr;
        }
    }
    
}