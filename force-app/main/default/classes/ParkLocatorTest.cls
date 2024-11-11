@isTest
private class ParkLocatorTest {
    @isTest static void testCallout() {              
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        string Country  = 'Germany';
        List<String> result = ParkLocator.country(country);
        List<String> parks = new List<String>{'Hamburg Wadden Sea National Park', 'Hainich National Park', 'Bavarian Forest National Park'};
            System.assertEquals(parks, result); 
    }
}