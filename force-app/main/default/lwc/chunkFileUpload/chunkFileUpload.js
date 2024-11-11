import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import uploadChunkedFile from "@salesforce/apex/CloudConnectorUploadFile.uploadChunkedFile";

const CHUNK_SIZE = 2000000; // 2 MB
const MAX_FILE_SIZE = 50000000; // 50 MB

export default class ChunkFileUpload extends LightningElement {
  @api recordId;
  @track fileName = "";
  @track fileContent = "";
  filesize = 0;
  uploadedsize = 0;
  showSpinner = false;

  handleInputFileChange(event) {
    if (event.target.files.length > 0) {
      this.fileContent = event.target.files[0];
      this.fileName = event.target.files[0].name;
    }
  }

  uploadFiles() {
    if (!this.fileContent) {
      this.showToast("Error!", "error", "No file selected.");
      return;
    }

    const fileCon = this.fileContent;
    this.filesize = fileCon.size;
    if (fileCon.size > MAX_FILE_SIZE) {
      this.showToast(
        "Error!",
        "error",
        "File size exceeded the upload size limit."
      );
      return;
    }

    const reader = new FileReader();
    reader.onload = () => {
      const fileContents = reader.result.split("base64,")[1];
      this.upload(fileCon, fileContents);
    };
    reader.readAsDataURL(fileCon);
  }

  upload(file, fileContents) {
    this.showSpinner = true;
    let fromIndex = 0;
    let toIndex = Math.min(fileContents.length, fromIndex + CHUNK_SIZE);
    this.uploadChunk(file, fileContents, fromIndex, toIndex, "");
  }

  uploadChunk(file, fileContents, fromIndex, toIndex, cvId) {
    const chunk = fileContents.substring(fromIndex, toIndex);
    uploadChunkedFile({
      recordId: this.recordId,
      fileName: file.name,
      fileContent: encodeURIComponent(chunk),
      contentVersionId: cvId
    })
      .then((result) => {
        cvId = result;
        fromIndex = toIndex;
        toIndex = Math.min(fileContents.length, fromIndex + CHUNK_SIZE);
        this.uploadedsize = toIndex;
        if (fromIndex < fileContents.length) {
          this.uploadChunk(file, fileContents, fromIndex, toIndex, cvId);
        } else {
          this.showSpinner = false;
          this.fileContent = "";
          this.fileName = "";
          this.showToast("Success", "success", "Files Uploaded successfully.");
        }
      })
      .catch((error) => {
        this.showToast(
          "Error",
          "error",
          error.body.message || "An error occurred"
        );
        this.removeReceiptImage();
        this.showSpinner = false;
      });
  }

  get progressBar() {
    if (this.filesize > 0 && this.uploadedsize > 0) {
      const uploadedPercent = (this.uploadedsize / this.filesize) * 100;
      return `width: ${Math.min(uploadedPercent, 100)}% !important`;
    }
    return "width: 0% !important"; // Default to 0% if no file is being uploaded
  }

  removeReceiptImage() {
    this.fileName = "";
    this.fileContent = "";
  }

  showToast(title, variant, message) {
    const event = new ShowToastEvent({
      title,
      variant,
      message
    });
    this.dispatchEvent(event);
  }
}