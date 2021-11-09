global class UpdateAllAccounts implements Database.Batchable<sObject>{
    
   global Database.QueryLocator start(Database.BatchableContext info){ 
       //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
       return Database.getQueryLocator('SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = \'Ordered\')');

   }
    
   global void execute(Database.BatchableContext info, List<Account> scope){
       //Set<Id> setAccountIds = (new Map<Id,SObject>(scope)).keySet();
       //AP01Account.updateChiffreAffaire(setAccountIds);
       for(Account myAccount : scope){
        myAccount.Chiffre_d_affaire__c = 0;
        for(Order order : myAccount.Orders){
            myAccount.Chiffre_d_affaire__c += order.TotalAmount;
        }
    }
    update scope;
}    
//--
// créer test account + 2 orders, puis assert account CA update
// créer test account 100 orders
    
   global void finish(Database.BatchableContext info){     
       
   } 
}