/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-21-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class helloWorld {
    
    @AuraEnabled(cacheable=true)
    public static Datetime getName(Id ids){
        Datetime     recordName = null;
        
        try {
            // Query to fetch the record name
            List<Account> records = [SELECT Name, CreatedDate FROM Account WHERE Id = :ids LIMIT 1];
            
            // Check if record was found
            if (!records.isEmpty()) {
                // recordName = records[0].Name;
                recordName = records[0].CreatedDate;
               // recordName = recordName.toISOString().split("T")[0];
            }
        } catch (Exception e) {
            // Handle any exceptions (e.g., query exceptions)
            System.debug('Error fetching record name: ' + e.getMessage());
        }
        
        return recordName;
    }
}