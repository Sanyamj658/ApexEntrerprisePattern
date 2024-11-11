public class SubscriptionUtils {

    // Method to fetch subscription data from an external API
    public static Map<String, Object> fetchSubscriptionData(String subscriptionId) {
        String endpoint = 'https://api.example.com/subscriptions/' + subscriptionId; // Replace with your API endpoint
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + 'your_access_token'); // Replace with actual token or authentication method
        
        Http http = new Http();
        HttpResponse response = http.send(request);

        // Parse the response
        if (response.getStatusCode() == 200) {
            try {
                // Parse JSON response
                Map<String, Object> subscriptionData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                return subscriptionData;
            } catch (Exception e) {
                System.debug('Error parsing JSON response: ' + e.getMessage());
                return null;
            }
        } else {
            System.debug('HTTP request failed with status code: ' + response.getStatusCode());
            return null;
        }
    }

    // Method to calculate the prorated amount
    public static Decimal calculateProratedAmount(DateTime billingCycleStart, DateTime billingCycleEnd, Decimal monthlyAmount, DateTime cancellationDate) {
        try {
            // Calculate the total billing period duration in days
            Integer totalDays = billingCycleEnd.date().daysBetween(billingCycleStart.date());
            
            // Calculate the elapsed time in days from the billing cycle start to the cancellation date
            Integer elapsedDays = cancellationDate.date().daysBetween(billingCycleStart.date());

            // Validate the dates
            if (totalDays <= 0 || elapsedDays < 0) {
                throw new IllegalArgumentException('Invalid date parameters for prorated calculation.');
            }
            
            // Calculate the prorated amount
            Decimal proratedAmount = (Decimal.valueOf(elapsedDays) / Decimal.valueOf(totalDays)) * monthlyAmount;

            // Return the prorated amount
            return proratedAmount;
        } catch (Exception e) {
            System.debug('Error calculating prorated amount: ' + e.getMessage());
            return null;
        }
    }

    // Method to process the subscription
    public static void processSubscription(String subscriptionId, DateTime cancellationDate) {
        // Fetch the subscription data
        Map<String, Object> subscriptionData = fetchSubscriptionData(subscriptionId);
        
        // Ensure subscription data exists
        if (subscriptionData == null || subscriptionData.isEmpty()) {
            System.debug('Subscription data not found.');
            return;
        }
        
        // Extract data from the map
        DateTime billingCycleStart = (DateTime)subscriptionData.get('billing_cycle_start'); // Adjust field names as needed
        DateTime billingCycleEnd = (DateTime)subscriptionData.get('billing_cycle_end'); // Adjust field names as needed
        Decimal monthlyAmount = (Decimal)subscriptionData.get('monthly_amount'); // Adjust field names as needed
        
        // Calculate the prorated amount
        Decimal proratedAmount = calculateProratedAmount(
            billingCycleStart, 
            billingCycleEnd, 
            monthlyAmount, 
            cancellationDate
        );
        
        // Debug the prorated amount
        System.debug('Prorated Amount: ' + proratedAmount);
        
        // Example of additional logic after calculation
        // e.g., sending the prorated amount to another system or processing it further
        
        // Example debug statement (mock update operation)
        System.debug('Processed subscription with ID: ' + subscriptionId);
    }
}