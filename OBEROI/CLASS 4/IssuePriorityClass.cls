public class IssuePriorityClass 
{
    public static void checkPriorityOfIssues()
    {
        String priorityURL = '';
        Organization orgObj = [SELECT Id, IsSandbox FROM Organization WHERE Id=:UserInfo.getOrganizationId()];
        if(orgObj.IsSandbox)
        {
            priorityURL = 'Some issues already has this priority <a href=\'https://oberoirealty--oberoidev.my.salesforce.com/';
            //priorityURL = 'Some issues already has this priority <a href=\'https://oberoirealty--oberoidev.my.salesforce.com/';
        }
        else
        {
            priorityURL = 'Some issues already has this priority <a href=\'https://oberoirealty--oberoidev.my.salesforce.com/';
        }
        
        list<string> priority = new list<string>();
        for(Issue__c prioVar:(List<Issue__c >)trigger.new)
        {
            priority.add(prioVar.Priority__c);
        }
        list<Issue__c> listOfAll = [SELECT Id,Name FROM Issue__c WHERE Status__c != 'Closed' AND
                                    Priority__c != 'Not Prioritized' AND Priority__c IN :priority];
        
        
        for(Issue__c issueNew:(List<Issue__c>)trigger.new)
        {
            if(trigger.isInsert)
            {
                if(listOfAll.size() > 0 && issueNew.Status__c != 'Closed')
                    issueNew.addError(priorityURL+listOfAll[0].Id+'\'>View L1/L2</a>', false);
            }
            if(trigger.isUpdate && listOfAll.size() > 0)
                for(Issue__c issueOld :(List<Issue__c>)trigger.old)
            {
                if(issueNew.Priority__c != issueOld.Priority__c && issueNew.Status__c != 'Closed' && (issueNew.Priority__c == 'L1' || issueNew.Priority__c == 'L2'))
                {
                    issueNew.addError(priorityURL+listOfAll[0].Id+'\'>View L1/L2</a>', false);
                }
                else if(issueNew.Status__c != issueOld.Status__c && issueNew.Priority__c != 'L1' && issueNew.Priority__c != 'L2' && issueNew.Status__c != 'Closed')
                {
                    issueNew.addError(priorityURL+listOfAll[0].Id+'\'>View L1/L2</a>', false);
                }
                else if(issueNew.Status__c != issueOld.Status__c && (issueNew.Priority__c == 'L1' || issueNew.Priority__c == 'L2') && issueOld.Status__c == 'Closed')
                {
                    issueNew.addError(priorityURL+listOfAll[0].Id+'\'>View L1/L2</a>', false);
                }
            }
        }
    }
}