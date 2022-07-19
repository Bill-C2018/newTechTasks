public with sharing class TT2NewAccountTriggerHandler {
    public TT2NewAccountTriggerHandler() {  }

    public Campaign addCampaign(Account a) {
        Campaign c = new Campaign(Name = a.Name);
        c.Type = 'Webinar';
        c.BudgetedCost = 0.01 * a.AnnualRevenue;
        c.StartDate = system.today() + 14;
        c.EndDate = c.StartDate;
        return c;
    }

    public Opportunity addOpportunity(Account a) {
        Opportunity o = new Opportunity(Name = a.Name);
        o.AccountId = a.Id;
        o.StageName = 'Prospecting';
        return o;
    }

    public Map<Id,Account> createAccountMap(List<Account> acc) {
        Map<Id,Account> m = new Map<Id,Account>();
        for (Account a: acc) {
            m.put(a.id,a);
        }
        return m;
    }

    public void handleAfterInsert(List<Account> accs) {
        List<Campaign> c = new List<Campaign>();
        List<Opportunity> ol = new List<Opportunity>();
        Map<Id,Account> m = createAccountMap(accs);
        Map<String, Id> mc = new Map<String,Id>();
        Map<Id,Opportunity> mo = new Map<Id,Opportunity>();

        for(Account a: accs) {
            system.debug('trigger loop ' + a);
            Opportunity opp = addOpportunity(a);            
            mo.put(a.Id, opp);
            Campaign camp = addCampaign(a);
            c.add(camp);
            mc.put(camp.Name,a.Id);
        }

        insert c;
        for (Campaign cc: c) {
            Id AcctId = mc.get(cc.Name);
            Opportunity o = mo.get(AcctId);
            o.CampaignId = cc.Id;
            o.CloseDate = cc.EndDate;
            ol.add(o);

        }

        insert ol;


    }

    public void HandleNewAccountInsert(List<Account> accs) {
        for(Account a: accs) {
            //first prevent poor companies from participating
            if (a.AnnualRevenue == 0 || a.AnnualRevenue == null) {
                a.addError('Poor companies NOT allowed');
            } 

        }








    }

    public void HandleAccountDelete(List<Account> accs) {
        
    }
}
