@isTest
public class googleMeetIntegrationTest {
    
    // Implement a mock HTTP callout class
    public class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id":"12345","hangoutLink":"https://meet.google.com/xyz123"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    public class MockHttpErrorResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            return res;
        }
    }
    
    @isTest
    static void testCreateEvents() {
        Contact testContact = new Contact( FirstName = 'sanyam', LastName = 'Jain', Email = 'jainsanyam@gmail.com');
        insert testContact;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Test.startTest();
        googleMeetIntegration.createEvents('Test Meeting', 'This is a test meeting.', DateTime.now(),DateTime.now(), testContact.Id);
        Test.stopTest();
        List<Create_Metting_Info__c> meetingInfos = [SELECT Id, Name, Contact__c, Description__c, meetingId__c FROM Create_Metting_Info__c WHERE Contact__c = :testContact.Id];
        System.assertNotEquals(0, meetingInfos.size(), 'Meeting Info record created.');
        // Verify the contents of the meeting info record
        Create_Metting_Info__c meetingInfo = meetingInfos[0];
        System.assertEquals('Test Meeting', meetingInfo.Name);
        System.assertEquals(testContact.Id, meetingInfo.Contact__c);
        String expectedMeetingLink = 'https://meet.google.com/xyz123';
        System.assertEquals(expectedMeetingLink, meetingInfo.meetingId__c, 'Meeting link is correct.');
        
    }
    
    @isTest
    static void checkNegativeScenario() {
        
        Contact testContact = new Contact(FirstName = 'sanyam', LastName = 'Jain', Email = 'jainsanyam@gmail.com');
        insert testContact;
        Test.setMock(HttpCalloutMock.class, new MockHttpErrorResponse());
        Test.startTest();
        googleMeetIntegration.createEvents('Test Meeting', 'This is a test meeting.', DateTime.now(), DateTime.now(), testContact.Id);
        Test.stopTest();
        List<Create_Metting_Info__c> meetingInfos = [SELECT Id FROM Create_Metting_Info__c WHERE Contact__c = :testContact.Id];
        System.assertEquals(0, meetingInfos.size(), 'No meeting info record should be created due to unsuccessful scenario.');
    }
    
}