/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class AccountTriggerHandler {
    
    public static void updateAccountNummberField(List<Account> newAccList){
        for(Account acc : newAccList){
            
            if(acc.Industry != null && acc.isAvailabel__c == true){
                acc.AccountNumber = '789';
            }
        }
    }
    
    public static void createRelatedContact(List<Account> newAccountList){
        list<contact> conList = new list<contact>();
        for(Account acc : newAccountList){
            contact conObj  = new Contact();
            conObj.AccountId = acc.Id;
            conObj.LastName = acc.Name;
            conlist.add(conObj);
        }
        if(!conlist.isEmpty()){
            insert conlist;
            
        }
    }
    
    public static void updateAccNumber(Map<id,Account>oldAccountMap,List<Account> newAccountList){
        system.debug('before update triggeer callled -->');
        system.debug('accountlist'+newAccountlist);
        
        for(Account acc : newAccountlist){
            if(oldAccountMap != null && acc.Industry != oldAccountMap.get(acc.Id).Industry
               && acc.isAvailabel__c==true){
                   acc.AccountNumber='1020';
               }
            else{
                acc.AccountNumber='3040';
            }
        }
    }
    
    public static void updateRelatedContactPhone(Map<id,Account> oldAccountMap , List<Account> newAccountList){
        
        Map<id,Account> accountMap = new Map<Id,Account>();
        List<Contact>contactlist = new List<Contact>();
        for(Account acc : newAccountList){
            if(oldAccountMap!=null && acc.Phone != oldAccountMap.get(acc.id).Phone  && acc.Rating=='Hot'){
                accountMap.put(acc.Id,acc);
            }
        }
        
        List<Contact>conList = [Select Id,Name,AccountId From Contact Where AccountId IN:accountMap.keySet()]; 
        
        for(Contact con : conList){
            Contact conObj = new Contact();
            if(accountMap.Containskey(con.AccountId)){
                conObj.Phone = accountMap.get(con.AccountId).Phone; 
                conObj.id = con.id;
                contactlist.add(conObj);
            }
        }
        if(!contactlist.isEmpty()){
            update contactlist;
        }
    }
    
    public static void preventAccountDelete(List<Account> oldAccountDelete){
        for(Account acc : oldAccountDelete){
            if(acc.isAvailabel__c == true && acc.phone != null){
                acc.addError('Account cannot be deleted');
            }
        }
    } 

    public static void ConcatNameWithPhone(List<Account> acclist , Map<id,Account>phoneOldValue){
        
        for(Account acc : acclist){
            if(acc.Phone != phoneOldValue.get(acc.id).phone){
                acc.Name = acc.Name.replace(phoneOldValue.get(acc.id).phone,'');    
            }
            acc.Name += acc.Phone; 
        }
    }
   
    public  static void PreventAccountFromDelete(List<Account> oldAccountDelete){
        Map<Id, Account> accountContact = new Map<Id, Account>([SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :oldAccountDelete]);
        
        for(Account acc : accountContact.values()){
            if(acc.Contacts.size()>=2){
                acc.addError('you cannot be deleted this account ');
            }
        }
    }
   
    public static void updateContactBalance( List<Account> newAccList){
        
        decimal totalAmount = 0;
        set<id> accountIds= new set<id>();
        
        for(Account acc : newAccList){
            totalAmount += acc.Balance__c;
            accountIds.add(acc.Id);
        }
        
        list<Contact> contacts = [Select id from Contact where AccountId IN : accountIds];
        
        decimal divide_indivdual = totalAmount/contacts.size();
        
        list<Contact> conUpdate = new list<contact>();
        
        for(Contact con : contacts){
            con.Contact_Balance__c = divide_indivdual;
            conUpdate.add(con);
        }
        update conUpdate;
    }
   
    public  static void updateOtherAndHomePhone(List<Account> accList , map<id,Account> newMap,Map<id,Account> mp){
        list<Contact> UpdateContact = new list<Contact>(); 
        Set<Id> accountIdsToUpdate = new Set<Id>();
        for(Account acc : accList){
            if(mp.get(acc.Id).phone != null && acc.Phone != mp.get(acc.Id).phone){
                accountIdsToUpdate.add(acc.Id);
            }
        }
        List<Contact> contactsToUpdate = [SELECT Id, OtherPhone, HomePhone, AccountId FROM Contact WHERE AccountId IN :accountIdsToUpdate];
        for (Contact con : contactsToUpdate) {
            for (Account newAcc : accList) {
                if (con.AccountId == newAcc.Id && con.OtherPhone != newAcc.Phone) {
                    con.OtherPhone = mp.get(con.AccountId).Phone;
                    con.HomePhone = newAcc.Phone;
                }
            }
        }
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }    

    public static void closeOpp(List<Account> accList, Map<Id,Account> oldMap){
        Set<Id> accountIds = new Set<Id>();
            for(Account acc : acclist){
                if(acc.CloseAllOpp__c == true){
                    accountIds.add(acc.Id);
                }
            }

            List<Opportunity> oppList = [Select Id,AccountId,Stagename from Opportunity where AccountId IN : accountIds and Stagename != 'Closed Won'];
            List<Opportunity> updateOpp = new List<Opportunity>();
            for(Opportunity opp : oppList){
                opp.Amount = 11;
                updateOpp.add(opp);
            }

            if(!updateOpp.isEmpty()){
                UPDATE updateOpp;
            }
        
    }

    public static void UpdateContactPhone(List<Account> newAccList){
        Map<Id, String> accIdToPhoneMap = new Map<Id, String>();
        for (Account acc : newAccList) {
            accIdToPhoneMap.put(acc.Id, acc.Phone);
        }
        
        List<Contact> conList = [Select Id,Phone,AccountId from Contact where AccountId IN : accIdToPhoneMap.keySet()];
        List<Contact> updateContact = new List<Contact>();
        
        for (Contact contact : conList) {
            contact.Phone = accIdToPhoneMap.get(contact.AccountId);
            updateContact.add(contact);
        }
		Update updateContact;  
            
    }
    public static void updateContactProcessTime(List<Account> accountList,Map<Id, Account> oldMap) {
        try {
            Map<Id, Account> accountMap = new Map<Id, Account>();
            for (Account newaccount : accountList) {
            Account oldAccount = oldMap.get(newaccount.Id);
            if (oldAccount != null && (newAccount.From_Time__c != oldAccount.From_Time__c || newAccount.To_Time__c != oldAccount.To_Time__c)){
                accountMap.put(newaccount.Id, newaccount);
            }
          }
          List<Contact> relatedContacts = [
            SELECT Id, Process_Time__c, AccountId
            FROM Contact
            WHERE AccountId IN :accountMap.KeySet()
          ];
          List<Contact> updateContacts = new List<Contact>();
          if (!relatedContacts.isEmpty()) {
            for (Contact contact : relatedContacts) {
                if(contact.AccountId != null){
                    Account account = accountMap.get(contact.AccountId);
                    contact.Process_Time__c = GenerateRandomTime.generateRandomTimeInRange(account.From_Time__c,account.To_Time__c);
                }
                  updateContacts.add(contact);
            }
              if (!updateContacts.isEmpty()) {
                Database.update(updateContacts, false);
              } 
          }
        } catch (Exception e) {
          System.debug(
            'Error when update the processing contact Random Time' + e.getMessage()
          );
        }
        
      }      

    public static void updateContactOwner(List<Account> accountList,Map<Id, Account> oldMap){
        Map<Id, Account> accountMap = new Map<Id, Account>();
        //Owner change store
        for(Account acc : accountList){
            Account oldAccount = oldMap.get(acc.Id);
            if(acc.owner.Id != oldAccount.owner.Id)
            accountMap.put(acc.Id, acc);
        }

        List<Contact> conList = [SELECT ID, AccountId, Owner.id FROM Contact WHERE AccountId IN :accountMap.KeySet()];

        List<Contact> updateContacts = new List<Contact>();
        for(Contact con : conList){
            Account acc = accountMap.get(con.AccountId);
            con.owner.id = acc.owner.id;
            updateContacts.add(con);
        }

        UPDATE updateContacts; 
    }
    }