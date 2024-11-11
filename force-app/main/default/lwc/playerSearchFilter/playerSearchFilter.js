import { LightningElement, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { getObjectInfo, getPicklistValues } from "lightning/uiObjectInfoApi";
import CRICKETER_OBJECT from "@salesforce/schema/Cricketer__c";
import NATIONALITY_FIELD from "@salesforce/schema/Cricketer__c.Nationality__c";

export default class PlayerSearchFilter extends NavigationMixin(
  LightningElement
) {
  recordTypeId;
  pickListValue;
  optionArray;
  selectedCricketerNationality = "";
  @wire(getObjectInfo, { objectApiName: CRICKETER_OBJECT })
  objectInfos({ data, error }) {
    if (error) {
      console.error(
        "Error retrieving object information:",
        JSON.stringify(error)
      );
    } else if (data) {
      this.recordTypeId = data.defaultRecordTypeId;
      console.log("Object information:", JSON.stringify(data));
    }
  }

  @wire(getPicklistValues, {
    recordTypeId: "$recordTypeId",
    fieldApiName: NATIONALITY_FIELD
  })
  nationalityFieldValue({ data, error }) {
    if (error) {
      console.error("Error retrieving picklist values:", JSON.stringify(error));
    } else if (data) {
      let arr = [];
      this.pickListValue = data.values;
      this.pickListValue.forEach((element) => {
        arr.push({ label: element.value, value: element.value });
      });

      this.optionArray = arr;
    }
  }

  createNewCricketer() {
    this[NavigationMixin.Navigate]({
      type: "standard__objectPage",
      attributes: {
        objectApiName: "Cricketer__c",
        actionName: "new"
      }
    });
  }

  handleOptionChange(event) {
    this.selectedCricketerNationality = event.detail.value;
    this.template.querySelector('c-player-search-result').searchPlayerResult(this.selectedCricketerNationality); 
  }
}