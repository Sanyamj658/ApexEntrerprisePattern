/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-16-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger opportunity_trigger on Opportunity (before insert ,  after update, before update) {
    
        if(trigger.isBefore){
            if(trigger.isUpdate || trigger.isInsert){
              //  OpportunityTriggerHandle.createOpportunity(trigger.new);
              OpportunityTriggerHandle.restrictCreateSecondOpp(trigger.new);
            }
          
        }
        if(trigger.isAfter || trigger.isUpdate){
          // OpportunityTriggerHandle.UpdateAccountFieldCity(trigger.new, trigger.oldMap);
         // OpportunityTriggerHandle.UpdateAccountContactPhone(trigger.new, trigger.oldMap); 
          //OpportunityTriggerHandle.CreateTask(trigger.new);
          //OpportunityTriggerHandle.updateAccount_contact_phone(trigger.new);

        }
    }