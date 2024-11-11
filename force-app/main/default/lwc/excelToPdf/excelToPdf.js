// excelToPdf.js
import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import convertExcelToPdf from "@salesforce/apex/ExcelToPdfConverter.convertExcelToPdf";

export default class ExcelToPdf extends LightningElement {
  file;
  base64ExcelContent;

  handleFileUpload(event) {
    this.file = event.target.files[0];

    if (this.file) {
      const reader = new FileReader();
      reader.onload = () => {
        this.base64ExcelContent = reader.result.split(",")[1]; // Extract base64 encoded Excel content
      };
      reader.readAsDataURL(this.file);
    }
  }

  async downloadPdf() {
    if (!this.file) {
      this.showToast("Error", "Please upload an Excel file.", "error");
      return;
    }

    if (!this.base64ExcelContent) {
      this.showToast("Error", "Failed to read Excel file content.", "error");
      return;
    }

    try {
      const fileName = this.file.name;

      // Call Apex method to convert Excel to PDF and get the Base64 encoded PDF content
      const base64PdfContent = await convertExcelToPdf({
        base64ExcelContent: this.base64ExcelContent,
        fileName: fileName
      });

      // Convert the Base64 string to Blob
      const byteCharacters = atob(base64PdfContent);
      const byteArrays = [];
      for (let offset = 0; offset < byteCharacters.length; offset += 512) {
        const slice = byteCharacters.slice(offset, offset + 512);
        const byteNumbers = new Array(slice.length);
        for (let i = 0; i < slice.length; i++) {
          byteNumbers[i] = slice.charCodeAt(i);
        }
        const byteArray = new Uint8Array(byteNumbers);
        byteArrays.push(byteArray);
      }
      const blob = new Blob(byteArrays, { type: "application/pdf" });

      // Create a temporary link element to trigger the download
      const link = document.createElement("a");
      link.href = URL.createObjectURL(blob);
      link.download = fileName.replace(/\.[^/.]+$/, "") + ".pdf";
      link.click();

      this.showToast(
        "Success",
        "Excel file converted to PDF and downloaded.",
        "success"
      );
    } catch (error) {
      console.error("Error converting Excel to PDF:", error);
      this.showToast("Error", "Failed to convert Excel to PDF.", "error");
    }
  }

  showToast(title, message, variant) {
    const toastEvent = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(toastEvent);
  }
}