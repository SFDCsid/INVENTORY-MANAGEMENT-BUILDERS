public class LeadTriggerHandler {
    /** @author: IBM
* @description: 1. Send SMS
*               2. auto populate the virtual number and it's corresponding advertisement, project, site
*               3. auto populate the advertisement, project, site according to tracking number
*               4. Insert Campaign Member for advertisement
*/
    static Id resRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(Label.Lead_RecordType_Residential).getRecordTypeId();
    public static void beforeInsertLead( list<Lead> newLead ){        
        
        set <String> trackingCodeSet = new set<String>();
        set<String> virtualNumberTextSet = new set<String>();
        for (Lead ld: newLead){
            virtualNumberTextSet.add(ld.Virtual_Number_Text__c);
            trackingCodeSet.add(ld.Tracking_No__c );
        }
        virtualNumberTextSet.remove(null);
        trackingCodeSet.remove(null);
        Map<String, Virtual_Number__c> virtualNumberMap = getVirtualNumbers(virtualNumberTextSet);
        Map<String, Campaign> trackingCodeCampaignMap = getCampaignsByTrackingCode(trackingCodeSet);
        
        
        for(Lead ld : newLead){
            
            if(!String.isBlank(ld.Virtual_Number_Text__c)){
                if(virtualNumberMap.containsKey(ld.Virtual_Number_Text__c)){
                    
                    ld.Virtual_Number__c = virtualNumberMap.get(ld.Virtual_Number_Text__c).Id;
                    ld.Campaign__c = virtualNumberMap.get(ld.Virtual_Number_Text__c).Advertisement__c;
                    //Added to avoid duplicate 
                    if(ld.Cloned_Lead__c == false){
                        ld.Project__c = virtualNumberMap.get(ld.Virtual_Number_Text__c).Advertisement__r.Project__c;
                        ld.Site__c = virtualNumberMap.get(ld.Virtual_Number_Text__c).Advertisement__r.Marketing_Channel__r.Marketing_Campaign__r.Marketing_Plan__r.Site__c == null ? ld.Site__c : virtualNumberMap.get(ld.Virtual_Number_Text__c).Advertisement__r.Marketing_Channel__r.Marketing_Campaign__r.Marketing_Plan__r.Site__c;
                    }
                }
                else {
                    ld.Virtual_Number_Text__c.addError(Label.Invalid_Virtual_Number);
                    
                }
            }
            if( String.isNotBlank(ld.Tracking_No__c )){
                //String.isBlank(ld.Project_Code__c) &&
                if(trackingCodeCampaignMap.containsKey(ld.Tracking_No__c )){
                    //Commented to avoid duplicate 
                    // ld.Project__c = trackingCodeCampaignMap.get(ld.Tracking_No__c).Project__c != null ? trackingCodeCampaignMap.get(ld.Tracking_No__c).Project__c : ld.Project__c;
                    //ld.Site__c = trackingCodeCampaignMap.get(ld.Tracking_No__c).Marketing_Channel__r.Marketing_Campaign__r.Marketing_Plan__r.Site__c != null ? trackingCodeCampaignMap.get(ld.Tracking_No__c).Marketing_Channel__r.Marketing_Campaign__r.Marketing_Plan__r.Site__c : ld.Site__c;
                    ld.Campaign__c =  trackingCodeCampaignMap.get(ld.Tracking_No__c).Id;            
                }
                else {
                    ld.Tracking_No__c.addError(Label.Invalid_Tracking_Code);
                }
            }
            // update ld;
        }
    }
    
    public static map<String, Campaign> getCampaignsByTrackingCode(set<String> trackingCodeSet){
        Map<String, Campaign> trackingCodeCampaignMap = new map<String, Campaign>();
        if(!trackingCodeSet.isEmpty()){     
            for(Campaign cp : [select id, Tracking_Code__c, IsActive, Project__c,Marketing_Channel__r.Marketing_Campaign__r.Marketing_Plan__r.Site__c 
                               from Campaign 
                               where Tracking_Code__c IN : trackingCodeSet
                               order by createdDate ASC]){                               
                                   trackingCodeCampaignMap.put(cp.Tracking_Code__c , cp);  
                               }
        }
        return trackingCodeCampaignMap;
    }
    
    public static map<String, Virtual_Number__c> getVirtualNumbers(set<String> virtualNumberTextSet){
        map<String, Virtual_Number__c> virtualNumberMap = new map<String, Virtual_Number__c >();
        if(virtualNumberTextSet != null && !virtualNumberTextSet.isEmpty()){
            for(Virtual_Number__c vn : [select id, Name, Advertisement__c, Advertisement__r.Project__c, Advertisement__r.Marketing_Channel__r.Marketing_Campaign__r.Marketing_Plan__r.Site__c
                                        from Virtual_Number__c
                                        where Name IN : virtualNumberTextSet]){
                                            virtualNumberMap.put(vn.Name, vn);                  
                                        }
        }
        return virtualNumberMap;
    }
    
    public static map<Id, Project__c> getProjects(set <Id> projectIdSet){
        Map<id, Project__c> projMap = new map<Id,Project__c>();
        
        if(projectIdSet!=null && !projectIdSet.isEmpty()){
            projMap = new Map<id, Project__c>([SELECT id, Name, Project_Site_Office_Address__c 
                                               FROM Project__c 
                                               where RecordType.Name =:Label.Lead_RecordType_Residential
                                               and Id IN : projectIdSet] );
        }
        return projMap;
        
    }
    
    public static void beforeUpdateLead( Map<id, Lead>newLead , Map<id, Lead>oldLead){ 
        Id resRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(Label.Lead_RecordType_Residential).getRecordTypeId();
        set <Id> projectIdSet = new set<Id>();
        string method= 'update';
        
        set <String> virtualNumberTextSet = new set<String>();
        set <String> trackingCodeSet = new set<String>();
        for (Lead ld: newLead.values()){
            if(ld.Virtual_Number_Text__c != oldLead.get(ld.id).Virtual_Number_Text__c && String.isNotBlank(ld.Virtual_Number_Text__c))
                virtualNumberTextSet.add(ld.Virtual_Number_Text__c);
            if(ld.Tracking_No__c != oldLead.get(ld.id).Tracking_No__c && ld.Project_Code__c == oldLead.get(ld.id).Project_Code__c)
                trackingCodeSet.add(ld.Tracking_No__c );
        }
        
        Map<String, Virtual_Number__c> virtualNumberMap = getVirtualNumbers(virtualNumberTextSet);
        Map<String, Campaign> trackingCodeCampaignMap = getCampaignsByTrackingCode(trackingCodeSet);
        list <CampaignMember> campaignMemberList = new list<CampaignMember>();
        for (Lead ld: newLead.values()){
            if(!String.isBlank(ld.Virtual_Number_Text__c) && ld.Virtual_Number_Text__c != oldLead.get(ld.id).Virtual_Number_Text__c){
                if(virtualNumberMap.containsKey(ld.Virtual_Number_Text__c)){
                    ld.Virtual_Number__c = virtualNumberMap.get(ld.Virtual_Number_Text__c).Id;
                    ld.Campaign__c = virtualNumberMap.get(ld.Virtual_Number_Text__c).Advertisement__c;
                    //Added to avoid duplicate 
                    if(ld.Cloned_Lead__c == false){                   
                        ld.Project__c = virtualNumberMap.get(ld.Virtual_Number_Text__c).Advertisement__r.Project__c;
                        ld.Site__c = virtualNumberMap.get(ld.Virtual_Number_Text__c).Advertisement__r.Marketing_Channel__r.Marketing_Campaign__r.Marketing_Plan__r.Site__c;
                    }
                }
                else {
                    ld.Virtual_Number_Text__c.addError(Label.Invalid_Virtual_Number);
                }
            }
            if(ld.Tracking_No__c != oldLead.get(ld.id).Tracking_No__c && ld.Project_Code__c == oldLead.get(ld.id).Project_Code__c){
                if(trackingCodeCampaignMap.containsKey(ld.Tracking_No__c )){
                    //Commented to avoid duplicate 
                    //  ld.Project__c = trackingCodeCampaignMap.get(ld.Tracking_No__c).Project__c != null ? trackingCodeCampaignMap.get(ld.Tracking_No__c).Project__c : ld.Project__c;
                    //  ld.Site__c = trackingCodeCampaignMap.get(ld.Tracking_No__c).Marketing_Channel__r.Marketing_Campaign__r.Marketing_Plan__r.Site__c != null ? trackingCodeCampaignMap.get(ld.Tracking_No__c).Marketing_Channel__r.Marketing_Campaign__r.Marketing_Plan__r.Site__c : ld.Site__c;
                    ld.Campaign__c =  trackingCodeCampaignMap.get(ld.Tracking_No__c).Id;            
                }
                else {
                    ld.Tracking_No__c.addError(Label.Invalid_Tracking_Code);
                }
            }
            if(ld.Campaign__c != oldLead.get(ld.Id).Campaign__c){
                campaignMemberList.add(new CampaignMember(CampaignId = ld.Campaign__c,
                                                          Status = 'Sent',
                                                          LeadId =  ld.Id));
            }
        }
        
        if(!campaignMemberList.isEmpty())
            database.insert(campaignMemberList, false);
        
        //Project code is auto populated from Virtual Number and Tracking code, hence process Send as it needs project details in the end
        for (Lead ld: newLead.values()){     
            if(((ld.Lead_Stage__c == Label.Lead_Status_Site_Visit_to_be_Scheduled && ld.Lead_Stage__c != oldLead.get(ld.Id).Lead_Stage__c )  || (ld.Lead_Stage__c == Label.Lead_Status_Contacted_But_Not_Answering_1  && ld.Lead_Stage__c != oldLead.get(ld.Id).Lead_Stage__c ) || (ld.Lead_Stage__c ==Label.Lead_Status_Site_Visit_Rescheduled && ld.Lead_Stage__c != oldLead.get(ld.Id).Lead_Stage__c ) ) && ld.RecordTypeId == resRecordTypeId)
                projectIdSet.add(ld.Project__c);
        }
        projectIdSet.remove(null);
        
        Map<id, Project__c> projMap = getProjects(projectIdSet);
        for (Lead ld: newLead.values()){
            if(((ld.Lead_Stage__c == Label.Lead_Status_Site_Visit_to_be_Scheduled && ld.Lead_Stage__c != oldLead.get(ld.Id).Lead_Stage__c )  || (ld.Lead_Stage__c == Label.Lead_Status_Contacted_But_Not_Answering_1  && ld.Lead_Stage__c != oldLead.get(ld.Id).Lead_Stage__c ) || (ld.Lead_Stage__c ==Label.Lead_Status_Site_Visit_Rescheduled && ld.Lead_Stage__c != oldLead.get(ld.Id).Lead_Stage__c ) || ld.Resent_SMS_Email__c == true) && ld.RecordTypeId == resRecordTypeId){
                sendSMS(ld, projMap, method);   //Commented By Vaidehi on 13/06  
            }           
        }
    }
    //Commented by Vaidehi 13/06
    //Method For generate OTP
    public static void sendSMS(Lead led, map<Id, Project__c> projMap, string method) {
        System.debug('we are here********'+led);       
        EmailTemplate templateId =  [SELECT Id, Name,RelatedEntityType, DeveloperName,Subject FROM EmailTemplate where DeveloperName='WebToLeadEmailTemplate' LIMIT 1];
        String statMess;
        if(led.Lead_Stage__c == Label.Lead_Status_Site_Visit_to_be_Scheduled && led.Project__c !=null && led.Date_of_Site_Visit__c !=null)
            statMess = 'We are pleased to inform you that your site visit to the Oberoi Realty Customer Experience Centre at ' + ProjMap.get(led.Project__c).Project_Site_Office_Address__c+ ' has been scheduled on '+ (led.Date_of_Site_Visit__c + new EnquiryDateComponent().offset)+' We look forward to having you there. Thank you. '+led.Google_Map_Link__c ;
        else if(led.Lead_Stage__c== Label.Lead_Status_Site_Visit_Rescheduled && led.Project__c !=null && led.Date_of_Site_Visit__c !=null)
            statMess ='We are pleased to inform you that your site visit to the Oberoi Realty Customer Experience Centre at ' + ProjMap.get(led.Project__c).Project_Site_Office_Address__c+ ' has been rescheduled on '+ (led.Date_of_Site_Visit__c + new EnquiryDateComponent().offset) +' We look forward to having you there. Thank you. '+led.Google_Map_Link__c;   
        else if(led.Lead_Stage__c == Label.Site_Visit_Scheduled_from_Website  &&  led.LeadSource =='Web' && led.Date_of_Site_Visit__c !=null) {
            //statMess = 'Hello world 345';
            statMess= Label.SMS_for_SIteVisit_From_Web;
            if(method== 'update'){
                led.Resent_SMS_Email__c = false;
            }
        }else if(led.LeadSource =='Web'&& led.Lead_Stage__c == Label.Open){
            system.debug('in condition');            
            statMess = Label.Website_Visited_No_Site_Visit_Schedule;
            If(templateId.Id != null &&  led.email != ''){sendEMail(led.email,templateId.Id , led.id);}
        }else if(led.LeadSource =='Web'&& led.Resent_SMS_Email__c == true){
            system.debug('in condition for resent mail n SMS');            
            statMess = Label.Website_Visited_No_Site_Visit_Schedule;
            if(templateId.Id != null &&  led.email != ''){sendEMail(led.email,templateId.Id , led.id);}
            if(method== 'update'){
                led.Resent_SMS_Email__c = false;
            }
            system.debug('@@@@@'+led.Resent_SMS_Email__c);
            
        }
        System.debug('-------SMS content '+statMess);
        
        String mbNoStr = led.Country_Code__c + led.Mobile_No__c;
        //String mbNoStr ='09836696777';
        //mbNoStr = mbNoStr.removeStart('+');
        try{ 
            system.debug('-------mbNoStr'+mbNoStr+'*********');
            String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(statMess, 'UTF-8')+'&senderid=ORLCRM';
            EnquirySMSCtrl.sendSMS(smsURL); 
            System.debug('-------SMS sent');
        }
        catch(exception ex){
            system.debug(ex.getMessage()+'****getError');            
        }
    }
    
    
    public static void afterInsertLead(map <Id, Lead> newMap){ 
        List <Lead> ldList = new List<Lead>();
        set<Id> projectIdSet = new set<Id>();
        for (Lead ld: newMap.values()){
            Lead led = new Lead();
            //Changes added by Vaidehi to update lead's CBNA status date/time
            if(ld.Lead_Stage__c == Label.Lead_Status_Contacted_But_Not_Answering_1){
                led.CBNA_Time__c = system.today();
                led.id = ld.id;
                ldList.add(led);
            }
            //Project code is auto populated from Virtual Number and Tracking code, hence process in the end  
            if(((ld.Lead_Stage__c == Label.Lead_Status_Site_Visit_to_be_Scheduled  )   || (ld.Lead_Stage__c ==Label.Lead_Status_Site_Visit_Rescheduled  )) && ld.RecordTypeId == resRecordTypeId)
                projectIdSet.add(ld.Project__c);
        }        
        update ldList;
        projectIdSet.remove(null);        
        
        Map<id, Project__c> projMap = getProjects(projectIdSet);        
        String method='insert';
        try{
            for(Lead ld : newMap.values()){
                if((ld.Lead_Stage__c == Label.Site_Visit_Scheduled_from_Website || ld.Lead_Stage__c == Label.Open || ld.Lead_Stage__c == Label.Lead_Status_Site_Visit_to_be_Scheduled ||ld.Lead_Stage__c == Label.Lead_Status_Contacted_But_Not_Answering_1 || ld.Lead_Stage__c ==Label.Lead_Status_Site_Visit_Rescheduled) && ld.RecordTypeId == resRecordTypeId && ld.Cloned_Lead__c == false){
                    System.debug('Attempting to call send SMS method for lead');
                    sendSMS(ld,projMap, method);//Commented on 13/06 by Vaidehi
                }
            }
        }catch(Exception e){
            system.debug('@@@###:'+e.getMessage()+'='+e.getLineNumber());
        }
        
        list <CampaignMember> campaignMemberList = new list<CampaignMember>();
        for(Lead l : newMap.values()){
            if(l.Campaign__c != null){
                campaignMemberList.add(new CampaignMember(CampaignId = l.Campaign__c,
                                                          Status = 'Sent',
                                                          LeadId =  l.Id));
            }
        }
        if(!campaignMemberList.isEmpty()){
            database.insert(campaignMemberList, false);
        }
        
    }
    //Method to populate CountryName
    public static string populateCountryName(list<Lead> ldList) { 
        Map<string, CTI_Country_Mappings__mdt> countryMap = new Map<string, CTI_Country_Mappings__mdt>();
        List <CTI_Country_Mappings__mdt>cList = [SELECT id, MasterLabel,Country_Name__c FROM CTI_Country_Mappings__mdt];
        for (CTI_Country_Mappings__mdt ct : cList){
            countryMap.put(ct.MasterLabel, ct);
        }
        for(Lead ld : ldList){
            if(countryMap.containsKey(ld.Country_Code__c)) 
                ld.Country_Name_by_Code__c = countryMap.get(ld.Country_Code__c).Country_Name__c  ;
            if( countryMap.containsKey(ld.Country_Code_for_Other_Mobile_Number__c))
                ld.Country_Name_of_Other_Mobile_Code__c = countryMap.get(ld.Country_Code_for_Other_Mobile_Number__c).Country_Name__c  ;
            if( countryMap.containsKey(ld.Country_Code_for_Phone__c))
                ld.Country_Name_of_Residence_Code__c  = countryMap.get(ld.Country_Code_for_Phone__c).Country_Name__c  ;
            if( countryMap.containsKey(ld.PC_Mobile_Country_Code__c))
                ld.Country_Name_for_PC_Mobile__c  = countryMap.get(ld.PC_Mobile_Country_Code__c).Country_Name__c  ; 
            if( countryMap.containsKey(ld.Country_Code_for_Office_Number__c))
                ld.Country_Name_of_Office_No__c  = countryMap.get(ld.Country_Code_for_Office_Number__c).Country_Name__c  ;     
        }
        return null;
    }
    
    
    
    
    public static void sendEMail(string toAddress, string templateId, string LeadId ){        
        OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress limit 1];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { toAddress };
            //  message.optOutPolicy = 'FILTER';
            message.setTargetObjectId(LeadId);
        message.setSaveAsActivity(false); 
        // set it in meassage as
        message.setOrgWideEmailAddressId(owa.id);//Changes added on 29/07 regarding case 00001075 from Prod
        //message.subject = 'Opt Out Test Message';
        message.setTemplateId(templateId);
        //message.setSenderDisplayName('ORL CRM');
        //message.plainTextBody = 'This is the message body.';
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) 
        {
            System.debug('The email was sent successfully.');
        } else 
        {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        
    }
    
    
    public static void afterUpdateLead(map <Id, Lead> newMap, map <Id, Lead> oldMap){
        List <Lead> ldList = new List<Lead>();
        for (Lead ld: newMap.values()){ 
            Lead led = new Lead();
            //Changes added by Vaidehi to update lead's CBNA status date/time
            if(ld.Lead_Stage__c == Label.Lead_Status_Contacted_But_Not_Answering_1 &&  ld.Lead_Stage__c != oldMap.get(ld.Id).Lead_Stage__c){
                led.id= ld.id;
                led.CBNA_Time__c = system.today(); 
                ldList.add(led);
            }
        }
        update ldList;
    }
    
}