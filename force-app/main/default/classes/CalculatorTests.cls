/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 02-27-2024
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest 
public class CalculatorTests {
    @isTest
    public static void testDivideByZero() {
        try {
            Calculator.divide(1, 0);
        }
        catch (Calculator.CalculatorException e) {
            System.assertEquals('You still can\'t divide by zero', e.getMessage());
            
        }
        
    }
}