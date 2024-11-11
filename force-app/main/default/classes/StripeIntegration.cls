public class StripeIntegration {

    private static final String STRIPE_SECRET_KEY = 'sk_test_51PTHYZRrdIyRa3YW8cRoJ5MR0dDDaxv7YQLr0bTDHpqHEgbJAGwE85eswyiTdVac6ddcLQYlD4w0MF1537ZSvHMX00Q8OLWONu';

    // Handle Immediate Subscription Cancellation with Refund
    public static void handleImmediateCancellation() {
        String subscriptionId = 'sub_1PsiVmRrdIyRa3YWCnb5Dyac';
        String customerId = 'cus_QkCuO4cIuIaSwB';
        
        // Set proration date to this moment
        Long prorationDate = DateTime.now().getTime() / 1000; // Unix timestamp
        System.debug('ProrationDate: ' + prorationDate);

        // Retrieve the subscription from Stripe
        HttpResponse subResponse = retrieveSubscription(subscriptionId);
        if (subResponse == null || subResponse.getStatusCode() != 200) {
            System.debug('Failed to retrieve subscription: ' + (subResponse != null ? subResponse.getBody() : 'No response'));
            return; // Handle error as needed
        } else {
            System.debug('Subscription retrieved successfully: ' + subResponse.getBody());
        }

        // Preview the upcoming invoice with proration
        HttpResponse invoiceResponse = retrieveUpcomingInvoice(subscriptionId, prorationDate);
        if (invoiceResponse == null || invoiceResponse.getStatusCode() != 200) {
            System.debug('Failed to retrieve upcoming invoice: ' + (invoiceResponse != null ? invoiceResponse.getBody() : 'No response'));
            return; // Handle error as needed
        } else {
            System.debug('Upcoming invoice retrieved successfully: ' + invoiceResponse.getBody());
            String invoiceJson = invoiceResponse.getBody();
            // Pass invoiceJson to your processing method
            handleInvoiceProration(invoiceJson, customerId);
        }

        // Cancel subscription immediately with proration
        HttpResponse cancelResponse = cancelSubscription(subscriptionId);
        if (cancelResponse == null || cancelResponse.getStatusCode() != 200) {
            System.debug('Failed to cancel subscription: ' + (cancelResponse != null ? cancelResponse.getBody() : 'No response'));
        } else {
            System.debug('Subscription cancelled successfully: ' + cancelResponse.getBody());
        }
    }

    // Function to Retrieve a Subscription
    private static HttpResponse retrieveSubscription(String subscriptionId) {
        String endpoint = 'https://api.stripe.com/v1/subscriptions/' + subscriptionId;
        return sendStripeRequest('GET', endpoint, STRIPE_SECRET_KEY);
    }

    // Function to Retrieve Upcoming Invoice with Proration
    private static HttpResponse retrieveUpcomingInvoice(String subscriptionId, Long prorationDate) {
        String endpoint = 'https://api.stripe.com/v1/invoices/upcoming?subscription=' + subscriptionId + '&subscription_proration_date=' + prorationDate;
        return sendStripeRequest('GET', endpoint, STRIPE_SECRET_KEY);
    }
private static void handleInvoiceProration(String invoiceJson, String customerId) {
    // Parse the JSON string to a Map
    Map<String, Object> invoice = (Map<String, Object>) JSON.deserializeUntyped(invoiceJson);

    // Extract line items and ensure proper casting
    List<Object> linesData = (List<Object>) ((Map<String, Object>) invoice.get('lines')).get('data');
    List<Map<String, Object>> lines = new List<Map<String, Object>>();

    // Ensure we only add items that are of type Map<String, Object>
    for (Object lineItem : linesData) {
        if (lineItem instanceof Map<String, Object>) {
            lines.add((Map<String, Object>) lineItem);
        }
    }
    
    // Initialize variables for calculating total refund
    Decimal totalRefundAmount = 0;
    Decimal totalInvoiceAmount = (Decimal) invoice.get('total') / 100; // Stripe returns amount in cents

    // Loop through each line item
    for (Map<String, Object> line : lines) {
        Decimal amount = (Decimal) line.get('amount') / 100; // Convert amount from cents to dollars
        Boolean proration = (Boolean) line.get('proration');

        // Calculate total amount of the invoice
        totalInvoiceAmount += amount;

        // Add up the proration amounts
        if (proration) {
            // This amount needs to be refunded
            totalRefundAmount += amount;
        }
    }

    // Output or store the calculated refund amount
    System.debug('Total Refund Amount: ' + totalRefundAmount);
    System.debug('Total Invoice Amount: ' + totalInvoiceAmount);

    // Create refund if there is a refundable amount
    if (totalRefundAmount > 0) {
        String chargeId = getChargeId(customerId); // Retrieve the charge ID from Stripe
        if (chargeId != null) {
            HttpResponse refundResponse = createRefund(chargeId, totalRefundAmount);
            if (refundResponse == null || refundResponse.getStatusCode() != 200) {
                System.debug('Failed to create refund: ' + (refundResponse != null ? refundResponse.getBody() : 'No response'));
            } else {
                Map<String, Object> refundData = (Map<String, Object>) JSON.deserializeUntyped(refundResponse.getBody());
                Decimal refundedAmount = (Decimal) refundData.get('amount') / 100; // Convert from cents to standard amount
                System.debug('Refund created successfully. Refunded Amount: ' + refundedAmount);
            }
        } else {
            System.debug('Charge ID not found for customer: ' + customerId);
        }
    }
}
// Function to Create a Refund
    private static HttpResponse createRefund(String chargeId, Decimal amount) {
        String endpoint = 'https://api.stripe.com/v1/refunds';
        Map<String, Object> params = new Map<String, Object>{
            'charge' => chargeId,
            'amount' => amount.setScale(0) * 100 // Stripe expects the amount in cents with no decimal
        };
        return sendStripeRequest('POST', endpoint, STRIPE_SECRET_KEY, params);
    }

    // Function to Cancel a Subscription with Proration
    private static HttpResponse cancelSubscription(String subscriptionId) {
        String endpoint = 'https://api.stripe.com/v1/subscriptions/' + subscriptionId;
        Map<String, Object> params = new Map<String, Object>{
            'prorate' => 'true'
        };
        return sendStripeRequest('DELETE', endpoint, STRIPE_SECRET_KEY, params);
    }

    // Function to Retrieve the Most Recent Charge ID for a Customer
    public static String getChargeId(String customerId) {
        String endpoint = 'https://api.stripe.com/v1/charges?customer=' + customerId + '&limit=1';
        HttpResponse response = sendStripeRequest('GET', endpoint, STRIPE_SECRET_KEY);
        
        if (response != null && response.getStatusCode() == 200) {
            Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> charges = (List<Object>) responseBody.get('data');
            if (charges != null && !charges.isEmpty()) {
                Map<String, Object> charge = (Map<String, Object>) charges[0];
                return (String) charge.get('id');
            }
        } else {
            System.debug('Failed to retrieve charges for customer ' + customerId + '. Status Code: ' + response.getStatusCode() + ', Body: ' + response.getBody());
        }
        return null;
    }
// Generic Method to Send HTTP Requests to Stripe
    private static HttpResponse sendStripeRequest(String method, String endpoint, String secretKey, Map<String, Object> params) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(endpoint);
        request.setMethod(method);
        request.setHeader('Authorization', 'Bearer ' + secretKey);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        if (params != null && !params.isEmpty()) {
            String body = '';
            for (String key : params.keySet()) {
                body += key + '=' + EncodingUtil.urlEncode(params.get(key).toString(), 'UTF-8') + '&';
            }
            request.setBody(body.removeEnd('&'));
        }

        try {
            HttpResponse response = http.send(request);
            System.debug('Response from Stripe (' + method + '): ' + response.getBody());
            return response;
        } catch (Exception e) {
            System.debug('HTTP request failed: ' + e.getMessage());
            return null;
        }
    }

    private static HttpResponse sendStripeRequest(String method, String endpoint, String secretKey) {
        return sendStripeRequest(method, endpoint, secretKey, null);
    }
}