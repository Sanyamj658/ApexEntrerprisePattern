import { LightningElement } from "lwc";
import getPaymentUrl from "@salesforce/apex/StripeIntegrationHandler.getPaymentUrl";

export default class StripeInegration extends LightningElement {
  checkoutURL = "";
  handlePaymentClick() {
    getPaymentUrl()
      .then((result) => {
        this.checkoutURL = result;
        console.log("Checkout URL:", this.checkoutURL);
        window.open(this.checkoutURL, "_blank");
      })
      .catch((error) => console.log(error));
  }
}