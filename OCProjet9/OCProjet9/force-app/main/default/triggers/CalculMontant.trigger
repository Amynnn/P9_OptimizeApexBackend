trigger CalculMontant on Order (before update) {
	
	for (Order newOrder : Trigger.new) {

		//Order newOrder 		= trigger.new[0];

		// if montant = null alors = 0

		newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
	}
}