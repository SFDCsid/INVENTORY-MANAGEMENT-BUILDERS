@RestResource(urlMapping='/Integration/Callback1/*') 
global class REST_CallbackCTI {
    
    @HttpPost
    global static void CreateEnquiry() {
        String data = '';
        data = RestContext.request.params.get('data');
        /*
if(Test.isRunningTest()){
data='{'+
'"monitorUCID": "1929157114451262", '+
'"UUI": "", '+
'"CampaignName": "Inbound_918068442375", '+
'"Did": "918068442375", '+
'"Location": "", '+
'"CallerID": "00917089581562",'+
'"PhoneName": "Sagar_Subhash", '+
'"Skill": "None", '+
'"StartTime": "2019-10-15 18:31:52",'+
'"EndTime": "2019-10-15 18:41:08",'+
'"TimeToAnswer": "00:00:15", '+
'"CallDuration": "00:09:16",'+
'"Duration": "00:09:01",'+
'"FallBackRule": "AgentDial",'+
'"DialedNumber": "08928493299",'+
'"Type": "Manual",'+
'"AgentID": "test.test1 -> test.test2",'+
'"AgentPhoneNumber": "08928493299",'+
'"AgentUniqueID": "93890",'+
'"AgentName": "Sagar Subhash", '+
'"Disposition": "", '+
'"HangupBy": "AgentHangup",'+
'"Status": "NotAnswered",'+
'"AudioFile": "https://google.com", '+
'"TransferType": "No Transfers", '+
'"TransferredTo": "",'+
'"Comments": "", '+
'"DialStatus": "answered", '+
'"Apikey": "KKdcdd1b0768911fc065fc0432268d034b", '+
'"AgentStatus": "answered", '+
'"CustomerStatus": "answered",'+
'"UserName": "upgrad_edu",'+
'"CallerConfAudioFile": "", '+
'"ConfDuration": "00:00:00",'+
'"CampaignStatus": "ONLINE", '+
'"DataUniqueId": ""'+
'}';
}else{
data = RestContext.request.params.get('data');
}*/
        
        CallbackParse cb = CallbackParse.Parse(data);
        String customerNumber = cb.CallerID; //cb.national
        String did = cb.DID;
        String ucid = cb.monitorUCID;
        String callStatus = cb.Status;
        String callType =cb.Type_Z;
        String agentid = cb.AgentID;
        //String account =cb.UserName;
        String recordingFile = cb.AudioFile;
        String duration = cb.CallDuration;
        String UUI = cb.UUI;
        String campname = cb.CampaignName;
        String CustomerNo = cb.CallerID;
        String CampaignStatus = cb.CampaignStatus;
        string countryCode = cb.countryCode;
        String agentstatus = cb.AgentStatus;
        string Country;
        system.debug('Callback Data:: ' + cb);
        system.debug('FallBackRule:: ' + cb.FallBackRule);
        System.debug('Incoming request callstatus:' + callStatus + ':::' + callType +':::'+ customerNumber + ':' + ucid + 'UUI:' + UUI + 'CampaignStatus:' + CampaignStatus + 'DID:' + did + 'countryCode::' + countryCode); 
        
        if(customerNumber != null){
            if(customerNumber.length() == 11 && customerNumber.startsWith('0')){
                customerNumber = customerNumber.substring(1);
            }}
        
        system.debug(' countryCode :: '+countryCode);
        if(string.isNotBlank(countryCode)){
            system.debug(' countryCode :: '+countryCode);
            
            if(countryCode.equals('91') || countryCode.equals('091') || countryCode.equals('+91') || countryCode.equals('0091')){
                Country = 'India';
            }if(countryCode.equals('+86') || (countryCode.equals('86') || countryCode.equals('0086') || countryCode.equals('086')))
                country = 'China'; //11-
            else if (countryCode.equals('+55') || (countryCode.equals('55') || countryCode.equals('0055') || countryCode.equals('055')))
                country = 'Brazil'; //11-            
            else if (countryCode.equals('+358') || (countryCode.equals('358') || countryCode.equals('00358') || countryCode.equals('0358')))
                country = 'Åland Islands'; //10-
            else if (countryCode.equals('+880') || (countryCode.equals('880') || countryCode.equals('00880') || countryCode.equals('0880')))
                country = 'Bangladesh'; //10-
            else if (countryCode.equals('+39') || countryCode.equals('39') || countryCode.equals('0039') || countryCode.equals('039')){
                system.debug(' Inside countryCode :: '+countryCode);
                country = 'Italy'; //10-
            }else if (countryCode.equals('+976') || (countryCode.equals('976') || countryCode.equals('00976') || countryCode.equals('0976')))
                country = 'Mongolia'; //10-
            else if (countryCode.equals('+977') || (countryCode.equals('977') || countryCode.equals('00977') || countryCode.equals('0977')))
                country = 'Nepal'; //10- 
            
            else if (countryCode.equals('+254') || countryCode.equals('254') || countryCode.equals('00254') || countryCode.equals('0254'))
                country = 'Kenya'; //?- 
            else if (countryCode.equals('+82') || countryCode.equals('82') || countryCode.equals('0082') || countryCode.equals('082'))
                country = 'South Korea'; //?-            
            else if (countryCode.equals('+355') || countryCode.equals('355') || countryCode.equals('00355') || countryCode.equals('0355'))
                country = 'Albania'; //9-
            else if (countryCode.equals('+213') || countryCode.equals('213') || countryCode.equals('00213') || countryCode.equals('0213'))
                country = 'Algeria'; //9-
            else if (countryCode.equals('+994') || countryCode.equals('994') || countryCode.equals('00994') || countryCode.equals('0994'))
                country = 'Azerbaijan'; //9-
            else if (countryCode.equals('+43') || countryCode.equals('43') || countryCode.equals('0043') || countryCode.equals('043'))
                country = 'Austria'; //10- 
            else if (countryCode.equals('+20') || countryCode.equals('20') || countryCode.equals('0020') || countryCode.equals('020'))
                country = 'Egypt'; //10- 
            else if (countryCode.equals('+49') || countryCode.equals('49') || countryCode.equals('0049') || countryCode.equals('049'))
                country = 'Germany'; //10-
            
            else if (countryCode.equals('+966') || countryCode.equals('966') || countryCode.equals('00966') || countryCode.equals('0966'))
                country = 'Saudi Arabia'; //9-
            
            
            
            else if (countryCode.equals('+52') || countryCode.equals('52') || countryCode.equals('0052') || countryCode.equals('052'))
                country = 'Mexico'; //10-
            
            else if (countryCode.equals('+63') || countryCode.equals('63') || countryCode.equals('0063') || countryCode.equals('063'))
                country = 'Philippines'; //10-
            else if (countryCode.equals('+92') || countryCode.equals('92') || countryCode.equals('0092') || countryCode.equals('092'))
                country = 'Pakistan'; //10-
            else if (countryCode.equals('+64') || countryCode.equals('64') || countryCode.equals('0064') || countryCode.equals('064'))
                country = 'New Zealand'; //10-
            else if (countryCode.equals('+351') || countryCode.equals('351') || countryCode.equals('00351') || countryCode.equals('0351'))
                country = 'Portugal'; //9-
            
            else if (countryCode.equals('+46') || countryCode.equals('46') || countryCode.equals('0046') || countryCode.equals('046'))
                country = 'Sweden'; //10-
            else if (countryCode.equals('+886') || countryCode.equals('886') || countryCode.equals('00886') || countryCode.equals('0886'))
                country = 'Taiwan'; //9-
            else if (countryCode.equals('+971') || countryCode.equals('971') || countryCode.equals('00971') || countryCode.equals('0971'))
                country = 'United Arab Emirates'; //9 -
            else if (countryCode.equals('+44') || countryCode.equals('44') || countryCode.equals('0044') || countryCode.equals('044'))
                country = 'United Kingdom'; //10-
            else if(countryCode.equals('+1') || countryCode.equals('1') || countryCode.equals('001'))
                country = 'United States'; //10-
            else if (countryCode.equals('+506') || countryCode.equals('506') || countryCode.equals('00506') || countryCode.equals('0506'))
                country = 'Costa Rica'; //8-
            else if (countryCode.equals('+36') || countryCode.equals('36') || countryCode.equals('0036') || countryCode.equals('036'))
                country = 'Hungary'; //9-
            else if (countryCode.equals('+965') || countryCode.equals('965') || countryCode.equals('00965') || countryCode.equals('0965'))
                country = 'Kuwait'; //8-
            else if (countryCode.equals('+973') || countryCode.equals('973') || countryCode.equals('00973') || countryCode.equals('0973'))
                country = 'Bahrain'; //8 -
            else if (countryCode.equals('+32') || countryCode.equals('32') || countryCode.equals('0032') || countryCode.equals('032'))
                country = 'Belgium'; //9-
            else if (countryCode.equals('+387') || countryCode.equals('387') || countryCode.equals('00387') || countryCode.equals('0387'))
                country = 'Bosnia and Herzegovina'; //8-
            else if (countryCode.equals('+33') || countryCode.equals('33') || countryCode.equals('0033') || countryCode.equals('033'))
                country = 'France'; //9-  
            else if (countryCode.equals('+230') || countryCode.equals('230') || countryCode.equals('00230') || countryCode.equals('0230'))
                country = 'Mauritius'; //8-
            else if (countryCode.equals('+31') || countryCode.equals('31') || countryCode.equals('0031') || countryCode.equals('031'))
                country = 'Netherlands'; //9-
            else if (countryCode.equals('+507') || countryCode.equals('507') || countryCode.equals('00507') || countryCode.equals('0507'))
                country = 'Panama'; //8-
            else if (countryCode.equals('+51') || countryCode.equals('51') || countryCode.equals('0051') || countryCode.equals('051'))
                country = 'Peru'; //9-
            else if (countryCode.equals('+48') || countryCode.equals('48') || countryCode.equals('0048') || countryCode.equals('048'))
                country = 'Poland'; //9 -
            else if (countryCode.equals('+7') || countryCode.equals('7') || countryCode.equals('007') || countryCode.equals('07'))
                country = 'Russia'; //10- 
            else if (countryCode.equals('+27') || countryCode.equals('27') || countryCode.equals('0027') || countryCode.equals('027'))
                country = 'South Africa'; //9 -
            else if (countryCode.equals('+34')  || countryCode.equals('34') || countryCode.equals('0034') || countryCode.equals('034'))
                country = 'Spain'; //9-
            else if (countryCode.equals('+41') || countryCode.equals('41') || countryCode.equals('0041') || countryCode.equals('041'))
                country = 'Switzerland'; //9-
            else if (countryCode.equals('+66') || countryCode.equals('66') || countryCode.equals('0066') || countryCode.equals('066'))
                country = 'Thailand'; //9-
            else if (countryCode.equals('+90') || countryCode.equals('90') || countryCode.equals('0090') || countryCode.equals('090'))
                country = 'Turkey'; //9-
            else if (countryCode.equals('+61') || countryCode.equals('61') || countryCode.equals('0061') || countryCode.equals('061'))
                country = 'Australia';
            else if (countryCode.equals('+974') || countryCode.equals('974') || countryCode.equals('00974') || countryCode.equals('0974'))
                country = 'Qatar'; //8
            else if (countryCode.equals('+968') || countryCode.equals('968') || countryCode.equals('00968') || countryCode.equals('0968'))
                country = 'Oman'; //?
            if (countryCode.equals('+45')  ||countryCode.equals('45') || countryCode.equals('0045') || countryCode.equals('045'))
                country = 'Denmark'; //8-
            else if (countryCode.equals('+65') || countryCode.equals('65') || countryCode.equals('0065') || countryCode.equals('065'))
                country = 'Singapore'; //8
            else if (countryCode.equals('+852') || countryCode.equals('852') || countryCode.equals('00852') || countryCode.equals('0852'))
                country = 'Hong Kong'; //8
            else if (countryCode.equals('+64') || countryCode.equals('64') || countryCode.equals('0064') || countryCode.equals('064'))
                country = 'New Zealand'; //8 -
            
            else if (countryCode.equals('+62') || countryCode.equals('62') || countryCode.equals('0062') || countryCode.equals('062'))
                country = 'Indonesia'; //7  
            else if (countryCode.equals('+353') || countryCode.equals('353') || countryCode.equals('00353') || countryCode.equals('0353'))
                country = 'Ireland'; //9
            else if (countryCode.equals('+972') || countryCode.equals('972') || countryCode.equals('00972') || countryCode.equals('0972'))
                country = 'Israel'; //9
            else if (countryCode.equals('+81') || countryCode.equals('81') || countryCode.equals('0081') || countryCode.equals('081'))
                country = 'Japan'; //11
            else if (countryCode.equals('+960') || countryCode.equals('960') || countryCode.equals('00960') || countryCode.equals('0960'))
                country = 'Maldives'; //7-
            else if (countryCode.equals('+47') || countryCode.equals('47') || countryCode.equals('0047') || countryCode.equals('047'))
                country = 'Norway'; //8- 
            else if (countryCode.equals('+60') || countryCode.equals('60') || countryCode.equals('0060') || countryCode.equals('060'))
                country = 'Malaysia'; //7-
            else if (countryCode.equals('+974') || countryCode.equals('974') || countryCode.equals('00974') || countryCode.equals('0974'))
                country = 'Qatar';
            else if (countryCode.equals('+968')  || countryCode.equals('968') || countryCode.equals('00968') || countryCode.equals('0968'))
                country = 'Oman';
            else if (countryCode.equals('+975') || countryCode.equals('975') || countryCode.equals('00975') || countryCode.equals('0975'))
                country = 'Bhutan'; //-
            else if (countryCode.equals('+359') || countryCode.equals('359') || countryCode.equals('00359') || countryCode.equals('0359'))
                country = 'Bulgaria';
            else if (countryCode.equals('+94') || countryCode.equals('94') || countryCode.equals('0094') || countryCode.equals('094'))
                country = 'Sri Lanka'; //7
            else if (countryCode.equals('+54') || countryCode.equals('54') || countryCode.equals('0054') || countryCode.equals('054'))
                country = 'Argentina'; //?- 
            
            
            
            /*    if(countryCode.startsWith('+')){
countryCode = countryCode.removeStart('+');
} */
        }
        List<Lead> leadlist = [SELECT Id, Name, Tracking_No__c,Virtual_Number_Text__c, LeadSource, Project__c, Country_Name_by_Code__c, Country_Code__c 
                               FROM Lead WHERE (MobilePhone = :customerNumber OR Other_Mobile_Number__c = :customerNumber) AND isConverted= false];
        
        string campaignId;
        String LeadSource, LeadSubSource, PrimaryCampaignCode, CampaignName, Project,TrackingCode,Site;
        List<Campaign> CampaignList = new List<Campaign>();
        // List<Project__c> project1List = new List<Project__c>();
        if(did != null){
            CampaignList = [SELECT Id, Name, Type, Marketing_Plan_Site__c,Tracking_Code__c, Virtual_Number__c,Project__r.Site__c,
                            Marketing_Channel__r.Name from Campaign where Virtual_Number__r.name = :did and IsActive = true];
            system.debug('CampaignList'+CampaignList);
        }
        if (CampaignList.size() > 0){      
            //LeadSource = CampaignList[0].Source__c;       
            //LeadSubSource = CampaignList[0].Sub_Source__c;
            //LeadSubSubSource = CampaignList[0].Sub_Sub_Source__c;
            CampaignName = CampaignList[0].Id;
            TrackingCode = CampaignList[0].Tracking_Code__c;
            Site = CampaignList[0].Project__r.Site__c;
            PrimaryCampaignCode = CampaignList[0].Virtual_Number__c;
            if(CampaignList[0].Project__c != null){
                Project = CampaignList[0].Project__c;
            }
        }
        
        Id taskLeadRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Lead').getRecordTypeId();    
        if(String.isNotBlank(callStatus) && callStatus != null && (callStatus.equalsIgnoreCase('NotAnswered')) && callType == 'Inbound' 
           && CampaignList != null && CampaignStatus == 'ONLINE' && !leadlist.isEmpty()){ 
               System.debug('Inside if callStatus: ' + callStatus + ' customerNumber::: ' + customerNumber + ' UUI::: '+UUI);
               	Task t = new Task();
                t.status = 'Open';
                t.Subject = 'Call back customer';
                t.RecordTypeId = taskLeadRecordTypeId;
                t.WhoId = leadlist[0].Id;
                //t.Call_Attempt_Status__c = 'New';
                //t.Call_Status__c = callStatus;
                t.CallObject = ucid;
                String[] tList = duration.split(':');
            	t.CallDurationInSeconds = Integer.valueOf(tList[0])*60*60 + Integer.valueOf(tList[1])*60 + Integer.valueOf(tList[2]);
                //t.Voice_Log_URL__c = recordingFile;
                //t.DID__c = Did;
                //t.UUI__c = UUI;
                //t.AgentId__c = agentid;
                //t.Campaign_Name__c = cb.CampaignName;
                //t.Call_Type__c = callType;
                //String dtIST = Datetime.valueOf(cb.StartTime).format('yyyy-MM-dd HH:mm:ss', 'IST');
                //t.Call_Start_Time__c =Datetime.valueOf(cb.StartTime.replace('T',' '));
            	//t.Call_Start_Time__c = Datetime.valueOf(t.Call_Start_Time__c.format('yyyy-MM-dd HH:mm:ss', 'IST'));//Datetime.valueOf(t.Call_Start_Time__c.format('yyyy-MM-dd HH:mm:ss', 'IST'));
            	//t.Call_End_Time__c =Datetime.valueOf(cb.EndTime.replace('T',' ')); //Datetime.valueOf(t.Call_End_Time__c.format('yyyy-MM-dd HH:mm:ss', 'IST'));
            	//t.Call_End_Time__c = Datetime.valueOf(t.Call_End_Time__c.format('yyyy-MM-dd HH:mm:ss', 'IST'));
                //t.Agent_Status__c = agentstatus;
                //t.Campaign_Status__c = cb.CampaignStatus;
                insert t;
               
           }else if(String.isNotBlank(callStatus) && callStatus != null && (callStatus.equalsIgnoreCase('NotAnswered')) && 
                    callType == 'Inbound' && CampaignList == null && CampaignStatus == 'ONLINE' && !leadlist.isEmpty()){
                Task t = new Task();
                t.status = 'Open';
                t.Subject = 'Call back customer';
                t.RecordTypeId = taskLeadRecordTypeId;
                t.WhoId = leadlist[0].Id;
                //t.Call_Attempt_Status__c = 'New';
                //t.Call_Status__c = callStatus;
                t.CallObject = ucid;
                String[] tList = duration.split(':');
            	t.CallDurationInSeconds = Integer.valueOf(tList[0])*60*60 + Integer.valueOf(tList[1])*60 + Integer.valueOf(tList[2]);
                //t.Voice_Log_URL__c = recordingFile;
                //t.DID__c = Did;
                //t.UUI__c = UUI;
                //t.AgentId__c = agentid;
                //t.Campaign_Name__c = cb.CampaignName;
                //t.Call_Type__c = callType;
                //String dtIST = Datetime.valueOf(cb.StartTime).format('yyyy-MM-dd HH:mm:ss', 'IST');
                //t.Call_Start_Time__c =Datetime.valueOf(cb.StartTime.replace('T',' '));
            	//t.Call_Start_Time__c = Datetime.valueOf(t.Call_Start_Time__c.format('yyyy-MM-dd HH:mm:ss', 'IST'));//Datetime.valueOf(t.Call_Start_Time__c.format('yyyy-MM-dd HH:mm:ss', 'IST'));
            	//t.Call_End_Time__c =Datetime.valueOf(cb.EndTime.replace('T',' ')); //Datetime.valueOf(t.Call_End_Time__c.format('yyyy-MM-dd HH:mm:ss', 'IST'));
            	//t.Call_End_Time__c = Datetime.valueOf(t.Call_End_Time__c.format('yyyy-MM-dd HH:mm:ss', 'IST'));
                //t.Agent_Status__c = agentstatus;
                //t.Campaign_Status__c = cb.CampaignStatus;
                insert t;
           }else if(String.isNotBlank(callStatus) && callStatus != null && (callStatus.equalsIgnoreCase('NotAnswered')) && callType == 'Inbound' 
           			&& CampaignList != null && CampaignStatus == 'ONLINE' && leadlist.isEmpty()){
               Lead l  = new Lead (
                   LastName = 'Missed Called Lead'+customerNumber,
                   MobilePhone = customerNumber,
                   Country_Code__c = countryCode,
                   Country_Name_by_Code__c = Country, 
                   Virtual_Number_Text__c = did,
                   Project__c = Project,
                   Tracking_No__c = TrackingCode,
                   Site__c = Site,
                   Campaign__c = CampaignName,
                   Status = 'Open',
                   Lead_Stage__c = 'Open'
               );
               
               try{
                   insert l;
                   Task t = new Task();
                   t.status = 'Open';
                   t.Subject = 'Call back customer';
                   t.RecordTypeId = taskLeadRecordTypeId;
                   t.WhoId = l.Id;
                   t.OwnerId = l.Id;
                   //t.Call_Attempt_Status__c = 'New';
                   //t.Call_Status__c = callStatus;
                   t.CallObject = ucid;
                   String[] tList = duration.split(':');
                   t.CallDurationInSeconds = Integer.valueOf(tList[0])*60*60 + Integer.valueOf(tList[1])*60 + Integer.valueOf(tList[2]);
                   //t.Voice_Log_URL__c = recordingFile;
                   //t.DID__c = Did;
                   //t.UUI__c = UUI;
                   //t.AgentId__c = agentid;
                   //t.Campaign_Name__c = cb.CampaignName;
                   //t.Call_Type__c = callType;
                   //String dtIST = Datetime.valueOf(cb.StartTime).format('yyyy-MM-dd HH:mm:ss', 'IST');
                   //t.Call_Start_Time__c =Datetime.valueOf(cb.StartTime.replace('T',' '));
                   //t.Call_Start_Time__c = Datetime.valueOf(t.Call_Start_Time__c.format('yyyy-MM-dd HH:mm:ss', 'IST'));//Datetime.valueOf(t.Call_Start_Time__c.format('yyyy-MM-dd HH:mm:ss', 'IST'));
                   //t.Call_End_Time__c =Datetime.valueOf(cb.EndTime.replace('T',' ')); //Datetime.valueOf(t.Call_End_Time__c.format('yyyy-MM-dd HH:mm:ss', 'IST'));
                   //t.Call_End_Time__c = Datetime.valueOf(t.Call_End_Time__c.format('yyyy-MM-dd HH:mm:ss', 'IST'));
                   //t.Agent_Status__c = agentstatus;
                   //t.Campaign_Status__c = cb.CampaignStatus;
                   insert t;
               }
               catch(Exception ex){
                   system.debug('Exception'+ex+':::::'+ex.getLineNumber());
               }
           }  
    }
    
    
}