@isTest
public class contactMergeBatchTest {
	@isTest
    public static void testExecute() {
		Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        List<Contact> conList = new List<Contact>();
        Contact con1 = new Contact(AccountId = acc.Id, FirstName = 'sanyam', LastName = 'jain', Email = 'sanyam@example.com');
        Contact con2 = new Contact(AccountId = acc.Id, FirstName = 'sanyam1', LastName = 'jain1', Email = 'sanyam@example.com');
        conList.add(con1);
        conList.add(con2);
        insert conList;
        
        Test.startTest();
       	MergeDuplicateContact myBatch = new MergeDuplicateContact();
		Database.executeBatch(myBatch);
        Test.stopTest();
        
        Integer contactCount = [SELECT count() FROM Contact WHERE AccountId = :acc.Id];
        System.assertEquals(1, contactCount, 'Contact Not Merged');

    }
}