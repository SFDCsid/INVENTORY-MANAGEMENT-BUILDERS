global class createTaskOnCBNAScheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
      createTaskOnCBNA b = new createTaskOnCBNA(); 
      database.executebatch(b);
   }
}