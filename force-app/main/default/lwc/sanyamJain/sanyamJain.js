import { LightningElement } from "lwc";
import jsPDF from "@salesforce/resourceUrl/ExcelToPdf";
import htmlToPdf from "@salesforce/resourceUrl/htmlToPdf";
import sheetJS from "@salesforce/resourceUrl/xlmsFile";
import { loadScript } from "lightning/platformResourceLoader";

export default class SanyamJain extends LightningElement {
  excelData = "";
  jsPdfInitialized = false;
  sheetJsInitialized = false;
  htmlToPdf = false;
  pdfGenerated = false; // Track if PDF has been generated

  renderedCallback() {
    if (
      this.jsPdfInitialized &&
      this.sheetJsInitialized &&
      this.htmlToPdfInitialized
    ) {
      return;
    }

    Promise.all([
      loadScript(this, jsPDF),
      loadScript(this, sheetJS, loadScript(this, htmlToPdf))
    ])
      .then(() => {
        this.jsPdfInitialized = true;
        this.sheetJsInitialized = true;
        this.htmlToPdfInitialized = true;
        console.log(
          "jsPDF, htmlToPdf and SheetJS libraries loaded successfully"
        );
      })
      .catch((error) => {
        console.error("Error loading libraries", error);
      });
  }

  handleFileChange(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        const data = new Uint8Array(e.target.result);
        const workbook = XLSX.read(data, { type: "array" });
        const sheetName = workbook.SheetNames[0];
        const worksheet = workbook.Sheets[sheetName];
        this.excelData = XLSX.utils.sheet_to_html(worksheet);
        console.log("Excel data loaded successfully", this.excelData);
        this.pdfGenerated = false; // Reset PDF generation flag when new file is uploaded
      };
      reader.readAsArrayBuffer(file);
    }
  }

  downloadPdf() {
    var h = document.getElementById("heading");
    var doc = new jsPDF();
    doc.fromHtml(h, 15, 15);
    doc.save("output.pdf");
  }

  //   downloadPdf() {
  //     if (this.excelData) {
  //       console.log("Generating PDF...>>>", this.excelData);
  //       console.log("log success");
  //       //const doc = new jsPDF("p", "pt", "a4");
  //       const doc = new jsPDF();
  //       console.log("below the doc jspdf");
  //       doc.fromHTML(this.excelData, 10, 10);
  //       doc.save("a4.pdf");
  //       console.log("doc>>>>>>>>>", this.doc);
  //       console.log("Generating PDF...", doc);
  //       doc.html(this.excelData, {
  //         callback: (pdf) => {
  //           this.pdfGenerated = true; // Set flag when PDF is generated
  //           pdf.save("ExcelToPDF.pdf"); // Save PDF immediately after generation
  //           console.log("PDF generated and downloaded successfully");
  //         },
  //         x: 10,
  //         y: 10
  //       });
  //     } else {
  //       console.error("No Excel data to convert");
  //     }
}