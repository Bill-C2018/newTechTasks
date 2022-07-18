public with sharing class UpdateAccount {
    public UpdateAccount() { }

/*
//  since Priority is not part of the standard account object, you must first define 
//  a picklist field with Low, Medium and High and name the field Priority
*/
    public void updatePriority() {
        for (List<Account> a : [SELECT AnnualRevenue FROM Account WHERE AnnualRevenue != null]) {
            for (Account a1: a) {
                a1.Priority__c = 'Medium';
                if (a1.AnnualRevenue > 800000000) {
                    a1.Priority__c = 'High';
                }
                else if (a1.AnnualRevenue < 200000000) {
                    a1.Priority__c = 'Low';
                }

            }
            upsert a;
        }

    }
 }
