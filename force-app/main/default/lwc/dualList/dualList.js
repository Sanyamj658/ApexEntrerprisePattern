import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getCustomObjectNames from "@salesforce/apex/CustomObjectController.getCustomObjectNames";
import getExistingValues from "@salesforce/apex/CustomObjectController.getExistingValues";
//import getSelectedExistingValues from "@salesforce/apex/CustomObjectController.getSelectedExistingValues";
import saveSelectedValues from "@salesforce/apex/CustomObjectController.saveSelectedValues";

export default class DualList extends LightningElement {
  options = []; // Stores the custom object names as an array of objects
  defaultValues = []; // Stores the initial set of values fetched from the server.
  selectedValues = []; // Stores the current selected values in the dual list.
  savedValues = new Set(); // Track saved values
  customObjectNames = []; // Store custom object names fetched from the server

  connectedCallback() {
    this.fetchCustomObjectNames();
  }

  fetchCustomObjectNames() {
    getCustomObjectNames()
      .then((data) => {
        this.customObjectNames = data;
        this.options = data
          .filter((name) => !this.defaultValues.includes(name))
          .map((name) => ({ label: name, value: name }));
        this.fetchExistingValues();
      })
      .catch((error) => {
        this.showToast(
          "Error",
          "An error occurred while fetching custom objects.",
          "error"
        );
        console.error("ERROR: ", error);
      });
  }

  fetchExistingValues() {
    getExistingValues()
      .then((existingValues) => {
        this.defaultValues = existingValues;
        this.selectedValues = []; // Clear selected values when component is initialized
        this.savedValues = new Set(existingValues); // Initialize saved values
        this.options = this.options.filter(
          (option) => !existingValues.includes(option.value)
        );
      })
      .catch((error) => {
        this.showToast(
          "Error",
          "An error occurred while fetching existing values.",
          "error"
        );
      });
  }

  handleChange(event) {
    this.selectedValues = event.detail.value;
  }

  handleSave() {
    if (this.selectedValues && this.selectedValues.length > 0) {
      saveSelectedValues({ selectedValues: this.selectedValues })
        .then(() => {
          this.showToast("Success", "Values saved successfully.", "success");
          this.selectedValues.forEach((value) => this.savedValues.add(value));
          this.options = this.options.filter(
            (option) => !this.selectedValues.includes(option.value)
          );
          this.selectedValues = [];
        })
        .catch((error) => {
          this.showToast(
            "Error",
            "An error occurred while saving values.",
            "error"
          );
        });
    } else {
      this.showToast("Error", "No values selected to save.", "error");
      console.log("ERROR: No values selected to save.");
    }
  }

  showToast(title, message, variant) {
    const toastEvt = new ShowToastEvent({ title, message, variant });
    this.dispatchEvent(toastEvt);
  }
}