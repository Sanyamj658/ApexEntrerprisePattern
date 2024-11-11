import { LightningElement } from "lwc";
import { loadScript } from "lightning/platformResourceLoader";
import XLSX from "@salesforce/resourceUrl/xlmsFile";

export default class ExcelToHtml extends LightningElement {
  htmlData = "";

  async handleFileChange(event) {
    const file = event.target.files[0];
    if (file) {
      await this.readFile(file);
    }
  }

  async readFile(file) {
    const reader = new FileReader();
    reader.onload = async (event) => {
      const data = new Uint8Array(event.target.result);
      const workbook = XLSX.read(data, { type: "array" });
      const firstSheetName = workbook.SheetNames[0];
      const worksheet = workbook.Sheets[firstSheetName];
      const jsonSheet = XLSX.utils.sheet_to_json(worksheet, { header: 1 });

      this.htmlData = this.convertToHtml(jsonSheet);
      console.log('"this.htmldata>>>>>>', this.htmlData);
    };
    reader.readAsArrayBuffer(file);
  }

  convertToHtml(data) {
    let html = '<table border="1">';

    for (let row of data) {
      html += "<tr>";
      for (let cell of row) {
        html += `<td>${cell}</td>`;
      }
      html += "</tr>";
    }

    html += "</table>";
    return html;
  }
}