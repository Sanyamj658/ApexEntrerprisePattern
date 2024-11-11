@IsTest
private class AccountWrapperTests {
  @TestSetup
  static void loadTestData() {
    // GIVEN
    Account acct = new Account(Name = 'ACME');
    Account acct1 = new Account(Name = 'ACME2');
    insert acct;
    insert acct1;
    List<Opportunity> opps = new List<Opportunity>();
    for(Integer i=0; i<2; i++){
       opps.add(new Opportunity(Name='Test'+i, AccountId =acct.Id, Amount=100000.00, StageName = 'Prospecting', CloseDate=System.today()));
        
    } 
    for(Integer i=0; i<2; i++){
        opps.add(new Opportunity(Name='Test'+i, AccountId =acct1.Id, Amount=120000.00, StageName = 'Need Analysis', CloseDate=System.today()));
         
     } 
    insert opps;
  }
  
  @IsTest
  static void testIsHighPriority(){
  // WHEN
  Account acct = [SELECT Id FROM Account WHERE Name = 'ACME' LIMIT 1];
  Account acct2 = [SELECT Id FROM Account WHERE Name = 'ACME2' LIMIT 1];
  AccountWrapper acctWrapper = new AccountWrapper(acct);
  AccountWrapper acctWrapper2 = new AccountWrapper(acct2);
  // THEN
    Test.startTest();
    Assert.areEqual(
        acctWrapper.isHighPriority(),false, 'Expected to get >100000.00');
    Assert.areEqual(
        acctWrapper2.isHighPriority(),true, 'Expected to get >100000.00');
    Test.stopTest();
  }
}