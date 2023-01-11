public class AsyncSalesOrder implements Queueable {  
    String salesorder = '';  
    public AsyncSalesOrder(String salesorder) {  
          this.salesorder = salesorder;  
    } 
    public void execute(QueueableContext qc) {  
        Booking__c  booking = [ SELECT Id,Related_Jodi_Booking__c FROM Booking__c WHERE ID =: salesorder LIMIT 1];
        ORL_SAP_IntegrationHelper.createSalesOrderInSAPFuture(booking.Id);
        
        //Customer Creation for Related Jodi Property
        // Chain this job to next job by submitting the next job
        if(!String.isBlank(booking.Related_Jodi_Booking__c)){
         System.enqueueJob(new AsyncCustomerSalesOrder(booking.Related_Jodi_Booking__c));}
    }  
}