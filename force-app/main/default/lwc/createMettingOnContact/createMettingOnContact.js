import { LightningElement, api } from "lwc";
import createEvents from "@salesforce/apex/googleMeetIntegration.createEvents";
export default class CreateMettingOnContact extends LightningElement {
  @api recordId;
  meetingattendees;
  description;
  startDate;
  startTime;
  meetingTitle;
  endDate;
  endTime;

  handleMettingTitle(event) {
    this.meetingTitle = event.target.value;
  }

  handleMettingattendees(event) {
    this.meetingattendees = event.target.value;
  }

  handleMettingDescription(event) {
    this.description = event.target.value;
  }

  handleMettingStartDate(event) {
    console.log("startdate ", event.target.value);
    this.startDate = event.target.value;
    console.log("startdate ", this.startDate);
  }

  handleMettingStartTime(event) {
    this.startTime = event.target.value;
  }

  handleMettingEndDate(event) {
    this.endDate = event.target.value;
  }

  handleMettingEndTime(event) {
    this.endTime = event.target.value;
  }

  handleCreateMeeting() {
    console.log("startdate ", this.startDate);
    //"2015-05-28T09:00:00-07:00"
    let startDateTime = new Date(this.startDate + "T" + this.startTime);
    let endDateTime = new Date(this.endDate + "T" + this.endTime);
    console.log("startDate-->", this.startDate);
    createEvents({
      meetingTitle: this.meetingTitle,
      description: this.description,
      startDate: startDateTime, //startDateTime.toISOString(),
      endDate: endDateTime, //endDateTime.toISOString(),
      ContactId: this.recordId
      //  startTime: this.startTime.toString(),
      // endTime: this.endTime.toString()
    })
      .then((result) => {
        // Handle success
        this.eventCreated = result;
        console.log("meeting--->title-->", this.meetingTitle);
        console.log("record id of this --->", this.recordId);
        console.log("Event created:", result);
      })
      .catch((error) => {
        // Handle error
        console.error("Error creating event:", error);
      });
  }
}