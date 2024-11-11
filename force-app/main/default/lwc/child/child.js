import { LightningElement, api } from "lwc";

export default class Child extends LightningElement {
  @api message = "Sanyam Jain";

  @api
  handleMessages() {
    this.message = "Avi Jain";
    return this.message;
  }
}