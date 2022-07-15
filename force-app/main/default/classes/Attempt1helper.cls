public with sharing class MaintenanceRequestHelper {


    private with sharing class MyCustomData {
        private String caseNumber;
        private Id equipmentId;
        private Integer cycleLength;
    }

    private List<Equipment_Maintenance_Item__c> newMaintenanceItems;
    private List<Equipment_Maintenance_Item__c> newMaintenanceItems2;
    private List<String> caseNumbers;
    private List<Product2> cycleTimes;
    private Map<Id,Product2> mapCycleTimes;
    private Map<String,Equipment_Maintenance_Item__c> mapCaseToItem;
    private List<Case> newCases;

    public MaintenanceRequestHelper() {

        newMaintenanceItems = new List<Equipment_Maintenance_Item__c>();
        //for clones for new request
        newMaintenanceItems2 = new List<Equipment_Maintenance_Item__c>();
        caseNumbers = new List<String>();
        mapCycleTimes = new Map<Id,Product2>();
        mapCaseToItem = new Map<String,Equipment_Maintenance_Item__c>();
        newCases = new List<Case>();
        

    }

    public List<Case> getNewCases() {
        return newCases;
    }

    public void getAllCaseNumbers(Case c) {
        String type = c.Type;
        if(type == 'Repair' || type == 'Routine Maintenance') {
            caseNumbers.Add(c.CaseNumber);
        } 

        System.Debug('ALL case numbers' + caseNumbers);
    }

    public void getListOfItemsFromCaseNumbers() {

        newMaintenanceItems = [SELECT ID, Name, Maintenance_Request__c, Equipment__c
            FROM Equipment_Maintenance_Item__c 
            WHERE Maintenance_Request__r.CaseNumber IN :caseNumbers];

        System.debug('List of maint items ' + newMaintenanceItems);


    }

    public void getCycleTimes() {
        List<Id> Ids = new List<Id>();
        for (Equipment_Maintenance_Item__c m :  newMaintenanceItems) {
            Ids.add(m.Equipment__c);
        }

        System.debug('Ids :  ' + Ids);

        cycleTimes = [SELECT Id, Maintenance_Cycle__c FROM Product2 
            WHERE Id IN :Ids];

        System.debug('Cycle times :  ' + cycleTimes);

        for (Product2 p : cycleTimes) {
            mapCycleTimes.put(p.Id,p);
        }

        System.debug(mapCycleTimes);
    }


    public List<Equipment_Maintenance_Item__c> newRecordIfNeeded(Case c) {

        String type = c.Type;
        if(type == 'Repair' || type == 'Routine Maintenance') {
            createNewRecord(c);
        } 

        System.debug('returning nmi: ' +  newMaintenanceItems2);
        return newMaintenanceItems2;

    }

    public void createNewRecord(Case c) {
        
        List<Equipment_Maintenance_Item__c> m = getMaintenanceItems(c);
        Integer nextAppt = calcMaintCycle(m);

        Case newCase = new Case();
        newCase.Type = 'Routine Maintenance';
        newCase.Subject = 'Auto generated';
        newCase.Date_Reported__c = Date.today();
        newCase.Date_Due__c = Date.today() + nextAppt;
        newCase.Vehicle__c = c.Vehicle__c;
        newCase.Status = 'New';
        try {
//            insert newCase;
            newCases.add(newCase);
            System.debug('Created new case' + newCase);
        } catch (Exception e) {
            System.debug('++++++++++++ Exception : ' + e.getMessage());
        }
       
//        setMaintenanceItems(newCase, m);
    }

    public void insertNewCases() {
        insert newCases;
    }
    public void setMaintenanceItems(Case c, List<Equipment_Maintenance_Item__c> m) {

        insert newCases;
        List<Equipment_Maintenance_Item__c> items = new List<Equipment_Maintenance_Item__c>();
        for (Equipment_Maintenance_Item__c m2 : m) {
            Equipment_Maintenance_Item__c newM = m2.clone(false,true,false,false);
            newM.Maintenance_Request__c = c.Id;
            items.add(newM);
        }

        newMaintenanceItems2.addAll(items);
    }

    public List<Equipment_Maintenance_Item__c> getMaintenanceItems(Case c) {

        List<Equipment_Maintenance_Item__c> mi = new List<Equipment_Maintenance_Item__c>();
        for (Equipment_Maintenance_Item__c m : newMaintenanceItems) {
            System.debug('+++++' + c.Id + ' ++++ ' + m.Maintenance_Request__c);
            if(c.Id == m.Maintenance_Request__c) {
                mi.add(m);
            }
        }

        System.debug('++++++++++++++++++++  getMaintenanceItems' + mi);
        return mi;

//old        return [SELECT ID, Name, Equipment__c, Maintenance_Request__r.CaseNumber FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__r.CaseNumber = :c.CaseNumber];
    }

    public Integer calcMaintCycle(List<Equipment_Maintenance_Item__c> m) {

        System.debug(m);
        Integer shortestCycle = 1000; // is there a max int in apex?
        //this could easily hit limits
        //we could do it with a set actually
        for (Equipment_Maintenance_Item__c m2 : m) {

            Id equip = m2.Equipment__c;
            Integer v = mapCycleTimes.get(equip).Maintenance_Cycle__c.intValue();
            if(v < shortestCycle) {
                shortestCycle = v;
            }

        }

/*old
            List<Product2> l = [SELECT Maintenance_Cycle__c FROM Product2
                WHERE ID = :m2.Equipment__c LIMIT 1];
            
            if (l.get(0).Maintenance_Cycle__c < shortestCycle) {
                 shortestCycle = l.get(0).Maintenance_Cycle__c.intValue(); 
            }
          
        }
*/
        System.debug('++++++++++ shortest cycle ' + shortestCycle);
        return shortestCycle;
    }
}
