import { LightningElement, track } from "lwc";
import uploadFileToGoogleDrive from "@salesforce/apex/IntegrationWithGoogleDrive.uploadFileToGoogleDrive";

export default class GoogleDriveIntegration extends LightningElement {
  @track googleDriveLogoUrl = "path/to/google-drive-logo.png"; // Set the path to your logo
  @track uploadStatus;
  selectedFile;

  handleFileChange(event) {
    this.selectedFile = event.target.files[0];
  }

  handleUpload() {
    if (this.selectedFile) {
      const reader = new FileReader();
      reader.onloadend = () => {
        const base64Data = reader.result.split(",")[1];
        uploadFileToGoogleDrive({
          fileName: this.selectedFile.name,
          base64Data: base64Data
        })
          .then((result) => {
            this.uploadStatus = result;
          })
          .catch((error) => {
            this.uploadStatus = "Upload failed: " + error.body.message;
          });
      };
      reader.readAsDataURL(this.selectedFile);
    } else {
      this.uploadStatus = "No file selected";
    }
  }
}