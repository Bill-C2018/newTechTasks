@isTest
public with sharing class testDataFactory {


    public static Account createAccountRecord(String accountName) {

        Account a = new Account(Name = accountName);
        return a;
    }

    public static List<Account> createAccountRecord(List<String> accountNames) {

        List<Account> accts = new List<Account>();
        for (String s: accountNames) {
            Account a = new Account(Name = s);
            accts.add(a);
        }
        return accts;
    }

    public static List<String> buildNameList(Integer count) {
        List<String> names = new List<String>();
        for (Integer x = 0; x < count; x++) {
            names.Add('Test_Account_' + count);
        }
        return names;
    }
/*
//  this could probably be just added to a the createAccountRecord above but 
//  in the interest of keeping everything seperate
*/
    public static List<Account> addAnnualRevenue(List<Account> a) {
   
        Integer count = 0;
        for (Account a1 : a) {
            Integer randomNumber = Integer.valueof((Math.random() * 10));
            a1.AnnualRevenue = randomNumber + 100000000;
        }

        return a;
        
    }

    
}
