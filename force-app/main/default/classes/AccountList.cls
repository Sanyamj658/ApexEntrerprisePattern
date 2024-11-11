/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-29-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public  class AccountList {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccount(String actName) {
        // Construct SOQL query based on the search criteria
        String searchName = '%' + actName + '%';
		return [SELECT Name, Phone, Industry FROM Account WHERE Name LIKE :searchName];

    }
}