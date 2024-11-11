/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-25-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class BookOrderHelper {
    public static void updateBookOrderStatus(List<Book_Order__c> bookOrders) {
        Set<Id> bookOrderIds = new Set<Id>();
        List<Book_Order__c> bookOrderToUpdate = new List<Book_Order__c>();
        List<Book_In_Warehouse__c> BookInWarehouses = new List<Book_In_Warehouse__c>();

        //store all the book order ids which status have been updated to ordered.
        for (Book_Order__c order : bookOrders) {
            if (order.Status__c == 'Ordered') {
                bookOrderIds.add(order.Id);
            }
        }

        // Query to retrieve the total quantity of each book for specified book orders, grouped by book and order IDs.
        if (!bookOrderIds.isEmpty()){     
            List<AggregateResult> aggregateResults = [SELECT Book__c, SUM(Quantity__c) Quantity, Book_Order__c
                                                     FROM Book_Order_Lines__c
                                                     WHERE Book_Order__c IN :bookOrderIds
                                                     GROUP BY Book__c, Book_Order__c];

            // Create a list of Book_Order_Lines__c records from the aggregate results, 
            // populating each record with the book ID, total quantity, and book order ID.
            List<Book_Order_Lines__c> bookOrderLines = new List<Book_Order_Lines__c>();
            for (AggregateResult aggregateResult : aggregateResults) {
                Book_Order_Lines__c bookOrderLine = new Book_Order_Lines__c();
                bookOrderLine.Book__c = (Id)aggregateResult.get('Book__c');
                bookOrderLine.Quantity__c = (Decimal)aggregateResult.get('Quantity');
                bookOrderLine.Book_Order__c = (Id)aggregateResult.get('Book_Order__c');

                bookOrderLines.add(bookOrderLine);
            }

            //Store the value in the nested map in this outer map store book Order line Id, and inner store book with quantity  
            Map<Id, Map<Id, Decimal>> bookOrderQuantities = new Map<Id, Map<Id, Decimal>>();
            for (Book_Order_Lines__c line : bookOrderLines) {
                if (!bookOrderQuantities.containsKey(line.Book_Order__c)) {
                    bookOrderQuantities.put(line.Book_Order__c, new Map<Id, Decimal>());
                }
                bookOrderQuantities.get(line.Book_Order__c).put(line.Book__c, line.Quantity__c);
            }

            // All the required book store in the set 
            Set<Id> requiredBooks = new Set<Id>();
            for (Id bookOrderId : bookOrderQuantities.keySet()) {
                requiredBooks.addAll(bookOrderQuantities.get(bookOrderId).keySet());
                // for (Id bookId : bookOrderQuantities.get(bookOrderId).keySet()) {
                //     requiredBooks.add(bookId);
                // }
            } 
            // Get the wareHouse were all the book are available 
            List<Warehouse__c> warehouses = [SELECT Id, Name, (SELECT Id, Book__c, Quantity__c FROM Book_In_Warehouses__r WHERE Book__c IN :requiredBooks)
                                             FROM Warehouse__c];

            Warehouse__c selectedWarehouse = null;
            Boolean allBooksAvailable = false;   
            Id bookOrderId = null;
            
            // for (Warehouse__c warehouse : warehouses) {
            //     Map<Id, Decimal> availableQuantities = new Map<Id, Decimal>  ();
            //     for (Book_In_Warehouse__c bookInWarehouse : warehouse.Book_In_Warehouses__r) {
            //         availableQuantities.put(bookInWarehouse.Book__c, bookInWarehouse.Quantity__c);
            //     }
            // }

            for (Warehouse__c warehouse : warehouses) {
                Map<Id, Decimal> availableQuantities = new Map<Id, Decimal>  ();
                for (Book_In_Warehouse__c bookInWarehouse : warehouse.Book_In_Warehouses__r) {
                    availableQuantities.put(bookInWarehouse.Book__c, bookInWarehouse.Quantity__c);
                }

                bookOrderId = null; 
                Boolean warehouseHasAllBooks = true;
                for (Id orderId : bookOrderQuantities.keySet()) {
                    bookOrderId = orderId;  
                    for (Id bookId : requiredBooks) {
                        if (!availableQuantities.containsKey(bookId) || availableQuantities.get(bookId) < bookOrderQuantities.get(orderId).get(bookId)) {
                            warehouseHasAllBooks = false;
                            break;
                        }
                    }
                    if (!warehouseHasAllBooks) {
                        break;
                    }
                }
                if (warehouseHasAllBooks) { 
                    selectedWarehouse = warehouse;
                    allBooksAvailable = true;
                    break;
                }
            }

            if (allBooksAvailable) {
                for (Id bookId : requiredBooks) {
                    Decimal requiredQuantity = bookOrderQuantities.get(bookOrderId).get(bookId);
                    for (Book_In_Warehouse__c bookInWarehouse : selectedWarehouse.Book_In_Warehouses__r) {
                        if (bookInWarehouse.Book__c == bookId) {
                            Decimal remainingQuantity = bookInWarehouse.Quantity__c - requiredQuantity;
                            bookInWarehouse.Quantity__c = remainingQuantity;
                            BookInWarehouses.add(BookInWarehouse);
                            break;
                        }
                    }
                }
                Book_Order__c bookOrderToUpdates = new Book_Order__c(Id = bookOrderId, Status__c = 'Shipped');
                bookOrderToUpdate.add(bookOrderToUpdates);
            } else {
                Book_Order__c bookOrderToUpdates = new Book_Order__c(Id = bookOrderId, Status__c = 'Backordered');
                bookOrderToUpdate.add(bookOrderToUpdates);
            }
        }
        //update the status
        if(!bookOrderToUpdate.isEmpty()){
            UPDATE bookOrderToUpdate;
        } 
        if(!BookInWarehouses.isEmpty()){
            UPDATE BookInWarehouses;
        }
    }
}
/*

public with sharing class BookOrderHelper {
  public static void updateBookOrderStatus(List<Book_Order__c> bookOrders) {

      Set<Id> bookOrderIds = new Set<Id>();
      List<Book_Order__c> bookOrderToUpdate = new List<Book_Order__c>();
      List<Book_In_Warehouse__c> bookInWarehouses = new List<Book_In_Warehouse__c>();
      try {
          for (Book_Order__c order : bookOrders) {
              if (order.Status__c == 'Ordered') {
                  bookOrderIds.add(order.Id);
              }
          }
          System.debug('bookOrderIds--1'+bookOrderIds);

          if (!bookOrderIds.isEmpty()) {
              List<AggregateResult> aggregateResults = [
                  SELECT Book__c, SUM(Quantity__c) Quantity, Book_Order__c
                  FROM Book_Order_Lines__c
                  WHERE Book_Order__c IN :bookOrderIds
                  GROUP BY Book__c, Book_Order__c
              ];

              List<Book_Order_Lines__c> bookOrderLines = new List<Book_Order_Lines__c>();
              for (AggregateResult aggregateResult : aggregateResults) {
                  Book_Order_Lines__c bookOrderLine = new Book_Order_Lines__c();
                  bookOrderLine.Book__c = (Id) aggregateResult.get('Book__c');
                  bookOrderLine.Quantity__c = (Decimal) aggregateResult.get('Quantity');
                  bookOrderLine.Book_Order__c = (Id) aggregateResult.get('Book_Order__c');
                  bookOrderLines.add(bookOrderLine);
              }
              System.debug('bookOrderLines--2'+bookOrderLines);

              Map<Id, Map<Id, Decimal>> bookOrderQuantities = new Map<Id, Map<Id, Decimal>>();
              for (Book_Order_Lines__c line : bookOrderLines) {
                  if (!bookOrderQuantities.containsKey(line.Book_Order__c)) {
                      bookOrderQuantities.put(line.Book_Order__c, new Map<Id, Decimal>());
                  }
                  bookOrderQuantities.get(line.Book_Order__c).put(line.Book__c, line.Quantity__c);
              }
              System.debug('bookOrderQuantities--3'+bookOrderQuantities);

              Set<Id> requiredBooks = new Set<Id>();
              for (Id bookOrderId : bookOrderQuantities.keySet()) {
                  for (Id bookId : bookOrderQuantities.get(bookOrderId).keySet()) {
                      requiredBooks.add(bookId);
                  }
              }
              System.debug('requiredBooks--4'+requiredBooks);


              List<Warehouse__c> warehouses = [SELECT Id, Name, (SELECT Id, Book__c, Quantity__c FROM Book_In_Warehouses__r WHERE Book__c IN :requiredBooks) FROM Warehouse__c];
              System.debug('warehouses--5'+warehouses);


              Warehouse__c selectedWarehouse = null;
              Boolean allBooksAvailable = false;
              Id bookOrderId = null;
              Map<Id, Decimal> availableQuantities = new Map<Id, Decimal>();

              for (Warehouse__c warehouse : warehouses) {
                  for (Book_In_Warehouse__c bookInWarehouse : warehouse.Book_In_Warehouses__r) {
                      availableQuantities.put(bookInWarehouse.Book__c, bookInWarehouse.Quantity__c);
                  }
              }
              System.debug('availableQuantities--6'+availableQuantities);

              System.debug('before 3 nested loop--7');
              for (Warehouse__c warehouse : warehouses) {
                  bookOrderId = null;
                  Boolean warehouseHasAllBooks = true;
                  for (Id orderId : bookOrderQuantities.keySet()) {
                      bookOrderId = orderId;
                      for (Id bookId : requiredBooks) {
                          if (
                              !availableQuantities.containsKey(bookId) ||
                              availableQuantities.get(bookId) < bookOrderQuantities.get(orderId).get(bookId)
                          ) {
                              warehouseHasAllBooks = false;
                              break;
                          }
                      }
                      if (!warehouseHasAllBooks) {
                          break;
                      }
                  }
                  if (warehouseHasAllBooks) {
                      selectedWarehouse = warehouse;
                      allBooksAvailable = true;
                      break;
                  }
              }

              System.debug('after 3 nested loop--8');


              if (allBooksAvailable) {
                  System.debug('All book Available--8:  '+allBooksAvailable);
                  for (Id bookId : requiredBooks) {
                      Decimal requiredQuantity = bookOrderQuantities.get(bookOrderId).get(bookId);
                      System.debug('requiredQuantity--9:  '+requiredQuantity);
                      for (Book_In_Warehouse__c bookInWarehouse : selectedWarehouse.Book_In_Warehouses__r) {
                          System.debug('for 1 ----> ');
                          if (bookInWarehouse.Book__c == bookId) {
                              System.debug('if 1 ----> ');
                              Decimal remainingQuantity = bookInWarehouse.Quantity__c - requiredQuantity;
                              System.debug('remainingQuantity--10:  '+remainingQuantity);
                              bookInWarehouse.Quantity__c = remainingQuantity;
                              System.debug('bookInWarehouse.Quantity__c--11'+bookInWarehouse.Quantity__c);
                              bookInWarehouses.add(bookInWarehouse);
                              break;
                          }
                          System.debug('if 1 ----<1 ');
                      }
                      System.debug('for 1 ----< ');
                  }
                  Book_Order__c bookOrderToUpdates = new Book_Order__c(Id = bookOrderId, Status__c = 'Shipped');
                  bookOrderToUpdate.add(bookOrderToUpdates);
              } else {
                  Book_Order__c bookOrderToUpdates = new Book_Order__c(Id = bookOrderId, Status__c = 'Backordered');
                  bookOrderToUpdate.add(bookOrderToUpdates);
              }
          }

          if (!bookOrderToUpdate.isEmpty()) {
              update bookOrderToUpdate;
          }
          if (!bookInWarehouses.isEmpty()) {
              update bookInWarehouses;
          }
      }catch (Exception e) {
          System.debug('Exception Occur: ' + e.getMessage());
      }
  }
}
  */