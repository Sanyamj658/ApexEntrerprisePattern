/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-26-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class MyDataGenerationTests {
    @TestSetup
    static void loadmyDataGenerationTests(){
        List<sObject> accounts = Test.loadData(Account.SObjectType, 'otherAccountData');
    }
    @isTest static void testLoadOtherAccountsFromStaticResource() {
    List<Account> accts = [SELECT ID FROM Account];
    system.assert(accts.size() == 15, 'expected 16 accounts');
  }
}