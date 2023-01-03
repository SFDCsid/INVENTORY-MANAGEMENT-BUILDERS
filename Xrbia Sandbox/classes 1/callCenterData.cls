public with sharing class callCenterData {

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
        List<AggregateResult> incomingGenerated = new List<AggregateResult>();
        List<AggregateResult> incomingCallsFormingLead = new List<AggregateResult>();
        List<AggregateResult> incomingCallsNotFormingLead = new List<AggregateResult>();
        List<AggregateResult> incomingCallsAssigned = new List<AggregateResult>();
        List<AggregateResult> answeredCallMorethan20 = new List<AggregateResult>();
        List<AggregateResult> answeredCallLessthan20 = new List<AggregateResult>();
        List<AggregateResult> totalMissedCall = new List<AggregateResult>();
        List<AggregateResult> uniqueMissedCall = new List<AggregateResult>();
        List<AggregateResult> callBackUniqueLeads = new List<AggregateResult>();
        List<AggregateResult> callReceivedByUniqueLeads = new List<AggregateResult>();
        List<AggregateResult> callNotReceivedByUniqueLeads = new List<AggregateResult>();
        List<AggregateResult> cnrMoreThan5 = new List<AggregateResult>();
        List<AggregateResult> unqualifiedDueToCnr = new List<AggregateResult>();
        Decimal totalIncomingCalls = 0;
        Decimal totalIncomingAssignedCalls = 0;
        Decimal totalIncomingFormingLeads = 0;
        Decimal totalIncomingNotFormingLeads = 0;
        Decimal totalmoreThan20s = 0;
        Decimal totallessThan20s = 0;
        Decimal totalMissedCalls = 0;
        Decimal totalUniqueMissLead = 0;
        Decimal totalCallBackToUniqueLead = 0;
        Decimal totalCallReceivedByUnique = 0;
        Decimal totalCallNotReceivedByUnique = 0;
        Decimal totalCallNotReceived = 0;
        Decimal totalUnqualifiedDueToCNR = 0;
        
        if(pId == 'All'){
            incomingGenerated = [select owner.name ownerName, COUNT(WhatId) incoming from task WHERE CallType=:'Inbound' AND whatId != Null 
                             	AND RecordType.Name ='Presales Call' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('incomingGenerated::'+incomingGenerated);
        }else if(pId != 'All'){
            incomingGenerated = [select owner.name ownerName, COUNT(WhatId) incoming from task WHERE CallType=:'Inbound' AND whatId != Null AND Project__c=:pId
                            	AND RecordType.Name ='Presales Call' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('incomingGenerated::'+incomingGenerated);
        }
        if(pId == 'All'){
            incomingCallsAssigned = [select owner.name ownerName, COUNT(WhatId) incomingAssigned from task where CallType='Inbound' AND whatId != Null 
                                	AND RecordType.Name ='Presales Call' AND OwnerId != Null AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('incomingCallsAssigned::'+incomingCallsAssigned);
        }else if(pId != 'All'){
            incomingCallsAssigned = [select owner.name ownerName, COUNT(WhatId) incomingAssigned from task where CallType='Inbound' AND whatId != Null AND Project__c=:pId
                                	AND RecordType.Name ='Presales Call' AND OwnerId != Null AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('incomingCallsAssigned::'+incomingCallsAssigned);
        }
        if(pId =='All'){
            incomingCallsFormingLead = [select owner.name ownerName, COUNT(WhatId) formingleads from task where CallType='Inbound' 
                                    	AND RecordType.Name ='Presales Call' AND Is_New_Lead_Created__c =:true AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('incomingCallsFormingLead::'+incomingCallsFormingLead);
        }else if(pId !='All'){
            incomingCallsFormingLead = [select owner.name ownerName, COUNT(WhatId) formingleads from task where Project__c=:pId AND CallType='Inbound' 
                                    	AND RecordType.Name ='Presales Call' AND Is_New_Lead_Created__c =:true AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('incomingCallsFormingLead::'+incomingCallsFormingLead);
        }
        if(pId == 'All'){
            incomingCallsNotFormingLead = [select owner.name ownerName, COUNT(WhatId) notFormingLeads from task where CallType='Inbound' 
                                      	   AND RecordType.Name ='Presales Call' AND Is_New_Lead_Created__c =:false AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('incomingCallsNotFormingLead::'+incomingCallsNotFormingLead);
        }else if(pId != 'All'){
            incomingCallsNotFormingLead = [select owner.name ownerName, COUNT(WhatId) notFormingLeads from task where Project__c=:pId AND CallType='Inbound' 
                                      	   AND RecordType.Name ='Presales Call' AND Is_New_Lead_Created__c =:false AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('incomingCallsNotFormingLead::'+incomingCallsNotFormingLead);
        } 
        if(pId == 'All'){
            answeredCallMorethan20 = [select owner.name ownerName, COUNT(WhatId) moreThan20 from task where CallType='Inbound' 
                                 	  AND RecordType.Name ='Presales Call' AND CallDurationInSeconds != null AND CallDurationInSeconds > 20 AND Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                                 	  group by owner.name];
        	System.debug('answeredCallMorethan20::'+answeredCallMorethan20);
        }else if(pId != 'All'){
            answeredCallMorethan20 = [select owner.name ownerName, COUNT(WhatId) moreThan20 from task where Project__c=:pId AND CallType='Inbound' 
                                 	  AND RecordType.Name ='Presales Call' AND CallDurationInSeconds != null AND CallDurationInSeconds > 20 AND Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                                 	  group by owner.name];
        	System.debug('answeredCallMorethan20::'+answeredCallMorethan20);
        }
        if(pId =='All'){
            answeredCallLessthan20 = [select owner.name ownerName, COUNT(WhatId) lessThan20 from task where CallType='Inbound' 
                                 	  AND RecordType.Name ='Presales Call' AND CallDurationInSeconds != null AND CallDurationInSeconds < 20 AND Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                                 	  group by owner.name];
        	System.debug('answeredCallLessthan20::'+answeredCallLessthan20);
        }else if(pId !='All'){
            answeredCallLessthan20 = [select owner.name ownerName, COUNT(WhatId) lessThan20 from task where Project__c=:pId AND CallType='Inbound' 
                                 	  AND RecordType.Name ='Presales Call' AND CallDurationInSeconds != null AND CallDurationInSeconds < 20 AND Created_Date__c >=:sdate AND Created_Date__c <=:edate 
                                 	  group by owner.name];
        	System.debug('answeredCallLessthan20::'+answeredCallLessthan20);
        }
        if(pId == 'All'){
            totalMissedCall = [select owner.name ownerName, COUNT(WhatId) totalMissed from task where Subject like '%missed%' AND 
                          	   RecordType.Name ='Presales Call' AND CallType='Inbound' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('totalMissedCall::'+totalMissedCall);
        }else if(pId != 'All'){
            totalMissedCall = [select owner.name ownerName, COUNT(WhatId) totalMissed from task where Subject like '%missed%' AND Project__c=:pId AND
                          	   RecordType.Name ='Presales Call' AND CallType='Inbound' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('totalMissedCall::'+totalMissedCall);
        }
        if(pId == 'All'){
            uniqueMissedCall = [select owner.name ownerName, COUNT_DISTINCT(WhatId) uniqueMissed, MAX(CreatedDate) cd from task where Subject like '%missed%' AND RecordType.Name ='Presales Call' AND
                           	   	Created_Date__c >=:sdate AND Created_Date__c <=:edate AND CallType='Inbound' group by owner.name];
        	System.debug('uniqueMissedCall::'+uniqueMissedCall);
        }else if(pId != 'All'){
            uniqueMissedCall = [select owner.name ownerName, COUNT_DISTINCT(WhatId) uniqueMissed, MAX(CreatedDate) cd from task where Subject like '%missed%' AND Project__c=:pId AND RecordType.Name ='Presales Call' AND
                           		Created_Date__c >=:sdate AND Created_Date__c <=:edate AND CallType='Inbound' group by owner.name];
        	System.debug('uniqueMissedCall::'+uniqueMissedCall);
        }
        if(pId =='All'){
            callBackUniqueLeads = [select owner.name ownerName, COUNT_DISTINCT(WhatId) cbUnique, MAX(CreatedDate) cd from task where CallType = 'Outbound'
                              	   AND RecordType.Name ='Presales Call' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('callBackUniqueLeads::'+callBackUniqueLeads);
        }else if(pId !='All'){
            callBackUniqueLeads = [select owner.name ownerName, COUNT_DISTINCT(WhatId) cbUnique, MAX(CreatedDate) cd from task where Project__c=:pId AND CallType = 'Outbound'
                              	   AND RecordType.Name ='Presales Call' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('callBackUniqueLeads::'+callBackUniqueLeads);
        }
        if(pId == 'All'){
        	callReceivedByUniqueLeads = [select owner.name ownerName, COUNT_DISTINCT(WhatId) CRUnique, MAX(CreatedDate) cd from task where CallType = 'Outbound' AND Call_Status__c ='Answered'                                      
                                    	AND RecordType.Name ='Presales Call' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('callReceivedByUniqueLeads::'+callReceivedByUniqueLeads);   
        }else if(pId != 'All'){
        	callReceivedByUniqueLeads = [select owner.name ownerName, COUNT_DISTINCT(WhatId) CRUnique, MAX(CreatedDate) cd from task where Project__c=:pId AND CallType = 'Outbound' AND Call_Status__c ='Answered'                                      
                                    	AND RecordType.Name ='Presales Call' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('callReceivedByUniqueLeads::'+callReceivedByUniqueLeads);   
        }
        if(pId == 'All'){
        	callNotReceivedByUniqueLeads = [select owner.name ownerName, COUNT_DISTINCT(WhatId) CRNUnique, MAX(CreatedDate) cd from task where CallType = 'Outbound' AND Call_Status__c ='NotAnswered'                                      
                                    	AND RecordType.Name ='Presales Call' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('callNotReceivedByUniqueLeads::'+callNotReceivedByUniqueLeads);   
        }else if(pId != 'All'){
        	callNotReceivedByUniqueLeads = [select owner.name ownerName, COUNT_DISTINCT(WhatId) CRNUnique, MAX(CreatedDate) cd from task where Project__c=:pId AND CallType = 'Outbound' AND Call_Status__c ='NotAnswered'                                      
                                    	AND RecordType.Name ='Presales Call' AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('callNotReceivedByUniqueLeads::'+callNotReceivedByUniqueLeads);   
        }
        if(pId == 'All'){
            cnrMoreThan5 = [select owner.name ownerName, COUNT_DISTINCT(WhatId) cnrCount from Task where 
                            WhatId IN (Select Id from Lead__c where CNR_Counter__c > 5) AND
                            Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('cnrMoreThan5::'+cnrMoreThan5);
        }else if(pId != 'All'){
            cnrMoreThan5 = [select owner.name ownerName, COUNT_DISTINCT(WhatId) cnrCount from Task where Project__c =: pId AND
                            WhatId IN (Select Id from Lead__c where CNR_Counter__c > 5) AND
                            Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
        	System.debug('cnrMoreThan5::'+cnrMoreThan5);
        }
        if(pId == 'All'){
            unqualifiedDueToCnr = [select owner.name ownerName, COUNT(Id) unqDueToCNR from Lead__c where CNR_Counter__c > 5 AND Created_Date__c >=:sdate AND 
                              	   Created_Date__c <=:edate AND Status__c ='Unqualified' group by owner.name];
        	System.debug('unqualifiedDueToCnr::'+unqualifiedDueToCnr);
        }else if(pId != 'All'){
            unqualifiedDueToCnr = [select owner.name ownerName, COUNT(Id) unqDueToCNR from Lead__c where Project__c=:pId AND CNR_Counter__c > 5 AND Created_Date__c >=:sdate AND 
                              	   Created_Date__c <=:edate AND Status__c ='Unqualified' group by owner.name];
        	System.debug('unqualifiedDueToCnr::'+unqualifiedDueToCnr);
        }

        if(!incomingGenerated.isEmpty() && incomingGenerated != null){
            for(AggregateResult ag: incomingGenerated){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.incomingCalls = (Decimal)ag.get('incoming');
                    totalIncomingCalls += (Decimal)ag.get('incoming');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }else{
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.incomingCalls = (Decimal)ag.get('incoming');
                    totalIncomingCalls += (Decimal)ag.get('incoming');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }
        if(!incomingCallsAssigned.isEmpty() && incomingCallsAssigned != null){
            for(AggregateResult ag: incomingCallsAssigned){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.incomingAssignedCalls = (Decimal)ag.get('incomingAssigned');
                    totalIncomingAssignedCalls += (Decimal)ag.get('incomingAssigned');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }else{
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.incomingAssignedCalls = (Decimal)ag.get('incomingAssigned');
                    totalIncomingAssignedCalls += (Decimal)ag.get('incomingAssigned');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }
        if(!incomingCallsFormingLead.isEmpty() && incomingCallsFormingLead != null){
            for(AggregateResult ag: incomingCallsFormingLead){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.incomingFormingLeads = (Decimal)ag.get('formingleads');
                    totalIncomingFormingLeads += (Decimal)ag.get('formingleads');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }else{
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.incomingFormingLeads = (Decimal)ag.get('formingleads');
                    totalIncomingFormingLeads += (Decimal)ag.get('formingleads');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }
        if(!incomingCallsNotFormingLead.isEmpty() && incomingCallsNotFormingLead != null){
            for(AggregateResult ag: incomingCallsNotFormingLead){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.incomingNotFormingLeads = (Decimal)ag.get('notFormingLeads');
                    totalIncomingNotFormingLeads += (Decimal)ag.get('notFormingLeads');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }else{
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.incomingNotFormingLeads = (Decimal)ag.get('notFormingLeads');
                    totalIncomingNotFormingLeads += (Decimal)ag.get('notFormingLeads');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }
        if(!answeredCallMorethan20.isEmpty() && answeredCallMorethan20 != null){
            for(AggregateResult ag: answeredCallMorethan20){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.moreThan20s = (Decimal)ag.get('moreThan20');
                    totalmoreThan20s +=  (Decimal)ag.get('moreThan20');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }else{
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.moreThan20s = (Decimal)ag.get('moreThan20');
                    totalmoreThan20s +=  (Decimal)ag.get('moreThan20');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }
        if(!answeredCallLessthan20.isEmpty() && answeredCallLessthan20 != null){
            for(AggregateResult ag: answeredCallLessthan20){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.lessThan20s = (Decimal)ag.get('lessThan20');
                    totallessThan20s += (Decimal)ag.get('lessThan20');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }else{
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.lessThan20s = (Decimal)ag.get('lessThan20');
                    totallessThan20s += (Decimal)ag.get('lessThan20');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }
        if(!totalMissedCall.isEmpty() && totalMissedCall != null){
            for(AggregateResult ag: totalMissedCall){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.totalMissCall = (Decimal)ag.get('totalMissed');
                    totalMissedCalls += (Decimal)ag.get('totalMissed');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }else{
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.totalMissCall = (Decimal)ag.get('totalMissed');
                    totalMissedCalls += (Decimal)ag.get('totalMissed');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }
        Map<String, DateTime> uniqueMissedCallMap = new Map<String, DateTime>();
        Set<Id> uniqueLeadId = new Set<Id>();
        if(!uniqueMissedCall.isEmpty() && uniqueMissedCall != null){
            for(AggregateResult ag: uniqueMissedCall){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.uniqueMissLead = (Decimal)ag.get('uniqueMissed');
                    totalUniqueMissLead += (Decimal)ag.get('uniqueMissed');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }else{
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.uniqueMissLead = (Decimal)ag.get('uniqueMissed');
                    totalUniqueMissLead += (Decimal)ag.get('uniqueMissed');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
                if(uniqueMissedCallMap.containsKey((String)ag.get('ownerName'))) {
                    if((DateTime)ag.get('cd') > uniqueMissedCallMap.get((String)ag.get('ownerName'))) {
                        uniqueMissedCallMap.put((String)ag.get('ownerName'), (DateTime)ag.get('cd'));
                    }
                } else {
                    uniqueMissedCallMap.put((String)ag.get('ownerName'), (DateTime)ag.get('cd'));
                }
                uniqueLeadId.add((Id)ag.get('uniqueMissed'));
            }
        }
        if(!callBackUniqueLeads.isEmpty() && callBackUniqueLeads != null){
            for(AggregateResult ag: callBackUniqueLeads){
                if(uniqueLeadId.contains((Id)ag.get('cbUnique'))) {
                    if(uniqueMissedCallMap.containsKey((String)ag.get('ownerName'))) {
                        if(uniqueMissedCallMap.get((String)ag.get('ownerName')) < (DateTime)ag.get('cd')) {
                            if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                                reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                                rwc.callBackToUniqueLead = (Decimal)ag.get('cbUnique');
                                totalCallBackToUniqueLead += (Decimal)ag.get('cbUnique');
                                wrapperMap.put((String)ag.get('ownerName'),rwc);
                            }else{
                                reportDataWrapperClass rwc = new reportDataWrapperClass();
                                rwc.callBackToUniqueLead = (Decimal)ag.get('cbUnique');
                                totalCallBackToUniqueLead += (Decimal)ag.get('cbUnique');
                                wrapperMap.put((String)ag.get('ownerName'),rwc);
                            }
                        }
                    }
                }
            }
        }
        if(!callReceivedByUniqueLeads.isEmpty() && callReceivedByUniqueLeads != null){
            for(AggregateResult ag: callReceivedByUniqueLeads){
                if(uniqueLeadId.contains((Id)ag.get('cbUnique'))) {
                    if(uniqueMissedCallMap.containsKey((String)ag.get('ownerName'))) {
                        if(uniqueMissedCallMap.get((String)ag.get('ownerName')) < (DateTime)ag.get('cd')) {
                            if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                                reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                                rwc.callReceivedByUnique = (Decimal)ag.get('CRUnique');
                                totalCallReceivedByUnique += (Decimal)ag.get('CRUnique');
                                wrapperMap.put((String)ag.get('ownerName'),rwc);
                            }else{
                                reportDataWrapperClass rwc = new reportDataWrapperClass();
                                rwc.callReceivedByUnique = (Decimal)ag.get('CRUnique');
                                totalCallReceivedByUnique += (Decimal)ag.get('CRUnique');
                                wrapperMap.put((String)ag.get('ownerName'),rwc);
                            }
                        }
                    }
                }
            }
        }
        if(!callNotReceivedByUniqueLeads.isEmpty() && callNotReceivedByUniqueLeads != null){
            for(AggregateResult ag: callNotReceivedByUniqueLeads){
                if(uniqueLeadId.contains((Id)ag.get('cbUnique'))) {
                    if(uniqueMissedCallMap.containsKey((String)ag.get('ownerName'))) {
                        if(uniqueMissedCallMap.get((String)ag.get('ownerName')) < (DateTime)ag.get('cd')) {
                            if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                                reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                                rwc.callNotReceivedByUnique = (Decimal)ag.get('CRNUnique');
                                totalCallNotReceivedByUnique += (Decimal)ag.get('CRNUnique');
                                wrapperMap.put((String)ag.get('ownerName'),rwc);
                            }else{
                                reportDataWrapperClass rwc = new reportDataWrapperClass();
                                rwc.callNotReceivedByUnique = (Decimal)ag.get('CRNUnique');
                                totalCallNotReceivedByUnique += (Decimal)ag.get('CRNUnique');
                                wrapperMap.put((String)ag.get('ownerName'),rwc);
                            }
                        }
                    }
                }
            }
        }
        if(!cnrMoreThan5.isEmpty() && cnrMoreThan5 != null){
            for(AggregateResult ag: cnrMoreThan5){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.callNotReceived = (Decimal)ag.get('cnrCount');
                    totalCallNotReceived += (Decimal)ag.get('cnrCount');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }else{
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.callNotReceived = (Decimal)ag.get('cnrCount');
                    totalCallNotReceived += (Decimal)ag.get('cnrCount');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }
        if(!unqualifiedDueToCnr.isEmpty() && unqualifiedDueToCnr != null){
            for(AggregateResult ag: unqualifiedDueToCnr){
                if(wrapperMap.containsKey((String)ag.get('ownerName'))){
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));
                    rwc.unqualifiedDueToCNR = (Decimal)ag.get('unqDueToCNR');
                    totalUnqualifiedDueToCNR += (Decimal)ag.get('unqDueToCNR');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }else{
                    reportDataWrapperClass rwc = new reportDataWrapperClass();
                    rwc.unqualifiedDueToCNR = (Decimal)ag.get('unqDueToCNR');
                    totalUnqualifiedDueToCNR += (Decimal)ag.get('unqDueToCNR');
                    wrapperMap.put((String)ag.get('ownerName'),rwc);
                }
            }
        }
        reportDataWrapperClass rwc = new reportDataWrapperClass();
        rwc.incomingCalls = totalIncomingCalls;
        rwc.incomingAssignedCalls = totalIncomingAssignedCalls;
        rwc.incomingFormingLeads = totalIncomingFormingLeads;
        rwc.incomingNotFormingLeads = totalIncomingNotFormingLeads;
        rwc.moreThan20s = totalmoreThan20s;
        rwc.lessThan20s = totallessThan20s;
        rwc.totalMissCall = totalMissedCalls;
        rwc.uniqueMissLead = totalUniqueMissLead;
        rwc.callBackToUniqueLead = totalCallBackToUniqueLead;
        rwc.callReceivedByUnique = totalCallReceivedByUnique;
        rwc.callNotReceivedByUnique = totalCallNotReceivedByUnique;
        rwc.callNotReceived = totalCallNotReceived;
        rwc.unqualifiedDueToCNR = totalUnqualifiedDueToCNR;
        if(pId=='All'){
            wrapperMap.put('Total', rwc);
        }

        system.debug('wrapperMap: '+wrapperMap);
        return wrapperMap;
    }
    public class reportDataWrapperClass{
        @AuraEnabled 
        public Decimal incomingCalls{get;set;}
        @AuraEnabled 
        public Decimal incomingAssignedCalls{get;set;}
        @AuraEnabled 
        public Decimal incomingFormingLeads{get;set;}
        @AuraEnabled 
        public Decimal incomingNotFormingLeads{get;set;}
        @AuraEnabled 
        public Decimal moreThan20s{get;set;}
        @AuraEnabled 
        public Decimal lessThan20s{get;set;}
        @AuraEnabled 
        public Decimal totalMissCall{get;set;}
        @AuraEnabled 
        public Decimal uniqueMissLead{get;set;}
        @AuraEnabled 
        public Decimal callBackToUniqueLead{get;set;}
        @AuraEnabled 
        public Decimal callReceivedByUnique{get;set;}
        @AuraEnabled 
        public Decimal callNotReceivedByUnique{get;set;}
        @AuraEnabled 
        public Decimal callNotReceived{get;set;}
        @AuraEnabled 
        public Decimal unqualifiedDueToCNR{get;set;}


        public reportDataWrapperClass(){
            //this.incomingCalls = 0;
            this.incomingAssignedCalls = 0;
            this.incomingFormingLeads = 0;
            this.incomingNotFormingLeads = 0;
            this.moreThan20s = 0;
            this.lessThan20s = 0;
            this.totalMissCall = 0;
            this.uniqueMissLead = 0;
            this.callBackToUniqueLead = 0;
            this.callReceivedByUnique = 0;
            this.callNotReceivedByUnique = 0;
            this.callNotReceived = 0;
            this.unqualifiedDueToCNR = 0;
        }
    }
}