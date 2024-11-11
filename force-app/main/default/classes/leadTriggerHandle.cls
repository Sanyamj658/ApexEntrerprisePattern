/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class leadTriggerHandle {
    // QUE.3
     public static void checkEmailInContact(list<lead> leadList){
        list<Contact> contacts = [Select email From Contact];	
        list<string> emails = new list<string>();
        for(Contact Contactemails : contacts){
            emails.add(Contactemails.email);
        }
        for(lead ld : leadList){
            if(emails.contains(ld.Email)){
                ld.addError('You not put this email');
            }
            
        }
    }
}