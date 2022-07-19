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
}
