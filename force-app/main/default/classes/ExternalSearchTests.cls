/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-27-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
private class ExternalSearchTests {
  @IsTest
  static void testPositiveMocking() {
    // GIVEN
    HTTPMockFactory mock = new HTTPMockFactory(
      200,
      'OK',
      'I found it!',
      new Map<String, String>()
    );
    Test.setMock(HttpCalloutMock.class, mock);
    // WHEN
    Test.startTest();
      String result = ExternalSearch.googleIt('epic search');
    Test.stopTest();
    // THEN
    Assert.areEqual('I found it!', result, 'Expected to receive mock response');
  }
      @IsTest
  static void testNegativeMocking() {
    HttpMockFactory mock = new HttpMockFactory(500, 'Internal Server Error', 'server issue!', new Map<String,String>());
    Test.setMock(HttpCalloutMock.class, mock);
    String result;
    Test.startTest();
    try{
      result = ExternalSearch.googleIt('server issue');
    } catch(ExternalSearch.ExternalSearchException e){
      system.assertEquals('Did not receive a 200 status code: 500', e.getMessage());
    }
      
    Test.stopTest();
    //system.assertEquals('server issue!', result); 
  }
    
}