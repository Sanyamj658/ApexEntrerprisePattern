/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger AccountTrigger on Account (before insert, after insert, before Update,after update, before delete ) {
    
    if(trigger.isInsert){
        if(trigger.isBefore){
           // AccountTriggerHandler.updateAccountNummberField(trigger.new);
        }
        else if(trigger.isAfter){
            //AccountTriggerHandler.createRelatedContact(trigger.new);
            //AccountTriggerHandler.updateContactProcessTimeOnInsert(trigger.new);
        }
    }
    
    if(trigger.isUpdate){
        if(trigger.isBefore){
            //AccountTriggerHandler.updateAccNumber(trigger.oldMap, trigger.new);
            //  AccountTriggerHandler.ConcatNameWithPhone(trigger.new, trigger.oldMap);
           // AccountTriggerHandler.updateOtherAndHomePhone(trigger.new, trigger.newMap ,trigger.oldMap);
           //AccountTriggerHandler.UpdateContactProcessTime(trigger.new, trigger.oldMap);
             
        }
        else if(trigger.isAfter){
             //  AccountTriggerHandler.updateRelatedContactPhone(trigger.oldMap, trigger.new);
             //  AccountTriggerHandler.updateContactBalance(trigger.new);
             //  AccountTriggerHandler.updateOtherAndHomePhone(trigger.new, trigger.newMap, trigger.oldMap);
             //AccountTriggerHandler.closeOpp(trigger.new, trigger.oldMap);
             //AccountTriggerHandler.UpdateContactPhone(trigger.new);
            
           //  AccountTriggerHandler.updateContactProcessTime(trigger.new, trigger.oldMap);
           //write a trigger whenever the account owner changes its related contact owner should be changed.
           AccountTriggerHandler.updateContactOwner(trigger.new, trigger.oldMap);

           
             
             
            
          
        }
    }
    
    if(trigger.isDelete){
        if(trigger.isBefore){
            // System.debug('IN DELETE TRANSACTION');
            //AccountTriggerHandler.preventAccountDelete(trigger.old);
            ////que 2
            AccountTriggerHandler.PreventAccountFromDelete(trigger.old);
        }
    }
}