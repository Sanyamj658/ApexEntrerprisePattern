import { LightningElement, track } from "lwc";

export default class StepAndIndicator extends LightningElement {
  @track selectedStep = "Step1";

  // Determine if current step is the last step
  get isLastStep() {
    return this.selectedStep === "Step3";
  }

  nextStep() {
    if (this.selectedStep === "Step2") {
      this.selectedStep = "Step3";
    } else if (this.selectedStep === "Step1") {
      this.selectedStep = "Step2";
    }
  }

  previousStep() {
    if (this.selectedStep === "Step2") {
      this.selectedStep = "Step1";
    } else if (this.selectedStep === "Step3") {
      this.selectedStep = "Step2";
    }
  }

  selectStep1() {
    this.selectedStep = "Step1";
  }

  selectStep2t() {
    this.selectedStep = "Step2";
  }

  selectStep3() {
    this.selectedStep = "Step3";
  }

  handleConfirm() {
    // Handle confirm button functionality here
    console.log("Confirm button clicked!");
  }
}