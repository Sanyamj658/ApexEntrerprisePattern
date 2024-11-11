/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class FavTaskController {
    public static List<FavroiteTask__c> getFavTasks(){
        return [SELECT Id, Name, TaskList__r.Name FROM FavroiteTask__c];
    }
}