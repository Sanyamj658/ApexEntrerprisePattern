/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-12-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger opportunitylineitem_trgr on opportunitylineitem (after delete) {
    if(trigger.isAfter){
        if(trigger.isDelete){
            oppLineHandler.deleteAssociatedOpportunity(trigger.old);
        }
    }
}