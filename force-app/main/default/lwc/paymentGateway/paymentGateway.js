import { LightningElement } from "lwc";
import getPaymentUrl from "@salesforce/apex/StripeIntegrationHandler.getPaymentUrl";
export default class PaymentGateway extends LightningElement {
  checkoutUrl = "";
  handlePayment() {
    getPaymentUrl()
      .then((result) => {
        this.checkoutUrl = result;
        console.log("this.checkoutUrl-->", this.checkoutUrl);
        window.open(this.checkoutUrl, "_blank");
      })
      .catch((error) => {
        console.error("Error making payment:", error);
      });
  }
}