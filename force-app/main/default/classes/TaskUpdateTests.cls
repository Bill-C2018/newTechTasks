@isTest
public with sharing class TaskUpdateTests {


    public TaskUpdateTests() { }

    @TestSetup
    static void makeData()  {  }

    @isTest
    static void createTasksTest() {

        AccountUtils au = new AccountUtils();
        List<String> names = testDataFactory.buildNameList(2);
        List<Id> ids = au.createAccs(names);


        if(ids.size() > 0) {

            TaskUpdate tu = new TaskUpdate();
            tu.createTasks(ids[0]);

            List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :ids[0]];
            system.assertEquals(3, tasks.size());

        }
        
    }

    @isTest 
    static void createTasksBatchTest() {
        AccountUtils au = new AccountUtils();
        List<String> names = testDataFactory.buildNameList(2);
        List<Id> ids = au.createAccs(names);


        if(ids.size() > 0) {

            TaskUpdate tu = new TaskUpdate();
            tu.createTasksBatch(ids);

            List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :ids[0]];
            system.assertEquals(6, tasks.size());

        }
         
    }

}
