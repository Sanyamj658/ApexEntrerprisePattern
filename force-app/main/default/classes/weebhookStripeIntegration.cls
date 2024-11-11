@RestResource(urlMapping='/Stripe')
global without sharing class weebhookStripeIntegration {

    @HttpPost
    global static String doPost() {
        // Initialize response
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type', 'application/json');

        // Get request body as a string
        String requestBody = RestContext.request.requestBody.toString();
        System.debug('Request Body: ' + requestBody);

        // Parse the JSON request body
        Map<String, Object> jsonData;
        String amount = '0'; // Default value
		Decimal prorateAmount = 0;

        try {
            jsonData = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
            // Log the entire JSON object
            System.debug('Parsed JSON Data: ' + jsonData);

            Map<String, Object> dataObject = (Map<String, Object>) jsonData.get('data');
            Map<String, Object> invoiceItem = (Map<String, Object>) dataObject.get('object');
            if (invoiceItem != null) {
                Object amountObj = invoiceItem.get('amount');
                if (amountObj != null) {
                    amount = String.valueOf(amountObj);
					
                }
            }
            // Log the extracted amount
            System.debug('Extracted Amount: ' + amount);
		    prorateAmount = Decimal.valueOf(amount);
			System.debug('Prorate Amount is: '+-(prorateAmount));

        } catch (Exception e) {
            // Log any errors encountered during JSON parsing
            System.debug('Error parsing JSON: ' + e.getMessage());
        }

        // Set the response body with the extracted amount
        response.responseBody = Blob.valueOf('{ "success": true, "amount": "' + amount + '" }');
        response.statusCode = 200; // Set the status code to 200 OK

        // Return the response
        return response.responseBody.toString();
    }

    @HttpGet
    global static void doGet(){
        system.debug('Received GET request');
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response; 
        system.debug('Request: ' + req);
        system.debug('Response: ' + res);

        // Optionally, you can also debug any request parameters or headers
        System.debug('Request Params: ' + req.requestURI);
        System.debug('Request Headers: ' + req.headers);
    }
}