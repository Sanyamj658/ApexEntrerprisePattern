/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ProjectTrackerController {

    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjects() {
        return [SELECT Id, Name FROM Project__c]; 
    }

    @AuraEnabled(cacheable=true)
    public static List<TaskList__c> getTasksByProject(Id projectId) {
        return [SELECT Id, Name FROM TaskList__c WHERE Project__c = :projectId];
    }

    @AuraEnabled
    public static Id createTask(Id projectId, String taskName) {
        TaskList__c newTask = new TaskList__c();
        newTask.Project__c = projectId;
        newTask.Name = taskName;
        insert newTask;
        return newTask.Id;
    }

    @AuraEnabled(cacheable=true)
    public static List<User> getUsers() {
        return [SELECT Id, Name FROM User WHERE IsActive = true]; 
    }

    @AuraEnabled
    public static void saveTimeEntry(Id taskId, Date logDate, Time startTime, Time endTime, Id userId, String description) {
        TimeEntry__c newEntry = new TimeEntry__c(); 
        newEntry.TaskList__c = taskId;
        //newEntry.Log_Date__c = logDate; // Uncommented to set log date
        newEntry.From_Time__c = startTime;
        newEntry.To_Time__c = endTime;
        //newEntry.User__c = userId; // Uncommented to set user ID
        //newEntry.Description__c = description; // Added to set description

        insert newEntry;
    }
}
