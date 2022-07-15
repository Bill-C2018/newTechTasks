public with sharing class AccountUtils {
   
    public AccountUtils() {  }

    public List<Id> createAccs(List<String> names) {

        List<Account> newAccounts = new List<Account>();
        List<Id> newIds = new List<Id>();

        for (String s: names) {
            newAccounts.add(testDataFactory.createAccountRecord(s));
        }

        insert newAccounts;

        for (Account a: newAccounts) {
            newIds.Add(a.Id);
        }

        return newIds;

    }
}
