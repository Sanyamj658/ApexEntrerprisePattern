/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestVerifyDate{

    @isTest
    static void checkDate(){
        Date d = VerifyDate.CheckDates(system.today(),system.today()+1);
        Date d1 = VerifyDate.CheckDates(system.today(),system.today()+60);
      
    }
}