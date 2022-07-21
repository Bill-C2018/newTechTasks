public with sharing class TT2NewAccountTriggerHandler {
    public TT2NewAccountTriggerHandler() {  }

    private Campaign genGenericCampaign() {
        Campaign c = new Campaign(Name = 'Webinar');
        c.Type = 'Webinar';
        c.BudgetedCost = 0.01;
        c.StartDate = system.today() + 14;
        c.EndDate = c.StartDate;
        return c;
    }

    public Opportunity addOpportunity(Account a) {
        Opportunity o = new Opportunity(Name = a.Name);
        o.AccountId = a.Id;
        o.StageName = 'Prospecting';
        o.CloseDate = system.today() + 14;
        return o;
    }



    public void handleAfterInsert( Map<Id,Account> newAccs)  {

        system.debug('After insert : ' + newAccs);
        List<Campaign> campaigns = new List<Campaign>();
        Map<Id,Opportunity> opportunities = new Map<Id,Opportunity>();

        for(ID id: newAccs.keySet()) {
            campaigns.add(genGenericCampaign());
            opportunities.put(id,addOpportunity(newAccs.get(id)));
        }

        insert campaigns;

        Integer index = 0;
        List<Opportunity> newOpps = new List<Opportunity>();
        for(ID id: newAccs.keySet()) {
            Opportunity o = opportunities.get(id);
            o.CampaignId = campaigns.get(index).Id;
            campaigns.get(index).BudgetedCost = newAccs.get(id).AnnualRevenue * .01;
            campaigns.get(index).Name = 'Webinar for ' + newAccs.get(id).Name;
            newOpps.add(o);
            index++;
        }

        update campaigns;
        insert newOpps;
       
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

        system.debug('Handle delete ');
        Set<Id> accId = new Set<Id>();
        for(Account a: accs) {
            accId.add(a.Id);
        }
        List<Opportunity> openOpps = [SELECT AccountId FROM Opportunity WHERE (AccountId IN :accId) AND (NOT StageName LIKE 'CLOSED%')];
        system.debug('Opps found ' + openOpps);
        Set<Id> oSet = new Set<Id>();
        for(Opportunity o: openOpps) {
            oSet.add(o.AccountId);
        }
        system.debug('opps ids ' + oSet);
        for(Account a: accs) {
            system.debug('Checking ' + a.Id);
            if(oSet.contains(a.Id)) {
                a.addError('This Account has Open Oportunities');
            }
        }
        
    }
}
