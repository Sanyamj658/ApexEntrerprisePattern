public class LeaveRequestBatch implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('starting...');
        Date previousDay = Date.today().addDays(-1);
        System.debug('inside start');
        String query = 'SELECT ID, Name, Email__c, LeaveUpdate__c FROM Employe__c WHERE LeaveUpdate__c < 1 AND LastModifiedDate > YESTERDAY';
        System.debug('After query');
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Employe__c> empList){
        System.debug('inside execute');
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>(); 
        for(Employe__c emp :empList){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setPlainTextBody('Hi '+emp.Name+',\nYou have consumed all the leaves assigned for a year.\n Thanks');
            System.debug('after plain text');
            String[] toAddresses = new String[] {emp.Email__c};
   			email.setToAddresses(toAddresses);
            System.debug('Address set');
            emails.add(email);   
        }
        System.debug('complete the execute method');
        Messaging.sendEmail(emails);
    }
    public void finish(Database.BatchableContext bc){}   
}
/*
public class FindAndMergeDuplicateContacts implements Database.Batchable<SObject> {

  public Database.QueryLocator start(Database.BatchableContext BC) {
    // Query all Contact records
    return Database.getQueryLocator([SELECT Id, Email, AccountId FROM Contact]);
  }

  public void execute(Database.BatchableContext BC, List<Contact> scopeContacts) {
    Map<String, List<Contact>> duplicatesByAccount = new Map<String, List<Contact>>();

    // Group contacts by AccountId and Email
    for (Contact contact : scopeContacts) {
      String key = contact.AccountId + contact.Email;
      if (!duplicatesByAccount.containsKey(key)) {
        duplicatesByAccount.put(key, new List<Contact>());
      }
      duplicatesByAccount.get(key).add(contact);
    }

    // Identify and merge duplicates
    for (String accountIdEmail : duplicatesByAccount.keySet()) {
      List<Contact> potentialDuplicates = duplicatesByAccount.get(accountIdEmail);
      if (potentialDuplicates.size() > 1) {
        Contact masterContact = potentialDuplicates.get(0);
        for (int i = 1; i < potentialDuplicates.size(); i++) {
          Contact duplicate = potentialDuplicates.get(i);
          masterContact.FirstName = mergeFields(masterContact.FirstName, duplicate.FirstName);
          masterContact.LastName = mergeFields(masterContact.LastName, duplicate.LastName);
          duplicate.IsDeleted = true;
        }
      }
    }

    // Update master contacts and delete duplicates
    update Contacts.upsert(duplicatesByAccount.values());
  }

  private String mergeFields(String field1, String field2) {
    if (field1 == null && field2 != null) {
      return field2;
    } else if (field1 != null && field2 == null) {
      return field1;
    } else {
      // Choose a merging logic here (e.g., concatenate, pick longest)
      return field1 + ' ' + field2;
    }
  }

  public void finish(Database.BatchableContext BC) {
    // Handle any post-processing after merging
  }
}

public class ManualDuplicateMerge {

  public static void mergeContacts(Id masterId, List<Id> duplicateIds) {
    // Prepare master and duplicate records
    Contact master = [SELECT Id, Email, FirstName, LastName FROM Contact WHERE Id = :masterId];
    List<Contact> duplicates = [SELECT Id FROM Contact WHERE Id IN :duplicateIds];

    // Execute the merge operation
    Database.MergeResult[] results = Database.merge(master, duplicates, false);

    // Handle merge results
    for (Database.MergeResult result : results) {
      if (result.isSuccess()) {
        System.debug('Successfully merged contact: ' + result.getId());
      } else {
        System.debug('Error merging contact: ' + result.getId());
        System.debug('Error message: ' + result.getError());
      }
    }
  }

  public static void main(String[] args) {
    // Replace these with actual IDs of your contacts
    Id masterId = 'YOUR_MASTER_CONTACT_ID';
    List<Id> duplicateIds = new List<Id> {'YOUR_DUPLICATE_CONTACT_ID1', 'YOUR_DUPLICATE_CONTACT_ID2'};

    mergeContacts(masterId, duplicateIds);
  }
-----------------------------------------------------------------------------------

public class MergeDuplicateContact implements Database.Batchable<sObject>{

  public Database.QueryLocator start(Database.BatchableContext bc){
    String query = 'SELECT Id, Email FROM Contact';
    return Database.getQueryLocator(query);
  }

  public void execute(Database.BatchableContext bc, List<Contact> conList){
    system.debug('execute 1');
    Map<String,List<Contact>> emailContactMap = new Map<String,List<Contact>>();

    for(Contact con : conList){
      system.debug('execute 2');
      String email = con.Email;
      if(emailContactMap.containsKey(email)){
        system.debug('execute 3');
        emailContactMap.get(email).add(con);
      } else {
        system.debug('execute 4');
        emailContactMap.put(email, new List<Contact>());
      }
    }

    system.debug('going to....');
    for (String emailId : emailContactMap.keySet()) {
      system.debug('execute 12');
      List<Contact> potentialDuplicates = emailContactMap.get(emailId);
      if (potentialDuplicates.size() > 1) {
        system.debug('execute 13');
        Contact masterContact = potentialDuplicates.get(0);
        for (Integer i = 1; i < potentialDuplicates.size(); i++) {
          system.debug('execute 14');
          Contact duplicate = potentialDuplicates.get(i);
          Database.MergeResult[] results = Database.merge(masterContact, duplicate, true);
          system.debug('execute 15');
        }
      }
    }
  }

  public void finish(Database.BatchableContext BC) {
  }
}

-----------------------------
public class MergeDuplicateContact implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, Email, AccountId FROM Contact';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Contact> conList){
        system.debug('execute 1');
        Map<String,List<Contact>> emailContactMap = new Map<String,List<Contact>>();
        
        for(Contact con : conList){
            system.debug('execute 2');
            String EmailId = con.AccountId + con.Email;
            // system.debug(EmailId);
            if(emailContactMap.containsKey(EmailId)){
                system.debug('execute 3');
                emailContactMap.get(EmailId).add(con);
            }else{
                system.debug('execute 4');
                emailContactMap.put(EmailId, new List<Contact>());
            }
            
        }
        system.debug('going to....');
        for (String accountIdEmail : emailContactMap.keySet()) {
            system.debug('execute 12');
            List<Contact> potentialDuplicates = emailContactMap.get(accountIdEmail);
            if (potentialDuplicates.size() > 1) 
                system.debug('execute 13');
            Contact masterContact = potentialDuplicates.get(0);
            for (Integer i = 1; i < potentialDuplicates.size(); i++) {
                system.debug('execute 14');
                Contact duplicate = potentialDuplicates.get(i);
                Database.MergeResult[] results = Database.merge(masterContact, new List<Contact>{duplicate}, false);
                system.debug('execute 15');
                // duplicate.IsDeleted = true;
            }
        }
    }
    
    
    public void finish(Database.BatchableContext BC) {
    }
    
}
*/