import { LightningElement, track } from "lwc";
import ConvertAmount from "@salesforce/apex/CurrecyConvertorController.ConvertAmount";

export default class CurrencyConverter extends LightningElement {
  @track SourceCurrency = "USD";
  @track targetCurrency = "INR";
  @track amount = "";
  @track ConvertedAmount;

  get options() {
    return [
      { label: "US Dollar", value: "USD" },
      { label: "Indian Rupee", value: "INR" },
      { label: "Pakistani Rupee", value: "PKR" },
      { label: "Singapore Dollar", value: "SGD" },
      { label: "Afghan Afghani", value: "AFN" }
    ];
  }

  SourcehandleChange(event) {
    this.SourceCurrency = event.detail.value;
  }

  handleAmount(event) {
    this.amount = event.target.value;
  }

  targethandleChange(event) {
    this.targetCurrency = event.detail.value;
  }

  handleConvert() {
    ConvertAmount({
      SourceCurrency: this.SourceCurrency,
      targetCurrency: this.targetCurrency,
      Amount: this.amount
    })
      .then((result) => {
        this.ConvertedAmount = result;
      })
      .catch((error) => {
        console.error("The error is: ", error);
      });
  }
}