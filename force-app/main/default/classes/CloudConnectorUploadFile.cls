/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-02-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
// /**
//  * @description       : 
//  * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
//  * @group             : 
//  * @last modified on  : 08-02-2024
//  * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
// **/
// public class CloudConnectorUploadFile {
    
//     @AuraEnabled
//     public static String uploadFile(
//         String filename, String base64Content
//     ) {
//         ContentVersion objContentVersion = new ContentVersion();
//         base64Content = EncodingUtil.urlDecode(
//             base64Content, 
//             'UTF-8'
//         );
//         objContentVersion.VersionData = EncodingUtil.base64Decode( 
//             base64Content 
//         );
//         objContentVersion.Title = filename;
//         objContentVersion.PathOnClient = filename;
//         try {
            
//             insert objContentVersion;
            
//         } catch( DMLException e ) {
            
//             System.debug(
//                 'Error while uploading the file ' +
//                 e.getMessage()
//             );
//             return e.getMessage();
            
//         }        
//         ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
//         objContentDocumentLink.ContentDocumentId = [
//             SELECT ContentDocumentId 
//             FROM ContentVersion 
//             WHERE Id =: objContentVersion.Id
//         ].ContentDocumentId;
//         objContentDocumentLink.ShareType = 'V';
//         try {
            
//             insert objContentDocumentLink;
            
//         } catch( DMLException e ) {
            
//             System.debug(
//                 'Error while uploading the file ' +
//                 e.getMessage()
//             );
//             return e.getMessage();
            
//         }
        
//         return 'File Uploaded Successfully';
        
//     }
    
// }

 
/* Code by CafeForce || www.cafeforce.com || support@cafeforce.com || Mandatory Header */
 
public with sharing class CloudConnectorUploadFile {

    @AuraEnabled
    public static Id uploadChunkedFile(Id recordId, String fileName, String fileContent, String contentVersionId) {
        try {
            fileContent = EncodingUtil.urlDecode(fileContent, 'UTF-8');
            ContentVersion cvObj;

            if (String.isBlank(contentVersionId)) {
                // Create new ContentVersion
                cvObj = new ContentVersion();
                cvObj.Title = fileName;
                cvObj.VersionData = EncodingUtil.base64Decode(fileContent);
                cvObj.PathOnClient = '/' + fileName;
                cvObj.IsMajorVersion = false;
                insert cvObj;

                Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cvObj.Id].ContentDocumentId;
                ContentDocumentLink cl = new ContentDocumentLink();
                cl.ContentDocumentId = contentDocId;
                cl.LinkedEntityId = recordId;
                cl.ShareType = 'V';
                cl.Visibility = 'AllUsers';
                insert cl;

                contentVersionId = cvObj.Id;
            } else {
                // Append to existing ContentVersion
                cvObj = [SELECT Id, VersionData FROM ContentVersion WHERE Id = :contentVersionId];
                String existingFileContent = EncodingUtil.base64Encode(cvObj.VersionData);
                cvObj.VersionData = EncodingUtil.base64Decode(existingFileContent + fileContent);
                update cvObj;
            }

            return contentVersionId;
        } catch (Exception ex) {
            throw new AuraHandledException('Error in file upload: ' + ex.getMessage());
        }
    }
}