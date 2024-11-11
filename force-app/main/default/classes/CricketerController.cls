/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-04-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class CricketerController {

    @AuraEnabled(cacheable = true)
    public static List<Cricketer__c> getCricketer(String Nationality) {
        System.debug('Nationality'+Nationality);
        if(Nationality==''){
            return [SELECT Id, Name, Age__c, Nationality__c, Runs__c, Picture__c, Image__c  From Cricketer__c];

        }else{
            return [SELECT Id, Name, Age__c, Nationality__c, Runs__c, Picture__c, Image__c  From Cricketer__c WHERE Nationality__c=:Nationality];

        }
    }
}