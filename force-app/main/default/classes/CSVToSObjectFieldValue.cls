public with sharing class CSVToSObjectFieldValue {

    private CSVToSObjectField fld;
    private String value;
    private Map<SObjectType, SObjectField> externalKeyByObject;

    private CSVToSObjectFieldValue(CSVToSObjectField fld, String value, Map<SObjectType, SObjectField> externalKeyByObject) {
        this.fld = fld;
        this.value = value;
        this.externalKeyByObject = externalKeyByObject;
    }

    public static CSVToSObjectFieldValue load(CSVToSObjectField fld, String value, Map<SObjectType, SObjectField> externalKeyByObject) {
		return new CSVToSObjectFieldValue(fld, value, externalKeyByObject);
    }

    public void putValue(SObject sObj) {
        Schema.DisplayType displayType = fld.sObjField.getDescribe().getType();
        switch on displayType {
            when Date {
                sObj.put(fld.name, value == '' ? null : Date.valueOf(value));
            }
            when DateTime {
                sObj.put(fld.name, value == '' ? null : DateTime.valueOfGmt(value));
            }
            when Percent, Currency {
                sObj.put(fld.name, value == '' ? null : Decimal.valueOf(value));
            }
            when Double {
                sObj.put(fld.name, value == '' ? null : Double.valueOf(value));
            }
            when Integer {
                sObj.put(fld.name, value == '' ? null : Integer.valueOf(value));
            }
            when Base64 {
                sObj.put(fld.name, value == '' ? null : Blob.valueOf(value));
            }    
            when Boolean {
                sObj.put(fld.name, value == '' ? false : Boolean.valueOf(value));
            }
            when REFERENCE {
                if (CSVToSObjectHelper.isValidId(value)) {
                    sObj.put(fld.name, value);
                } else {
                    SObjectType relatedSObjectType = getRelatedSObjectType();    
                    System.debug(relatedSObjectType);              
                    SObject relatedObject = (SObject)(Type.forName('Schema.'+ relatedSObjectType.getDescribe().getName()).newInstance());
                    System.debug(relatedObject);   
                    relatedObject.put(externalKeyByObject.get(relatedSObjectType), value);
                    System.debug(relatedObject);   
                    System.debug(fld.sObjField.getDescribe());   
                    String relationshipName = fld.sObjField.getDescribe().getRelationshipName();
                    if (String.isEmpty(relationshipName)) {
                        relationshipName = getRelatedSObjectType().getDescribe().getName();
                    }
                    sObj.putSObject(relationshipName, relatedObject);  
                    System.debug(sObj);                              
                }
            }
            when else {
                sObj.put(fld.name, value);
            }
        }
    }    

    public SObjectType getRelatedSObjectType() {
        SObjectType relatedSObjectType;
        List<SObjectType> relatedSObjectTypes = fld.sObjField.getDescribe().getReferenceTo();
        if (relatedSObjectTypes.size() > 1) {
            for (SObjectType sObjType : relatedSObjectTypes) {
                if (sObjType.getDescribe().getName() == fld.relatedTo) {
                    relatedSObjectType = sObjType;
                    break;
                }
            }             
        } else {
            relatedSObjectType = fld.sObjField.getDescribe().getReferenceTo()[0];
        }  
        if (relatedSObjectType == null) {
            throw new CSVToSObjectFieldValueException(
                'Unable to find relationship for ' + fld.name + ' on ' + fld.sObjType.getDescribe().getName()
            );
        }
        return relatedSObjectType;
    }

    public class CSVToSObjectFieldValueException extends Exception {}

}