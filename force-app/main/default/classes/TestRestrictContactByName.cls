@isTest
public class TestRestrictContactByName {
   
    @isTest
    static void RestrictContactByName(){
         Contact con  = new Contact();
         con.LastName = 'INVALIDNAME';
        
        
      Test.startTest();
            try
            {
                insert con;
            }
            catch(Exception ee)
            {
                
            }
        
        Test.stopTest();
        
     
        
    }
}