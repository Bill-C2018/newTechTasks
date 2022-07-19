public with sharing class EmployeeNumberMod {

    static final Integer modby = 50;

    public EmployeeNumberMod() {   }

    
    public void roundDown() {
        
        for(List<Account> accs: [Select Id, NumberOfEmployees FROM Account]) {
            List<Account> updatedAccounts = new List<Account>();
            for (Account a : accs) {
                Integer emps = a.NumberOfEmployees - Math.mod(a.NumberOfEmployees, modby);
                if(emps >= modby) {
                    a.NumberOfEmployees = emps;
                    updatedAccounts.add(a);
                }
            }
            upsert updatedAccounts;
        }
    }
}
