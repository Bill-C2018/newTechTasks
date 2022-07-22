@isTest
public with sharing class BookLoanTriggerTestDataFactory {

    private static Map<String,Book__c> mb;
    private static Map<String,Reader__c> mr;
    private static List<String> subject;

    public BookLoanTriggerTestDataFactory() { 
        mb = new Map<String,Book__c>();
        mr = new Map<String,Reader__c>();
        subject = new List<String>{'Salesforce', 'Google','Aws','Microsoft','Linux'};
     }



     public Map<String,Reader__c> getReaderMap() {
        if (mr == null || mr.size() == 0) {
            return buildReaderMap(buildReaderList());
        }
        else {
            return mr;
        }
     }

     public Map<String,Book__c> getBookMap() {
        if (mb == null || mb.size() == 0) {
            return buildBookMap(buildBookList());
        }
        else {
            return mb;
        }
     }

     private List<Reader__c> buildReaderList() {
        String firstName = 'Reader';
        String domain = '@kindergarten.com';
        List<Reader__c> rl = new List<Reader__c>();
        for(String s: subject) {
            Reader__c r = new Reader__c();
            String email_addy = firstName + '_' + s + domain;

            r.Full_Name__c = firstName + s;
            r.Email__c = email_addy.toLowerCase();
            system.debug(r.Email__c);
            r.Speciality__c = s;
            r.Name = r.Full_Name__c;
            rl.add(r);
        }

        insert rl;
        return rl;
     }

     private Map<String,Reader__c> buildReaderMap(List<Reader__c> readers) {
        for (Reader__c r: readers) {
            mr.put(r.Speciality__c, r);
        }
        return mr;
     }

     private List<Book__c> buildBookList() {

        List<Book__c> bl = new List<Book__c>();
        for(String s: subject) {
            Book__c b = new Book__c();
            b.Name = s;
            
            b.NumberToLoan__c = 1;
            if(s == 'Linux') { b.NumberToLoan__c = 0; } //for the not enough books test
            b.Books_Out__c = 0;
            b.Subject__c = s;

            bl.add(b);
        }

        insert bl;
        return bl;
     }

     private Map<String,Book__c> buildBookMap(List<Book__c> books) {
        for (Book__c b: books) {
            mb.put(b.Subject__c,b);
        }
        return mb;
     }



}
