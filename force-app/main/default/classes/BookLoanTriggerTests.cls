@isTest
public with sharing class BookLoanTriggerTests {


    //there is an edge case where if several people take out the same book its possible that the available
    //number of books could drop below zero befor the book table is actually updated so I changed
    //the simulatecheckout to only support single reader and book even though most of the rest 
    //of the code is batch safe

    static BookLoanTriggerTestDataFactory testData = new BookLoanTriggerTestDataFactory();

    public BookLoanTriggerTests() { }


    private static User createRunAsUser() {
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName);

         return u;

    }
    private static BookLoan__c simulateCheckoutScreen(Reader__c reader, Book__c book) {
        
        BookLoan__c bl = new BookLoan__c();
        bl.Name = reader.Name + '-' + book.Name;
        bl.Date_loaned__c = system.today();
        bl.Book__c = book.Id;
        bl.Reader__c = reader.Id;
        bl.Active__c = false; //set if it passes the valid tests in the trigger

        return bl;
    }

    @isTest
    public static void TestLoanBook() {

        Map<String,Book__c> books = testData.getBookMap();
        Map<String,Reader__c> readers = testData.getReaderMap();
        system.debug('Initial set ' + books + '++' + readers);
        BookLoan__c bl = simulateCheckoutScreen(readers.get('Aws'),books.get('Aws'));

        //run as a standard user
        User u = createRunAsUser();
        System.runAs(u) {
            Database.SaveResult srList = Database.insert(bl, false);
            system.assertEquals(true, srList.isSuccess());
        }
        

        List<BookLoan__c> current = [SELECT Book__c, Reader__c FROM BookLoan__c];

        //validate out count has gone from 0 to 1
        List<Book__c> btest = [SELECT Books_Out__c FROM Book__c WHERE Subject__c = 'AWS'];
        system.debug('Btest' + btest);
        system.assertEquals(1, btest.size());
        system.assertEquals(1, btest.get(0).Books_Out__c);

        //validate a task was created
        Contact c = [SELECT LastName FROM Contact WHERE LastName = :readers.get('Aws').Full_Name__c LIMIT 1];
        system.debug('contacts ' + c);
        List<Task> t = [SELECT WhoId FROM TASK WHERE WhoId = :c.Id];
        system.debug('Tasks ' + t);
        system.assertEquals(1,t.size());


    }

    @isTest
    public static void TestLoanBookInvalidCount() {
        Map<String,Book__c> books = testData.getBookMap();
        Map<String,Reader__c> readers = testData.getReaderMap();

        BookLoan__c bl = simulateCheckoutScreen(readers.get('Linux'),books.get('Linux'));

        //run as a standard user
        User u = createRunAsUser();
        System.runAs(u) {
            Database.SaveResult sr = Database.insert(bl, false);
            system.assertNotEquals(true, sr.isSuccess());
            
            for(Database.Error err: sr.getErrors()) { 
                system.assert(err.getMessage().contains('Not Rentable - no books available'));
            }
        }


  
    }

    @isTest
    public static void TestLoanBookInvalidSpeciality() {
        Map<String,Book__c> books = testData.getBookMap();
        Map<String,Reader__c> readers = testData.getReaderMap();

        BookLoan__c bl = simulateCheckoutScreen(readers.get('Linux'),books.get('Aws'));

        //run as a standard user
        User u = createRunAsUser();
        System.runAs(u) {
            Database.SaveResult srList = Database.insert(bl, false);
            system.assertNotEquals(true, srList.isSuccess());
            for(Database.Error err: srList.getErrors()) { 
                system.assert(err.getMessage().contains('Not Rentable - reader is not qualified'));
            }
        }

  

    }

    @isTest
    public static void TestBookReturn() {

        Map<String,Book__c> books = testData.getBookMap();
        Map<String,Reader__c> readers = testData.getReaderMap();
        BookLoan__c bl = simulateCheckoutScreen(readers.get('Aws'),books.get('Aws'));
        User u = createRunAsUser();
        System.runAs(u) {
            Database.SaveResult srList = Database.insert(bl, false);
            system.assertEquals(true, srList.isSuccess());
            }
        
        List<BookLoan__c> returns = [SELECT Active__c, Book__c, Date_returned__c FROM BookLoan__c WHERE Book__c = :books.get('Aws').Id AND Reader__c = :readers.get('Aws').Id]; 

        List<Database.SaveResult> srListupdate = Database.update(returns, false);
        List<Book__c> btest = [SELECT Books_Out__c FROM Book__c WHERE Subject__c = 'AWS'];
        system.debug('Btest' + btest);
        system.assertEquals(1, btest.size());
        system.assertEquals(0, btest.get(0).Books_Out__c);


    }

}
