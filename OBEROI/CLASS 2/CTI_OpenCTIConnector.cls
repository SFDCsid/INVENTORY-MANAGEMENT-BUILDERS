global class CTI_OpenCTIConnector{
    
    /*************************************************************
    * Update the virtual number and lead owner for existing leads. 
    **************************************************************/
    webService static String updateLead(String leadIdToUpdate, String virtualNumberToUpdate, String leadOwner){
        //UserId for the VccAdmin user
        User vccUser = [SELECT Name FROM User WHERE Name LIKE '%VCC Admin%'];
        
        final String VCC_ADMIN_ID =vccUser.Id;
            
        Lead ul = [SELECT Virtual_Number_Text__c, Original_PMT_Owner__c, ownerId FROM Lead WHERE Id =: leadIdToUpdate];
        ul.Virtual_Number_Text__c = virtualNumberToUpdate;

        if(ul.Original_PMT_Owner__c==VCC_ADMIN_ID){
            ul.ownerId = leadOwner;
            ul.Original_PMT_Owner__c = leadOwner;
        }
        update ul;
        String updatedLeadRespString= SYSTEM.JSON.serialize(ul);
        return updatedLeadRespString;
        
    }

    
    /********************************************************************
    * Fetch the country code and virtual number for Click-to-dial
    *********************************************************************/
    webService static String getCountryCodeVirtualNumberFromLead(String strLeadId){
        Lead ul = [SELECT Virtual_Number_Text__c, Country_Code__c FROM Lead WHERE Id =: strLeadId];
        return SYSTEM.JSON.serialize(ul);
    }
    
    /********************************************************************
    * Create a new lead. Called from ICWS:CONNECTED event
    *********************************************************************/
    
     webService static String createLead(String strLeadInput) {
        Lead nl= New Lead();
        Map<String, Object> jl = (Map<String, Object>) JSON.deserializeUntyped(strLeadInput);
        nl.FirstName = String.valueOf(jl.get('FirstName'));
        nl.LastName = String.valueOf(jl.get('LastName'));
        nl.MobilePhone= String.valueOf(jl.get('MobilePhone'));
        nl.Campaign__c = String.valueOf(jl.get('Campaign__c'));
        nl.Country_Code__c = String.valueOf(jl.get('Country_Code__c'));
        nl.Virtual_Number_Text__c = String.valueOf(jl.get('Virtual_Number_Text__c'));
        nl.Status= String.valueOf(jl.get('Lead_Stage__c'));
        nl.Lead_Stage__c = String.valueOf(jl.get('Status'));
        nl.LeadSource = String.valueOf(jl.get('LeadSource'));
        nl.OwnerId= String.valueOf(jl.get('OwnerId'));
        nl.Original_PMT_Owner__c = String.valueOf(jl.get('Original_PMT_Owner__c'));
        Insert nl;
        String newLeadRespString= SYSTEM.JSON.serialize(nl);
        return newLeadRespString;    
    }
    
    /********************************************************************
    * Insert a new call record except call comments. 
    * Called from ICWS:DISCONNECTED event
    *********************************************************************/
    webService static String disposeFullCall(String jsonInput) {

        Call__c nc= New Call__c();
        Map<String, Object> j = (Map<String, Object>) JSON.deserializeUntyped(jsonInput);
        nc.Agent__c = String.valueOf(j.get('agent'));
        nc.Booking__c = String.valueOf(j.get('booking'));
        nc.Broker__c = String.valueOf(j.get('broker'));
        
        nc.Called_Number__c = String.valueOf(j.get('calledNumber'));
        
        Long callStartDateTimeMillis = Long.valueOf(String.valueOf(j.get('callStartDateTime')));
        nc.Call_Start_Date_Time__c = DateTime.newInstance(callStartDateTimeMillis);
        
        Long callEndDateTimeMillis = Long.valueOf(String.valueOf(j.get('callEndDateTime')));
        nc.Call_End_Date_Time__c = DateTime.newInstance(callEndDateTimeMillis);

        nc.Call_Duration_Seconds__c = Decimal.valueOf(String.valueOf(j.get('callDuration')));
        
        nc.Calling_Country_code__c = String.valueOf(j.get('callingCountrycode'));
        nc.Calling_Number__c = String.valueOf(j.get('callingNumber'));
        
        nc.Call_Status__c = String.valueOf(j.get('callStatus'));
        nc.Call_Team__c = String.valueOf(j.get('callTeam'));
        nc.Call_Type__c = String.valueOf(j.get('callType'));
        nc.Comments__c = String.valueOf(j.get('comments'));
        nc.Contact__c = String.valueOf(j.get('contactId'));
        nc.Lead__c = String.valueOf(j.get('leadId'));
        nc.Opportunity__c = String.valueOf(j.get('opportunityId'));
        nc.Project__c = String.valueOf(j.get('projectId'));
        
        String propertyId = String.valueOf(j.get('property'));
        if(propertyId != ''){
            nc.Property__c = propertyId;
        }
        
        nc.Recording_URL__c = String.valueOf(j.get('recordingURL'));
        nc.Session_Id__c = String.valueOf(j.get('sessionId'));
        nc.Tower__c = String.valueOf(j.get('tower'));
        nc.Call_Disposition_Category__c = String.valueOf(j.get('callDispositionCategory'));
        nc.Call_Disposition_Sub_Category__c = String.valueOf(j.get('callDispositionSubCategory'));
        nc.Call_Disposition_Type__c = String.valueOf(j.get('callDispositionType'));
         
        upsert nc;
        String newCallRespString= SYSTEM.JSON.serialize(nc);
        return newCallRespString;
             
    }
        
    /************************************************************************
    * update a call record with call comments. Called upon the acwFinished event
    * Comments are obsolte but this method invokes the updateCallRecord trigger
    *********************************************************************/
    webService static String updateCallWithComments(String callIdToUpdate , String callComments) {
        Call__c uc = [SELECT Comments__c FROM Call__c WHERE Id =: callIdToUpdate];
        uc.Comments__c = callComments;
        update uc;
        String updatedCallRespString= SYSTEM.JSON.serialize(uc);
        return updatedCallRespString;
        
    }
   
       
    /********************************************************************
    * Fetch Salesforce UserID, used for updating LeadOwner.
    * Also fetches CTI credentials for softphone Login
    *********************************************************************/
    webService static String getUserCtiDetails() {
       String userId = UserInfo.getUserId();
       user currentUserDetails =  [SELECT id, CTI_Agent_ID__c, CTI_Extension__c, CTI_Password__c FROM user WHERE id =: userId];
       String currentUserJSONString = SYSTEM.JSON.serialize(currentUserDetails);
       return currentUserJSONString;
    }
    
    /********************************************************************
    * Fetch Virtual Number for the Latest Missed Call for a lead
    * Used to tag inbound campaign calls with a virtual number 
    *********************************************************************/
    webService static String getVirtualNumberForLatestMissedCall(String cli){
        Call__c virtualNumber = [SELECT Called_Number__c FROM Call__c where Calling_Number__c=:cli AND Call_Type__c = 'Inbound' AND Call_Status__c ='Missed' order by CreatedDate desc LIMIT 1];
        return SYSTEM.JSON.serialize(virtualNumber);
    }
    
}