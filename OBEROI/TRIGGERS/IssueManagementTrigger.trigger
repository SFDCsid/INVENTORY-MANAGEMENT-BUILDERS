trigger IssueManagementTrigger on Issue__c (before insert,before update)
{
    {
        IssuePriorityClass.checkPriorityOfIssues();   
    }
    {
        //IssueManagementVR.requiredField();
    }    
    if(Trigger.isUpdate)
    {
        //IssueManagementService ism = new IssueManagementService();
        IssueManagementService_Pack ism = new IssueManagementService_Pack ();
        ism.sendIssueUpdateEmail(trigger.new, trigger.old);
    }
}