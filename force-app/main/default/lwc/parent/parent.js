import { LightningElement } from "lwc";

export default class Parent extends LightningElement {
  parVar;
  handleMessage(event) {
    this.parVar = this.template.querySelector("c-child").message;
  }

  handleMethod() {
    this.parVar = this.template.querySelector("c-child").handleMessages();
  }
}