trigger LeaveReqest_trgr on Leave_Request__c (after insert) {
    if(trigger.isInsert){
		if(trigger.isAfter){
        	leaveRequestHandler.leaveCalculate(trigger.new);
        }
    }
}