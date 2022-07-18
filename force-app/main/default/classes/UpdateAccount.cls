public with sharing class UpdateAccount {
    public UpdateAccount() { }

/*
//  there IS an existing field CustomerPriority__c so no need for the priority__c I created
*/
    public void updatePriority() {
        for (List<Account> a : [SELECT AnnualRevenue FROM Account WHERE AnnualRevenue != null]) {
            for (Account a1: a) {
                a1.CustomerPriority__c = 'Medium';
                if (a1.AnnualRevenue > 800000000) {
                    a1.CustomerPriority__c = 'High';
                }
                else if (a1.AnnualRevenue < 200000000) {
                    a1.CustomerPriority__c = 'Low';
                }

            }
            upsert a;
        }

    }
 }
