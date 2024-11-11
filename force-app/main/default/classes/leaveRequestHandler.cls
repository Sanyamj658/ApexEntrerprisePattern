public class leaveRequestHandler {
    public static void leaveCalculate(List<Leave_Request__c> empLeaveList){
		//For the count to particular Employees leaveDays and IDs
        Map<Id, Decimal> empleavesMap = new Map<Id, Decimal>();
        
        // store the EmpIDs and leave duration
        for(Leave_Request__c leaveRequest : empLeaveList){
            if (empleavesMap.containsKey(leaveRequest.Employe__c)) {
                empleavesMap.put(leaveRequest.Employe__c, empleavesMap.get(leaveRequest.Employe__c) + leaveRequest.Leaves__c);
            } else {
                empleavesMap.put(leaveRequest.Employe__c, leaveRequest.Leaves__c);
            }
        }
        
        //Get all employee which take the leave
        List<Employe__c> employees= [SELECT Id, LeaveUpdate__c From Employe__c WHERE Id IN :empleavesMap.KeySet()];
        
        List<Employe__c> empUpdate = new  List<Employe__c>();
        
        //update leave of Employees
        for(Employe__c emp : employees){
            if(empleavesMap.containsKey(emp.id)) {
                emp.LeaveUpdate__c = emp.LeaveUpdate__c - empleavesMap.get(emp.id);
                empUpdate.add(emp);
            }
        }
        
        //if empupdate not empty then update 
        if(!empUpdate.isEmpty()){
            UPDATE empUpdate;
        }   
    }
}