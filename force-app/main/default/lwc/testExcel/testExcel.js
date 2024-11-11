import { LightningElement } from "lwc";
import { loadScript } from "lightning/platformResourceLoader";
//import jsPDF from '@salesforce/resourceUrl/jspdf'; // adjust the path to your jsPDF script
import jsPDF from "@salesforce/resourceUrl/ExcelToPdf";

export default class CreatePdf extends LightningElement {
  renderedCallback() {
    loadScript(this, jsPDF)
      .then(() => {
        console.log("jsPDF loaded successfully");
      })
      .catch((error) => {
        console.error("Error loading jsPDF", error);
      });
  }

  async createPdf() {
    if (typeof jsPDF !== "undefined") {
      // Example HTML content
      const htmlContent = `
                <html>
                <head><title>Sample PDF</title></head>
                <body>
                    <h1>Hello PDF!</h1>
                    <p>This is a sample PDF document generated from HTML content.</p>
                </body>
                </html>
            `;

      // Create jsPDF instance
      const doc = new jsPDF();

      // Convert HTML to PDF
      doc.text("htmlContent", {
        callback: () => {
          // Save the PDF
          doc.save("sample.pdf");
        }
      });
    } else {
      console.error("jsPDF not loaded");
    }
  }
}