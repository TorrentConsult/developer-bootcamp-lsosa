public class OrgSetupDataHelper {

    public enum OperationType { INSERT_DATA, DELETE_DATA }
    
    private static OrgSetupDataHelper orgSetupDataHelperInstance = null;
    private String staticResourceName;
    private OperationType operation;

    public static OrgSetupDataHelper instance(String staticResourceName, OperationType operation) {
        if (orgSetupDataHelperInstance == null) {
        	orgSetupDataHelperInstance = new OrgSetupDataHelper(staticResourceName, operation);
        }
        return orgSetupDataHelperInstance;
    }

    private OrgSetupDataHelper(String staticResourceName, OperationType operation) {
        this.staticResourceName = staticResourceName;
        this.operation = operation;
    }
    
    public Org_Sample_Data_Resource__mdt sampleDataResource {
        get {
            if (sampleDataResource == null) {
                String soql = 'SELECT DeveloperName, Label, Setup_Complete__c ' + 
                    'FROM Org_Sample_Data_Resource__mdt ' + 
                    'WHERE DeveloperName =: staticResourceName ' + 
                    'LIMIT 1';
                System.debug(soql);
                sampleDataResource = Database.query(soql);                    
            }
            return sampleDataResource;
        }
        private set;        
    }
    
    public List<Org_Sample_Data_SObject__mdt> sampleDataObjects {
        get {
            if (sampleDataObjects == null) {
                String soql = 'SELECT Label, File_Name__c, External_Key_Field__c, Insert_Order__c, Delete_Order__c ' + 
                    'FROM Org_Sample_Data_SObject__mdt ' + 
                    'WHERE Org_Sample_Data_File__r.DeveloperName =: staticResourceName ' + 
                    'AND ' + (operation == OperationType.INSERT_DATA ? 'Allow_Insert__c' : 'Allow_Delete__c') + ' = TRUE ' + 
                    'ORDER BY ' + (operation == OperationType.INSERT_DATA ? 'Insert_Order__c' : 'Delete_Order__c');
                System.debug(soql);
                sampleDataObjects = Database.query(soql);                    
            }
            return sampleDataObjects;
        }
        private set;
    }
    
    public Map<SObjectType, SObjectField> externalKeyByObject {
        get {
            if (externalKeyByObject == null) {
                externalKeyByObject = new Map<SObjectType, SObjectField>();
                for (Org_Sample_Data_SObject__mdt sdo : [SELECT Label, External_Key_Field__c FROM Org_Sample_Data_SObject__mdt WHERE Org_Sample_Data_File__r.DeveloperName =: staticResourceName]) {
                    if (String.isNotEmpty(sdo.External_Key_Field__c)) {
                        externalKeyByObject.put(
                            Schema.getGlobalDescribe().get(sdo.Label).getDescribe().SObjectType, 
                            Schema.getGlobalDescribe().get(sdo.Label).getDescribe().SObjectType.getDescribe().fields.getMap().get(sdo.External_Key_Field__c)
                        );
                    }
                }
            }
            return externalKeyByObject;
        }
        private set;
    }
    
}