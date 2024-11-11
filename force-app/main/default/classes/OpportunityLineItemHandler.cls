/**
 * @description       : Trigger handler for OpportunityLineItem to handle operations related to the deletion of OpportunityLineItems.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-12-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class OpportunityLineItemHandler {
    
  public static void handleOpportunityLineItemDeletion(List<OpportunityLineItem> oppLineItems) {
      Set<Id> oppIds = new Set<Id>();
      
      for (OpportunityLineItem oppLineItem : oppLineItems) {
          oppIds.add(oppLineItem.OpportunityId);
      }

      List<Opportunity> opportunitiesToDelete = [SELECT Id FROM Opportunity WHERE Id IN :oppIds];

      if (!opportunitiesToDelete.isEmpty()) {
          delete opportunitiesToDelete;
      }
  }

  public static void updateAccountWithOpportunityLineItemCount(List<OpportunityLineItem> oppLineItems) {
      Set<Id> oppIds = new Set<Id>();

      // Get the opportunities related to these OpportunityLineItems
      for (OpportunityLineItem oli : oppLineItems) {
          oppIds.add(oli.OpportunityId);
      }

      // Map to keep track of Opportunity counts for each Account
      Map<Id, Decimal> accountOpportunityCountMap = new Map<Id, Decimal>();

      List<Opportunity> opportunities = [SELECT Id, AccountId FROM Opportunity WHERE Id IN :oppIds];

      for (Opportunity opp : opportunities) {
          accountOpportunityCountMap.put(opp.AccountId, 0);
      }

      // Aggregate OpportunityLineItems count per Account
      for (AggregateResult aggr : [SELECT COUNT(Id) oliCount, Opportunity.AccountId FROM OpportunityLineItem WHERE Opportunity.AccountId IN :accountOpportunityCountMap.keySet() GROUP BY Opportunity.AccountId]) {
          accountOpportunityCountMap.put((Id)aggr.get('Opportunity.AccountId'), (Decimal)aggr.get('oliCount'));
      }

      // Prepare accounts for update
      List<Account> accountsToUpdate = new List<Account>();
      for (Id accountId : accountOpportunityCountMap.keySet()) {
          Account acc = new Account();
          acc.Id = accountId;
          acc.NoOfOpportunity__c = accountOpportunityCountMap.get(accountId);
          accountsToUpdate.add(acc);
      }

      if (!accountsToUpdate.isEmpty()) {
          update accountsToUpdate;
      }
  }
}