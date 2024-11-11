public class MergeDuplicateContact implements Database.Batchable<sObject>,Schedulable{
    public Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, Email, AccountId FROM Contact WHERE AccountId != NULL AND Email != NULL';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Contact> conList){
        Map<String,List<Contact>> emailContactMap = new Map<String,List<Contact>>();
        for(Contact con : conList){
            String EmailId = String.valueOf(con.AccountId) + con.Email;
            if(emailContactMap.containsKey(EmailId)){
                emailContactMap.get(EmailId).add(con);
            }else{
                emailContactMap.put(EmailId, new List<Contact>());
            } 
        }
        List<Contact> contactsToMerge = new List<Contact>();
        for (List<Contact> SameEmailContacts : emailContactMap.values()) {
            if (SameEmailContacts.size() > 1) {
                Contact masterContact = SameEmailContacts.remove(0);
                contactsToMerge.addAll(sameEmailContacts);
                Database.MergeResult[] results = Database.merge(masterContact, contactsToMerge, false);   
            }
        }
    }
    
    public void finish(Database.BatchableContext BC) {
    }
    
    public void execute(SchedulableContext sc){
		MergeDuplicateContact MDC = new MergeDuplicateContact();
        Database.executeBatch(MDC);
    }
}