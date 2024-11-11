import { LightningElement, wire } from "lwc";
import getExistingValues from "@salesforce/apex/CustomObjectController.getExistingValues";
export default class DualListDataTable extends LightningElement {
  data = [];
  columns = [{ label: "Name", fieldName: "Name", type: "text" }];

  @wire(getExistingValues)
  wiredMyData({ error, data }) {
    if (data) {
      console.log(data);
      this.data = data.map((value) => {
        return { Name: value };
      });
    } else if (error) {
      console.log(error);
    }
  }
}