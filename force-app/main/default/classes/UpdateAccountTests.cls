@isTest
public with sharing class UpdateAccountTests {

    @isTest
    public static void testUpdateAccount() {

        List<String> names = testDataFactory.buildNameList(20);
        List<Account> accts = testDataFactory.addAnnualRevenue(
                            testDataFactory.createAccountRecord(names));

        Integer NumberOfMediums = 0;
        for(Account a: Accts) {
            if(a.AnnualRevenue < 800000000  && a.AnnualRevenue > 200000000) {
                NumberOfMediums += 1;
            }
        }

        insert accts;
        UpdateAccount ua = new UpdateAccount();
        ua.updatePriority();
        List<Account> howMany = [SELECT Id FROM Account WHERE Priority__c = 'Medium'];
        system.assertEquals(NumberOfMediums, howMany.size());
        howMany.clear();
        howMany = [SELECT Id FROM Account WHERE Priority__c != null];
        system.assertNotEquals(0, howMany.size());
                           
        
    }

}
