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
        system.debug(a);
        Campaign c = [SELECT Name,BudgetedCost FROM Campaign WHERE Name = 'Rich Company' LIMIT 1];
        system.debug(c);
        Opportunity o = [SELECT Name, AccountId, CampaignId FROM OPPORTUNITY WHERE Name = 'Rich Company' LIMIT 1];
        system.debug(o);
    }
}
