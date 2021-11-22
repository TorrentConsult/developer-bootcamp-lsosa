public class OrgSetupDataResult {

    @AuraEnabled
    public Boolean value;
    
    @AuraEnabled
    public String message;
    
    public OrgSetupDataResult(Boolean value, String message) {
        this.value = value;
        this.message = message;
    }
    
}