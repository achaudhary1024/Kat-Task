Public class TransactionItemTriggerHandler{
    public static void CreateTransItemOnServer(List<TransactionItem__c> items){
        Map<Id, List<TransactionItem__c>> transactionItemsMap = new Map<Id, List<TransactionItem__c>>();
        for(TransactionItem__c item : items){
            if(transactionItemsMap.containsKey(item.Transaction__c)){
            	transactionItemsMap.get(item.Transaction__c).add(item);
            }else{
                transactionItemsMap.put(item.Transaction__c, new List<TransactionItem__c>{item});
            }
        }        
        List<Transaction__c> transactions = [Select Id, Transaction_Count__c, Total_Cost__c, Total_Discount__c, CreatedDate from Transaction__c where Id IN : transactionItemsMap.keySet()];
        List<TItemWrap> TItemObjs = new List<TItemWrap>();
        List<TWrap> TWrapObjs = new List<TWrap>();
        for(Transaction__c trans : transactions){
            if(trans.Transaction_Count__c == transactionItemsMap.get(trans.Id).size()){                
				TItemObjs.addAll(getTIWrapperInstance(transactionItemsMap.get(trans.Id)));
                TWrapObjs.add(new TWrap(trans));
			}
        }
        if(TItemObjs.size() > 0 ){
            System.enqueueJob(new TransactionItemCallout(TItemObjs, TWrapObjs));
        }        
    }
    public static List<tItemWrap> getTIWrapperInstance(List<TransactionItem__c> tItems){
		List<TItemWrap> TItemWrapObjs = new List<TItemWrap>();
        for(TransactionItem__c tItem : tItems){
            TItemWrapObjs.add(new TItemWrap(tItem));
        }
        return TItemWrapObjs;
    }
    
    public class TItemWrap{
        public keyWrap keys;
        public valueWrap values;
        public tItemWrap(TransactionItem__c tItem){
            keys = new keyWrap(tItem.Transaction__c);
            values = new valueWrap(tItem.Item_Cost__c, tItem.Name);
        }
    }
    public class keyWrap{
        public String TransactionItemID;
        public keyWrap(String key){
            TransactionItemID = key;
        }
    }
    public class valueWrap{
        public Decimal ItemCost;
		public String ItemName;
        public valueWrap(Decimal cost, String iName){
            ItemCost = cost;
            ItemName = iName;
        }
    }
    public class TWrap{
        public TkeyWrap keys;
        public TValueWrap values;
        public TWrap(Transaction__c trans){
            system.debug(trans.createdDate);
            keys = new TkeyWrap(trans.Id);            
            values = new TvalueWrap(trans.Total_Cost__c, trans.Total_Discount__c, Integer.valueOf(trans.Transaction_Count__c), trans.CreatedDate.format('yyyy-MM-dd'));
        }
    }
    public class TkeyWrap{
        public String TransactionID;
        public TkeyWrap(String key){
            TransactionID = key;
        }
    }
    public class TvalueWrap{
        public Decimal TotalCost;
		public Decimal TotalDiscount;
        public Integer TotalCount;
        public String TransactionDate;
        public TvalueWrap(Decimal cost, Decimal discount, Integer count, String tDate){
            TotalCost = cost;
            TotalDiscount = discount;
            TotalCount = count;
            TransactionDate = tDate;
        }
    }
}