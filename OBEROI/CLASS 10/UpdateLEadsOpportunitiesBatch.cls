global class UpdateLEadsOpportunitiesBatch implements Schedulable 
{
    global void execute(SchedulableContext sc) 
    {
      CloseLEadsOpportunities lc = new CloseLEadsOpportunities();
      Database.executeBatch(lc);
    }
    
    }