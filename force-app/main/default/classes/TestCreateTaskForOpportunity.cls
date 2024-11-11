@istest
public class TestCreateTaskForOpportunity {
    @testSetup 
    static void setup()
    {
        profile checkprofile = [Select Id From profile where Name ='System Administrator' Limit 1];
        List<User> userList = new List<User>();
        
        //CREATE 2 USER FOR  Active or NonActive
        User user1 = new User(ProfileId = checkprofile.Id,Username ='Sanyam646@gmail.com',Alias = 'batman',
                              Email='bruce.wayne@wayneenterprises.com',EmailEncodingKey='UTF-8',Firstname='Bruce',
                              Lastname='Wayne',LanguageLocaleKey='en_US',LocaleSidKey='en_US',TimeZoneSidKey='America/Chicago',IsActive = TRUE);
        User user2 = new User(ProfileId = checkprofile.Id,Username ='Ramesh646@gmail.com',Alias = 'Ramesh',
                              Email='Ramesh.wayne@Rameshenterprises.com',EmailEncodingKey='UTF-8',Firstname='Ramesh',
                              Lastname='Wayne',LanguageLocaleKey='en_US',LocaleSidKey='en_US',TimeZoneSidKey='America/Chicago',IsActive = TRUE);
        userList.add(user2);
        userList.add(user1);
        if(!userList.isEmpty()){
            try{
                insert userList;
            }
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
            
        } 
        
        List<Opportunity> opportunityList = new List<Opportunity>();
        Opportunity testOpportunity1 = new Opportunity(Name = 'opportunity1',CloseDate = Date.today() ,StageName = '--NONE--',OwnerId = user1.id);
       Opportunity testOpportunity2 =new Opportunity(Name = 'Opportunity2',CloseDate = Date.today() ,StageName = '--NONE--',OwnerId = user2.id);
        opportunityList.add(testOpportunity1);
        opportunityList.add(testOpportunity2);
        if(!opportunityList.isEmpty()){
            try{
                insert opportunityList;
            }
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
            
        } 
    }
    //Test for active user
    @istest
    public static void testActiveUserOpportunity(){
        Test.startTest();
        CreateTaskForOpportunity testing = new CreateTaskForOpportunity();
        Database.executeBatch(testing);
        test.stopTest();
        // Assert that tasks are created for active user's opportunity
        Integer activeUserTasks = [SELECT COUNT() FROM Task WHERE WhatId IN (SELECT Id FROM Opportunity WHERE Owner.IsActive = TRUE)];
        Assert.areEqual(2, activeUserTasks, 'Tasks are not created for active user');
        
    List<Task> createdTasks = [SELECT Id, OwnerId , Subject FROM Task];
    User testUser = [SELECT Id FROM User WHERE Username = 'Sanyam646@gmail.com'];
    for(Task task : createdTasks) {
      System.assertEquals(2, createdTasks.size(), 'Tasks should be created');
      System.assertEquals('Opportunity Assign', task.Subject , 'Incorrect subject');
       System.assertEquals(testUser.Id, task.OwnerId, 'Incorrect owner id ');
        
    }
  
        
    }
    //Test for Non Active user 
    @istest
    public static void testNonActiveUserOpportunity(){
        User users = [SELECT FirstName,IsActive FROM User WHERE IsActive=true AND FirstName = 'Ramesh'];
        users.IsActive = false;
        update users;
        Test.startTest();
        CreateTaskForOpportunity testing1 = new CreateTaskForOpportunity();
        Database.executeBatch(testing1);
        test.stopTest();
        Integer nonActiveUserTasks = [SELECT COUNT() FROM Task WHERE WhatId IN (SELECT Id FROM Opportunity WHERE Owner.IsActive = FALSE)];
        Assert.areEqual(1, nonActiveUserTasks, 'Tasks should not be created for non-active user');
    }

}