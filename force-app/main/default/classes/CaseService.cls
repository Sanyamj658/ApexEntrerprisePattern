global class CaseService {

    global static void closeCases(Set<Id> caseIds, String closeReason) {
        
        List<Case> casesToClose = [SELECT Id, Status, Reason 
                                    FROM Case WHERE Id IN :caseIds AND Status != 'Closed'];
        
     
        for (Case c : casesToClose) {
            c.Status = 'Closed'; 
            c.Reason = closeReason; 
        }
        
        
        if (!casesToClose.isEmpty()) {
            update casesToClose;
        }
    }
}