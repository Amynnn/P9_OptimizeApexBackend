@isTest
private class TestUpdateAccountCA {
    @isTest static void test() {
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert pd1;

        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1,
            IsActive = true
        );
        Insert pbe;
        
        //Create the Order
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
        
        //Create the Order Items
        OrderItem oi1 = new OrderItem (OrderId = newOrder.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 100);
        insert oi1;
        OrderItem oi2 = new OrderItem (OrderId = newOrder.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 200);
        insert oi2;  
        
        newOrder.Status = 'Ordered'; 
        update newOrder;

        //Retrieve the Order and the Account
        newOrder = [SELECT Name, TotalAmount, Status FROM Order WHERE Id =:newOrder.Id LIMIT 1];
        acc1 = [SELECT Name, Chiffre_d_affaire__c FROM Account WHERE Id =:acc1.Id LIMIT 1];
        
        // Test that the trigger correctly updated the CA of the Account
        System.debug('CA du compte: ' + acc1.Chiffre_d_affaire__c);
        System.assertEquals(10*100 + 20*200, acc1.Chiffre_d_affaire__c, 'CA du compte incorrect');        

    }  
}