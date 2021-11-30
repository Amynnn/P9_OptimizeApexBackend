trigger UpdateAccountCA on Order (after update) {
    
    set<Id> setAccountIds = new set<Id>();
    
    for(integer i=0; i< trigger.new.size(); i++){
        setAccountIds.add(trigger.new[i].AccountId);
    }
    System.debug(setAccountIds);
    
       AccountService.updateChiffreAffaire(setAccountIds);

        System.debug('Orders: ' + trigger.new.size());
    
}