trigger IssueCommentTrigger on Issue_Comment__c (after insert) {
    IssueManagementService_Pack ism = new IssueManagementService_Pack ();
   
     ism.sendIssueCommentEmail(Trigger.new);
}