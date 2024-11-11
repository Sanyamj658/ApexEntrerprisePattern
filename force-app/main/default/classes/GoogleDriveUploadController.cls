/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class GoogleDriveUploadController {

    @AuraEnabled
    public static void uploadFile(String fileName, String fileType, String base64Data) {
        try {
            String uploadUrl = initiateResumableSession(fileName, fileType);

            Integer chunkSize = 256 * 1024; // 256 KB
            Blob fileBlob = EncodingUtil.base64Decode(base64Data);
            String fileString = EncodingUtil.convertToHex(fileBlob); // Convert Blob to Hex String for slicing

            for (Integer offset = 0; offset < fileString.length(); offset += chunkSize * 2) { // *2 because Hex is double the length of Blob
                String chunkString = fileString.substring(offset, Math.min(offset + chunkSize * 2, fileString.length()));
                Blob chunk = EncodingUtil.convertFromHex(chunkString); // Convert sliced Hex String back to Blob
                Boolean isLastChunk = (offset + chunkSize * 2) >= fileString.length();
                uploadChunk(uploadUrl, chunk, offset / 2, fileBlob.size(), isLastChunk); // offset / 2 to convert Hex length back to Blob length
            }
        } catch(Exception e) {
            // Log the exception and throw a meaningful error message
            System.debug('Error during file upload: ' + e.getMessage());
            throw new AuraHandledException('An error occurred during the file upload. Please try again.');
        }
    }

    private static String initiateResumableSession(String fileName, String fileType) {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:GoogleDrive123/upload/drive/v3/files?uploadType=resumable');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');

            // File metadata
            String body = '{"name": "' + fileName + '", "mimeType": "' + fileType + '"}';
            req.setBody(body);

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                return res.getHeader('Location');
            } else {
                throw new CalloutException('Failed to initiate resumable session: ' + res.getBody());
            }
        } catch (Exception e) {
            // Handle and log errors
            System.debug('Error initiating resumable session: ' + e.getMessage());
            throw new AuraHandledException('Could not initiate the file upload session. Please try again.');
        }
    }

    private static void uploadChunk(String uploadUrl, Blob chunkData, Integer offset, Integer totalSize, Boolean isLastChunk) {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(uploadUrl);
            req.setMethod('PUT');
            req.setHeader('Content-Length', String.valueOf(chunkData.size()));
            req.setHeader('Content-Range', 'bytes ' + offset + '-' + (offset + chunkData.size() - 1) + '/' + totalSize);
            req.setBodyAsBlob(chunkData);

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (isLastChunk && (res.getStatusCode() != 200 && res.getStatusCode() != 201)) {
                throw new CalloutException('Failed to upload the last chunk: ' + res.getBody());
            }
        } catch (Exception e) {
            // Handle and log errors
            System.debug('Error uploading chunk: ' + e.getMessage());
            throw new AuraHandledException('An error occurred during chunk upload. Please try again.');
        }
    }
}