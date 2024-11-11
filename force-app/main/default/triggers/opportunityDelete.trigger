/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-04-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger opportunityDelete on opportunitylineitem (after delete) {

    if(trigger.isAfter){
        if(trigger.isDelete){
            oppLineHandler.oppLineItemHandler(trigger.old);
        }
    }


}