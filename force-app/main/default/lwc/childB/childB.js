import { LightningElement, api } from "lwc";

export default class ChildB extends LightningElement {
  @api counter = 0;

  @api maximumcounter() {
    this.counter = parseInt(this.counter) + 100;
  }
}