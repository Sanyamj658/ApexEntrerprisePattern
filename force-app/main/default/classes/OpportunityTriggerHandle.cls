/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-16-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class OpportunityTriggerHandle{
    
    public static void UpdateAccountFieldCity(list<Opportunity> oppList, Map<id,Opportunity>map_Opportunity){
        
        set<Id>AccountUpdateId = new set<Id>(); 
        
        for(Opportunity op : oppList){
            if(op.Field_city__c != map_Opportunity.get(op.Id).Field_city__c){
                AccountUpdateId.add(op.AccountId);
            }
        }
        
        list<Account> accCityUpdate = new List<Account>();
        list<ACCOUNT> city_And_Id = [select id,City__c From Account where id IN : AccountUpdateId];
        
        for(Account acc :City_And_Id){
            for(Opportunity op : oppList){  //Avoid for loop and use .Contains METHOD
                if(acc.Id == op.AccountId){  
                    acc.City__c = op.Field_city__c;
                    accCityUpdate.add(acc);
                    break;
                    
                }
                
            }
        }
        //  system.debug('accCityUpdate -->'+accCityUpdate);
        update accCityUpdate;
    }
    
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    public static void UpdateAccountContactPhone(list<Opportunity> oppList, Map<id,Opportunity>map_Opportunity){
        list<Account> accountPhoneUpdate = new List<Account>();
        list<Contact> contactPhoneUpdate = new List<Contact>();
        
        for(Opportunity op : oppList){
            if(op.phone__c != map_Opportunity.get(op.Id).phone__c){
                Account acc = new Account();
                acc.Id = op.AccountId;
                acc.Phone = op.phone__c;
                accountPhoneUpdate.add(acc);
                
                Contact con = new Contact();
                con.Id = op.ContactId;
                con.Phone = op.phone__c;
                contactPhoneUpdate.add(con);
                
            }
        }
        update accountPhoneUpdate;
        update contactPhoneUpdate;
        
        
    }



    //-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    //QUE.6-->
    Public static void CreateTask(list<Opportunity> oppList){
        List<Opportunity> opp = [SELECT ID,StageName FROM Opportunity WHERE StageName='Closed Won' AND ID IN :oppList];
        system.debug('opp list -->'+opp);
        List<Task> taskToInsert = new List<Task>();
        for(Opportunity it:opp){
            system.debug('inside the task');
            Task newTask = new Task();
            newTask.subject = 'follow up';
            newTask.WhatId = it.Id;
            newTask.priority = 'Normal';
            taskToInsert.add(newTask);
            
        }
        system.debug('outside the task');
        Insert taskToInsert;
    }
    

    //question
    public static void updateAccountTotal(list<Opportunity> oppList){
       List<Id> accId = new List<Id>();
       for(opportunity opp : oppList){
           accId.add(opp.AccountId);
       }
     Decimal totalOppAmount = 0;
        // List<Opportunity> oppList = [SELECT AccountId, SUM(Amount), COUNT(ID) FROM Opportunity WHERE ID IN :accID GROUP BY AccountId ];
        List<AggregateResult> aggResult =[SELECT AccountId, SUM(Amount) TotalAmount, COUNT(ID) TotalOpp FROM Opportunity WHERE ID IN :accID GROUP BY AccountId ];

        List<Account> accounts = new List<Account>();

        for(AggregateResult opp : aggResult){
            Account acc = new Account();
            acc.Id = (Id) opp.get('AccountId');
            acc.Total_Amount_c__c = (Integer) opp.get('TotalAmount');
            acc.Total_Opportunities_c__c = (Integer) opp.get('TotalOpp');
            accounts.add(acc);
        }
        if(!accounts.isEmpty()){
            update accounts;

        }
    }

    // public static void updateAccount_contact_phone(List<Opportunity> oppList){
    //     Map<Id, String> accMap = new Map<Id, String>();
        
    //     // Iterate through the list of opportunities
    //     for(Opportunity opp : oppList){
    //         // Ensure that Trigger.oldMap is not null and contains the necessary old values
    //         if (Trigger.oldMap != null && Trigger.oldMap.containsKey(opp.Id)) {
    //             // Get the old Opportunity record from Trigger.oldMap
    //             //Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
                
    //             // Compare the old and new phone numbers
    //             if (opp.phone__c != oldOpp.phone__c) {
    //                 // Add the Account Id and new phone number to the map
    //                 accMap.put(opp.AccountId, opp.phone__c);
    //             }
    //         }
    //     }
        
    //     // Fetch the accounts that need to be updated
    //     List<Account> accList = [SELECT Id, Phone FROM Account WHERE Id IN :accMap.keySet()];
    //     List<Account> accountsToUpdate = new List<Account>();
    
    //     // Update the phone number for each account
    //     for(Account acc : accList){
    //         acc.Phone = accMap.get(acc.Id);
    //         accountsToUpdate.add(acc);
    //     }
      
    //     // Perform the update operation
    //     if (!accountsToUpdate.isEmpty()) {
    //         update accountsToUpdate;
    //     }
    // }
    

    public static void restrictCreateSecondOpp(List<Opportunity> oppList){
        Set<String> oppName = new Set<String>();
        for(Opportunity opp : oppList){
            oppName.add(opp.Name);
        }

        Map<String,Opportunity> existingOpportunity = new Map<String,Opportunity>([SELECT NAME FROM Opportunity WHERE NAME IN :oppName]);

        for(Opportunity opp : oppList){
            if(existingOpportunity.containsKey(opp.Name)){
                opp.addError('This Opportunity already Exist');
            }
        }

    }
    
}