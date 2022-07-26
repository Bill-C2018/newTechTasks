trigger BookLoanTrigger on BookLoan__c (before insert, after insert,  before update) {

    BookLoanTriggerHandler bl = new BookLoanTriggerHandler();

    if(Trigger.isInsert) {
        if (trigger.isBefore) {
            bl.handleBeforeInsert(Trigger.new);
        } else {
            bl.handleAfterInsert(Trigger.newMap);
        }
    }

    if(Trigger.isUpdate) {
        bl.handleBeforeUpdate(Trigger.new);
    }

}