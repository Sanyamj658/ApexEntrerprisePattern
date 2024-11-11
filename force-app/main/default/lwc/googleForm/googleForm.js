import { LightningElement, track } from "lwc";
import createRecord from "@salesforce/apex/RecordController.createRecord";

export default class GoogleForm extends LightningElement {
  @track name = "";
  @track classValue = "";
  @track college = "";
  @track location = "";

  handleInputChange(event) {
    const { name, value } = event.target;
    this[name] = value;
  }

  handleClick() {
    createRecord({
      name: this.name,
      classValue: this.classValue,
      college: this.college,
      location: this.location
    })
      .then((result) => {
        console.log("Record created successfully:", result);
        this.resetFields();
      })
      .catch((error) => {
        console.error("Error creating record:", error);
      });
  }

  resetFields() {
    this.name = "";
    this.classValue = "";
    this.college = "";
    this.location = "";
  }
}