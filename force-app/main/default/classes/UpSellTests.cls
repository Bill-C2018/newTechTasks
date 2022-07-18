@isTest
public with sharing class UpSellTests {
    public UpSellTests() {   }

    @TestSetup
    static void makeData(){
        List<String> slas = new List<String>{'Bronze','Silver','Gold','Platnum'};
        List<Account> newAccounts = new List<Account>();
        for (String s: slas) {
            newAccounts.addAll(testDataFactory.createAccountsWithSla(3, s));
        }

        insert newAccounts;       
    }

    @isTest
    public static void createOppsTest() {
        UpSell u = new UpSell();
        u.createOpps();
        
        List<Opportunity> o = [Select Id FROM Opportunity WHERE Name LIKE  '%Upsell - Silver'];
        system.assertEquals(3, o.size());
        o.clear();
        o = [Select Id FROM Opportunity WHERE Name LIKE  '%Upsell - Platnum'];
        system.assertEquals(3, o.size());
        
    }
}
