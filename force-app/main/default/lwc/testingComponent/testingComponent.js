import { LightningElement, wire } from "lwc";
import getContact from "@salesforce/apex/contactList.getContact";

export default class TestingComponent extends LightningElement {
  //   greeting = "Bharat";
  // }

  //2. ------------

  // import { LightningElement, track } from 'lwc';

  // export default class MyConditionalRendering extends LightningElement {
  //     @track isVisible = false;

  //     changeHandler(event) {
  //         this.isVisible = event.target.checked;
  //     }
  // }
  //----------------------------------------------------------------------------------
  //   userList = [
  //     { id: 1, Name: "A" },
  //     { id: 2, Name: "B" },
  //     { id: 3, Name: "C" }
  //   ];

  //----------------------------------------------------------------------------------------------c/accountList

  data = [];

  @wire(getContact)
  contacts
}