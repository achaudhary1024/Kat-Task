@isTest
public class TransactionItemTriggerHandlerTest {
    public static testMethod void testFeature(){
        List<Transaction__c> tansactionRecs = new List<Transaction__c>();
        tansactionRecs.add(new Transaction__c(Name = 'T1', Total_Cost__c = 500, Total_Discount__c = 10, Transaction_Count__c = 1));
        tansactionRecs.add(new Transaction__c(Name = 'T2', Total_Cost__c = 600, Total_Discount__c = 20, Transaction_Count__c = 2));
        tansactionRecs.add(new Transaction__c(Name = 'T3', Total_Cost__c = 700, Total_Discount__c = 30, Transaction_Count__c = 3));
        Insert tansactionRecs;
        
		Map<String, String> tMap = new Map<String, String>();
        tMap.put(tansactionRecs[0].Name, tansactionRecs[0].Id);
        tMap.put(tansactionRecs[1].Name, tansactionRecs[1].Id);
        tMap.put(tansactionRecs[2].Name, tansactionRecs[2].Id);
        
        List<TransactionItem__c> tansactionItemRecs = new List<TransactionItem__c>();
        tansactionItemRecs.add(new TransactionItem__c(Name = 'T1-TI1', Transaction__c = tMap.get('T1'), Item_Cost__c = 10));
        
        tansactionItemRecs.add(new TransactionItem__c(Name = 'T2-TI1', Transaction__c = tMap.get('T2'), Item_Cost__c = 20));
        tansactionItemRecs.add(new TransactionItem__c(Name = 'T2-TI2', Transaction__c = tMap.get('T2'), Item_Cost__c = 30));
        
        tansactionItemRecs.add(new TransactionItem__c(Name = 'T3-TI1', Transaction__c = tMap.get('T3'), Item_Cost__c = 40));
        tansactionItemRecs.add(new TransactionItem__c(Name = 'T3-TI2', Transaction__c = tMap.get('T3'), Item_Cost__c = 50));
        tansactionItemRecs.add(new TransactionItem__c(Name = 'T3-TI3', Transaction__c = tMap.get('T3'), Item_Cost__c = 60));
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Insert tansactionItemRecs;
                
        List<TransactionItemTriggerHandler.TWrap> TWrapObjs = new List<TransactionItemTriggerHandler.TWrap>();
        for(Transaction__c t : [Select Id, Transaction_Count__c, Total_Cost__c, Total_Discount__c, CreatedDate from Transaction__c]){            
            TWrapObjs.add(new TransactionItemTriggerHandler.TWrap(t));
        }        
        System.enqueueJob(new TransactionCallout(TWrapObjs));        
    }
}