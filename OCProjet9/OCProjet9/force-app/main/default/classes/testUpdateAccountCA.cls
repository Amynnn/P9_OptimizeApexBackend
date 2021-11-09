@isTest
private class testUpdateAccountCA {
    @isTest static void test() {
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert pd1;

        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

        Order newOrder = new Order(
            AccountId = acc1.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Pricebook2Id=Test.getStandardPricebookId(),
            ShipmentCost__c = 0,
            NetAmount__c = 0
        );
        insert newOrder;
        update acc1;

        // system assert order net amount = 1020
        //System.assertEquals('Test Account 1', acc1.Name);

        OrderItem oi1 = new OrderItem (OrderId = newOrder.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
        insert oi1;
        OrderItem oi2 = new OrderItem (OrderId = newOrder.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
        insert oi2;  
        
        //newOrder.Status = 'Ordered'; 
        //update newOrder;
        
        newOrder = [SELECT Name, TotalAmount FROM Order WHERE Id = :newOrder.Id LIMIT 1];
        //Order updatedOrder = [SELECT Name, TotalAmount FROM Order WHERE Id = :newOrder.Id LIMIT 1];
            
        System.assertEquals(21500, newOrder.TotalAmount);

    }  
}