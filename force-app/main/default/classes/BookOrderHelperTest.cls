@isTest
	public class BookOrderHelperTest {
		@isTest
        Public static void testUpdateBookOrderStatus(){
       
		Book__c Book = new Book__c(Name = 'TEST BOOK');
		INSERT Book;

		Seller__c seller = new Seller__c(Name = 'TEST SELLER');
		INSERT seller;
		
        Warehouse__c wareHouse = new Warehouse__c(Name = 'TEST WAREHOUSE');
		INSERT wareHouse;

		Book_In_Warehouse__c bookInWareHouse = new Book_In_Warehouse__c	(Book__c = BOOK.Id, Quantity__c = 50, Warehouse__c = wareHouse.Id);
		INSERT bookInWareHouse;
		
		List<Book_Order__c> bookOrders = new List<Book_Order__c>();
        Book_Order__c bookOrder = new Book_Order__c(Name = 'TEST BOOK ORDER', status__c = 'New', Seller__c = seller.Id);
		bookOrders.add(bookOrder);
		INSERT bookOrders;

		Book_Order_Lines__c bookOrderLine = new Book_Order_Lines__c(Name = 'TEST BOOK ORDER LINE', Book__c = Book.Id, Book_Order__c = bookOrder.Id, Quantity__c = 20);
		INSERT bookOrderLine;

		Test.startTest();
        //BookOrderHelper.updateBookOrderStatus(bookOrders);
		UPDATE bookOrders;

        Test.stopTest();

        Book_Order__c updatedBookOrder = [SELECT Id, Status__c FROM Book_Order__c WHERE Id =: bookOrder.Id];
		System.assertEquals('Shipped', updatedBookOrder.Status__c, 'Book order status is updated');

		
        Book_In_Warehouse__c updatedBookInWarehouse = [SELECT Id, Quantity__c FROM Book_In_Warehouse__c WHERE Id =: bookInWareHouse.Id];
		System.assertEquals(30, updatedBookInWarehouse.Quantity__c, 'Book quantity is decreased in BookInwarehouse');


        } 
}