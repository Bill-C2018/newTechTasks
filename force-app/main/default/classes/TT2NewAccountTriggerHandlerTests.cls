@isTest
public with sharing class TT2NewAccountTriggerHandlerTests {
    public TT2NewAccountTriggerHandlerTests() {

    }

    @isTest
    public static void TestNoRevenue() {
        Account a = new Account(Name = 'Poor Company');
        Database.SaveResult srList = Database.insert(a, false);
        system.assertNotEquals(true, srList.isSuccess());
    }

    @isTest
    public static void TestValidAccount() {
        Account a = new Account(Name = 'Rich Company', AnnualRevenue = 2000000);
        Database.SaveResult srList = Database.insert(a, false);
        system.assertEquals(true, srList.isSuccess());
        List<Opportunity> o = [SELECT Name, AccountId, CampaignId FROM Opportunity WHERE AccountId=:a.Id ];
        system.assertEquals(1, o.size());
        List<Campaign> c = [SELECT Name, Type, BudgetedCost FROM Campaign WHERE Id=:o.get(0).CampaignId ];
        system.assertEquals(1, c.size());
        system.assertEquals(2000000 *.01, c.get(0).BudgetedCost);
    }

    @isTest
    public static void TestOpenOpp() {
        Account a = new Account(Name = 'Rich Company', AnnualRevenue = 2000000);
        Database.SaveResult srList = Database.insert(a, false);
        system.assertEquals(true, srList.isSuccess());

        try {
            Database.delete(a.Id);
           
        } catch(DMLexception e){
            system.assert(e.getMessage().contains('This Account has Open Oportunities'));
        }   
    }

    @isTest
    public static void TestBatchInsert() {
        Integer count = 300;
        List<Account> a = new List<Account>();
        for (Integer x = 0; x < count; x++) {
            String name = 'Rich Company_' + x;
            Account a2 = new Account(Name = name , AnnualRevenue = 2000000);
            a.add(a2);
        }
        List<Database.SaveResult> srList = Database.insert(a, false);
        for(Database.SaveResult s: srList) {
            system.assertEquals(true, s.isSuccess());
        }
        Set<Id> aSet = new Set<Id>();
        for(Account aa: a) {
            aSet.add(aa.Id);
        }
        List<Opportunity> o = [SELECT Name, AccountId, CampaignId FROM Opportunity WHERE AccountId IN :aSet ];
        system.assertEquals(count, o.size());


    }
}
