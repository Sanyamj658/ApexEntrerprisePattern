import { LightningElement } from "lwc";
import { loadStyle } from "lightning/platformResourceLoader";
import MY_PDF from "@salesforce/resourceUrl/MyPDF";

export default class StaticResourceTest extends LightningElement {
  openPdf() {
    // Opens the PDF in a new tab
    window.open(MY_PDF, "_blank");
  }
}