/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-16-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class StagingBatchClassTest {

    @isTest
    static void testBatchProcessing() {
        // Setup test data
        List<Staging__c> stagingRecords = new List<Staging__c>{
            new Staging__c(
                Individual_or_Organization__c = 'I',
                First_Name__c = 'Sanyam',
                Last_Name__c = 'Jain',
                Postal_Code__c = '12345',
                Organization_Name__c = 'SanyamOrg',
                Amount__c = 1000,
                Description__c = 'NA'
            ),
            new Staging__c(
                Individual_or_Organization__c = 'O',
                Organization_Name__c = 'SanyamOrg',
                Postal_Code__c = '12345',
                Amount__c = 2000,
                Description__c = 'NA'
            )
        };
        insert stagingRecords;
        
        Test.startTest();
        
        // Execute the batch class
        StagingBatchClass batch = new StagingBatchClass();
        Database.executeBatch(batch);
        
        Test.stopTest();
        
        // Verify Contacts creation
        List<Contact> contacts = [SELECT Id, FirstName, LastName, MailingPostalCode FROM Contact];
        System.assertEquals(1, contacts.size(), 'One Contact created.');
        System.assertEquals('Sanyam', contacts[0].FirstName, 'First name matched.');
        System.assertEquals('Jain', contacts[0].LastName, 'Last name matched.');
        
        // Verify Accounts creation
        List<Account> accounts = [SELECT Id, Name, BillingPostalCode FROM Account];
        System.assertEquals(1, accounts.size(), 'One Account be created.');
        System.assertEquals('SanyamOrg', accounts[0].Name, 'Account name matched.');
        

    }
}