//created new custom object DescribeObjTest__c

public with sharing class DescribeOjbectDeepDive {

    sObject obj;
    Map<String, Schema.SObjectType> objList;

    public DescribeOjbectDeepDive() {
        
        obj = new DescribeObjTest__c();
        objList = Schema.getGlobalDescribe();
    }

    public void Test1() {
        system.debug(objList);
        SObjectType t = objList.get('SchoolBook__c');
        system.debug(t);
        List<Schema.DescribeSObjectResult> res = Schema.describeSObjects(new String[]{'SchoolBook__c'});
        system.debug(res[0]);
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Account.fields.getMap();
        system.debug(fieldMap);

    }
}
