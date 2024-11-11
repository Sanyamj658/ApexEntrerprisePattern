public class QueueableInterfaceDemo implements Queueable{
    
    public void execute(QueueableContext qx){
       system.debug('Iam in a executr method');
        Account acc = new Account();
        acc.Name = 'Queueable Class Account121';
        Insert acc;
        system.debug('Account Inserted in == '+acc.Name);
        ID jobId = system.enqueueJob(new QueueableInterfaceDemo1());
        system.debug('job id of demo1 ->'+jobId);
         System.debug('WE HAVE ACCOUNT  + ' +acc.Id);
       
    }

}