@isTest
public class ContactTriggerHandlerTestClass {

    @isTest
    static void testContactProcessTime() {
        Account testAccount = new Account(Name = 'Test Account', From_Time__c = Time.newInstance(9, 23, 12, 0), To_Time__c = Time.newInstance(9, 50, 40, 0));
        insert testAccount;
		Contact testContact = new Contact(LastName = 'Sanyam', AccountId = testAccount.Id);
		insert testContact;

        testContact.LastName = 'Jain';
		update testContact;

        Test.startTest();
		List<Contact> conList = new List<Contact>{testContact};
        ContactTriggertHandler.contactProcessTime(conList); 
        Test.stopTest();

		Contact updatedContact1 = [SELECT Id, Process_Time__c FROM Contact WHERE Id = :testContact.Id];
		Time processTime = updatedContact1.Process_Time__c;
        boolean isWithinSameHour = processTime.hour() == testAccount.From_Time__c.hour();
        Assert.areEqual(true, isWithinSameHour, 'the hour time will be on same of account fromTime, toTime, and contactProcessTime');
      
    }
}