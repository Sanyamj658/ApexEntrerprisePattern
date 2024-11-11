/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger distributedRevenueOnMonthlyBasis_trgr on Revenue__c (after insert) {

    if(trigger.isInsert || trigger.isUpdate){
        if(trigger.isAfter){
            distributedRevenueOnMonthlyBasis.distributeMonthlyRevenue(trigger.new);
        }
    }
}