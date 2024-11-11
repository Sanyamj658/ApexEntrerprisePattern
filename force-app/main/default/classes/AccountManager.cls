@RestResource(urlMapping = '/Accounts/*/contacts')
global class AccountManager {
    @HttpGet
    global static Account getAccount(){
        RestRequest req = RestContext.request;
        String accId = req.requestURI.subStringBetween('Accounts/','/contacts');
        Account acc = [SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account WHERE ID =:accId];
        return acc;
    }
}