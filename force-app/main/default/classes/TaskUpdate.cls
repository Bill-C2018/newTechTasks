public with sharing class TaskUpdate {

    public TaskUpdate() { }

    private Task createTask(Id id, Id owner, String title, String Priority, Date dueDate) {

        Task T = new Task();
        T.Description = title;
        T.Subject = title;
        T.WhatId = Id;
        T.OwnerId = owner;
        T.Priority = Priority;
        T.Type = 'Call';
        T.ActivityDate = dueDate;
        T.Status = 'Not Started';

        return T;

    }

    private List<Task> doIt(Account a) {
        List<Task> taskList = new List<Task>();
        Date dueDate = system.today();
        Task t = createTask(a.Id, a.OwnerId,'Feature call','High',dueDate);
        taskList.add(t);
        taskList.add(createTask(a.Id, a.OwnerId,'Follow up 1','Normal',dueDate + 14));
        taskList.add(createTask(a.Id, a.OwnerId,'Follow up 2','Normal',dueDate + 28));
        return taskList;

    }

    public void createTasks(Id accountId) {

        List<Task> taskList = new List<Task>();
        Account a = [SELECT OwnerId FROM Account WHERE Id = :accountId];
        List<Task> newTasks = doIt(a);
        insert newTasks;
     }

     public void createTasksBatch(List<Id> accounts) {
        Set<Id> sIds = new Set<Id>();
        sIds.addAll(accounts);
        List<Task> allTasks = new List<Task>();
        List<Account> a = [SELECT Id,OwnerId From Account WHERE Id IN :sIds];
        for (Account a1 : a) {
            List<Task> newTasks = doIt(a1);
            allTasks.addAll(newTasks);
        }
        insert allTasks;
     }
}
