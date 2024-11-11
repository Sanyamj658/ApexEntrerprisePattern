/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class transcation {
    @AuraEnabled
    public static ID transcationRecord(String Name, String paymentDate, Date purchaseDate, Integer amount, Integer noOfMonth){
        TR__c obj = new TR__c();
        obj.Name = Name;
        obj.Amount__c = amount;
        obj.Payment__c= paymentDate;
        obj.PurchasDate__c = purchaseDate;
        obj.Number_Of_Month__c= noOfMonth;
        
        insert obj;
        Id recordId = obj.Id;

        return recordId;


    }

    @AuraEnabled
    public static void monthlyInstallment(String parentId, List<Monthly_Installment__c> installments){
        for(Monthly_Installment__c installment : installments) {
            installment.TR__c = parentId;
        }
        insert installments;
    }
}














/*
public class MyApexClass {
    @AuraEnabled
    public static void saveData(String field1, String field2, String field3, String field4) {
        // Create an instance of your object (let's call it MyObject__c)
        MyObject__c obj = new MyObject__c();
        
        // Populate fields with the values from LWC
        obj.Field1__c = field1;
        obj.Field2__c = field2;
        obj.Field3__c = field3;
        obj.Field4__c = field4;

        // Insert the object
        insert obj;
    }
}
*/