/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-28-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class tester {
	@AuraEnabled(cacheable = true)
    public static List<Account> getAccounts(String actName){
		//String searchTerm = '%' + actName + '%';  WHERE Name LIKE : searchTerm
		return [SELECT Name, Phone, Industry FROM Account];
		
    }
}