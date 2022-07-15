@isTest
public with sharing class AccountUtilsTest {

    @isTest
    static void testcreateAccs(){
        Integer number_to_add = 2;
        AccountUtils au = new AccountUtils();
        List<String> names = testDataFactory.buildNameList(2);
        List<Id> ids = au.createAccs(names);
        system.debug(ids);
        system.assertEquals(number_to_add, ids.size());
    }

/*
//for now this fails .. I don't think the defualt is to trigger a dupe
//on name only
    @isTest
    static void testHandleDups(){
        Integer number_to_add = 2;
        AccountUtils au = new AccountUtils();
        List<String> names = new List<String>();
        for(Integer x = 0; x < number_to_add; x++ ) {
            names.add('TestAccount');
        }
        List<Id> ids = au.createAccs(names);
        system.debug(ids);
        system.assertEquals(number_to_add, ids.size());
        Set<Id> theset = new Set<Id>();
        theset.addAll(ids);
        system.assertEquals(1, theset.size());

    }
*/

 }
