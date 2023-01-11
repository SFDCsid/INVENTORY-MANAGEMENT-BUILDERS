public class ApplicantHelper {

    public static void sendApplicantNameChange(Map<String,Applicant__c> appMap){
       
        for(String a:appMap.KeySet()){
           
            system.debug('OldName=='+a); 
            system.debug('NewName=='+appMap.get(a).Name); 
              List<String> toAddresses=new List<String>();
              List<String> ccAddresses=new List<String>();
              // ccAddresses.add('yogesh.swami@excellerconsultancy.in');
             if(String.isNotBlank(appMap.get(a).Site_Support_Email__c)){
                toAddresses.add(appMap.get(a).Site_Support_Email__c);      
             }
            if(String.isNotBlank(appMap.get(a).Central_Support_Email__c)){
                toAddresses.add(appMap.get(a).Central_Support_Email__c);      
             }
           if(!toAddresses.isEmpty()){
        String Subject='Applicant Name Changed';
        String body = 'Dear Sir/ Ma\'am,<br/><br/>'
+'Applicant details: <a href="https://oberoirealty.lightning.force.com/'+appMap.get(a).Id+'">'+appMap.get(a).Name+'</a><br/>'
+'Booking no: <a href="https://oberoirealty.lightning.force.com/'+appMap.get(a).Booking__c+'">'+appMap.get(a).Booking_No__c+'</a><br/>'
+'Applicant name changed from: (Old:) '+a+' to (New:) '+appMap.get(a).Name+'<br/>'  
+'Applicant Type: '+appMap.get(a).Applicant_Number__c+'<br/>'              
+'Customer Code: '+appMap.get(a).Customer_Code__c+'<br/>'  
+'Sales Order Number(SAP): '+appMap.get(a).Sales_Order_Number_SAP__c+'<br/>'             
+'Last Modified Date: '+appMap.get(a).LastModifiedDate+'<br/>'    
 
+'<br/><br/>'
+'Regards,<br/>'
+'ORL Admin<br/>';
               Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
              
                email.setToAddresses(toAddresses);
                //email.setCcAddresses(ccAddresses);
                email.setSubject(Subject);
                email.setHtmlBody(body);
               
				Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.Singleemailmessage[] {email});
                  if (results[0].success) {
                     System.debug('The email was sent successfully.');
                  } else {
                     System.debug('The email failed to send: ' + results[0].errors[0].message);
                  }
         }
        }
    }
}