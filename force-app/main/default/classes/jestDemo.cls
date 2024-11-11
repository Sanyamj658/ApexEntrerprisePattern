/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-10-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class jestDemo {
    @AuraEnabled(cacheable = true)
    public static List<Account> getaccountList() {
        return [SELECT Id,Name FROM Account LIMIT 5];
    }
}