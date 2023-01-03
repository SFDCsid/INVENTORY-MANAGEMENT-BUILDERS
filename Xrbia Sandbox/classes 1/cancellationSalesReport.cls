public with sharing class cancellationSalesReport {
    
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
        List<AggregateResult> totalCancelList = new List<AggregateResult>();
        List<AggregateResult> agreementValueList = new List<AggregateResult>();

        if(pId == 'All'){
            totalCancelList= [select owner.name ownerName, COUNT(Id) cancelBook from Opportunity__c where Booking__c!= null AND 
                             Booking__r.Booking_Stages__c ='Booking Cancelled' AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate
                             group by owner.name];
            System.debug('totalCancelList::'+totalCancelList);
        }else if(pId != 'All'){
            totalCancelList= [select owner.name ownerName, COUNT(Id) cancelBook from Opportunity__c where Booking__c!= null AND Project__c =: pId AND
                             Booking__r.Booking_Stages__c ='Booking Cancelled' AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate
                             group by owner.name];
            System.debug('totalCancelList::'+totalCancelList);
        }

        if(pId == 'All'){
            agreementValueList = [select owner.name ownerName, SUM(Booking__r.Agreement_Value__c) agrValue from Opportunity__c where Booking__c!= null AND
                                  Booking__r.Booking_Stages__c ='Booking Cancelled' AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate
                                  group by owner.name];
            System.debug('agreementValueList::'+agreementValueList);
        }else if(pId != 'All'){
            agreementValueList = [select owner.name ownerName, SUM(Booking__r.Agreement_Value__c) agrValue from Opportunity__c where Booking__c!= null AND Project__c =: pId AND
                                  Booking__r.Booking_Stages__c ='Booking Cancelled' AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate
                                  group by owner.name];
            System.debug('agreementValueList::'+agreementValueList);
        }

        if(!totalCancelList.isEmpty() && totalCancelList != null) {
            for(AggregateResult ag: totalCancelList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                                        	
					if((Decimal)ag.get('cancelBook') > 0)           
                        rwc.totalCancelBooking = (Decimal)ag.get('cancelBook');
                    else
                        rwc.totalCancelBooking = 0;
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                                        
                    if((Decimal)ag.get('cancelBook') > 0)           
                        rwc.totalCancelBooking = (Decimal)ag.get('cancelBook');
                    else
                        rwc.totalCancelBooking = 0;
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!agreementValueList.isEmpty() && agreementValueList != null) {
            for(AggregateResult ag: agreementValueList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.agreementCount = (Decimal)ag.get('agrValue');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.agreementCount = (Decimal)ag.get('agrValue'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }

        System.debug('wrapperMap::'+wrapperMap);
        return wrapperMap;
    }
    public class reportDataWrapperClass{
        @AuraEnabled 
        public Decimal totalCancelBooking{get;set;}
        @AuraEnabled 
        public Decimal agreementCount{get;set;}
        @AuraEnabled 
        public Decimal clAmountCount{get;set;}
        @AuraEnabled 
        public Decimal refamountrequestedCount{get;set;}
        @AuraEnabled 
        public Decimal refamountapprovedCount{get;set;}
        @AuraEnabled 
        public Decimal refamountpaidCount{get;set;}
        
        public reportDataWrapperClass() {
            this.totalCancelBooking = 0;
            this.agreementCount = 0;
            this.clAmountCount = 0;
            this.refamountrequestedCount = 0;
            this.refamountapprovedCount = 0;
            this.refamountpaidCount = 0;
        }
    }
}