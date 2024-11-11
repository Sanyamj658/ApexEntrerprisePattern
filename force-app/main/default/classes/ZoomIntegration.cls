/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 07-10-2024
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class ZoomIntegration {
    
    public static void populateWrapper(){
        ZoomIntegration.WrapperZoomMeeting wrap = new ZoomIntegration.WrapperZoomMeeting();
        wrap.topicOfMeeting = 'Integrate the zoom meeting topic';
        wrap.typeOfMeeting = 2;
        wrap.startTime = '2024-06-18T14:00:00z'; 
        wrap.durationMeeting = 60;
        wrap.timeZone = 'Asia/Kolkata';
        String jsonString = JSON.serialize(wrap);
        CreateMeeting(jsonString);
        
    }
    Public static void CreateMeeting(String jsonBody){
        HttpRequest req = new HttpRequest();
        req.setBody(jsonBody);
        req.setMethod('POST'); 
        req.setHeader('Content-type','application/json');
        req.setEndPoint('callout:Zoom_Meeting_Integration/v2/users/me/meetings');
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        System.debug('the response code is '+res.getStatusCode());
        if(res.getStatusCode()==201){
            System.debug('Success');
            //Parse the data
            Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            System.debug('responseBody--->'+responseBody);
            
            Long meetingId = (Long) responseBody.get('id');
            System.debug('Meeting ID: ' + meetingId);
            fetchMeetingParticipants(meetingId);
            
            if (responseBody.containsKey('join_url')) {
                String meetingUrl = (String) responseBody.get('join_url');
                System.debug('Meeting URL: ' + meetingUrl);
                System.debug('Meeting Details: ' + res.getBody());
            } else {
                System.debug('Meeting URL not found in the response');
            }
            
        }
        else{
            System.debug('Failure');
        }
        
    }
    public class WrapperZoomMeeting{
        public String topicOfMeeting{get; private set;}
        public Integer typeOfMeeting{get; set;}
        public String startTime{get; set;}
        public Integer durationMeeting{get; set;}
        public String timeZone{get; set;}
    }
    
    public static void fetchMeetingParticipants(Long meetingId) {
        // Construct the request to fetch participants using the Zoom API
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Content-type', 'application/json');
        req.setEndpoint('callout:Zoom_Meeting_Integration/v2/past_meetings/'+ meetingID+'/participants');
        
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('response body in id'+res.getBody());
        
        if (res.getStatusCode() == 200) {
            // Parse the response to get participant details
            List<Object> participants = (List<Object>) JSON.deserializeUntyped(res.getBody());
            System.debug('participants--->'+participants);
            
            for (Object participant : participants) {
                Map<String, Object> participantInfo = (Map<String, Object>) participant;
                String participantName = (String) participantInfo.get('name');
                String participantEmail = (String) participantInfo.get('email');
                
                System.debug('Participant Name: ' + participantName + ', Email: ' + participantEmail);
            }
        } else {
            System.debug('Failed to fetch participants for meeting ' + meetingId + ' with status code ' + res.getStatusCode());
        }
    }
}