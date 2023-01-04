public class EmailUtility {
    public static void sendScheduledmail(list<Interview__c> interviewlist){
        OrgWideEmailAddress owea = new OrgWideEmailAddress();
        owea = [SELECT Id, Address, DisplayName FROM 
                OrgWideEmailAddress WHERE DisplayName='HR@excellerconsultancy.in'];
        
        for(Interview__c interview:interviewlist){
            if(String.isNotBlank(interview.Email__c)){
                DateTime dt = interview.Scheduled_Date__c;
                string location = interview.Office_location__c != Null? interview.Office_location__c :'';
                string vlink = interview.Virtual_Meeting_Link__c != Null? interview.Virtual_Meeting_Link__c:'';
                System.debug('location: '+location);
                System.debug('---->'+dt);
                String dateTimeStr = dt.format('dd/MM/yyyy hh:mm:ss a');
                System.debug('>>>>' + dateTimeStr);   
                String Subject='Your Interview with Exceller consultancy has been Scheduled';
                String body = 'Dear Candidate,<br/><br/>'
                    +'We are glad to inform you that your '+ interview.Interview_Location__c +' interview with Exceller Management Consultancy has been scheduled on '+dateTimeStr+'.<br/>'+
                    ' Location: '+  location +'<br/>'+
                    ' Virtual Link: '+          
                    +'<br/> Have a nice day.<br/><br/>'
                    +'<b> Regards,</b><br/>'
                    +'<b> Team HR</b><br/>'
                    +'<b> Exceller Management Consultancy<b><br/>';    
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                List<String> toAddresses=new List<String>();
                List<String> ccAddresses=new List<String>();
               
                toAddresses.add(interview.Email__c);      
               
                Interviewer_Details__c interviewer;
                if(String.isNotBlank(interview.Interviewer_Name__c)){
                  interviewer = Interviewer_Details__c.getInstance(interview.Interviewer_Name__c);
                }

                if(String.isNotBlank(interviewer.Email__c)){
                    ccAddresses.add(interviewer.Email__c);                    
                }
                
                 if ( owea != null) {
                    email.setOrgWideEmailAddressId(owea.id);
                }  
                ccAddresses.add('dhanashree.patil@excellerconsultancy.in');
                email.setToAddresses(toAddresses);
                email.setCcAddresses(ccAddresses);
                email.setSubject(Subject);
                email.setHtmlBody(body);
                email.setTreatTargetObjectAsRecipient(false);
                email.setWhatId(interview.Application_Detail__c);
                Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.Singleemailmessage[] {email});
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }
            } 
        }
    }
    
    public static void sendReScheduledmail(list<Interview__c> interviewlist){
        OrgWideEmailAddress owea = new OrgWideEmailAddress();
        owea = [SELECT Id, Address, DisplayName FROM 
                OrgWideEmailAddress WHERE DisplayName='HR@excellerconsultancy.in'];
        
        for(Interview__c interview:interviewlist){
            if(String.isNotBlank(interview.Email__c)){
                
                DateTime dt = interview.Scheduled_Date__c;
                string location = interview.Office_location__c != Null? interview.Office_location__c :'';
                string vlink = interview.Virtual_Meeting_Link__c != Null? interview.Virtual_Meeting_Link__c:'';
                System.debug('location: '+location);
                System.debug('---->'+dt);
                String dateTimeStr = dt.format('dd/MM/yyyy hh:mm:ss a');
                System.debug('>>>>' + dateTimeStr);
                String Subject='Your Interview with Exceller consultancy has been Re-Scheduled';
                String body = 'Dear Candidate,<br/><br/>'
                    +'We are glad to inform you that your '+ interview.Interview_Location__c +' interview with Exceller Management Consultancy has been Re-scheduled on '+dateTimeStr+'<br/>'            
                    +' Location: '+  location +'<br/>'
                    +' Virtual Link: '
                    +'Have a nice day.<br/><br/>'
                    +'<b>Regards,</b><br/>'
                    +'<b>Team HR</b><br/>'
                    +'<b>Exceller Consultancy</b><br/>';
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                 String[] toAddresses=new String[] {interview.Email__c};
                List<String> ccAddresses=new List<String>();
                    
               Interviewer_Details__c interviewer = Interviewer_Details__c.getInstance(interview.Interviewer_Name__c);

                if(String.isNotBlank(interviewer.Email__c)){
                    ccAddresses.add(interviewer.Email__c);                    
                }
                    
                    
                if ( owea != null) {
                    message.setOrgWideEmailAddressId(owea.id);
                }  
                ccAddresses.add('dhanashree.patil@excellerconsultancy.in');
               
                message.setToAddresses(toAddresses);
                message.setCcAddresses(ccAddresses);
           
                message.setSubject(Subject);
                message.setHtmlBody(body);
                message.setTreatTargetObjectAsRecipient(false);
                message.setWhatId(interview.Application_Detail__c);
                Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.Singleemailmessage[] {message});
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }
            } 
        }
    }    
    
    
    
}