public class AsyncCustomerJodiUpdate implements Queueable {  
    String bookingOrder = '';  
    public AsyncCustomerJodiUpdate(String bookingOrder) {  
          this.bookingOrder = bookingOrder;  
    } 
    public void execute(QueueableContext qc) {  
        Booking__c  booking = [ SELECT Id FROM Booking__c WHERE ID =: bookingOrder LIMIT 1];
        ORL_SAP_IntegrationHelper.updateResidentialCustomerInSAPFuture(booking.Id);
    }  
}