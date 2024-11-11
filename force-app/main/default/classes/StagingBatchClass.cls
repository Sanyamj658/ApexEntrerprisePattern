/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 09-17-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public class StagingBatchClass implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
      String query = 'SELECT Id, Individual_or_Organization__c, Organization_Name__c, First_Name__c, Last_Name__c, Postal_Code__c, Date_Recieved__c, Amount__c, Description__c FROM Staging__c';
      return Database.getQueryLocator(query);
    }
  
    public void execute(Database.BatchableContext bc, List<Staging__c> stgList) {
      try {
        Set<String> stagingFirstNames = new Set<String>();
        Set<String> stagingLastNames = new Set<String>();
        Set<String> stagingPostalCodes = new Set<String>();
        Set<String> stagingOrganizationNames = new Set<String>();
  
        for (Staging__c stagingRecord : stgList) {
          if (stagingRecord.First_Name__c != null) {
            stagingFirstNames.add(stagingRecord.First_Name__c);
          }
          if (stagingRecord.Last_Name__c != null) {
            stagingLastNames.add(stagingRecord.Last_Name__c);
          }
          if (stagingRecord.Postal_Code__c != null) {
            stagingPostalCodes.add(stagingRecord.Postal_Code__c);
          }
          if (stagingRecord.Organization_Name__c != null) {
            stagingOrganizationNames.add(stagingRecord.Organization_Name__c);
          }
        }
  
        List<Contact> contactsToUpsert = new List<Contact>();
        List<Account> accountsToInsert = new List<Account>();
        List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
  
        Map<String, Contact> existingContacts = new Map<String, Contact>();
        Map<String, Account> existingAccounts = new Map<String, Account>();
  
        List<Contact> existingContactRecords = [
          SELECT Id, FirstName, LastName, MailingPostalCode
          FROM Contact
          WHERE
            FirstName IN :stagingFirstNames
            AND LastName IN :stagingLastNames
            AND MailingPostalCode IN :stagingPostalCodes
        ];
  
        List<Account> existingAccountRecords = [
          SELECT Id, Name, BillingPostalCode
          FROM Account
          WHERE
            Name IN :stagingOrganizationNames
            AND BillingPostalCode IN :stagingPostalCodes
        ];
  
        for (Contact contact : existingContactRecords) {
          String key =
            contact.FirstName +
            '|' +
            contact.LastName +
            '|' +
            contact.MailingPostalCode;
          existingContacts.put(key, contact);
        }
  
        for (Account account : existingAccountRecords) {
          String key = account.Name + '|' + account.BillingPostalCode;
          existingAccounts.put(key, account);
        }
  
        for (Staging__c stagingRecord : stgList) {
          String contactKey =
            stagingRecord.First_Name__c +
            '|' +
            stagingRecord.Last_Name__c +
            '|' +
            stagingRecord.Postal_Code__c;
          String accountKey =
            stagingRecord.Organization_Name__c +
            '|' +
            stagingRecord.Postal_Code__c;
  
          if (stagingRecord.Individual_or_Organization__c == 'I') {
            Contact contactToUpsert = existingContacts.containsKey(contactKey)
              ? existingContacts.get(contactKey)
              : new Contact(
                  FirstName = stagingRecord.First_Name__c,
                  LastName = stagingRecord.Last_Name__c,
                  MailingPostalCode = stagingRecord.Postal_Code__c
                );
            System.debug(contactToUpsert);
  
            if (
              stagingRecord.Organization_Name__c != null &&
              stagingRecord.Postal_Code__c != null
            ) {
              if (existingAccounts.containsKey(accountKey)) {
                contactToUpsert.AccountId = existingAccounts.get(accountKey).Id;
                System.debug(
                  'contactToUpsert' + existingAccounts.get(accountKey).Id
                );
              }
            }
  
            contactsToUpsert.add(contactToUpsert);
          } else if (stagingRecord.Individual_or_Organization__c == 'O') {
            Account existingAccount = existingAccounts.containsKey(accountKey)
              ? existingAccounts.get(accountKey)
              : new Account(
                  Name = stagingRecord.Organization_Name__c,
                  BillingPostalCode = stagingRecord.Postal_Code__c
                );
  
            accountsToInsert.add(existingAccount);
          }
        }
  
        if (!accountsToInsert.isEmpty()) {
            Database.insert(accountsToInsert,false);

        }
  
        List<Account> updatedAccounts = [
          SELECT Id, Name, BillingPostalCode
          FROM Account
          WHERE Id IN :accountsToInsert
        ];
        Map<String, Id> accountIdMap = new Map<String, Id>();
        for (Account account : updatedAccounts) {
          String key = account.Name + '|' + account.BillingPostalCode;
          accountIdMap.put(key, account.Id);
        }
  
        for (Staging__c stagingRecord : stgList) {
          String contactKey =
            stagingRecord.First_Name__c +
            '|' +
            stagingRecord.Last_Name__c +
            '|' +
            stagingRecord.Postal_Code__c;
          String accountKey =
            stagingRecord.Organization_Name__c +
            '|' +
            stagingRecord.Postal_Code__c;
  
          if (stagingRecord.Individual_or_Organization__c == 'O') {
            if (accountIdMap.containsKey(accountKey)) {
              createOpportunity(
                opportunitiesToInsert,
                null,
                accountIdMap.get(accountKey),
                stagingRecord
              );
            }
  
            if (
              stagingRecord.Last_Name__c != null &&
              stagingRecord.Postal_Code__c != null
            ) {
              if (existingContacts.containsKey(contactKey)) {
                Contact existingContact = existingContacts.get(contactKey);
                existingContact.AccountId = accountIdMap.get(accountKey);
                contactsToUpsert.add(existingContact);
              }
            }
          }
        }
  
        if (!contactsToUpsert.isEmpty()) {
          Database.upsert(contactsToUpsert,false);
        }
        List<Contact> updatedContacts = [
          SELECT Id, FirstName, LastName, MailingPostalCode
          FROM Contact
          WHERE Id IN :contactsToUpsert
        ];
  
        Map<String, Id> contactIdMap = new Map<String, Id>();
        for (Contact contact : updatedContacts) {
          String key =
            contact.FirstName +
            '|' +
            contact.LastName +
            '|' +
            contact.MailingPostalCode;
          contactIdMap.put(key, contact.Id);
        }
  
        for (Staging__c stagingRecord : stgList) {
          String contactKey =
            stagingRecord.First_Name__c +
            '|' +
            stagingRecord.Last_Name__c +
            '|' +
            stagingRecord.Postal_Code__c;
          String accountKey =
            stagingRecord.Organization_Name__c +
            '|' +
            stagingRecord.Postal_Code__c;
  
          if (stagingRecord.Individual_or_Organization__c == 'I') {
            if (contactIdMap.containsKey(contactKey)) {
              createOpportunity(
                opportunitiesToInsert,
                contactIdMap.get(contactKey),
                null,
                stagingRecord
              );
            }
          }
        }
  
        if (!opportunitiesToInsert.isEmpty()) {
          Database.insert(opportunitiesToInsert, false);
        }
      } catch (Exception e) {
        System.debug('Error during batch processing: ' + e.getMessage());
      }
    }
  
    public void finish(Database.BatchableContext bc) {
    }
  
    public void createOpportunity(
      List<Opportunity> opportunities,
      Id contactId,
      Id accountId,
      Staging__c stagingRecord
    ) {
      Opportunity newOpportunity = new Opportunity(
        Name = (contactId != null
            ? stagingRecord.First_Name__c +
              ' ' +
              stagingRecord.Last_Name__c +
              ' ' +
              stagingRecord.Date_Recieved__c
            : stagingRecord.Organization_Name__c) +
          ' ' +
          stagingRecord.Date_Recieved__c,
        CloseDate = stagingRecord.Date_Recieved__c,
        Amount = stagingRecord.Amount__c,
        Description = stagingRecord.Description__c,
        StageName = 'Prospecting',
        ContactId = contactId,
        AccountId = accountId
      );
      opportunities.add(newOpportunity);
    }
  }