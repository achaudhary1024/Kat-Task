trigger TransactionItemTrigger on TransactionItem__c (after Insert) {
    if(trigger.isInsert && trigger.isAfter){
        TransactionItemTriggerHandler.CreateTransItemOnServer(trigger.new);
    }
}