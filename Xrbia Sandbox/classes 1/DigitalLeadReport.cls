public with sharing class DigitalLeadReport {
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
        List<AggregateResult> noOfLeadAssignedList = new List<AggregateResult>();
        List<AggregateResult> callAttemptedList = new List<AggregateResult>();
        List<AggregateResult> callNotAttemptedList = new List<AggregateResult>();
        List<AggregateResult> callReceivedByUniqueLeadList = new List<AggregateResult>();
        List<AggregateResult> callNotReceivedByUniqueLeadList = new List<AggregateResult>();
        List<AggregateResult> cnrMoreThan5List = new List<AggregateResult>();
        List<AggregateResult> unqualifiedDueToCNRList = new List<AggregateResult>();
        Decimal totalAssignedLeads = 0;
        Decimal totalcallsAttempted = 0;
        Decimal totalcallsNotAttempted = 0;
        Decimal totalcallsReceivedByUniqueLeads = 0;
        Decimal totalcallsNotReceivedByUniqueLeads = 0;
        Decimal totalcnrMoreThan5 = 0;
        Decimal totalunqualifiedDueToCNR = 0;
        

        if(pId == 'All'){
            noOfLeadAssignedList = [select owner.Name ownerName, COUNT(Id) lCount from Lead__c where (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web') 
                                    AND Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('noOfLeadAssignedList::'+noOfLeadAssignedList);
        }else if(pId != 'All'){
            noOfLeadAssignedList = [select owner.Name ownerName, COUNT(Id) lCount from Lead__c where (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web') AND Project__c =:pId  
                                    AND Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('noOfLeadAssignedList::'+noOfLeadAssignedList);
        }
        if(pId == 'All'){
            callAttemptedList = [select owner.Name ownerName, COUNT(Id) attemptedCall from Lead__c where (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web') 
                                AND Presales_Call_Count__c > 0 AND Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('callAttemptedList::'+callAttemptedList);
        }else if(pId != 'All'){
            callAttemptedList = [select owner.Name ownerName, COUNT(Id) attemptedCall from Lead__c where Project__c=:pId AND (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web') 
                                AND Presales_Call_Count__c > 0  AND Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('callAttemptedList::'+callAttemptedList);
        }
        if(pId == 'All'){
            callNotAttemptedList = [select owner.Name ownerName, COUNT(Id) notAttemptedCall from Lead__c where (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web') 
                                    AND (Presales_Call_Count__c = 0 OR Presales_Call_Count__c = null) AND Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('callNotAttemptedList::'+callNotAttemptedList);
        }else if(pId != 'All'){
            callNotAttemptedList = [select owner.Name ownerName, COUNT(Id) notAttemptedCall from Lead__c where Project__c=:pId AND (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web') 
                                    AND (Presales_Call_Count__c = 0 OR Presales_Call_Count__c = null) AND Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('callNotAttemptedList::'+callNotAttemptedList);
        }
        if(pId == 'All'){
            callReceivedByUniqueLeadList = [select owner.Name ownerName, COUNT(Id) receivedCallByUniqueLead from Lead__c where (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web') 
                                            AND Total_Call_Duration__c > 0 AND Presales_Call_Count__c > 0 AND Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('callReceivedByUniqueLeadList::'+callReceivedByUniqueLeadList);
        }else if(pId != 'All'){
            callReceivedByUniqueLeadList = [select owner.Name ownerName, COUNT(Id) receivedCallByUniqueLead from Lead__c where Project__c=:pId AND (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web')
                                            AND Total_Call_Duration__c > 0 AND Presales_Call_Count__c > 0 AND Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('callReceivedByUniqueLeadList::'+callReceivedByUniqueLeadList);
        }
        if(pId == 'All'){
            callNotReceivedByUniqueLeadList = [select owner.Name ownerName, COUNT(Id) notReceivedCallByUniqueLead from Lead__c where (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web') 
                                               AND (Total_Call_Duration__c = 0 OR Total_Call_Duration__c = null) AND Presales_Call_Count__c > 0 AND Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('callNotReceivedByUniqueLeadList::'+callNotReceivedByUniqueLeadList);
        }else if(pId != 'All'){
            callNotReceivedByUniqueLeadList = [select owner.Name ownerName, COUNT(Id) notReceivedCallByUniqueLead from Lead__c where Project__c=:pId AND (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web') 
                                               AND (Total_Call_Duration__c = 0 OR Total_Call_Duration__c = null) AND Presales_Call_Count__c > 0 AND Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('callNotReceivedByUniqueLeadList::'+callNotReceivedByUniqueLeadList);
        }
        if(pId == 'All'){
            cnrMoreThan5List = [select owner.Name ownerName, COUNT(Id) cnrCounter from Lead__c where (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web') 
                                AND Not_Responding_Count__c > 5 AND Presales_Call_Count__c > 0 AND (Total_Call_Duration__c = 0 OR Total_Call_Duration__c = null) AND Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('cnrMoreThan5List::'+cnrMoreThan5List);
        }else if(pId != 'All'){
            cnrMoreThan5List = [select owner.Name ownerName, COUNT(Id) cnrCounter from Lead__c where Project__c=:pId AND (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web') 
                                AND Not_Responding_Count__c > 5 AND Presales_Call_Count__c > 0 AND (Total_Call_Duration__c = 0 OR Total_Call_Duration__c = null) AND Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('cnrMoreThan5List::'+cnrMoreThan5List);
        }
        if(pId == 'All'){
            unqualifiedDueToCNRList = [select owner.Name ownerName, COUNT(Id) unqualifiedDueToCNR from Lead__c where (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web') 
                                       AND Not_Responding_Count__c > 5 AND Status__c= 'Unqualified' AND Presales_Call_Count__c > 0 AND (Total_Call_Duration__c = 0 OR Total_Call_Duration__c = null) AND  
                                       Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('unqualifiedDueToCNRList::'+unqualifiedDueToCNRList);
        }else if(pId == 'All'){
            unqualifiedDueToCNRList = [select owner.Name ownerName, COUNT(Id) unqualifiedDueToCNR from Lead__c where Project__c=:pId AND (Lead_Created_From__c = 'Facebook'  OR Lead_Created_From__c = 'Web') 
                                       AND Not_Responding_Count__c > 5 AND Status__c= 'Unqualified' AND Presales_Call_Count__c > 0 AND (Total_Call_Duration__c = 0 OR Total_Call_Duration__c = null) AND  
                                       Created_Date__c>=:sdate AND Created_Date__c<=:edate group by owner.name];
            System.debug('unqualifiedDueToCNRList::'+unqualifiedDueToCNRList);
        }


        if(!noOfLeadAssignedList.isEmpty() && noOfLeadAssignedList != null){
            for(AggregateResult ag:noOfLeadAssignedList){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.AssignedLeads = (Decimal)ag.get('lCount'); 
                    totalAssignedLeads += (Decimal)ag.get('lCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.AssignedLeads = (Decimal)ag.get('lCount'); 
                    totalAssignedLeads += (Decimal)ag.get('lCount');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!callAttemptedList.isEmpty() && callAttemptedList != null){
            for(AggregateResult ag: callAttemptedList){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.callsAttempted = (Decimal)ag.get('attemptedCall');
                    totalcallsAttempted += (Decimal)ag.get('attemptedCall');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.callsAttempted = (Decimal)ag.get('attemptedCall');
                    totalcallsAttempted += (Decimal)ag.get('attemptedCall');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!callNotAttemptedList.isEmpty() && callNotAttemptedList != null){
            for(AggregateResult ag: callNotAttemptedList){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.callsNotAttempted = (Decimal)ag.get('notAttemptedCall'); 
                    totalcallsNotAttempted += (Decimal)ag.get('notAttemptedCall');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.callsNotAttempted = (Decimal)ag.get('notAttemptedCall'); 
                    totalcallsNotAttempted += (Decimal)ag.get('notAttemptedCall');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!callReceivedByUniqueLeadList.isEmpty() && callReceivedByUniqueLeadList != null){
            for(AggregateResult ag: callReceivedByUniqueLeadList){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.callsReceivedByUniqueLeads = (Decimal)ag.get('receivedCallByUniqueLead');
                    totalcallsReceivedByUniqueLeads += (Decimal)ag.get('receivedCallByUniqueLead');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.callsReceivedByUniqueLeads = (Decimal)ag.get('receivedCallByUniqueLead');
                    totalcallsReceivedByUniqueLeads += (Decimal)ag.get('receivedCallByUniqueLead');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!callNotReceivedByUniqueLeadList.isEmpty() && callNotReceivedByUniqueLeadList != null){
            for(AggregateResult ag: callNotReceivedByUniqueLeadList){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.callsNotReceivedByUniqueLeads = (Decimal)ag.get('notReceivedCallByUniqueLead');
                    totalcallsNotReceivedByUniqueLeads += (Decimal)ag.get('notReceivedCallByUniqueLead');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.callsNotReceivedByUniqueLeads = (Decimal)ag.get('notReceivedCallByUniqueLead');
                    totalcallsNotReceivedByUniqueLeads += (Decimal)ag.get('notReceivedCallByUniqueLead');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!cnrMoreThan5List.isEmpty() && cnrMoreThan5List != null){
            for(AggregateResult ag: cnrMoreThan5List){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.cnrMoreThan5 = (Decimal)ag.get('cnrCounter');
                    totalcnrMoreThan5 += (Decimal)ag.get('cnrCounter');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.cnrMoreThan5 = (Decimal)ag.get('cnrCounter'); 
                    totalcnrMoreThan5 += (Decimal)ag.get('cnrCounter');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!unqualifiedDueToCNRList.isEmpty() && unqualifiedDueToCNRList != null){
            for(AggregateResult ag: unqualifiedDueToCNRList){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.unqualifiedDueToCNR = (Decimal)ag.get('unqualifiedDueToCNR'); 
                    totalunqualifiedDueToCNR += (Decimal)ag.get('unqualifiedDueToCNR');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.unqualifiedDueToCNR = (Decimal)ag.get('unqualifiedDueToCNR'); 
                    totalunqualifiedDueToCNR += (Decimal)ag.get('unqualifiedDueToCNR');
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        reportDataWrapperClass rwc = new reportDataWrapperClass();
        rwc.AssignedLeads = totalAssignedLeads;
        rwc.callsAttempted = totalcallsAttempted;
        rwc.callsNotAttempted = totalcallsNotAttempted;
        rwc.callsReceivedByUniqueLeads = totalcallsReceivedByUniqueLeads;
        rwc.callsNotReceivedByUniqueLeads = totalcallsNotReceivedByUniqueLeads;
        rwc.cnrMoreThan5 = totalcnrMoreThan5;
        rwc.unqualifiedDueToCNR = totalunqualifiedDueToCNR;
        if(pId == 'All'){
            wrapperMap.put('Total', rwc);
        }

        system.debug('wrapperMap: '+wrapperMap);
        return wrapperMap;
    }
        public class reportDataWrapperClass{
            @AuraEnabled 
            public Decimal AssignedLeads{get;set;}
            @AuraEnabled 
            public Decimal callsAttempted{get;set;}
            @AuraEnabled 
            public Decimal callsNotAttempted{get;set;}
            @AuraEnabled 
            public Decimal callsReceivedByUniqueLeads{get;set;}
            @AuraEnabled 
            public Decimal callsNotReceivedByUniqueLeads{get;set;}
            @AuraEnabled 
            public Decimal cnrMoreThan5{get;set;}
            @AuraEnabled 
            public Decimal unqualifiedDueToCNR{get;set;}

            public reportDataWrapperClass() {
                this.AssignedLeads = 0;
                this.callsAttempted = 0;
                this.callsNotAttempted = 0;
                this.callsReceivedByUniqueLeads = 0;
                this.callsNotReceivedByUniqueLeads = 0;
                this.cnrMoreThan5 = 0;
                this.unqualifiedDueToCNR = 0;
        }
    }
        
}