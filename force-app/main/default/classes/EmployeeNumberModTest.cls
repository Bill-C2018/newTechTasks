
@isTest
public with sharing class EmployeeNumberModTest {
    
    @TestSetup
    static void makeData(){
        List<Account> accs = new List<Account>();
        accs.add( new Account(Name = 'test150', NumberOfEmployees = 150));
        accs.add( new Account(Name = 'test17', NumberOfEmployees = 17));
        accs.add( new Account(Name = 'teste17', NumberOfEmployees = 217));

        insert accs;
        
    }

    @isTest
    static void roundDownTest() {

        system.assertEquals(0, [SELECT COUNT() FROM Account Where NumberOfEmployees = 200]);

        test.startTest();
        EmployeeNumberMod e = new EmployeeNumberMod();
        e.roundDown();
        test.stopTest();

        system.assertEquals(1, [SELECT COUNT() FROM Account Where NumberOfEmployees = 17]);
        system.assertEquals(1, [SELECT COUNT() FROM Account Where NumberOfEmployees = 150]);
        system.assertEquals(1, [SELECT COUNT() FROM Account Where NumberOfEmployees = 200]);
    }

    @isTest
    static void roundDownWithDatabaseClassTest() {

        system.assertEquals(0, [SELECT COUNT() FROM Account Where NumberOfEmployees = 200]);
        test.startTest();
        EmployeeNumberMod e = new EmployeeNumberMod();
        List<String> errors = e.roundDownWithDatabaseClass('Select Id, NumberOfEmployees FROM Account');
        test.stopTest();    

        system.assertEquals(0, errors.size());
        system.assertEquals(1, [SELECT COUNT() FROM Account Where NumberOfEmployees = 17]);
        system.assertEquals(1, [SELECT COUNT() FROM Account Where NumberOfEmployees = 150]);
        system.assertEquals(1, [SELECT COUNT() FROM Account Where NumberOfEmployees = 200]);
    }

}
