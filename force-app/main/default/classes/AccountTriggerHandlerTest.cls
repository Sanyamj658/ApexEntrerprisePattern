@isTest
public class AccountTriggerHandlerTest {
    @isTest
    static void testUpdateContactProcessTime() {
        Account account1 = new Account(Name = 'Test2', From_Time__c = Time.newInstance(1, 2, 3, 0), To_Time__c = Time.newInstance(3, 9, 3, 0));
        insert account1;
        
        Contact contact1 = new Contact(FirstName = 'Sanyam', LastName = 'Jain', AccountId = account1.Id);
        insert contact1;
        
		Map<Id, Account> oldAccountMap = new Map<Id, Account>();
        oldAccountMap.put(account1.Id, account1);
        
        account1.From_Time__c = Time.newInstance(3, 9, 3, 0);
        update account1;
		
        Test.startTest();
        List<Account> accList = new List<Account>{account1};
        AccountTriggerHandler.updateContactProcessTime(accList, oldAccountMap);
        Test.stopTest();
        
        Contact updatedContact1 = [SELECT Id, Process_Time__c FROM Contact WHERE Id = :contact1.Id];
        
        Time processTime = updatedContact1.Process_Time__c;
        Assert.areEqual(account1.From_Time__c, processTime, 'Contact 1 not updated the time between the From_Time and To_Time');
    }    
}