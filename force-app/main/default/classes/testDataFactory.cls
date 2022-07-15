public with sharing class testDataFactory {


    public static Account createAccountRecord(String accountName) {

        Account a = new Account(Name = accountName);
        return a;
    }

    public static List<String> buildNameList(Integer count) {
        List<String> names = new List<String>();
        for (Integer x = 0; x < count; x++) {
            names.Add('Test_Account_' + count);
        }
        return names;
    }

    
}
