import { LightningElement } from 'lwc';
import uploadFile from '@salesforce/apex/GoogleDriveUploadController.uploadFile';

export default class FileUpload extends LightningElement {
    fileData;
    isUploadDisabled = true;

    handleFileChange(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = () => {
                this.fileData = {
                    filename: file.name,
                    filetype: file.type,
                    base64: reader.result.split(',')[1] // Stripping the base64 header
                };
                this.isUploadDisabled = false;
            };
            reader.readAsDataURL(file);
        }
    }

    handleUpload() {
        if (this.fileData) {
            uploadFile({
                fileName: this.fileData.filename,
                fileType: this.fileData.filetype,
                base64Data: this.fileData.base64
            })
            .then(result => {
                console.log('File uploaded successfully');
            })
            .catch(error => {
                console.error('Error uploading file:', error);
            });
        }
    }
}