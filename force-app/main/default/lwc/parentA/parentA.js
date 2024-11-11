import { LightningElement } from "lwc";

export default class ParentA extends LightningElement {
  counter = 0;

  handleIncrement() {
    this.counter++;
  }

  handleDecrement() {
    this.counter--;
  }

  handleMultiply(event) {
    const val = event.detail;
    this.counter *= val;
  }
}