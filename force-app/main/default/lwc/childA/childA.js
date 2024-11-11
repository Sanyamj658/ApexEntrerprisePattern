import { LightningElement } from "lwc";

export default class ChildA extends LightningElement {
  handleIncrement() {
    this.dispatchEvent(new CustomEvent("add"));
  }

  handleDecrement() {
    this.dispatchEvent(new CustomEvent("sub"));
  }

  handleMultiply(event) {
    const mulValue = event.target.value;
    this.dispatchEvent(
      new CustomEvent("mul", {
        detail: mulValue
      })
    );
  }
}