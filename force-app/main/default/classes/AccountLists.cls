/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public  class AccountLists {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccount(String actName) {
        
       // if(!String.isBlank(actName))
       // {
            String searchName = '%' + actName + '%';
		    return [SELECT Name, Phone, Industry FROM Account WHERE Name LIKE :searchName];
       // }
       /* else
        {
            return [SELECT Name, Phone, Industry FROM Account ];
        }
        */

    }
}