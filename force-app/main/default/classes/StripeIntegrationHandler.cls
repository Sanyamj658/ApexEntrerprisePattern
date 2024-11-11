/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-20-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class StripeIntegrationHandler {
   @AuraEnabled
   public static String getPaymentUrl(){
       String endpoint = 'callout:Stripe_Payment/v1/checkout/sessions';
       String payload = 'cancel_url=https://www.example.com/cancel'
    + '&line_items[0][price_data][currency]=usd'
    + '&line_items[0][price_data][product_data][name]=T-shirt'
    + '&line_items[0][price_data][unit_amount]=200'
    + '&line_items[0][quantity]=2'
    + '&mode=payment'
    + '&payment_method_types[0]=card'
    + '&success_url=https://www.example.com/cancel';

       //Callout the Weather Api
        Http http = new http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(payload);
        HttpResponse res = http.send(req);

        if(res.getStatusCode() == 200){
            Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String checkoutUrl = (String) parsedResponse.get('url');

			System.debug('Parse response ---> '+parsedResponse);
            System.debug('Checkout URL: ' + checkoutUrl);
            return checkoutUrl;
        }
        else{
            return 'Error';
        }
   }
}