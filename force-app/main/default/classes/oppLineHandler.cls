/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-12-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class oppLineHandler{
    public static void deleteAssociatedOpportunity(List<OpportunityLineItem> oppLineItems){
        List<Id> deletedOpportunityIds = new List<Id>();
        for(OpportunityLineItem oppLineItem : oppLineItems){
          deletedOpportunityIds.add(oppLineItem.OpportunityId);
    }
    List<opportunity> opportunitiesList = [SELECT Id FROM opportunity WHERE ID IN :deletedOpportunityIds];
    if(opportunitiesList.size() > 0){
      DELETE opportunitiesList;
    }
  }
}