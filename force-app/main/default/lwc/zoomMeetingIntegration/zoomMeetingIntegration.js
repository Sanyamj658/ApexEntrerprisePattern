// zoomMeetingIntegration.js
import { LightningElement } from "lwc";
import createMeeting from "@salesforce/apex/ZoomIntegration.populateWrapper";

export default class ZoomMeetingIntegration extends LightningElement {
  handleCreateMeeting() {
    createMeeting()
      .then((result) => {
        console.log("Meeting created successfully:", result);
        // Optionally handle success actions like displaying a confirmation
      })
      .catch((error) => {
        console.error("Error creating meeting:", error);
        // Optionally handle error actions like displaying an error message
      });
  }
}