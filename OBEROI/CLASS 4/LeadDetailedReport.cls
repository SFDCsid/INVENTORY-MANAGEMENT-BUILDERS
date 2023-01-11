public class LeadDetailedReport {
    @AuraEnabled
    public static list<site__c> listSite(){
        list <site__c> siteList = [SELECT id, Name, Active__c FROM Site__c];
        system.debug(siteList+'siteList');
        return siteList;
    }
    
    
    @AuraEnabled
    public static list<leadCampaignWrapper> leadCountBasedonCampaign (DateTime startDate , DateTime EndDate, string siteID){       
        
        string EndDateTime =EndDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') ;
        string startDateTime =startDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') ;
        list <leadCampaignWrapper> wrapperList = new list <leadCampaignWrapper>();
        system.debug(startDateTime +'***'+EndDateTime+'^^^^^^'+startDate);
        //system.debug(Integer.ValueOf(startDateTime) - Integer.ValueOf(EndDateTime) +'$%$%$%'+EndDateTime);
        string query = 'SELECT id, Name , createdDate, Campaign__c,Campaign__r.Name, Channel_Name__c , Campaign_Name__c, site__c FROM Lead WHERE campaign__c != null AND  createdDate > ' + startDateTime +' AND createdDate < '+ EndDateTime + ' AND site__c = \''+ siteID + '\''; 
        Map<string, list<Lead>> campWiseLead = new Map<string, list<Lead>>();
        list<Lead> LeadListCount = new list<Lead>();
        list<Lead> ldList = database.Query(query); 
        system.debug(ldList.size()+'<=======result Size');
        for (Lead ld : ldList){
            if(ld.Campaign__r.Name!= null && !campWiseLead.containskey(ld.Campaign__r.Name) ){ 
                campWiseLead.put(ld.Campaign__r.Name	, new List<Lead> {ld});
            } else if (campWiseLead.containskey(ld.Campaign__r.Name)){
                LeadListCount = campWiseLead.get(ld.Campaign__r.Name);
                LeadListCount.add(ld); 
            }
        }   
        system.debug(campWiseLead+'campWiseLead');
        return wrapperList;
        
    }
    
    //Wrapper class to send Lead count across advertisement, Channel and Campaign  
    public class leadCampaignWrapper {
        @AuraEnabled Public string campName { get; set;}
        @AuraEnabled Public string channelName { get; set;}
        @AuraEnabled Public string advertisement { get; set;}
        @AuraEnabled Public list<Lead> leadList{get; set;}
        @AuraEnabled Public integer leadCount{get; set;}
        
        public leadCampaignWrapper(string advt ,string channel, string camp, list<Lead> leadCountList ) {
            advertisement = advt;
            channelName = channel;
            campName = camp;
            leadList = leadCountList;
            leadCount = leadCountList.size();
        }
    }
    
    
    
}