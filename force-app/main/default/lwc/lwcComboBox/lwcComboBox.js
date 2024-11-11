import { LightningElement, track } from "lwc";
import getCountryName from "@salesforce/apex/ImperativeDemo.getCountryName";

export default class LwcComboBox extends LightningElement {
  @track value = "";
  @track accOption = [];

  get options() {
    return this.accOption;
  }

  connectedCallback() {
    getCountryName().then((results) => {
      let arr = [];
      for (var i = 0; i < results.length; i++) {
        arr.push({ label: results[i].Name, value: results[i].Id });
      }
      this.accOption = arr;
    });
  }
  handleChanged(event) {
    this.value = event.detail.value;
  }
}