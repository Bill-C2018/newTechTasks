public with sharing class UpSell {
    public UpSell() {    }

    

     Opportunity createOpportunity(String Name, String upsellTo) {
        Opportunity o = new Opportunity();
        String title =  Name + ' Upsell - ' + upsellTo;
        o.Name = title;
        Date t = system.today();
        o.CloseDate = t.addMonths(1);
        o.StageName = 'Prospecting';
        return o;
     }

    public void createOpps() {

        for (List<Account> eligable : [SELECT Id, Name, SLA__c FROM Account WHERE SLA__c != 'Platinum']) {
            //Hmmm can we move this outside the outer loop without risking a limit?
            List<Opportunity> opps = new List<Opportunity>();
            for (Account e : eligable) {
                
                switch on (e.SLA__c) {
                    when 'Bronze' { opps.add(createOpportunity(e.Name,'Silver')); }
                    when 'Silver'{  opps.add(createOpportunity(e.Name,'Gold')); }
                    when 'Gold' {   opps.add(createOpportunity(e.Name,'Platnum')); }
                    when else { opps.add(createOpportunity(e.Name,'Bronze')); }

                }
            }

            insert opps;
        }

    }
}
