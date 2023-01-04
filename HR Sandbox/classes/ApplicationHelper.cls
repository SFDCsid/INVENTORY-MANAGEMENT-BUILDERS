public class ApplicationHelper {

      public static void sendmailtoapp(list<Application_Details__c> applicationlist){
        //Sandbox Site: https://hrsandbox-excellerconsultancy.cs75.force.com/ScreeningForm
        //Prodution Site: https://excellerconsultancy.secure.force.com/ScreeningForm
          OrgWideEmailAddress owea = new OrgWideEmailAddress();
        owea = [SELECT Id, Address, DisplayName FROM 
                OrgWideEmailAddress WHERE DisplayName='HR@excellerconsultancy.in'];
          
        for(Application_Details__c app:applicationlist){
            if(String.isNotBlank(app.Email__c)){

               // String Recordlink = app.Id;
                String Subject='About application to Exceller Management Consultancy.';
                String body='Dear Candidate,<br/><br/>'
                    +'Thanks for your interest in Exceller Management Consultancy.<br/>'
                    +'Please fill out the below screening form. <br/><br/>'
                    +'<a href=https://excellerconsultancy.secure.force.com/ScreeningForm?id='+app.Id+'>Click here </a> <br/></br>'
                    +'Have a nice day.<br/><br/>'
                    +'<b>Regards,</b><br/>'
                    +'<b>Team HR </b><br/>'
                    +'<b>Exceller Management Consultancy</b><br/>';
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                String[] toAddresses=new String[]{app.Email__c};
                     if ( owea != null) {
                    message.setOrgWideEmailAddressId(owea.id);
                }  
                //ccAddresses.add('dhanashree.patil@excellerconsultancy.in');
                message.setToAddresses(toAddresses);
                message.setSubject(Subject);
                message.setHtmlBody(body);
                 message.setTreatTargetObjectAsRecipient(false);
                    message.setWhatId(app.Id);
                Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.Singleemailmessage[] {message});
                  if (results[0].success) {
                     System.debug('The email was sent successfully.');
                  } else {
                     System.debug('The email failed to send: ' + results[0].errors[0].message);
                  }
                
            }
            
        }
        
    }
    public static void sendApplAcceptedEmail(List<Application_Details__c> aplist){
      
          OrgWideEmailAddress owea = new OrgWideEmailAddress();
        owea = [SELECT Id, Address, DisplayName FROM 
                OrgWideEmailAddress WHERE DisplayName='HR@excellerconsultancy.in'];
        
        for(Application_Details__c ap:aplist){
                   
            if(String.isNotBlank(ap.Email__c)){
                 List<String> toAddress = new List<String>();
                 List<String> ccAddress = new List<String>();
                
                    toAddress.add(ap.Email__c);
                   // ccAddress.add('yogesh.swami@excellerconsultancy.in');
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();   
                    
                    String body = 'Dear Candidate,<br/><br/><br/>'
+'We are glad to inform you have been shortlisted for HR + Aptitude Round. You will receive your interview link shortly.<br/><br/>'
+'We appreciate your patience and keen interest with Exceller Management Consultancy.<br/><br/>'
+'Have a nice day.<br/><br/><br/>'
+'<b>Regards,</b><br/>'
+'<b>Team HR</b><br/>'
+'<b>Exceller Consultancy</b><br/>';                        
                    String subject = 'You have been shortlisted for the Interview';
                
                 if ( owea != null) {
                    email.setOrgWideEmailAddressId(owea.id);
                }  
                      ccAddress.add('dhanashree.patil@excellerconsultancy.in');
                
                      email.setSubject(subject);
                   // email.setOrgWideEmailAddressId(orgw[0].id);
                      email.setToAddresses(toAddress);
                   // email.setCcAddresses(ccAddress);
                   // email.setBccAddresses(bccAddress);
                     email.setHtmlBody(body);
                     email.setTreatTargetObjectAsRecipient(false);
                     email.setWhatId(ap.Id);
                     Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.Singleemailmessage[] {email});
                  if (results[0].success) {
                     System.debug('The email was sent successfully.');
                  } else {
                     System.debug('The email failed to send: ' + results[0].errors[0].message);
                  }
            
        }else{
            ap.addError('"Email Address" Field Is Missing (At Account level). Please Add "Email" field And Try Again.');
        }
      }
    }
    
    public static void updateOfferCreated(Map<Id,Offer__c> OfferMap){
        List<Application_Details__c> aplist = new List<Application_Details__c>();
       for(Id opId:OfferMap.keySet()){
           Application_Details__c apUpdate = new Application_Details__c();
           apUpdate.id=opId;
           apUpdate.Application_Status__c = 'Offer Created';
           apUpdate.Latest_Offer_Created__c = OfferMap.get(opId).id;
           aplist.add(apUpdate);
       }
        if(!aplist.isEmpty()){
            update aplist;
        }
    }
    public static void updateScreeningCreated(Map<Id,Screening_Questionnaire__c> scMap){
        List<Application_Details__c> aplist = new List<Application_Details__c>();
       for(Id apId:scMap.keySet()){
           Application_Details__c apUpdate = new Application_Details__c();
           apUpdate.id=apId;
           apUpdate.Application_Status__c = 'Ongoing Screening';
           apUpdate.Latest_Screening__c = scMap.get(apId).id;
           apUpdate.Screening_Submitted__c = true;
           aplist.add(apUpdate);
       }
        if(!aplist.isEmpty()){
            update aplist;
        }
    }
    
    public static void OfferApprovedEmail(list<Offer__c> offerlist){
        //Sandbox Site: https://hrsandbox-excellerconsultancy.cs75.force.com/OfferForm
        //Prodution Site: https://excellerconsultancy.secure.force.com/OfferForm
             OrgWideEmailAddress owea = new OrgWideEmailAddress();
        owea = [SELECT Id, Address, DisplayName FROM 
                OrgWideEmailAddress WHERE DisplayName='HR@excellerconsultancy.in'];
        for(Offer__c offer:offerlist){
            if(String.isNotBlank(offer.Applicant_Email__c)){
            
                try{
                String Subject='Congratulations for your offer with Exceller Management Consultancy!';
                String Body='Dear Candidate,<br/><br/>' 
                    +'Congratulations!!! <br/>'
                    +'Please Click On Below link to Accept or Reject the Offer <br/><br/>'
                    +'<a href=https://excellerconsultancy.secure.force.com/OfferForm?id='+offer.Id+'>Click here </a> <br/></br>'
                    +'Have a nice day.<br/><br/><br/>'
                    +'<b>Regards,</b><br/>'
                    +'<b>Team HR</b><br/>'
                    +'<b>Exceller Consultancy</b><br/>';   
                String currentUserEmail = UserInfo.getUserEmail();
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    String[] toAddresses=new String[] {offer.Applicant_Email__c};
                        
                    String[] ccAddresses=new String[] {currentUserEmail};
                        if ( owea != null) {
                    message.setOrgWideEmailAddressId(owea.id);
                }  
                      ccAddresses.add('dhanashree.patil@excellerconsultancy.in');
                
                    message.setToAddresses(toAddresses);
                    message.setCcAddresses(ccAddresses);
                    message.setSubject(Subject);
                    message.setHtmlBody(Body);
                    message.setTreatTargetObjectAsRecipient(false);
                    message.setWhatId(offer.Application__c);
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.Singleemailmessage[] {message});
                      if (results[0].success) {
                         System.debug('The email was sent successfully.');
                      } else {
                         System.debug('The email failed to send: ' + results[0].errors[0].message);
                      }
                }catch(Exception e){
                    system.debug(e);
                } 
            }
        }
        } 
        

}