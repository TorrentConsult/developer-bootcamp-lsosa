public with sharing class CSVToSObjectField {

    private String headerValue;
    public SObjectType sObjType {get; private set;}

    private CSVToSObjectField(SObjectType sObjType, String headerValue) {
        this.sObjType = sObjType;
        this.headerValue = headerValue;
    }

	public static CSVToSObjectField load(SObjectType sObjType, String headerValue) {
		return new CSVToSObjectField(sObjType, headerValue);
    }
    
    public SObjectField sObjField {
        get {
            if (sObjField == null) {
                sObjField = sObjType.getDescribe().fields.getMap().get(name);
                if (sObjField == null) {
                    throw new CSVToSObjectFieldException(
                        'Unable to find field ' + headerValue + ' on ' + sObjType.getDescribe().getName()
                    );
                }
            }
            return sObjField;
        }
        private set;
    }

    public String name {
        get {
            if (name == null) {
                List<String> headerValues = headerValue.split(':');
                name = headerValues[0];     
            }
            return name;
        }
        private set;
    }

    public String relatedTo {
        get {
            if (relatedTo == null) {
                List<String> headerValues = headerValue.split(':');
                relatedTo = headerValues.size() > 1 ? headerValues[1] : null; 
            }       
            return relatedTo;    
        }
        private set;
    }

    public class CSVToSObjectFieldException extends Exception {}

}