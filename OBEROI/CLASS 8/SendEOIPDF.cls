public class SendEOIPDF {
    @InvocableMethod
    public static void sendSMSwithPDF(List<Id> eoId){
        system.debug('insidesendeoipdf');
        List<EOI__c> eoList = [Select Id,Opportunity__c,Name,Project__r.Name,Is_Channel_Partner_EOI__c,Country_Code_Mobile_1__c,Mobile_No_1__c,
                               UniqueEOInumber__c,Project__r.Payment_Options__c From EOI__c Where Id=: eoId];
        
        if(eoList != null && eoList.size()>0){
            for(EOI__c eo: eoList){
                sendEmail(eo.Id);    
            }              
        }
    } 
    @future(callout=true)
    public static void sendEmail(Id eoiId){
        EOI__c eo = [Select Id,Opportunity__c,Name,Project__r.Name,Is_Channel_Partner_EOI__c,Country_Code_Mobile_1__c,Mobile_No_1__c,
                     UniqueEOInumber__c,Project__r.Payment_Options__c,Property_Consultant_s_Email__c From EOI__c Where Id=: eoiId];
        List<Opportunity> optyList = new List<Opportunity>();
        if(eo != null){
            optyList = [Select Id,Name,EOI_Project__c,AccountId,Channel_Partner_Name__c,UniqueEOInumber__c,
                        Partner_s_Firm_Name__c From Opportunity Where Id=: eo.Opportunity__c];
            
            EmailTemplate templateId1 = [Select id,Name,Body from EmailTemplate where name = 'RP EOI registration']; 
            EmailTemplate templateId2 = [Select id,Name,Body from EmailTemplate where name = 'CP EOI Registration'];
            
            List<OrgWideEmailAddress> orgw = [SELECT Id,Address FROM OrgWideEmailAddress where Address = 'bhagyashri.gandhare@stetig.in' ];
            Messaging.Email[] messages = new Messaging.Email[0];
            
            if(optyList != NULL && optyList.size()>0){
                for(Opportunity op:optyList){   
                    system.debug('eoIdinsideopty'+eo.Id);
                    List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                    String customLabelValue = System.Label.SendEOIEmailSMSUrl;
                    PageReference pref = new PageReference(customLabelValue);
                    pref.getParameters().put('eoId',eo.Id); 
                    
                    Blob bb;
                    if(!Test.isRunningTest()){
                        bb = pref.getContentAsPDF();   
                        System.debug('bb==>'+bb);
                    } else {
                        bb = Blob.valueOf('Test123');
                    }      
                    
                    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();                                
                    attach.setBody(bb);
                    attach.setFileName('EOI.pdf'); 
                    fileAttachments.add(attach);
                    
                    list<string> lststringtoaddress = new list<string>();
                    list<string> lststringccaddress = new list<string>();
                    list<string> lststringbccaddress = new list<string>();
                    
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    List<Contact> conList = [SELECT Id,Name FROM Contact WHERE AccountId=:op.AccountId];
                    if(eo.Is_Channel_Partner_EOI__c == true){
                        if(eo.Property_Consultant_s_Email__c != null){
                            lststringtoaddress.add(eo.Property_Consultant_s_Email__c);
                        }
                        email.setTemplateId(templateId2.id);
                    }else {
                        email.setTemplateId(templateId1.id);
                    }
                    email.setwhatid(op.Id);
                    email.setOrgWideEmailAddressId(orgw[0].id);
                    email.setTargetObjectId(conList[0].id);
                    email.setSaveAsActivity(false);
                    
                    //lststringbccaddress.add('amit.kshirsagar@stetig.in');
                    lststringbccaddress.add('chandan.kokul@oberoirealty.com');
                    email.setToAddresses(lststringtoaddress);   
                    email.setCcAddresses(lststringccaddress);
                    email.setBccAddresses(lststringbccaddress);
                    email.setFileAttachments(fileAttachments); 
                    messages.add(email);
                    Messaging.sendEmail(messages);
                }
            }
        }
    }
}