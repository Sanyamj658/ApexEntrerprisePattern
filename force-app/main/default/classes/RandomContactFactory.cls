/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-26-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class RandomContactFactory{

    public static List<Contact> generateRandomContacts(Integer noOfContacts, String lastName){

        List<Contact> con = new List<Contact>();
        for(Integer i =0; i<noOfContacts; i++){
            Contact conn = new Contact();
            conn.firstName  = 'Test'+i;
            conn.lastName = lastName;
            con.add(conn);
        }
        return con;
    }
}