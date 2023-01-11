global class CloseLeadOpptySchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      CloseLEadsOpportunities b = new CloseLEadsOpportunities(); 
      database.executebatch(b,1);
   }
}