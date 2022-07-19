trigger TT2NewAccountTrigger on Account (before insert, before delete, before update) {

    TT2NewAccountTriggerHandler th = new TT2NewAccountTriggerHandler();
    if(Trigger.isInsert) {
        
        th.HandleNewAccountInsert(Trigger.new);
    }
    else if(Trigger.isDelete) {
        th.HandleAccountDelete(Trigger.old);
    }
    else if(Trigger.isUpdate) {

    }
}