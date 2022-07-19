trigger TT2NewAccountTrigger on Account (before insert, after insert, before delete, before update) {

    TT2NewAccountTriggerHandler th = new TT2NewAccountTriggerHandler();
    if(Trigger.isInsert) {
        if (trigger.isBefore) {
            th.HandleNewAccountInsert(Trigger.new);
        } 
        else {
            system.debug('trigger new ' + Trigger.new);
            th.handleAfterInsert(Trigger.new);
        }
    }
    else if(Trigger.isDelete) {
        th.HandleAccountDelete(Trigger.old);
    }
   
    else if(Trigger.isUpdate) {

    }
}