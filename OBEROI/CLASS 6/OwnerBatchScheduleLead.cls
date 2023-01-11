global class OwnerBatchScheduleLead implements Schedulable {
   global void execute(SchedulableContext sc) {
      LeadOwnerUpdateBatch b = new LeadOwnerUpdateBatch(); 
      database.executebatch(b);
   }
}