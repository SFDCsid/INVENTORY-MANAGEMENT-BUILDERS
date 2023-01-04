public class Ex_LeadValidation {
	public static string leadValidate(Map<Id,Lead_c__c> oldLeadMap, Map<Id, Lead_c__c> newLeadMap)
    {
        List<Lead_c__c> leadList = new List<Lead_c__c>();
        for(Lead_c__c oldLead: oldLeadMap.values())
        {
            Lead_c__c newLead = newLeadMap.get(oldLead.Id);
            if(oldLead.Presales_Call_Count__c !=  newLead.Presales_Call_Count__c && newLead.Lead_Stage__c == '')
            {
                return 'error';
            }
        }
        return '';
    }
}