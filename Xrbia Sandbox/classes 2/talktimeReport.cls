public with sharing class talktimeReport {
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
        Date startDate = sdate;
        Date endDate = edate;
        Integer noOfDays = startDate.daysBetween( endDate );
        system.debug( 'Output is ' + noOfDays );
        
        
        List<AggregateResult> totalTTList = new List<AggregateResult>();
        if(pId == 'All'){
            totalTTList = [select owner.Name ownername, SUM(CallDurationInSeconds) total from task where RecordType.Name ='Presales Call' 
                           AND Created_Date__c>=:sdate AND Created_Date__c <=:edate group by owner.Name];
            system.debug('totalTTList: '+totalTTList);   
        }else if(pId != 'All'){
            totalTTList = [select owner.Name ownername, SUM(CallDurationInSeconds) total from task where RecordType.Name ='Presales Call' AND  Project__c=:pId
                           AND Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.Name];
            system.debug('totalTTList: '+totalTTList);   
        }       
          
        if(!totalTTList.isEmpty() && totalTTList != null) {
            for(AggregateResult ag: totalTTList) {
                system.debug('ag:'+ag);
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	Decimal TalkTime = (Decimal)ag.get('total');
                    system.debug('TalkTime:'+TalkTime);
                    rwc.totalTalkTime = (TalkTime/3600).setScale(2,System.RoundingMode.HALF_UP);
                    System.debug('totalTalkTime:'+rwc.totalTalkTime);
                    rwc.avgTalkTime = (rwc.totalTalkTime / noOfDays).setScale(2,System.RoundingMode.HALF_UP);
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();   
                    Decimal TalkTime = (Decimal)ag.get('total');
                    System.debug(TalkTime);
                    if(TalkTime > 0 ){
                        rwc.totalTalkTime = (TalkTime/3600).setScale(2,System.RoundingMode.HALF_UP);    
                        System.debug('totalTalkTime:'+rwc.totalTalkTime);  
                    }
                    rwc.avgTalkTime = (rwc.totalTalkTime / noOfDays).setScale(2,System.RoundingMode.HALF_UP);
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }        
        
        system.debug('wrapperMap: '+wrapperMap);
        return wrapperMap;
    }
    public class reportDataWrapperClass{
        @AuraEnabled 
        public Decimal totalTalkTime{get;set;}
        @AuraEnabled 
        public Decimal avgTalkTime{get;set;}
        
        public reportDataWrapperClass() {
            this.totalTalkTime = 0;
            this.avgTalkTime = 0;           
        }
    }
}