/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-19-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

public with sharing class distributedRevenueOnMonthlyBasis {
    public static void distributeMonthlyRevenue(List<Revenue__c> RevenueList){
        List<MonthlyRevenue__c> MonthlyRevenues = new List<MonthlyRevenue__c>();
        for(Revenue__c revenue : RevenueList){
            if(revenue.End_Date__c > revenue.Start_Date__c){

                //calculate total days 
                Integer totalDays = revenue.End_Date__c.daysBetween(revenue.Start_Date__c);

                //calculate the total months
                Integer monthsBetween = revenue.Start_Date__c.monthsBetween(revenue.End_Date__c); 

                Date startDate = revenue.Start_Date__c;

                for(Integer i=0; i<=monthsBetween; i++){ 
                    // calculate the days in a particular month
                    Integer daysInMonth = Date.daysInMonth(revenue.Start_Date__c.year(),revenue.Start_Date__c.month());                  

                    Date firstDayOfNextMonth = startDate.addMonths(1).toStartOfMonth();
                    Date endDate =firstDayOfNextMonth.addDays(-1);

                    if(i==monthsBetween){
                         endDate = revenue.End_Date__c;
                    }
                    MonthlyRevenue__c MonthlyRevenue = new MonthlyRevenue__c();

                    MonthlyRevenue.Start_Date__c = startDate;
                    MonthlyRevenue.End_Date__c = endDate;
                    MonthlyRevenue.Monthly_Qunanity__c = (daysInMonth*revenue.Quantity__c)/totalDays;
                    MonthlyRevenue.Price__c = revenue.Price__c;
                    MonthlyRevenue.Monthly_Amount__c = revenue.Quantity__c*revenue.Price__c;
                    MonthlyRevenue.Revenue__c = revenue.Id;
                    MonthlyRevenues.add(MonthlyRevenue);
                    startDate = endDate.addDays(1);

                }
                
            }
        }
        System.debug(MonthlyRevenues);
        if(!MonthlyRevenues.isEmpty()){
            INSERT MonthlyRevenues;
        }
        
    }
}



/*
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-27-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

/*
public with sharing class BookOrderHelper {
    public static void updateBookOrderStatus(List<Book_Order__c> bookOrders) {
    // Step 1 ---------------------------------------------------------------------------------------------------------------------------------------------
    Set<Id> bookOrderIds = new Set<Id>();
    for (Book_Order__c order : bookOrders) {
        if (order.Status__c == 'Ordered') {
            bookOrderIds.add(order.Id);
        }
    }
    // Step 1  complete --------------------------------------------------------------------------------------------------------       
    if (!bookOrderIds.isEmpty()){
        //Mere pass sari wo books  with quantity  aa gai jo kisi particular book order se related h aur jinka status ORDERED hua h 
        List<Book_Order_Lines__c> orderLines = [SELECT Id, Book__c, Quantity__c, Book_Order__c FROM Book_Order_Lines__c WHERE Book_Order__c IN :bookOrderIds];
		System.debug('order line '+ orderLines);
        // particular book order se related book order line ko store karne k liye map
        Map<Id, List<Book_Order_Lines__c>> orderLineMap = new Map<Id, List<Book_Order_Lines__c>>();
		List<Book_Order_Lines__c> bol = new List<Book_Order_Lines__c>();
        
        for (Book_Order_Lines__c line : orderLines) {
			System.debug('lines--->'+ line);
            if (!orderLineMap.containsKey(line.Book_Order__c)) {
				System.debug('line.Book_Order__c--->'+line.Book_Order__c);
				bol.add(line);
                orderLineMap.put(line.Book_Order__c,bol);
            }
            else{
				 orderLineMap.get(line.Book_Order__c).add(line);
            }
           
        }

	System.debug('orderLineMap---->'+orderLineMap);
        // we get the  book and quantity on Particular warehouse
        List<Warehouse__c> warehouses = [SELECT Id, Name, (SELECT Id, Book__c, Quantity__c FROM Book_In_Warehouses__r) FROM Warehouse__c];
		List<Book_Order__c> bookOrderToBeUpdated = new LIST<Book_Order__c>();
        for (Book_Order__c order : bookOrders) {
            
            if (bookOrderIds.contains(order.Id)) {
                Map<Id, Decimal> bookQuantityMap = new Map<Id, Decimal>();
                // Map create kiya for particular book ki  quantity ko store karne ke liye  
                for (Book_Order_Lines__c line : orderLineMap.get(order.Id)) {
                    bookQuantityMap.put(line.Book__c, line.Quantity__c);
                }

                Boolean allBooksAvailable = true;
                Warehouse__c bestWarehouse = null;

                // for that find the best warehouse 
                for (Warehouse__c warehouse : warehouses) {
                    Boolean allBooksAvailableInWarehouse = true;
                    
                    //checked the all book order are available in this warehouse 
                    for (Book_In_Warehouse__c bookInWarehouse : warehouse.Book_In_Warehouses__r) {
                        if (bookQuantityMap.containsKey(bookInWarehouse.Book__c) || bookInWarehouse.Quantity__c < bookQuantityMap.get(bookInWarehouse.Book__c)) {
                            allBooksAvailableInWarehouse = false;
                            break;
                        }
                    }
                    
                    // agar sabhi book ek he warehouse se mili to usse best warehouse kardo
                    if (allBooksAvailableInWarehouse) {
                        bestWarehouse = warehouse;
                        break;
                    }
                }

                if (bestWarehouse != null) {
                    //quantity ko update kardo aur status ko uppdate kar diya as a Shipped
                    for (Book_Order_Lines__c line : orderLineMap.get(order.Id)) {
                        for (Book_In_Warehouse__c bookInWarehouse : bestWarehouse.Book_In_Warehouses__r) {
                            if (bookInWarehouse.Book__c == line.Book__c) {
                                bookInWarehouse.Quantity__c -= line.Quantity__c;
                               
                                break;
                            }
                        }
                    }
                    order.Status__c = 'Shipped';
					bookOrderToBeUpdated.add(order);
                    //update bestWarehouse;
                  
                } else {
                   // otherrwise status is backordered
                    order.Status__c = 'Backordered';
                    bookOrderToBeUpdated.add(order);
                }
            }
        }      
		UPDATE bookOrderToBeUpdated;
    }
}
}

*/