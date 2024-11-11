@istest
public class OpportunityTestClass {
    @TestSetup
    static void opportunityTest(){
        Account acc = new Account(Name = 'Account Test');
        insert acc;
        
        List<opportunity> oppList = new List<opportunity>();
        opportunity opp1 = new opportunity(Name = 'Test1', stageName = 'Prospecting', Amount = 20000, AccountId = acc.Id , CloseDate = Date.Today());
        opportunity opp2 = new opportunity(Name = 'Test2', stageName = 'closed', Amount = 10000, AccountId = acc.Id, CloseDate = Date.Today());
        oppList.add(opp1);
        oppList.add(opp2);
        
        insert oppList;
        
        Test.startTest();
        OpportunityTriggerHandle.createOpportunity(oppList);
        Test.stopTest();
        
        opp2 = [SELECT StageName FROM Opportunity WHERE Id = :opp2.Id];
        System.assertEquals('Prospecting', opp1.StageName, 'stageName');
    }
    
    
}