global class AllotmentCaseGenPerBatchSchedule Implements Schedulable{
    global void execute(SchedulableContext sc){
        AllotmentCaseGenPerBatch acg = new AllotmentCaseGenPerBatch();
        database.executeBatch(acg, 10);
    }
}