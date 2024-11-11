public class NewCaseListController {
    public List<Case> getNewCases(){
		List<Case> caseList = [SELECT ID, CaseNumber FROM case WHERE Status = 'New'];
        return caseList;
    }
}