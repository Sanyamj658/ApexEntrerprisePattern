/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-14-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class googleMeetIntegration {
    @AuraEnabled
    
    public static void createEvents(String meetingTitle, String description, DateTime startDate, DateTime endDate, String ContactId, String attendees) {
        String endpoint = 'callout:GoogleMeeting/calendar/v3/calendars/primary/events?conferenceDataVersion=1';
     System.debug('the record id is ---->'+ ContactId);         
        String emails = [SELECT Email FROM Contact WHERE Id = :ContactId].Email;

        System.debug('the email of contact is ' + emails);
        // Create map to hold event data 
        Map<String, Object> eventData = new Map<String, Object>();
        eventData.put('summary', meetingTitle);
        eventData.put('description', description);
        eventData.put('start', new Map<String, Object>{'dateTime' => startDate, 'timeZone' => 'Asia/Kolkata'});
        eventData.put('end', new Map<String, Object>{'dateTime' => endDate, 'timeZone' => 'Asia/Kolkata'});
        eventData.put('attendees', new List<Object>{new Map<String, Object>{'email' => emails}});
       eventData.put('conferenceData', new Map<String, Object>{
        'createRequest' => new Map<String, Object>{
            'requestId' => String.valueOf(System.currentTimeMillis()),
            'conferenceSolutionKey' => new Map<String, Object>{ 
                'type' => 'hangoutsMeet'
            }
        }
    });
        System.debug('The Event  is' + eventData);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(eventData));

        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() == 200) {
            System.debug('Response Body: ' + res.getBody());
            Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String meetingId = (String) responseBody.get('id');
            String meetingLink = (String) responseBody.get('hangoutLink');
            //Create_Metting_Info__c meeting_info = new Create_Metting_Info__c();
            Create_Metting_Info__c meeting_info = new Create_Metting_Info__c();
            meeting_info.Contact__c = ContactId;
            meeting_info.Name = meetingTitle;
            meeting_info.meetingId__c = meetingLink;
            meeting_info.End_Date__c = endDate.date();
            meeting_info.End_Time__c= endDate.time();
            meeting_info.Start_Date__c = startDate.date();
            meeting_info.Start_Time__c = startDate.time(); 
            meeting_info.Description__c = description;
            //meeting_info.meetingCode__c = meetingId; 

            //  Contact__c = ContactId, Name = meetingTitle, meetingId__c = meetingLink, 
            //End_Date__c = endDate.date(), End_Time__c= endDate.time(), Start_Date__c = startDate.date(), Start_Time__c = startDate.time(), Description__c = description
            try {
                insert meeting_info;
                System.debug('Meeting information stored successfully: ' + meeting_info);
            } catch (Exception e) {
                System.debug('Error: Failed to insert meeting information. ' + e.getMessage());
            }
            
        } else {
            //  return ''; 
            System.debug('Error: Failed to create event. Status code: ' + res.getStatusCode());
        }
    }
}