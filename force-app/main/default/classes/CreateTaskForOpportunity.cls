public class CreateTaskForOpportunity implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([Select Id, owner.isActive, OwnerId From Opportunity]);
    }
    public void execute(Database.BatchableContext bc, List<Opportunity> opportunities){
        List<Task> taskList = new list<Task>();
        user systemAdmin = [SELECT Id FROM User WHERE profile.Name ='System Administrator' AND isActive = TRUE Limit 1];
        for(opportunity opportunityObject : opportunities){
            Task taskNew = new task(Subject = 'Opportunity Assign', WhatId = opportunityObject.Id, Priority = 'Normal');
            if(opportunityObject.owner.isActive){ 
                taskNew.OwnerId = opportunityObject.OwnerId;   
            }
            else{
                //  if any of the Owner/User is inactive then assign the task to any user with a profile System Administrator              
                taskNew.OwnerId = systemAdmin.Id;        
            }
            taskList.add(taskNew); 
        }
        if(!taskList.isEmpty()){
            try{
                insert taskList;
            }
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
            
        } 
    }
    public void finish(Database.BatchableContext bc){}
}