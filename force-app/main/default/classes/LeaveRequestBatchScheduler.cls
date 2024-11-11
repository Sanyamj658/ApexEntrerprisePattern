global class LeaveRequestBatchScheduler implements Schedulable{
    global void execute(SchedulableContext SC){
         LeaveRequestBatch lrb = new LeaveRequestBatch();
         Database.executeBatch(lrb);
    }
    
}