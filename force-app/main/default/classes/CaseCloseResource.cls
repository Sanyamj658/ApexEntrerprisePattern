@RestResource(urlMapping='/case/*/close')
global class CaseCloseResource {
    @HttpPost
    global static void closeCase(String reason) {
        
        RestRequest req = RestContext.request;
        String[] uriParts = req.requestURI.split('/');
        
        if (uriParts.size() > 2) {
            Id caseId = uriParts[2];
            
           
            if (caseId != null && caseId.getSObjectType() == Case.SObjectType) {
              
                CaseService.closeCases(new Set<Id> { caseId }, reason);
            } else {
               
                RestContext.response.statusCode = 400;
                RestContext.response.responseBody = Blob.valueOf('Invalid Case ID');
            }
        } else {
           
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('Missing Case ID');
        }
    }
}