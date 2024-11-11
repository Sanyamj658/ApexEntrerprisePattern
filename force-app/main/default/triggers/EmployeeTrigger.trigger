/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-09-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger EmployeeTrigger on Employee__c (after update, after insert, after delete){
    // in this question i take only update scenario
    EmployeeTriggerHandler.updateMinMaxSalary(trigger.new,trigger.oldMap);
}