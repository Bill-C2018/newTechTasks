public with sharing class TT2NewAccountTriggerHandler {
    public TT2NewAccountTriggerHandler() {  }


    public void HandleNewAccountInsert(List<Account> accs) {
        for(Account a: accs) {
            //first prevent poor companies from participating
            if (a.AnnualRevenue == 0 || a.AnnualRevenue == null) {
                a.addError('Poor companies NOT allowed');
            } 
            else {
                
            }
        }

    }

    public void HandleAccountDelete(List<Account> accs) {
        
    }
}
