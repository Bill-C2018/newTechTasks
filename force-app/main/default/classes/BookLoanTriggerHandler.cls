public with sharing class BookLoanTriggerHandler {

    public BookLoanTriggerHandler() {  }


    private void doUpdateBoosk(List<Id> bookstoupdate) {
//        List<Book__c> books = [SELECT Number_Out__c FROM Books__c WHERE Id IN :bookstoupdate];
        List<Book__c> b = new List<Book__c>();
        For(Book__c books: [SELECT Books_Out__c FROM Book__c WHERE Id IN :bookstoupdate]) {
            books.Books_Out__c = books.Books_Out__c - 1;
            b.add(books);
        }

        update b;
    }

    private void createEmailTask(List<Reader__c> readers) {

        system.debug('Create Task ' + readers);
        List<Task> emailTask  = new List<Task>();
        List<Contact> contacts = createContactsForTasks(readers);
        Map<String,Id> cmap = new Map<String,Id>();
        for(Contact x : contacts) {
            cmap.put(x.LastName, x.Id);
        }

        for(Reader__c r: readers) {
            Task t = new Task();
            t.Type = 'Email';
            t.Subject = 'Email';
            t.ActivityDate	= system.today() + 14;
            t.WhoId = cmap.get(r.Full_Name__c);
            emailTask.add(t);
        }


        insert emailTask;

    }


    private List<Contact> createContactsForTasks(List<Reader__c> readers) {
        List<Contact> newContacts = new List<Contact>();
        for (Reader__c r: readers) {
            Contact x = new Contact(LastName = r.Full_Name__c);
            x.Email = r.Email__c;
            newContacts.add(x);
        }

        upsert newContacts;
        
        return newContacts;
    }


    private Reader__c getReaderFromId(List<Reader__c> rl, Id id){
        Reader__c foundReader =null;
        for (Reader__c r : rl) {
            if(r.Id == id) {
                foundReader = new Reader__c();
                foundReader = r;
                break;
            }
        }
        return foundReader;
    }

    private Book__c getBookFromId(List<Book__c> bl, ID id) {
        Book__c foundBook = null;
        for (Book__c b: bl) {
            if(b.Id == id) {
                foundBook = new Book__c();
                foundBook = b;
                break;
            }
        }
        return foundBook;
    }

    public void handleBeforeInsert(List<BookLoan__c> b) {
        system.debug('Before Insert ' + b);

        List<Id> readers = new List<Id>();
        List<Id> books = new List<Id>();
        for(BookLoan__c bl: b) {
            readers.add(bl.Reader__c);
            books.add(bl.Book__c);
        }

        List<Reader__c> r = [SELECT Speciality__c FROM Reader__c WHERE ID IN :readers];
        List<BooK__c> bk = [SELECT Subject__c, NumberToLoan__c, Books_Out__c  FROM Book__c WHERE ID IN :books];
        //should really make maps and eliminate the for loops but ehh its hot
        for(BookLoan__c bcheck: b) {
            bcheck.Active__c = true;
            Book__c  bcurrent = getBookFromId(bk,bcheck.Book__c);
            Reader__c rcurrent = getReaderFromId(r,bcheck.Reader__c);
            system.debug('Bookloan ' + bcheck);
            system.debug('book Item ' + bcurrent);
            system.debug('reader Item ' + rcurrent);
            if(bcurrent == null || rcurrent == null) {
                system.debug('failed on nul book or reader');
                bcheck.addError('Not Rentable - can not find book or reader');
                
            }
            if((bcurrent.NumberToLoan__c - bcurrent.Books_Out__c ) < 1) {
                system.debug('failed on not enough books');
                bcheck.addError('Not Rentable - no books available');
                
            }
            if(rcurrent.Speciality__c != bcurrent.Subject__c) {
                system.debug('failed on subject');
                bcheck.addError('Not Rentable - reader is not qualified');
                
            }
           
        }


        

    }

    public void handleAfterInsert(Map<Id,BookLoan__c> b) {
        system.debug('After Insert ' + b);
        //two tasks here .. create the new task and update the number out
        //don't use a set as there may be multiples of the same book 
        //which can cause a problem in a batch scenario
        //hmm but even handling it before insert would not solve the problem 
        List<Id> booksNeedingUpdate = new List<Id>();
        List<Id> readersNeedingEmails = new List<Id>();
        for(ID id: b.keySet()) {
            booksNeedingUpdate.add(b.get(id).Book__c);
            readersNeedingEmails.add(b.get(id).Reader__c);
        }
        List<Book__c> updateBooks = [SELECT Books_Out__c FROM Book__c WHERE Id IN :booksNeedingUpdate ];
        List<Reader__c> emailToReader = [SELECT Email__c, Full_Name__c FROM Reader__c WHERE Id IN :readersNeedingEmails];

        for (Book__c ubook : updateBooks) {
            ubook.Books_Out__c = ubook.Books_Out__c + 1;
        } 

        system.debug('books to update ' + updateBooks);
        update updateBooks;

        system.debug('readers needing mail ' + emailToReader);
        createEmailTask(emailToReader);

    }

    public void handleBeforeUpdate(List<BookLoan__c> b) {
        List<Id> booksNeedingUpdate = new List<Id>();
        for(BookLoan__c ln: b) {
            booksNeedingUpdate.add(ln.Book__c);
            ln.Active__c = false;
            ln.Date_returned__c = system.today();
        }

        doUpdateBoosk(booksNeedingUpdate);

        //should also clear the task here but word came down that there 
        //is no need
    }
}
