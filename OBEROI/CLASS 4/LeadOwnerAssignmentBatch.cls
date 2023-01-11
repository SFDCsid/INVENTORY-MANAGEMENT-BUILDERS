global class LeadOwnerAssignmentBatch implements Schedulable 
{
    global void execute(SchedulableContext sc) 
    {
      LeadOwnerUpdateBatch lc = new LeadOwnerUpdateBatch();
      Database.executeBatch(lc);
    }
    
    }