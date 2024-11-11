public class practiceSOQL {
    public static void soql() {
        //List<Opportunity> oppList = [SELECT Id, CloseDate, Amount FROM Opportunity WHERE Amount >= 300 AND Amount <= 600 AND (CloseDate <= :System.today().addDays(90) AND CloseDate >= :System.today())];
        //System.debug(oppList);
        //List<Contact> conList = [SELECT NAME, (SELECT ID, ContactId, NAME FROM OPPORTUNITIES WHERE IsPrivate = TRUE) FROM CONTACT WHERE ID IN (SELECT ContactId FROM Opportunity WHERE IsPrivate = TRUE)];
		//List<Account> accList = [SELECT Id, Name, (SELECT Id, AccountId, StageName FROM OPPORTUNITIES WHERE StageName = 'CloseWon')  FROM Account WHERE AccountId IN:(SELECT StageName, Count(id) cnt FROM Opportunity where cnt>4 and StageName = 'CloseWon') ];
        //List<Account> accList = [SELECT AccountId, Count(Id) FROM Opportunity WHERE StageName = 'CloseWon' GROUP BY AccountId HAVING COUNT(Id) > 4];
        
        
        //Que 2. Find the total number of Opportunities for each Account. 
		List<AggregateResult> acc = [Select AccountId, count(id) From opportunity Group By AccountId];
		//System.debug(acc);

		//Que 3. Retrieve the names of Contacts associated with an Opportunity named “XYZ Opportunity.”
		List<Contact> conList = [SELECT Name FROM Contact WHERE AccountId IN (SELECT AccountId FROM Opportunity WHERE Name = 'XYZ Opportunity')];
        //System.debug(conList);
        
        //Que 4. List all closed Won Opportunities along with their amounts.
        List<Opportunity> oppList = [SELECT StageName, Amount FROM Opportunity WHERE StageName = 'closed Won'];
		//System.debug(oppList);

		//Que 5. Identify the five most recently created Leads.
		List<Lead> LeadList = [SELECT NAME, CreatedDate FROM LEAD ORDER BY CreatedDate DESC LIMIT 5];
        //System.debug(LeadList);
        
        		
        //Que 6. Retrieve Account names and their associated Opportunities where the Opportunity Amount is greater than $50,000.
        //List<Account> accList = [SELECT NAME, Account.Name, Amount FROM Opportunity WHERE AMOUNT>50000];
		//System.debug(accList);
        
        //Que.7 Find the average amount of all closed Won Opportunities.
        List<AggregateResult> opp = [SELECT StageName, AVG(AMOUNT) FROM Opportunity WHERE StageName = 'closed Won' Group By StageName];
        
        //Que 8. List the Opportunities that are due to close in the next 7 days.
        List<Opportunity> oppList1 = [SELECT CloseDate, StageName, NAME FROM Opportunity WHERE CloseDate > :System.today() AND CloseDate < :System.today().addDays(7)];
		//System.debug(oppList1);
        
        //Que 9. Retrieve the names and email addresses of all Contacts associated with Opportunities that are in the “Proposal” stage.
		List<Contact> contactList = [SELECT Name, Email, AccountId FROM Contact WHERE AccountId IN (SELECT AccountId FROM Opportunity WHERE StageName = 'Proposal')];
        
        //Que 10. Find the Account with the maximum number of Opportunities
		List<AggregateResult> accList = [SELECT AccountId, COUNT(Id) totalOpp, MAX(ID) FROM Opportunity GROUP BY AccountId ORDER BY COUNT(Id) DESC LIMIT 1];
        
    }
}