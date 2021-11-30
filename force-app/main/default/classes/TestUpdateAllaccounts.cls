@isTest
public class TestUpdateAllaccounts {
    @isTest static void test() {
        
        System.debug('Start TestUpdateAllAccounts...');
        
        // Inserting an account
        
        System.debug('Inserting an account and a product...');
        
        Account acc1 = new Account(Name = 	'Test Account 1');
        Product2 pd1 = new Product2(Name = 	'Chemise Verte longue XYX', Family = 'Chemise');
        
        insert acc1;
        insert pd1;
        
        acc1 	= [SELECT Name, Chiffre_d_affaire__c FROM Account WHERE Id =:acc1.Id LIMIT 1];
        pd1 	= [SELECT Name FROM Product2 WHERE Name = 'Chemise Verte longue XYX' LIMIT 1];
        
        System.assertEquals('Test Account 1', acc1.Name);
        System.debug('Account inserted: ' 	+ acc1.Name);
        System.debug('Account CA: ' 		+ acc1.Chiffre_d_affaire__c);
        
        System.assertEquals('Chemise Verte longue XYX', pd1.Name);
        System.debug('Product inserted: ' + pd1.Name);
        
        // Inserting a contract
        
        System.debug('Inserting a contract...');
        
        Contract contract1 	= new Contract(
            AccountId		= acc1.id, 
            ContractTerm	= 10,
            Name			= 'Acc1 Contract',
            Status			= 'Draft'
        );
        
        insert contract1;
        
        contract1 = [SELECT Name, Status FROM Contract WHERE AccountId =:acc1.Id LIMIT 1];
        
        System.assertEquals('Acc1 Contract', contract1.Name);
        System.debug('Contract inserted: ' + contract1.Name);
        
        // Inserting 400 orders
        
        System.debug('Inserting 100 orders...');
        
        List<Order> orders = new List<Order>();
        
        for (Integer i = 0; i < 400; i++) {
            Order order = new Order(
                AccountId		= acc1.id,
                ContractId		= contract1.id,
                Status			= 'Draft',
                EffectiveDate	= Date.today(),
                Pricebook2Id	= Test.getStandardPricebookId()
            );
            orders.add(order);
        }
        
        insert orders;
        
        orders = [SELECT Name, Status FROM Order WHERE AccountId =:acc1.Id LIMIT 400];
        
        System.assertEquals(400, orders.size());
        System.debug('Orders inserted: ' + orders.size());
        
        // Inserting 400 order items
        
        // 1.Create the PricebookEntry
        PricebookEntry pbe 	= new PricebookEntry(
            Pricebook2Id 	= Test.getStandardPricebookId(),
            Product2Id 		= pd1.Id,
            UnitPrice 		= 1,
            IsActive 		= true
        );
        
        insert pbe;
        
        // 2.Create the 400 Items
        System.debug('Inserting items...');
        
        List<OrderItem> items = new List<OrderItem>();
        OrderItem item;
        
        for (Order order : orders) {
            item = new OrderItem (
                OrderId				= order.Id,
                PricebookEntryId	= pbe.Id,
                Quantity			= 10,
                UnitPrice			= 10
            );
            items.add(item);
        }
        
        insert items;
        
        items = [SELECT OrderId FROM OrderItem WHERE Quantity = 10 LIMIT 400];
        
        System.assertEquals(400, items.size());
        System.debug('Items inserted: ' + items.size());
        
        // Unit Price = 10, Quantity = 10, Number of items = 400; acc1.CA should be 10*10*400 = 40000
        
        contract1.Status 	= 'Ordered';
        
        update contract1;
        
        contract1 			= [SELECT Name, Status FROM Contract WHERE AccountId =:acc1.Id LIMIT 1];
        
        System.assertEquals('Ordered', contract1.Status);
        System.debug('Status of the contract: ' + contract1.Status);
        
        for (Integer i = 0; i < 400; i++) {
            orders[i].Status = 'Ordered';   
        }
        
        update orders;
        
        orders = [SELECT Name, Status FROM Order WHERE AccountId =:acc1.Id LIMIT 400];
        
        System.assertEquals('Ordered', orders[0].Status);
        System.debug('Status of orders: ' + orders[0].Status);
        
        update items;
        
        items = [SELECT OrderId FROM OrderItem WHERE Quantity = 10 LIMIT 400];
        
        update acc1;
        
        acc1 = [SELECT Name, Chiffre_d_affaire__c FROM Account WHERE Id =:acc1.Id LIMIT 1];
        
        update orders;
        
        System.assertEquals(40000, acc1.Chiffre_d_affaire__c);
        System.debug('Account CA: ' + acc1.Chiffre_d_affaire__c);
        
        System.debug('Finish TestUpdateAllAccounts!');
    }   
}