public class QueueableInterfaceDemo1 implements Queueable{
       public void execute(QueueableContext qx){
        system.debug('Iam in a execute method1 - ');
        Contact con = new Contact();
        con.LastName = 'Queueable Class Implementation - ContactDEMO';
        Insert con;
        system.debug('Contact Inserted in == '+con.LastName);
            System.debug('WE HAVE ANOTHER ACCOUNT + ' +con.AccountId);
       }
}