/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger leadTrigger on Lead (Before Insert)
 {      if(Trigger.isInsert && Trigger.isBefore)
    {    
         // LeadTriggerHandler.BeforeInsert(); 
    } 
 }