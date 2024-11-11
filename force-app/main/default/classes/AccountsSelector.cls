public class AccountsSelector extends fflib_SObjectSelector {

    // Implement getSObjectFieldList method to specify the fields to retrieve
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Account.Name,
            Account.Description,
            Account.AnnualRevenue
        };
    }

    // Implement getSObjectType method to return the sObject type
    public Schema.SObjectType getSObjectType() {
		System.debug('Account.sObjectType;'+Account.sObjectType);
        return Account.sObjectType;
    }

    // Custom method to retrieve Accounts by Id
    public List<Account> selectById(Set<ID> idSet) {
        return (List<Account>) selectSObjectsById(idSet);
    }
}