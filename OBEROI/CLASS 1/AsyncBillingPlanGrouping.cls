public class AsyncBillingPlanGrouping implements Queueable {  
    List<String> lstId;
    public AsyncBillingPlanGrouping(List<String> lstId) {  
          this.lstId = lstId;  
    } 
    public void execute(QueueableContext qc) {  
        for(String s : lstId){
            //ORL_SAPInterfaceTriggerHandler.createBillingLineItemsFuture(s);
            BillingPlanLineItemGroupingController.createBillingLineItemsFuture(s);
            system.debug('Aditya Bhasin++++++++');
        }
    }  
}