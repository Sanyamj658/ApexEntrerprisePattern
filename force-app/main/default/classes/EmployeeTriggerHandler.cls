/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-09-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class EmployeeTriggerHandler {
    public static void updateMinMaxSalary(List<Employee__c> empList, Map<Id, Employee__c> oldMap) {
        Set<Id> parentIds = new Set<Id>();
        
        // Collect unique Tech Firm IDs that are impacted
        for (Employee__c emp : empList) {
          
                parentIds.add(emp.TechFirm__c);
            
        }

        // Aggregate the max and min salary for each Tech Firm
        List<AggregateResult> aggrList = [
            SELECT TechFirm__c, MAX(Salary__c) maxSalary, MIN(Salary__c) minSalary 
            FROM Employee__c 
            WHERE TechFirm__c IN :parentIds 
            GROUP BY TechFirm__c
        ];
        
        // Create a map to hold TechFirm__c records to update
        List<TechFirm__c> techFirmList = new List<TechFirm__c>();
        
        for (AggregateResult aggr : aggrList) {
            TechFirm__c tf = new TechFirm__c();
            tf.Id = (Id)aggr.get('TechFirm__c');
            tf.MaxSalary__c = (Decimal)aggr.get('maxSalary');
            tf.MinSalary__c = (Decimal)aggr.get('minSalary');
            techFirmList.add(tf);
        }

        // Perform DML operation to update TechFirm__c records
        if (!techFirmList.isEmpty()) {
            update techFirmList;
        }
    }
}