/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class VerifyDate {
    //method to handle potential checks against two dates
    public static Date CheckDates(Date date1, Date date2) {
      //if date2 is within the next 30 days of date1, use date2.  Otherwise use the end of the month
      if(DateWithin30Days(date1,date2)) {
        return date2;
      } else {
        return SetEndOfMonthDate(date1);
      }
    }


    //method to check if date2 is within the next 30 days of date1
    private static Boolean DateWithin30Days(Date date1, Date date2) {
      //check for date2 being in the past
      if( date2 < date1) { return false; }
      //check that date2 is within (>=) 30 days of date1
      Date date30Days = date1.addDays(30); //create a date 30 days away from date1
      if( date2 >= date30Days ) { return false; }
      else { return true; }
    }


    
    //method to return the end of the month of a given date
    private static Date SetEndOfMonthDate(Date date1) {
      Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
      Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
      return lastDay;
    }
  }


















/*
 public class MergeDuplicateContact implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, Email, AccountId FROM Contact';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Contact> conList){
        Map<String,List<Contact>> emailContactMap = new Map<String,List<Contact>>();
        
        for(Contact con : conList){
            String EmailId = con.AccountId + con.Email;
            if(emailContactMap.containsKey(EmailId)){
                emailContactMap.get(EmailId).add(con);
            }
            else{
                emailContactMap.put(EmailId, new List<Contact>{con});
            }
        }
        
        for (String accountIdEmail : emailContactMap.keySet()) {
            List<Contact> potentialDuplicates = emailContactMap.get(accountIdEmail);
            if (potentialDuplicates.size() > 1) {
                Contact masterContact = potentialDuplicates[0];
                for (Integer i = 1; i < potentialDuplicates.size(); i++) {
                    Contact duplicate = potentialDuplicates[i];
                    Database.MergeResult[] results = Database.merge(masterContact, new List<Contact>{duplicate}, false);
                    if (results[0].isSuccess()) {
                        System.debug('Merge successful');
                    } else {
                        System.debug('Merge failed: ' + results[0].getErrorMessage());
                    }
                }
            }
        }
    }
    
    
    public void finish(Database.BatchableContext BC) {
    }
    
}


----------------------------------------------------------------------------------------------------------------
public void execute(Database.BatchableContext bc, List<Contact> conList){
    Map<String, List<Contact>> emailContactMap = new Map<String, List<Contact>>();
    
    for(Contact con : conList){
        String EmailId = con.AccountId + con.Email;
        
        if(emailContactMap.containsKey(EmailId)){
            emailContactMap.get(EmailId).add(con);
        } else {
            emailContactMap.put(EmailId, new List<Contact>{con});
        }
    }
    
    for (String accountIdEmail : emailContactMap.keySet()) {
        List<Contact> potentialDuplicates = emailContactMap.get(accountIdEmail);
        if (potentialDuplicates.size() > 1) {
            Contact masterContact = potentialDuplicates[0];
            for (Integer i = 1; i < potentialDuplicates.size(); i++) {
                Contact duplicate = potentialDuplicates[i];
                Database.MergeResult[] results = Database.merge(masterContact, new List<Contact>{duplicate}, false);
                // Check merge results if necessary
            }
        }
    }
}
--------------------

global class MergeDuplicateContactsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Email, AccountId, FirstName, LastName
            FROM Contact
            WHERE Email != null AND AccountId != null
            ORDER BY AccountId, Email
        ]);
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope) {
        Map<String, List<Contact>> accountEmailToContactsMap = new Map<String, List<Contact>>();
        for (Contact con : scope) {
            String key = con.AccountId + '_' + con.Email;
            if (!accountEmailToContactsMap.containsKey(key)) {
                accountEmailToContactsMap.put(key, new List<Contact>{con});
            } else {
                accountEmailToContactsMap.get(key).add(con);
            }
        }
        
        for (String key : accountEmailToContactsMap.keySet()) {
            List<Contact> contacts = accountEmailToContactsMap.get(key);
            if (contacts.size() > 1) {
                mergeContacts(contacts);
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
        // Optionally, you can add post-processing logic here
    }
    
    private void mergeContacts(List<Contact> contacts) {
        Contact masterContact = contacts.remove(0); // Select the first contact as the master
        for (Contact duplicateContact : contacts) {
            // Merge duplicate contact fields into the master contact
            masterContact.FirstName = mergeField(masterContact.FirstName, duplicateContact.FirstName);
            masterContact.LastName = mergeField(masterContact.LastName, duplicateContact.LastName);
            // Add any additional fields you want to merge
            
            // Merge other related records if needed (e.g., Tasks, Events, etc.)
            // Database.merge(masterContact, duplicateContact);
        }
        update masterContact;
        delete contacts; // Delete the duplicate contacts
    }
    
    private String mergeField(String masterValue, String duplicateValue) {
        // Add your logic here to determine how to merge field values
        // For simplicity, this example just returns the master value
        return masterValue;
    }
}




private void mergeContacts(List<Contact> contacts) {
    Contact masterContact = contacts.remove(0); // Select the first contact as the master
    Database.MergeResult[] mergeResults = Database.merge(masterContact, contacts, false);
    for(Database.MergeResult result : mergeResults) {
        if (result.isSuccess()) {
            System.debug('Successfully merged contact with Id: ' + result.getMasterRecordId());
        } else {
            System.debug('Failed to merge contact. Error message: ' + result.getErrorMessage());
        }
    }
}

*/