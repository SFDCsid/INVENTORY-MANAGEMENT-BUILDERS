global class RegistrationReminderSchedule Implements Schedulable{
    global void execute(SchedulableContext sc){
        RegistrationReminderBatch rr = new RegistrationReminderBatch();
        database.executeBatch(rr, 100);
    }
}