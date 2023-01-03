public with sharing class unqualifiedData {
    @AuraEnabled (cacheable=true)
    public static Map<String,String> getProject(){
        Map<String,String> projectMap = new Map<String,String>();
        for (Project__c projectObj : [Select id,Name FROM Project__c]) {
            projectMap.put(projectObj.id, projectObj.Name);
        }
        return projectMap;  
    }
    @AuraEnabled (cacheable=true)
    public static Map<String, reportDataWrapperClass> Wrapper(String pId, Date sdate, Date edate ){
        Map<String, reportDataWrapperClass> wrapperMap = new Map<String, reportDataWrapperClass>();
        List<AggregateResult> totalLeads = new List<AggregateResult>();
        List<AggregateResult> totalUnqualifiedLeads = new List<AggregateResult>();

        if(pId == 'All'){
            totalLeads = [select owner.name ownerName, COUNT(Id) all from Lead__c where Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                          group by owner.name]; 
            system.debug('totalLeads: '+totalLeads);
        }else if(pId != 'All'){
            totalLeads = [select owner.name ownerName, COUNT(Id) all from Lead__c where Project__c=:pId AND Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                          group by owner.name];
            system.debug('totalLeads: '+totalLeads);
        }
        if(pId =='All'){
            totalUnqualifiedLeads = [select owner.name ownerName, COUNT(Id) unLead from Lead__c where Status__c ='Unqualified' 
                                    AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            system.debug('totalUnqualifiedLeads: '+totalUnqualifiedLeads);
        }else if(pId != 'All'){
            totalUnqualifiedLeads = [select owner.name ownerName, COUNT(Id) unLead from Lead__c where Project__c=:pId AND Status__c ='Unqualified' 
                                    AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            system.debug('totalUnqualifiedLeads: '+totalUnqualifiedLeads);
        }
        

        if(!totalLeads.isEmpty() && totalLeads != null) {
            for(AggregateResult ag: totalLeads) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.totalLeads = (Decimal)ag.get('all');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.totalLeads = (Decimal)ag.get('all'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!totalUnqualifiedLeads.isEmpty() && totalUnqualifiedLeads != null) {
            for(AggregateResult ag: totalUnqualifiedLeads) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.unqualifiedLeads = (Decimal)ag.get('unLead'); 
                    if(rwc.totalLeads > 0)
                        rwc.unqualifiedPercent = ((rwc.unqualifiedLeads / rwc.totalLeads) * 100).setScale(2,System.RoundingMode.HALF_UP);
                    else 
                        rwc.unqualifiedPercent = 0;
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.unqualifiedLeads = (Decimal)ag.get('unLead'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        
        system.debug('wrapperMap: '+wrapperMap);
        return wrapperMap;
    }
    public class reportDataWrapperClass{
        @AuraEnabled 
        public Decimal totalLeads{get;set;}
        @AuraEnabled 
        public Decimal unqualifiedLeads{get;set;}
        @AuraEnabled 
        public Decimal unqualifiedPercent{get;set;}
        

        public reportDataWrapperClass() {
            this.totalLeads = 0;
            this.unqualifiedLeads = 0;
            this.unqualifiedPercent = 0;
        }
    }
}