/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-20-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger contactTrigger on Contact (after update,after insert,before insert, before update) {

    if(trigger.isUpdate || trigger.isInsert){
        if(trigger.isAfter){
           //contactHandler.updateAccountPrimaryDescription(trigger.new);
           //contactHandler.updateCompleteOppAmountOnAcc(trigger.new);
           
        }
    }
    
      if(Trigger.isBefore && Trigger.isUpdate || Trigger.isBefore && Trigger.isInsert){
       // if(trigger.isbefore){
            //contactHandler.insertUpdateContactWhichLastNameInvalid(trigger.new);
        
            contactHandler.contactProcessTime(trigger.new);
       // }
    }
}