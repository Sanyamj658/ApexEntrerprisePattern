/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-09-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class contactList {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContact(){
         return [SELECT Name FROM Contact LIMIT 5];
    }  
}