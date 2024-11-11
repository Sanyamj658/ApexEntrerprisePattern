import { LightningElement } from "lwc";

export default class ParentB extends LightningElement {
  startCounter = 0;

  handleStartChange(event) {
    // console.log(typeof(event.target.value));
    this.startCounter = event.target.value;
  }

  handleMaxClick() {
    // const update = this// template.querySelector('c-child-b');
    // update.maximumcounter();
    this.template.querySelector("c-child-b").maximumcounter();
  }
}