import { LightningElement, wire } from "lwc";
import { publish, MessageContext } from "lightning/messageService";
import COUNT_UPDATED_CHANNEL from "@salesforce/messageChannel/counting_Update__c";

export default class PubLwc extends LightningElement {
  @wire(MessageContext)
  messageContext;

  handleIncrement() {
    const payload = {
      operator: "Addition",
      constant: 1
    };
    publish(this.messageContext, COUNT_UPDATED_CHANNEL, payload);
  }

  handleDecrement() {
    const payload = {
      operator: "Subtarct",
      constant: 1
    };
    publish(this.messageContext, COUNT_UPDATED_CHANNEL, payload);
  }

  handleMultiply() {
    const payload = {
      operator: "Multiply",
      constant: 2
    };
    publish(this.messageContext, COUNT_UPDATED_CHANNEL, payload);
  }
}