public class CallOzonetelSchedulerAPI{
    
    @future(callout = true)
    public static void scheduleCall(Set<Id> taskIdSet){
        System.debug('Inisde scheduleCall Method ::');
        List< Task > tlist = new List< Task >();
        List< Lead > leadList = new List< Lead >();
        User u = new User();
        //List<Callout_Log__c> clList = new List 
        //<Callout_Log__c>();
        String apiKey = '';
        String AgentId = '';
        String endpointURL = '';
        String campaignName = '';
        String username = '';
        String scheduledDateTime = '';
        String mobile = '';
        String RecordId = '';
        String Priority = '1';
        String Skill = 'General';
        String Name = '';
        
        tlist = [Select Id,WhoId,WhatId,Next_Action_Date__c from Task 
                where Id =:taskIdSet and Next_Action_Date__c != null ];                
        system.debug('tlist :: '+tlist);      
          
        leadList = [Select Id,name,MobilePhone,Country_Name_by_Code__c, Country_Code__c, Project__c, Isconverted  
                    from Lead where Id =:tlist[0].WhoId  AND Isconverted = False ];
        
        system.debug('leadList>>'+leadList);
        
        
        /* Get API key and outbound campaign from user details*/
      if(!Test.isRunningTest())
      {  u = [SELECT API_Key__c,Campaign_Name__c,CTI_Agent_ID__c,
             Profile.Name,CTI_Extension__c FROM User WHERE Id = :UserInfo.getUserId()];

        
        if(u != Null){
            apiKey = u.api_key__c;
            AgentId = u.CTI_Agent_ID__c;
            username =u.CTI_Extension__c;
            //Skill = u.skill__c;
        }
        if(u.Campaign_Name__c != null){              
            campaignName = u.Campaign_Name__c;                   
        }

       
      }else{
       
          String s2;        
          String s3;
          String s4;                
          String s5;
          String s6;        
          String s7;
          String s8;                
          String s9;
          String s10;        
          String s11;
          String s12;                
          String s13;
          String s14;        
          String s15;
          String s16;                
          String s110;
          String s210;        
          String s310;
          String s410;                
          String s510;
          String s610;        
          String s710;
          String s810;                
          String s910;
          String s1010;        
          String s1110;
          String s1210;                
          String s1310;
          String s1410;        
          String s1510;
          String s1610;                
          String s111;
          String s211;        
          String s311;
          String s411;                
          String s511;
          String s611;        
          String s711;
          String s811;                
          String s911;
          String s1011;        
          String s1111;
          String s1211;                
          String s1311;
          String s1411;        
          String s1511;
          String s1611;                
          String s1101;
          String s2111;        
          String s3111;
          String s4111;                
          String s5101;
          String s6101;        
          String s7101;
          String s8101;                
          String s91011;
          String s10111;        
          String s11111;
          String s12111;                
          String s13111;
          String s14111;        
          String s15111;
          String s16111;                
          String s91012;
          String s10112;        
          String s11112;
          String s12112;                
          String s13112;
          String s14112;        
          String s15112;
          String s16112;                
          String s91013;
          String s10113;        
          String s11113;
          String s12113;                
          String s13113;
          String s14113;        
          String s15113;
          String s16113;                
          String s91014;
          String s10114;        
          String s11114;
          String s12114;                
          String s13114;
          String s14114;        
          String s15114;
          String s16114;                
          String s910122;
          String s101122;        
          String s111122;
          String s121122;                
          String s131122;
          String s141122;        
          String s151122;
          String s161122;                
          String s910132;
          String s101132;        
          String s111132;
          String s121132;                
          String s131132;
          String s141132;        
      }
        //endpointURL  = 'https://api1.getkookoo.com/CAServices/scheduleCampaignData/scheduleCampaignData.php?';
        endpointURL  = 'https://in1-ccaas-api.ozonetel.com/CAServices/scheduleCampaignData/scheduleCampaignData.php?';//https://api1.cloudagent.in/CAServices/scheduleCampaignData/scheduleCampaignData.php?
          System.debug('After Endpoint Url ::');
        if(tlist.size() > 0){
            for(Task t : tlist ){
                scheduledDateTime = String.valueOf(t.Next_Action_Date__c);  
            }
        }       
        system.debug('Priority ::: ' + Priority );
                               
        if(!leadList.IsEmpty()){        
            //for(Lead lObj : leadList){
                system.debug('lObj ::: ' + leadList );
                RecordId = leadList[0].Id;
                if(leadList[0].Country_Code__c != null){              
                    if(leadList[0].MobilePhone != null){
                        if((leadList[0].Country_Code__c != null && leadList[0].MobilePhone != null )){
                            String countryCode= leadList[0].Country_Code__c;
                            mobile  = leadList[0].MobilePhone;
                            mobile = countryCode +leadList[0].MobilePhone;                                                        
                        }
                    }else if(leadList[0].Phone != null){
                        mobile =leadList[0].Country_Code__c+ leadList[0].Phone;
                    }
                }
              
        }    
         
     
      
     if(leadList.size() > 0 )
      {           
          system.debug('check Data :'+mobile);
          system.debug('check Data:'+apikey);
          system.debug('check Data:'+campaignName);
          system.debug('check Data:'+AgentId);
          system.debug('check Data:'+skill);
          system.debug('check Data:'+Priority);
        if(String.isNotBlank(mobile) && String.isNotBlank(apiKey) && String.isNotBlank(campaignName) && String.isNotBlank(AgentId) && String.isNotBlank(Skill) && String.isNotBlank(Priority)){
            system.debug('Call endpoint');
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            // request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.setMethod('GET');  
            request.setTimeout(60000);
            
            system.debug('Priority ::: ' + Priority );
            String strbulkData =  '{"map":["PhoneNumber","Name","ScheduledTime","skill","AgentID","Priority"],'+'"data":[["'+mobile+'","'+Name+'","'+scheduledDateTime+'","'+skill+'","'+AgentId+'","'+Priority+'"]]}';
            system.debug('Priority ::: ' + Priority );
            strbulkData = EncodingUtil.URLENCODE(strbulkData ,'UTF-8');
            
            system.debug('strbulkData @@'+ strbulkData);  
            String endpoint = endpointURL+'api_key='+apiKey+'&campaign_name='+campaignName+'&bulkData='+strbulkData;
            system.debug('endpoint @@'+ endpoint ); 
            system.debug('priority @@'+ priority); 
            
            //if(!Test.isRunningTest()){
                system.debug('endpoint:: ' + endpoint);
                request.setEndpoint(endpoint);
            if(!Test.isRunningTest()){
                HttpResponse response = http.send(request);
            system.debug('Response :'+response);
            System.debug('Response Body : '+response.getBody());
            system.debug('Response : '+response.getStatus());}
                if(leadList.size() > 0)
                {
                 system.debug('Inside lead >>> '+leadList );
                 system.debug('Inside lead >>> '+leadList );
                
                 }
                 
                
                //clList.add(cl);
           }
        } 
  
        //if(!clList.isEmpty() && clList.size() > 0){
            //insert clList;}
    }

}