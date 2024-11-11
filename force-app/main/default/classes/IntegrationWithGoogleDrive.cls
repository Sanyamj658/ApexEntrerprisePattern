public class IntegrationWithGoogleDrive {
    public static void uploadFile() {
        ContentVersion cv = [SELECT Id, Title, VersionData FROM ContentVersion WHERE Id = '0682w00000R6rstAAB'];
        String body = '--foo_bar_baz\r\nContent-Type: application/json; charset=UTF-8\r\n\r\n {\r\n"name": "My Image File"\r\n}\r\n\r\n--foo_bar_baz\r\nContent-Transfer-Encoding: base64\r\nContent-Type: image/jpeg\r\n\r\n' + EncodingUtil.base64Encode(cv.VersionData) + '\r\n--foo_bar_baz--';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:GoogleDrive123/upload/drive/v3/files?uploadType=multipart');
        request.setHeader('Content-Type', 'multipart/related; boundary=foo_bar_baz');
        request.setHeader('Content-Length', Blob.valueOf(body).size() + '');
        request.setMethod('POST');
        request.setBody(body);
        HttpResponse response = new HttpResponse();
        response = http.send(request);
        system.debug('>>>>response body'+response.getBody());
    }
}