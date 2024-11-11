import { LightningElement, wire } from "lwc";
import { subscribe, MessageContext } from "lightning/messageService";
import COUNT_UPDATED_CHANNEL from "@salesforce/messageChannel/counting_Update__c";

export default class SubLwc extends LightningElement {
  counter = 0;

  subscription = null;

  @wire(MessageContext)
  messageContext;

  connectedCallback() {
    this.subscriptionToMessageChannel();
  }

  subscriptionToMessageChannel() {
    this.subscription = subscribe(
      this.messageContext,
      COUNT_UPDATED_CHANNEL,
      (message) => this.handleMessage(message)
    );
  }

  handleMessage(message) {
    //alert("message" + JSON.stringify(message));
    console.log("in Addition", message);
    if (message.operator == "Addition") {
      this.counter += message.constant;
    } else if (message.operator == "Subtarct") {
      this.counter -= message.constant;
    } else if (message.operator == "Multiply") {
      this.counter *= message.constant;
    }
  }
}