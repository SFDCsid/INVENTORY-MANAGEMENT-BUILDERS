Public class BookingEmailToCustomer{
    Public Static void sendEmail(set<id> bookids){
    List<Booking__c> booklist = New  List<Booking__c>();
    List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();
    List<Messaging.SingleEmailMessage> actualMessageList = new List<Messaging.SingleEmailMessage>();
    Id Etid = [SELECT Id from EmailTemplate where developername='Booking_Confirmation_Email'].Id;
        If(Bookids.size()>0){
            booklist = [Select id,Name,Opportunity__c,Opportunity__r.Owner.Email,Opportunity__r.Owner.Name,Future_Correspondence_Contact_Email__c
            From Booking__c where id in:Bookids];
            For(Booking__c boo : booklist){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setToAddresses(new String[] { boo.Future_Correspondence_Contact_Email__c});
                message.setTemplateId(Etid);
                message.setSaveAsActivity(false);
                message.setTargetObjectId(UserInfo.getUserId());
                message.setWhatId(boo.Id);
                message.setReplyTo(boo.Opportunity__r.Owner.Email); 
                message.setSenderDisplayName(boo.Opportunity__r.Owner.Name);
                messageList.add(message);
            }   
             Savepoint sp = Database.setSavepoint();
             Messaging.sendEmail(messageList);
             Database.rollback(sp); 
             
             for (Messaging.SingleEmailMessage email : messageList) {
                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend.setToAddresses(email.getToAddresses());
                emailToSend.setHTMLBody(email.getHTMLBody());
                emailToSend.setSubject(email.getSubject());
                emailToSend.setReplyTo(email.getReplyTo()); 
                emailToSend.setSenderDisplayName(email.getSenderDisplayName());
                actualMessageList.add(emailToSend);
            }
            Messaging.SendEmailResult [] serList = Messaging.sendEmail(actualMessageList);                    
        }        
    }
}