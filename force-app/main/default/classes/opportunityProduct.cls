/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class opportunityProduct {
    @AuraEnabled(cacheable=true)
    public static List<OpportunityProduct__c> getOpportunityProduct() {
        return [SELECT Name, Phone__c, Balance__c, Type__c FROM OpportunityProduct__c];
    }
}