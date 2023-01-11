public class QuickLaunchController {
    
	@AuraEnabled
    public static String getleadConvertprocess(String leadnumber){
		
		List<Database.LeadConvert> lstLeadconvert = new List<Database.LeadConvert>();
		LeadStatus Leads= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        System.debug('AdityaBhasinCode'+leadnumber);
        //String num = '0'+leadnumber;
        Lead currentlead = [select id,Lead_Number__c from lead where Lead_Number__c =: leadnumber limit 1];
         System.debug('AdityaBhasinCode'+currentlead);
        if(!String.isBlank(currentlead.Id)){
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(currentlead.Id);
            lc.ConvertedStatus = Leads.MasterLabel;
            Id oppId;
            Database.LeadConvertResult lcr = Database.convertLead(lc);       
            if(lcr.isSuccess()){
               oppId = lcr.getOpportunityId();
            }
            return oppId;
        }
        else {
            return null;
        }
        
	
	}
}