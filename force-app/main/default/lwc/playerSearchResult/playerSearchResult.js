import { LightningElement, wire, api } from "lwc";
import getCricketer from "@salesforce/apex/CricketerController.getCricketer";

export default class PlayerSearchResult extends LightningElement {
  playerData;
  playerDataId;
  cricketerNationality = "";

  @wire(getCricketer, { Nationality: "$cricketerNationality" })
  wiredgetCricketer({ error, data }) {
    if (error) {
      console.log("Some error occured");
    } else if (data) {
      this.playerData = data;
      console.log(JSON.stringify(this.playerData));
    }
  }

  handlePlayerClick(event) {
    // Retrieve the ID of the clicked player
    this.playerDataId = event.currentTarget.dataset.id;

    // Remove 'selected' class from all elements with that class
    this.removClass();

    // Add 'selected' class to the clicked player
    let playerBox = this.template.querySelector(
      `[data-id="${this.playerDataId}"]`
    );
    if (playerBox) {
      playerBox.classList.add("selected");
    }
  }

  removClass() {
    // Remove 'selected' class from all elements with that class
    this.template.querySelectorAll(".selected").forEach((element) => {
      element.classList.remove("selected");
    });
  }

  @api searchPlayerResult(nationality) {
    console.log(this.nationality);
    this.cricketerNationality = nationality;
  }
}