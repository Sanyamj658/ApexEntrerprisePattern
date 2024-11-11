/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-13-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class CurrecyConvertorController {
    @AuraEnabled(cacheable=true)
    public static Decimal ConvertAmount(String SourceCurrency, String targetCurrency, String Amount) {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        String apiKey = 'OtSlu4FpO2X0aR3Kt7KBQwmfkJgeXAtt';
        req.setEndpoint('https://api.apilayer.com/fixer/convert?from=' + SourceCurrency + '&to=' + targetCurrency + '&amount=' + Amount);
        req.setMethod('GET');
        req.setHeader('apikey', apiKey);
        res = http.send(req);

        if (res.getStatusCode() == 200) {
            // Parse JSON response
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            Decimal convertedAmount = (Decimal) responseMap.get('result'); // Adjust based on actual response structure
            return convertedAmount;
        } else {
            throw new AuraHandledException('Error from API: ' + res.getBody());
        }
    }
}