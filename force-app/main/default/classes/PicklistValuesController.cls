/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-02-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PicklistValuesController {
    @AuraEnabled(cacheable=true)
    public static List<String> getPicklistValues() {
        List<String> picklistValues = new List<String>();
        
        // Query your custom object and retrieve picklist values
        List<Cricketer__c> records = [SELECT Nationality__c FROM Cricketer__c];
        System.debug('records'+records);
        // Extract unique picklist values
        for (Cricketer__c record : records) {
            if (record.Nationality__c != null && !picklistValues.contains(record.Nationality__c)) {
                picklistValues.add(record.Nationality__c);
            }
        }
        System.debug('picklistValues'+picklistValues);
        return picklistValues;
    }
}