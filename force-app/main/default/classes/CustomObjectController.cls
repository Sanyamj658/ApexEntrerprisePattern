/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-04-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class CustomObjectController {
    @AuraEnabled(cacheable=true)
    //Fetches the names of custom objects.
    public static List<String> getCustomObjectNames() {
        List<String> customObjectNames = new List<String>();
        List<EntityDefinition> customObjects = [SELECT QualifiedApiName FROM EntityDefinition WHERE IsCustomizable = true];
        for(EntityDefinition obj : customObjects) {
            customObjectNames.add(obj.QualifiedApiName);
        }
        return customObjectNames;
    }
    // get records for to store on the dataTable 
    // @AuraEnabled(cacheable=true)
    // public static List<dualListObject__c> getAllRecords() {
    //   List<dualListObject__c> allRecords = [SELECT Id, Name FROM dualListObject__c];
    //   return allRecords;
    // }

    //Fetches existing values for the custom objects --> jo custom object m value h wo 
    @AuraEnabled(cacheable=true)
    public static List<String> getExistingValues() {
        List<String> existingValues = new List<String>();
        List<dualListObject__c> existingRecords = [SELECT Id,Name FROM dualListObject__c];
        for (dualListObject__c record : existingRecords) {
            existingValues.add(record.Name);
            
        }
        return existingValues;
    }
    //Checks which of the selected values are already saved.
    // @AuraEnabled
    // public static List<String> getSelectedExistingValues(List<String> selectedValues) {
    //     List<String> existingValues = new List<String>();
    //     for (String value : selectedValues) {
    //         List<dualListObject__c> existingRecords = [SELECT Id FROM dualListObject__c WHERE Name = :value];
    //         if (!existingRecords.isEmpty()) {
    //             existingValues.add(value);
    //         }
    //     }
    //     return existingValues;
    // }
    // Saves the selected values.
    @AuraEnabled
    public static void saveSelectedValues(List<String> selectedValues) {
        List<dualListObject__c> recordsToUpdate = new List<dualListObject__c>();
        for (String value : selectedValues) {
            dualListObject__c record = new dualListObject__c();
            record.Name = value;  // Assuming you're saving the name field, adjust as necessary
            recordsToUpdate.add(record);
        }
        try {
            upsert recordsToUpdate;  // Adjust DML operation as needed (e.g., insert, update)
        } catch (DmlException e) {
            throw new AuraHandledException('Error saving records: ' + e.getMessage());
        }
    }
}