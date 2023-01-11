public without sharing class SiteVisitDateValidator{

    public static void validateSiteVisitDate(list <sObject> newRecords){
        if(Trigger.isExecuting){
            for(SObject l : newRecords){
                if(l.get('Date_of_Site_Visit__c') != null){
                    
                    datetime siteVisitDate = (datetime)l.get('Date_of_Site_Visit__c');
                    System.debug('Date_of_Site_Visit__c.timeGmt()'+siteVisitDate.timeGmt());
                    System.debug('Date_of_Site_Visit__c.time()'+siteVisitDate.time());
                    
                    /*if(!isValid((datetime)l.get('Date_of_Site_Visit__c'))){
                        l.addError(Label.Invalid_Site_Visit_DateTime);
                    }*/
                }
            }
        }
    }
    
    public static boolean isValid(datetime siteVisitDate){
        boolean isValid = false;
        
        Time timeOfVisit = siteVisitDate.timeGmt();
        // UTC 3:30 am is 9:00 am IST
        // UTC 12:30 PM is 6:00 pm IST
        System.debug(timeOfVisit);
        
        System.debug('siteVisitDate.timeGmt()=>'+siteVisitDate.time());
        
        if(timeOfVisit.hour() >= 3 && timeOfVisit.hour() <= 12){
            isValid = true;
            if((timeOfVisit.hour() == 3 && timeOfVisit.minute() < 30) || (timeOfVisit.hour() == 12 && timeOfVisit.minute() > 30))
                isValid = false;
        }
        
        return isValid;
    }
}