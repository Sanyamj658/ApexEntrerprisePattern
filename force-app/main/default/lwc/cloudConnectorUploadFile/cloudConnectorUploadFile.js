// // import { LightningElement, track, api } from 'lwc';
// // import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// // export default class CloudConnectorUploadFile extends LightningElement {
// //     @api recordId;  // To use this component with a specific record, pass the recordId from the parent component
// //     @track uploadedFiles = [];

// //     handleUploadFinished(event) {
// //         const uploadedFiles = event.detail.files;
// //         this.uploadedFiles = uploadedFiles.map(file => {
// //             return {
// //                 fileName: file.name,
// //                 documentId: file.documentId,
// //                 fileUrl: file.contentDocumentId ? `/sfc/servlet.shepherd/document/download/${file.documentId}` : ''
// //             };
// //         });
// //         this.showToast('Success', 'File uploaded successfully!', 'success');
// //     }

// //     showToast(title, message, variant) {
// //         const event = new ShowToastEvent({
// //             title: title,
// //             message: message,
// //             variant: variant
// //         });
// //         this.dispatchEvent(event);
// //     }
// // }import { LightningElement } from 'lwc';
// import uploadFile from "@salesforce/apex/CloudConnectorUploadFile.uploadFile";
// import { ShowToastEvent } from "lightning/platformShowToastEvent";
// export default class CloudConnectorUploadFile extends LightningElement {
//   fileName;
//   fileInformation;

//   handleFileUpload(event) {
//     let selectedFile = event.target.files[0];
//     this.fileName = selectedFile.name;
//     let reader = new FileReader();
//     reader.onload = () => {
//       let fileContent = reader.result.split(",")[1];
//       this.fileInformation = {
//         fileName: selectedFile.name,
//         fileContent: fileContent
//       };
//     };
//     reader.readAsDataURL(selectedFile);
//   }

//   submitFile() {
//     let fileName = this.fileInformation.fileName;
//     let fileContent = this.fileInformation.fileContent;
//     console.log("File Name is", fileName);

//     uploadFile({
//       filename: fileName,
//       base64Content: encodeURIComponent(fileContent)
//     }).then((result) => {
//       this.fileName = null;
//       const toastEvent = new ShowToastEvent({
//         title: "File Uploaded",
//         message: "File Uploaded Successfully!!!",
//         variant: "success"
//       });
//       this.dispatchEvent(toastEvent);
//     });
//   }
// }

import { LightningElement } from "lwc";
import uploadFile from "@salesforce/apex/CloudConnectorUploadFile.uploadFile";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
export default class CloudConnectorUploadFile extends LightningElement {
  fileName;
  fileInformation;

  handleFileUpload(event) {
    let selectedFile = event.target.files[0];
    this.fileName = selectedFile.name;
    let reader = new FileReader();
    reader.onload = () => {
      let fileContent = reader.result.split(",")[1];
      this.fileInformation = {
        fileName: selectedFile.name,
        fileContent: fileContent
      };
    };
    reader.readAsDataURL(selectedFile);
  }

  submitFile() {
    let fileName = this.fileInformation.fileName;
    let fileContent = this.fileInformation.fileContent;
    console.log("File Name is", fileName);

    uploadFile({
      filename: fileName,
      base64Content: encodeURIComponent(fileContent)
    }).then((result) => {
      this.fileName = null;
      const toastEvent = new ShowToastEvent({
        title: "File Uploaded",
        message: "File Uploaded Successfully!!!",
        variant: "success"
      });
      this.dispatchEvent(toastEvent);
    });
  }
}