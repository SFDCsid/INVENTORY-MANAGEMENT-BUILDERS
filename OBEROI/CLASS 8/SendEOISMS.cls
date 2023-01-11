public class SendEOISMS {
    @InvocableMethod
    public static void sendSMS(List<Id> eoId){
        List<EOI__c> eoList = [SELECT Id,Opportunity__r.Name,Country_Code_Mobile_1__c,Is_Channel_Partner_EOI__c, 
                               Country_Code_Property_Consultant_Mobile__c,Property_Consultant_s_Telephone_Mobile__c, 
                               Opportunity__r.Partner_s_Firm_Name__c,Opportunity__c,Mobile_No_1__c,Property_Consultant_s_Email__c,
                               Opportunity__r.EOI_Project__c,UniqueEOInumber__c,Opportunity__r.Channel_Partner_Name__c,
                               Opportunity__r.AccountId FROM EOI__c WHERE Id=: eoId];
        
        if(eoList != null && eoList.size()>0){
            List<Opportunity> optyList = [Select Id,Name,EOI_Project__c,AccountId,Channel_Partner_Name__c,UniqueEOInumber__c,
                                          Partner_s_Firm_Name__c From Opportunity Where Id=: eoList[0].Opportunity__c];
            for(EOI__c eo: eoList){ 
                if(eo.Is_Channel_Partner_EOI__c == true){
                    String statMess = 'Thank you for the interest in '+eo.Opportunity__r.EOI_Project__c+' by Oberoi Realty, submitted by '+eo.Opportunity__r.Channel_Partner_Name__c+' from '+eo.Opportunity__r.Partner_s_Firm_Name__c+' on behalf of '+eo.Opportunity__r.Name+'. The Unique code is '+eo.UniqueEOInumber__c+'. Kindly quote this code on the date of booking for a seamless experience.';                                                                                  
                    String mbNoStr = eo.Country_Code_Property_Consultant_Mobile__c + eo.Property_Consultant_s_Telephone_Mobile__c;
                    mbNoStr = mbNoStr.removeStart('+');
                    System.debug(mbNoStr);
                    String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(statMess, 'UTF-8')+'&senderid=ORLCRM';
                    system.debug('smsURL'+smsURL);
                    EnquirySMSCtrl.sendSMS(smsURL);
                }else{
                    String statMess = 'Thank you for your interest in '+eo.Opportunity__r.EOI_Project__c+' by Oberoi Realty. Your Unique code is '+eo.UniqueEOInumber__c+'. Kindly quote this code on the date of booking for a seamless experience.';
                    system.debug('statMess'+statMess);
                    String mbNoStr = eo.Country_Code_Mobile_1__c + eo.Mobile_No_1__c;
                    mbNoStr = mbNoStr.removeStart('+');
                    System.debug(mbNoStr);
                    String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(statMess, 'UTF-8')+'&senderid=ORLCRM';
                    system.debug('smsURL'+smsURL);
                    EnquirySMSCtrl.sendSMS(smsURL);
                }
                SendEOIPDF.sendEmail(eo.Id);
            }
        }
    }
}