global class CallTriggerHandler {
    @future(Callout = True)
    webservice static void sendSMS(List<id> callid) {
        String SMSmessage;
        PMT_Central_Number__c centralNumber = PMT_Central_Number__c.getOrgDefaults();
        String contactNumber = centralNumber.PMT_Number__c;
        //String contactNumber = Called_Number__c
        List<call__c> calllst=[select Call_Status__c,Calling_Country_code__c,Calling_Number__c from call__c where id in :callid];
        
        for(call__c callDetails: calllst){
            if(callDetails.Call_Status__c == 'Missed'){
                SMSmessage = 'Thank you for calling Oberoi Realty. We are sorry to have missed your call, our team will get back to you at the earliest.' ; 
            }if(callDetails.Call_Status__c == 'Not Answered'){
                SMSmessage = 'Greetings from Oberoi Realty. We tried calling you but were unable to get through. Please call us on '+contactNumber + 'at a time convenient to you. Thank you.' ; 
            }if(callDetails.Call_Status__c == 'Answered'){
                SMSmessage = 'Thank you for calling Oberoi Realty. We hope we were of assistance to you. For any further queries.'; 
            }
            
            String mbNoStr = callDetails.Calling_Country_code__c + callDetails.Calling_Number__c;
            //mbNoStr = mbNoStr.removeStart('+');
            //mbNoStr = '919740952069';
            //String mbNoStr=mbno;
            mbNoStr = mbNoStr.replaceAll('/[^0-9]/g','');
            mbNoStr =mbNoStr.remove('(');
            mbNoStr =mbNoStr.remove(')');
            mbNoStr =mbNoStr.remove('+');
            mbNoStr =mbNoStr.remove('-');
            mbNoStr =mbNoStr.remove(' ');
            try{ 
                system.debug('mbNoStr__'+mbNoStr);
                //String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(message, 'UTF-8')+'&senderid=ORLCRM';
                //string smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=8879255563&password=pdmtj&To='+String.valueof(phNo)+'&Text='+EncodingUtil.urlEncode(Message, 'UTF-8')+'&senderid=Test';
                //String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(statMess, 'UTF-8')+'&senderid=ORLCRM';       
                String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=8879255563&password=pdmtj&To='+String.valueof(mbNoStr)+'&Text='+EncodingUtil.urlEncode(SMSmessage, 'UTF-8')+'&senderid=ORLCRM';        
                EnquirySMSCtrl.sendSMS(smsURL); 
                system.debug('***done**');
            }
            catch(exception ex){
                system.debug(ex.getMessage()+'****getError');            
            }
        }
        
    }
    
    public static void sendEmail(Call__c callDetails) {
        
        If(callDetails.Lead__c!=null){
            system.debug('In Email------>');
            Lead sinlgeContact = [SELECT Email FROM Lead WHERE Id=:callDetails.Lead__c];
            List<Lead> LdLst =[SELECT Email FROM Lead WHERE Id=:callDetails.Lead__c];
            try{
                if(LdLst.size()>0){
                    //Contact ContName =[select Name from contact where id=:callDetails.Contact__c];
                    List<string> toAddress = new List<string>();
                    toAddress.add(sinlgeContact.Email);
                    EmailTemplate templateId = [Select id,subject,HtmlValue, Body from EmailTemplate where name = 'Inbound call is answered at the SENT TO THE CUSTOMER'];
                    String htmlBody = templateId.HtmlValue;
                    htmlBody = htmlBody.replace('{!Call__c.Lead_Name__c}', callDetails.Lead_Name__c);
                    htmlBody = htmlBody.replace('{!Call__c.Called_Number__c}', callDetails.Called_Number__c);
                    
                    String plainBody = templateId.Body;
                    plainBody = plainBody.replace('{!Call__c.Lead_Name__c}', callDetails.Lead_Name__c);
                    plainBody = plainBody.replace('{!Call__c.Called_Number__c}', callDetails.Called_Number__c);
                    
                    List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateID(templateId.Id); 
                    mail.setToAddresses(toAddress);
                    mail.setHtmlBody(htmlBody);
                    mail.setPlainTextBody(plainBody);
                    mail.setSubject('Thank you for calling Oberoi Realty');
                    mail.setTargetObjectId(sinlgeContact.Id);
                    mail.setSenderDisplayName('ORL CRM');
                    System.debug('emailId__'+sinlgeContact.Email);
                    //mail.setOrgWideEmailAddressId(sinlgeContact.Email);
                    allmsg.add(mail);
                    Messaging.sendEmail(allmsg,false);
                }
            }
            catch(Exception e){
                System.debug('Skip error:'+e.getMessage());
            }
            
        }
        
    }
    //-------------------------
    public static void missedUpdatecomingCall(List<Call__c> newCallList,Map<id,Call__c> oldCallMap){
        For(Call__c singleCall:newCallList){
            sendEmail(singleCall);//Added on 21-05
        }
    }
    
    
    public static void updateLeadEmail(List<Call__c> newCallList, Map <id, Call__c>oldCallMap, string operation){
        set<Id>leadSet = new set<Id>();
        Map <id,Lead> ldMap = new Map<id,Lead>();
        
        for (Call__c cl : newCallList){ 
            if(operation == 'Insert') {      
                leadSet.add(cl.Lead__c);
            } else if(operation == 'Update'){
                if(oldCallMap.get(cl.id).Lead__c != cl.Lead__c)
                    leadSet.add(cl.Lead__c);
            }
        }
        if(leadSet.size() >0){
            for(Lead ld: [SELECT id, Email FROM Lead WHERE id IN : leadSet ] ){
                ldMap.put(ld.id, ld);
            }
        }        
        for(Call__c cl : newCallList){
            if(ldMap.size() > 0){
                if(cl.LEad__c!= null && ldMap.get(cl.Lead__c).Email != null){
                    cl.Lead_s_Email__c = ldMap.get(cl.Lead__c).Email ;
                }      
            } 
        }
    }
    
    
    
    //Added by Ravi Kumar K
    public static void updateLeadonCall(List<Call__c> newCallList,Map<id,Call__c> oldCallMap, String methodName){
        Map<String,Lead> mobilePhoneMap = new Map<String,Lead>();
        Map<String,Lead> PhoneMap = new Map<String,Lead>();
        Map<String,Lead> OtherPhoneMap = new Map<String,Lead>();
        
        List<Lead> leadList = [SELECT Country_Code_for_Phone__c,Country_Code_for_Other_Mobile_Number__c,
                               MobilePhone,Phone,Country_Code__c,Other_Mobile_Number__c FROM Lead 
                               WHERE MobilePhone!=null OR Phone!=null OR Other_Mobile_Number__c!=null] ;
        
        For(Lead singleLead:leadList){
            if(singleLead.MobilePhone!=null){  
                mobilePhoneMap.put(singleLead.MobilePhone,singleLead);  
            }else if(singleLead.Phone!=null){          
                PhoneMap.put(singleLead.Phone,singleLead);
            }else{
                OtherPhoneMap.put(singleLead.Other_Mobile_Number__c,singleLead);
            }
        }
        List<Call__c> updatedCallList = new List<Call__c>();
        For(Call__c sinlgeCall :newCallList){
            
            system.debug('singleCall$$$'+sinlgeCall);
            if(mobilePhoneMap.get(sinlgeCall.Calling_Number__c)!=null
               && mobilePhoneMap.get(sinlgeCall.Calling_Number__c).Country_Code__c==sinlgeCall.Calling_Country_code__c)
            {
                sinlgeCall.Lead__c = mobilePhoneMap.get(sinlgeCall.Calling_Number__c).Id;
                updatedCallList.add(sinlgeCall);
            }if(PhoneMap.get(sinlgeCall.Calling_Number__c)!=null && 
                PhoneMap.get(sinlgeCall.Calling_Number__c).Country_Code__c==sinlgeCall.Calling_Country_code__c)
            {
                sinlgeCall.Lead__c = PhoneMap.get(sinlgeCall.Calling_Number__c).Id;
                updatedCallList.add(sinlgeCall);
            }if(OtherPhoneMap.get(sinlgeCall.Calling_Number__c)!=null && 
                OtherPhoneMap.get(sinlgeCall.Calling_Number__c).Country_Code_for_Other_Mobile_Number__c==sinlgeCall.Calling_Country_code__c)
            {
                sinlgeCall.Lead__c = OtherPhoneMap.get(sinlgeCall.Calling_Number__c).Id;
                updatedCallList.add(sinlgeCall);
            }
        }
        /*if(updatedCallList.size()>0){
update updatedCallList;
}*/
    }
    
    //Updated by Vaidehi 31/05/2019
    public static void missedIncomingCall(List<Call__c> newCallList,Map<id,Call__c> oldCallMap, String methodName){
        
        For(Call__c singleCall:newCallList){
            system.debug('singleCall$$$'+singleCall);
            if(singleCall.Call_Type__c=='Inbound' && singleCall.Call_Status__c=='Missed'){
                if(methodName == 'insert' || ((oldCallMap.get(singleCall.Id).Call_Type__c != singleCall.Call_Type__c  || oldCallMap.get(singleCall.Id).Call_Status__c != singleCall.Call_Status__c)&& methodName == 'update') ){
                    sendSMS(singleCall);
                }
            }          
            if(singleCall.Call_Type__c=='Outbound' && singleCall.Call_Status__c=='Not Answered'  ){
                if(methodName == 'insert' || ((oldCallMap.get(singleCall.Id).Call_Type__c != singleCall.Call_Type__c  || oldCallMap.get(singleCall.Id).Call_Status__c != singleCall.Call_Status__c)&& methodName == 'update') ){
                    sendSMS(singleCall);
                }
            }
            if(singleCall.Call_Type__c=='Inbound' && singleCall.Call_Status__c=='Answered'){
                if(methodName == 'insert'){
                    // sendEmail(singleCall);//Created Email Alert for this
                    sendSMS(singleCall); 
                }
                else if((oldCallMap.get(singleCall.Id).Call_Type__c != singleCall.Call_Type__c  || oldCallMap.get(singleCall.Id).Call_Status__c != singleCall.Call_Status__c)&& methodName == 'update') {
                    system.debug('In IF^^^^^');
                    sendSMS(singleCall);                   
                }
                
                
            }    
        }   
    }
    
    
    public static void sendSMS(Call__c callDetails) {
        String message;
        //PMT_Central_Number__c centralNumber = PMT_Central_Number__c.getOrgDefaults();
        //String contactNumber = centralNumber.PMT_Number__c;
        String contactNumber = '';
        if(callDetails.Called_Number__c != Null){
            contactNumber = callDetails.Called_Number__c;
        }else if(callDetails.Lead__c != Null){
            List<Lead> leadList = [select id,name,Campaign__c,Campaign__r.Virtual_Number__r.Name from Lead where Id=:callDetails.Lead__c];
            if(leadList[0].Campaign__r.Virtual_Number__r.Name != Null){
                contactNumber = leadList[0].Campaign__r.Virtual_Number__r.Name;
            }
        }else{
        }
        
        if(callDetails.Call_Status__c == 'Missed'){
            message = 'Thank you for calling Oberoi Realty. We are sorry to have missed your call, our team will get back to you at the earliest.' ; 
        }if(callDetails.Call_Status__c == 'Not Answered'){
            if(contactNumber != '' && contactNumber != Null){
                message = 'Greetings from Oberoi Realty. We tried calling you but were unable to get through. Please call us on '+contactNumber + ' at a time convenient to you. Thank you.' ; 
            }else{
                message = 'Greetings from Oberoi Realty. Thank you for your interest in our project. Our customer service team tried calling you but were unable to get through, we shall get in touch with you at the earliest.';
            }
        }if(callDetails.Call_Status__c == 'Answered'){
            message = 'Thank you for calling Oberoi Realty. We hope we were of assistance to you. For any further queries, please feel free to call us on '+contactNumber+'.'; 
        }
        
        String mbNoStr = callDetails.Calling_Country_code__c + callDetails.Calling_Number__c;
        //mbNoStr = mbNoStr.removeStart('+');
        //mbNoStr = '919740952069';
        mbNoStr = mbNoStr.replaceAll('/[^0-9]/g','');
        mbNoStr =mbNoStr.remove('(');
        mbNoStr =mbNoStr.remove(')');
        mbNoStr =mbNoStr.remove('+');
        mbNoStr =mbNoStr.remove('-');
        mbNoStr =mbNoStr.remove(' ');
        try{ 
            system.debug('mbNoStr__'+mbNoStr);
            String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(message, 'UTF-8')+'&senderid=ORLCRM';
            EnquirySMSCtrl.sendSMS(smsURL); 
            system.debug('***done**');
        }
        catch(exception ex){
            system.debug(ex.getMessage()+'****getError'+ex.getLineNumber());            
        }
    }
    
    
    
}