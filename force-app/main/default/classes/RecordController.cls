/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-27-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RecordController {
  
    @AuraEnabled
    public static Id createRecord(String name, String classValue, String college, String location) {
        try {
            GoogleFormRecord__c newRecord = new GoogleFormRecord__c(
               // Name = name,
                Class__c = classValue,
                College__c = college,
                Location__c = location
            );
            insert newRecord;
            return newRecord.Id;
        } catch (Exception e) {
            System.debug('Exception occurred while creating record: ' + e.getMessage());
            throw new AuraHandledException('Error creating record: ' + e.getMessage());
        }
    }
}