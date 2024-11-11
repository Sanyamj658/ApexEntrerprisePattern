@isTest
public class AccountManagerTest {
    public static ID createTestRecord(){
        Account testAcc = new account(Name = 'Test1');
        insert testAcc;
        Contact testCon = new Contact(lastName = 'test', AccountId = testAcc.id);
        insert testCon;
        
       return testAcc.Id;
    }
    public static testMethod void getAccountTest1(){
       Id recordId = createTestRecord();
       RestRequest request = new RestRequest();
       request.requestUri = 'https://yourInstance.my.salesforce.com/services/apexrest/Accounts/'+ recordId+'/contacts'; 
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        Account thisAccount = AccountManager.getAccount();
        system.assertEquals('Test1',thisAccount.Name,'abcd');
        

    }
}