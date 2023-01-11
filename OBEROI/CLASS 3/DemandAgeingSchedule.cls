global class DemandAgeingSchedule Implements Schedulable{
    global void execute(SchedulableContext sc){
        DemandAgeingEmailBatch da = new DemandAgeingEmailBatch();
        database.executeBatch(da, 100);
    }
}