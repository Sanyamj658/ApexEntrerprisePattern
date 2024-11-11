public class SubscriptionProrationCalculator {

    // Example usage
    public static void exampleUsage() {
        // Example values
        Date subscriptionStartDate = Date.newInstance(2024, 8, 28); // Start date of the subscription
        Date subscriptionEndDate = Date.newInstance(2024, 9, 27); // End date of the subscription
        Decimal totalAmount = 10600; // Total amount in cents ($106.00)
        Date cancellationDate = Date.newInstance(2024, 8, 29); // Cancellation date

        // Calculate prorated refund amount
        Decimal refundAmount = calculateProratedAmount(subscriptionStartDate, subscriptionEndDate, totalAmount, cancellationDate);

        // Print the result
        System.debug('Prorated Refund Amount ===============: $' + (refundAmount / 100)); // Convert to dollars for display
    }

    // Method to calculate prorated refund amount
    public static Decimal calculateProratedAmount(Date subscriptionStartDate, Date subscriptionEndDate, Decimal totalAmount, Date cancellationDate) {
        // Convert dates to DateTime objects for accurate calculations
        DateTime startDateTime = DateTime.newInstance(subscriptionStartDate.year(), subscriptionStartDate.month(), subscriptionStartDate.day());
        DateTime endDateTime = DateTime.newInstance(subscriptionEndDate.year(), subscriptionEndDate.month(), subscriptionEndDate.day());
        DateTime cancelDateTime = DateTime.newInstance(cancellationDate.year(), cancellationDate.month(), cancellationDate.day());

        // Ensure dates are in correct order
        if (cancelDateTime < startDateTime || cancelDateTime > endDateTime) {
            throw new IllegalArgumentException('Cancellation date must be between subscription start and end dates.');
        }

        // Calculate the total subscription period in days
        Long totalDays = (endDateTime.getTime() - startDateTime.getTime()) / (1000 * 60 * 60 * 24);

        // Calculate the number of days the subscription was active
        Long activeDays = (cancelDateTime.getTime() - startDateTime.getTime()) / (1000 * 60 * 60 * 24);

        // Ensure activeDays does not exceed totalDays
        activeDays = Math.min(activeDays, totalDays);

        // Calculate the prorated amount
        Decimal dailyRate = totalAmount / totalDays;
        Decimal proratedAmount = dailyRate * activeDays;

        // Calculate the refund amount as the difference between the total amount and the prorated amount
        Decimal refundAmount = totalAmount - proratedAmount;

        // Round the refund amount to 2 decimal places
        refundAmount = refundAmount.setScale(0, RoundingMode.HALF_UP);

        return refundAmount;
    }
}