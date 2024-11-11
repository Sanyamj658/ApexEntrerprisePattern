/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-20-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class ContactTriggertHandler {
    public static void updateAccountPrimaryDescription(List<Contact> contactNewList){
        // Map<id,Contact> AccountIdToUpdateContact = new map<id,Contact>();
        // for(contact con :contactNewList){
        //     if(con.isPrimary__c){
        //         AccountIdToUpdateContact.put(con.AccountId,con);
        //     }
        // }
        // list<Account> updateDescription = new list<Account>();
        // list<Account> updateAccIds = [Select ID, isPrimaryDescription__c From Account WHERE ID IN :AccountIdToUpdateContact.keyset()];
        // for(Account acc :updateAccIds){
        //     Contact con = AccountIdToUpdateContact.get(acc.Id);
        //     acc.isPrimaryDescription__c = con.FirstName +' '+ con.LastName;
        //     updateDescription.add(acc);
        // }
        
        
        // List<Contact> contactsToUpdate = new List<Contact>();
        // List<Contact> otherContacts = [SELECT Id, isPrimary__c,AccountId FROM Contact WHERE AccountId IN :AccountIdToUpdateContact.keySet() AND isPrimary__c = TRUE ];
        
        // for(Contact con : otherContacts){
        //     if(con.id != AccountIdToUpdateContact.get(con.AccountId).id){
        //         con.isPrimary__c = false;
        //         contactsToUpdate.add(con); 
        //     }
        // }
        // update contactsToUpdate;
        // update updateDescription;  
    }
    
    public static void insertUpdateContactWhichLastNameInvalid(List<Contact> contactNewList){
        // for(Contact c : contactNewList) {
        //     if(c.LastName == 'INVALIDNAME') {
        //         c.AddError('The Last Name "'+c.LastName+'" is not allowed for DML');
        //     }
        // }
        
    }
    
    public static void updateTheAccountDescription(List<Contact> contactNewList){
        // Set<Id> conIds = new Set<Id>();
        // for(Contact conObj : contactNewList){
        //     if(conObj.AccountId != null && conObj.Description != trigger.oldMap.get(conObj.Id).Description){
        //         conIds.add(conObj.AccountId);
        //     }
        // }

        // Map<Id, Account> parentAccMap = new Map<Id, Account>([SELECT Id, Description FROM Account WHERE Id IN :conIds]);
        // List<Account> updateaccList = new List<Account>();

        // for(Contact conList : contactNewList){
        //     Account acc = parentAccMap.get(conList.AccountId);
        //     acc.Description = conList.Description;
        //     updateaccList.add(acc);
        // }
        //     UPDATE updateaccList;
    }

    public static void updateCompleteOppAmountOnAcc(List<Contact> contactNewList){
        // Set<id> AccountIds = new Set<id>();
        // for(Contact con : contactNewList){
        //     if(con.AccountId !=NULL  && con.AccountId != trigger.oldMap.get(con.id).AccountId){
        //         AccountIds.add(con.AccountId);
        //     }
        // }

        // List<Account> accListToUpdate = new List<Account>();
        // AggregateResult result = [SELECT sum(Amount)amountOfOpp FROM Opportunity];
        // List<Account> accList = [select Id,Complete_Opportunity_Amount__c from Account where Id =:AccountIds];
        // if(accList.size()>0){

        // }

    }

    public static void contactProcessTime(List<Contact> contactList) {
        try {
          Set<Id> accountIds = new Set<Id>();
          for (Contact contact : contactList) {
            if (contact.AccountId != null) {
              accountIds.add(contact.AccountId);
            }
          }
          Map<Id, Account> accountMap = new Map<Id, Account>(
            [
              SELECT Id, From_Time__c, To_Time__c
              FROM Account
              WHERE Id IN :accountIds
            ]
          );
      
          for (Contact contact : contactList) {
            if (
              contact.AccountId != null &&
              accountMap.containsKey(contact.AccountId)
            ) {
              Account account = accountMap.get(contact.AccountId);
              Time fromTime = account.From_Time__c;
              Time toTime = account.To_Time__c;
              Time randomTime = GenerateRandomTime.generateRandomTimeInRange(fromTime, toTime);
              contact.Process_Time__c = randomTime;
            }
          }
        } catch (Exception e) {
          System.debug(
            'Error when processing contact Random Time' + e.getMessage()
          );
        }
      }
      
      // public static Time generateRandomTime(Time fromTime, Time toTime) {
      //   if (fromTime == null || toTime == null || fromTime > toTime) {
      //     return null;
      //   } else if (fromTime == toTime) {
      //     return fromTime;
      //   } else {
      //     try {
      //       Long startSeconds = fromTime.hour() * 3600 + fromTime.minute() * 60 + fromTime.second();
      //       Long endSeconds = toTime.hour() * 3600 + toTime.minute() * 60 + toTime.second();
      //       Long totalSeconds = endSeconds - startSeconds;
      //       Long randomSeconds = Math.round(Math.random() * totalSeconds);
      //       Long randomTimeInSeconds = startSeconds + randomSeconds;
      //       Integer hours = (Integer) (randomTimeInSeconds / 3600);
      //       Integer minutes = (Integer) (Math.mod(randomTimeInSeconds, 3600) / 60);
      //       Integer seconds = (Integer) (Math.mod(randomTimeInSeconds, 60));
      //       return Time.newInstance(hours, minutes, seconds, 0);
      //     } catch (Exception e) {
      //       System.debug('Error when generating random time: ' + e.getMessage());
      //       return null;
      //     }
      //   }
      // }
      
      



}