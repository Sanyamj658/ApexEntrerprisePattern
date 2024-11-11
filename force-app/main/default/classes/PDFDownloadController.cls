/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PDFDownloadController {

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getDataForPDF(String startDate, String endDate) {
        // Query your Salesforce data based on the startDate and endDate
        List<Time_Entry__c> records = [SELECT  projectName__c, TaskList__c, Date__c, From_Time__c, To_Time__c, Description__c
        FROM Time_Entry__c
        WHERE Date__c >= :startDate AND Date__c <= :endDate];
        
        List<Map<String, String>> data = new List<Map<String, String>>();
        
        for (Time_Entry__c record : records) {
            Map<String, String> row = new Map<String, String>();
            row.put('projectName', record.projectName__c);
            row.put('taskName', record.TaskList__c);
            row.put('date', record.Date__c);
            row.put('startTime', record.From_Time__c);
            row.put('endTime', record.To_Time__c);
            row.put('description', record.Description__c);
            data.add(row);
        }

        return data;
    }
}
