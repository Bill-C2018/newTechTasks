trigger TT2NewAccountTrigger on Account (before insert, after insert, before delete, before update) {

    TT2NewAccountTriggerHandler th = new TT2NewAccountTriggerHandler();
    if(Trigger.isInsert) {
        if (trigger.isBefore) {
            th.HandleNewAccountInsert(Trigger.new);
        } 
        else {
            th.handleAfterInsert(Trigger.newMap);
        }
    }
    else if(Trigger.isDelete) {
        th.HandleAccountDelete(Trigger.old);
    }
  

}