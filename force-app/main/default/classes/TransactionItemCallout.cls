public class TransactionItemCallout implements Queueable, Database.AllowsCallouts{
    public List<TransactionItemTriggerHandler.TItemWrap> tIwrapper;
    public List<TransactionItemTriggerHandler.TWrap> twrapper;
    
    public TransactionItemCallout(List<TransactionItemTriggerHandler.TItemWrap> transItemWrapper, List<TransactionItemTriggerHandler.TWrap> transWrapper){
        tIwrapper = transItemWrapper;
        twrapper = transWrapper;
    }
    public void execute(QueueableContext context) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();  
        req.setMethod('POST');   
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());        
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        req.setBody(JSON.serialize(tIwrapper));
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/TransactionItems/');
		HttpResponse resp = h.send(req);
        if (resp.getStatusCode() == 200 && !Test.isRunningTest()) {            
			  System.enqueueJob(new TransactionCallout(twrapper));
        }
    }
}