public class CreateCampaignRecord {
    
    @AuraEnabled
    public static list<RecordType> fetchRecordTypeValues(ID campId){
        system.debug(campId);
        list<RecordType> rtList = new List<RecordType>();
        Campaign camp = [SELECT Id,Name,IsActive,RecordtypeId,RecordType.DeveloperName FROM Campaign WHERE id=:campId];
        Map<string,RecordType> rtMap = new Map<string,RecordType>();
        for(RecordType rtp:[SELECT Id,DeveloperName,Name FROM RecordType WHERE SobjectType='Campaign']){
            rtMap.put(rtp.DeveloperName,rtp);
        }
        
        if(camp.RecordType.DeveloperName == Label.ORL_Campaign_Marketing_Campaign_Multi_Project || camp.RecordType.DeveloperName == Label.ORL_Campaign_Marketing_Campaign_Single_Project){
            rtList.add(rtMap.get(Label.ORL_Campaign_Marketing_Channel)); 
        } else if(camp.RecordType.DeveloperName == Label.ORL_Campaign_Marketing_Plan_Site_Specific && camp.IsActive== true){            
            rtList.add(rtMap.get(Label.ORL_Campaign_Marketing_Campaign_Single_Project)); 
            rtList.add(rtMap.get(Label.ORL_Campaign_Marketing_Campaign_Multi_Project)); 
        }  else if(camp.RecordType.DeveloperName == Label.ORL_Campaign_Marketing_Channel){
            rtList.add(rtMap.get(Label.ORL_Campaign_Advertisement)); 
        } else if(camp.RecordType.DeveloperName == Label.ORL_Campaign_Marketing_Plan_HO_Common && camp.IsActive== true ){
            rtList.add(rtMap.get(Label.ORL_Campaign_Marketing_Campaign_Multi_Project));
        }
        return rtList;  
    }
    
    @AuraEnabled
    public static Campaign fetchsiteProject(ID campId){
        Map<id, Campaign> CampMap = new Map<id, Campaign>([SELECT id, NAme,Project__c, Marketing_Plan__c FROM Campaign WHERE Recordtype.DeveloperName =: Label.ORL_Campaign_Marketing_Campaign_Single_Project]);
        Map<id, Campaign> ChannelMap = new Map<id, Campaign>([SELECT id, NAme, Marketing_Campaign__c FROM Campaign WHERE Recordtype.DeveloperName =: Label.ORL_Campaign_Marketing_Channel]);
        system.debug(CampMap+'Camp');
        system.debug(ChannelMap+'Channel');
        Campaign cp = new Campaign();
        system.debug(campId);
        if(ChannelMap.containsKey(campId)){
            if(CampMap.containsKey(ChannelMap.get(campId).Marketing_Campaign__c)){
                cp = CampMap.get(ChannelMap.get(campId).Marketing_Campaign__c);
            }
            system.debug(cp+'**(*(*(*');
            return cp;
        }else{
            return null;
        }
    }
    
    
}