/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger BookOrder_trgr on Book_Order__c (after update) {
    if(trigger.isUpdate){
        if(trigger.isAfter){
            BookOrderHelper.updateBookOrderStatus(trigger.new);
        }
    }
}