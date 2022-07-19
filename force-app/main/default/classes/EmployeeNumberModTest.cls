
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
        EmployeeNumberMod e = new EmployeeNumberMod();
        e.roundDown();
        system.assertEquals(1, [SELECT COUNT() FROM Account Where NumberOfEmployees = 17]);
        system.assertEquals(1, [SELECT COUNT() FROM Account Where NumberOfEmployees = 150]);
        system.assertEquals(1, [SELECT COUNT() FROM Account Where NumberOfEmployees = 200]);
    }

}
