public class ImperativeDemo {
    @AuraEnabled
    public static List<Cricketer__c> getCountryName(){
		List<Cricketer__c> countryList = [SELECT ID, Coach__c, NAME FROM CRICKETER__C];
		return countryList;
    }

}