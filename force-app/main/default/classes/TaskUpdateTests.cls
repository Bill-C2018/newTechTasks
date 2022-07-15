@isTest
public with sharing class TaskUpdateTests {

    public static List<Id> ids;

    public TaskUpdateTests() { }

    @TestSetup
    static void makeData(){
        
        AccountUtils au = new AccountUtils();
        List<String> names = AccountUtilsTest.buildNameList(2);
        ids = au.createAccs(names);
    }

    @isTest
    static void createTasksTest() {
        
    }

}
