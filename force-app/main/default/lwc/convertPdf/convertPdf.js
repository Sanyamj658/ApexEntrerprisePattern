import { LightningElement } from "lwc";
import jsPDF from "@salesforce/resourceUrl/ExcelToPdf";
import XLSX from "@salesforce/resourceUrl/xlmsFile";
import { loadScript } from "lightning/platformResourceLoader";

export default class ConvertPdf extends LightningElement {
  excelData = null;
  jsPdfInitialized = false;
  sheetJsInitialized = false;
  pdfGenerated = false;

  renderedCallback() {
    if (this.jsPdfInitialized && this.sheetJsInitialized) {
      return;
    }

    Promise.all([loadScript(this, jsPDF), loadScript(this, XLSX)])
      .then(() => {
        this.jsPdfInitialized = true;
        this.sheetJsInitialized = true;
        console.log("jsPDF and SheetJS libraries loaded successfully");
      })
      .catch((error) => {
        console.error("Error loading libraries", error);
      });
  }

  handleFileChange(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = () => {
        try {
          const data = new Uint8Array(reader.result);
          const workbook = XLSX.read(data, { type: "array" });
          const sheetName = workbook.SheetNames[0];
          const worksheet = workbook.Sheets[sheetName];
          this.excelData = XLSX.utils.sheet_to_html(worksheet);
          console.log("Excel data loaded successfully");
          this.pdfGenerated = false;
        } catch (error) {
          console.error("Error reading or parsing Excel file:", error);
          this.excelData = null; // Reset excelData if there's an error
          // Optionally, provide user feedback about the error
        }
      };
      reader.readAsArrayBuffer(file);
    }
  }

  downloadPdf() {
    if (this.excelData) {
      console.log("Generating PDF...");
      const doc = new jsPDF("p", "pt", "a4");
      doc.html(this.excelData, {
        callback: (pdf) => {
          this.pdfGenerated = true;
          pdf.save("ExcelToPDF.pdf");
          console.log("PDF generated and downloaded successfully");
        },
        x: 10,
        y: 10
      });
    } else {
      console.error("No Excel data to convert");
      // Optionally, provide user feedback that no data is available to convert
    }
  }
}