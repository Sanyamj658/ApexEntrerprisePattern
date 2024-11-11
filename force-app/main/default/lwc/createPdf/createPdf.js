import { LightningElement } from "lwc";
import XLSX from "@salesforce/resourceUrl/xlmsFile"; // Import the xlsx library resource

export default class CreatePdf extends LightningElement {
  jsonString;

  handleFileChange(event) {
    const file = event.target.files[0];
    if (file) {
      this.readFile(file);
    }
  }

  readFile(file) {
    const reader = new FileReader();
    reader.onload = (event) => {
      const data = event.target.result;
      this.processExcelData(data);
    };
    reader.readAsBinaryString(file);
  }

  processExcelData(data) {
    const workbook = XLSX.read(data, { type: "binary" });
    const sheetName = workbook.SheetNames[0]; // Assuming first sheet
    const worksheet = workbook.Sheets[sheetName];
    const jsonData = XLSX.utils.sheet_to_json(worksheet, { raw: true });

    this.jsonString = JSON.stringify(jsonData, null, 2);
    console.log("json data->>>", this.jsonString);
  }
}