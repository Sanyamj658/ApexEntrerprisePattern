public class UnitOfWork {
    private List<SObject> newRecords = new List<SObject>();

    // Register a new record to be processed
    public void registerNew(SObject record) {
        newRecords.add(record);
    }

    // Commit all registered records to the database
    public void commitWork() {
        if (!newRecords.isEmpty()) {
            insert newRecords; // Bulk insert to optimize performance
        }
    }
}