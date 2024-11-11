/**
 * @description       : Converts Excel file content to PDF using an external API.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ExcelToPdfConverter {
    // External API endpoint for conversion
    private static final String CONVERTAPI_ENDPOINT = 'https://v2.convertapi.com/convert/xls/to/pdf?Secret=NTmPvprXL5WPQ8ve';

    @AuraEnabled(cacheable=true)
    public static String convertExcelToPdf(String base64ExcelContent, String fileName) {
        String base64PdfContent = '';

        try {
            // Prepare request body
            Map<String, Object> requestBody = new Map<String, Object>();
            List<Map<String, Object>> parameters = new List<Map<String, Object>>();
            Map<String, Object> fileParam = new Map<String, Object>();
            Map<String, Object> fileValue = new Map<String, Object>();

            fileValue.put('Name', fileName);
            fileValue.put('Data', base64ExcelContent);

            fileParam.put('Name', 'File');
            fileParam.put('FileValue', fileValue);

            parameters.add(fileParam);
            requestBody.put('Parameters', parameters);

            // Create HTTP request
            HttpRequest req = new HttpRequest();
            req.setEndpoint(CONVERTAPI_ENDPOINT);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(requestBody));

            // Send HTTP request
            Http http = new Http();
            HttpResponse res = http.send(req);

            // Parse the response
            if (res.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                if (responseMap.containsKey('Files')) {
                    List<Object> filesList = (List<Object>) responseMap.get('Files');
                    if (!filesList.isEmpty()) {
                        Map<String, Object> fileMap = (Map<String, Object>) filesList[0];
                        if (fileMap.containsKey('FileData')) {
                            
                            base64PdfContent = (String) fileMap.get('FileData');
                            System.debug(base64PdfContent);
                        }
                    }
                }
            } else {
                System.debug('ConvertAPI request failed. Status code: ' + res.getStatusCode());
            }

        } catch (Exception ex) {
            System.debug('Error converting Excel to PDF using ConvertAPI: ' + ex.getMessage());
        }
        
        return base64PdfContent;
    }
}