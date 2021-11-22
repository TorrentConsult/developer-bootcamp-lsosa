public class CSVToSObject {

    private Schema.SObjectType sObjType;
    private Blob file;
    private Map<SObjectType, SObjectField> externalKeyByObject;
    public List<SObject> records;

    public CSVToSObject(SObjectType sObjType, Blob file, Map<SObjectType, SObjectField> externalKeyByObject) {
        this.sObjType = sObjType;
        this.externalKeyByObject = externalKeyByObject;
        this.file = file;
        this.records = new List<SObject>();
    }    
    
    public CSVToSObject parseFile() {
        List<List<String>> csvData = CSVReader.readCSVFile(file);
        System.debug('Number of rows in file: ' + csvData.size());

        for (Integer i=1; i<csvData.size(); i++) { // Row 0 is Header Row
            SObject sObj = Schema.getGlobalDescribe().get(sObjType.getDescribe().getName()).newSObject();
            for (Integer j=0; j<csvData[i].size(); j++) {
                String value = csvData[i][j];
                String headerValue = String.valueOf(csvData[0][j]);
                System.debug(i + ': ' + headerValue + ' : ' + value);
                CSVToSObjectField fld = CSVToSObjectField.load(sObjType, headerValue);
                if (CSVToSObjectHelper.isMethod(value)) {
                    value = getValuByMethod(value);
                }
                CSVToSObjectFieldValue.load(fld, value, externalKeyByObject).putValue(sObj);
            }
            records.add(sObj);
        }
        System.debug('Number of records generated: ' + records.size());
        return this;
    }
    
    private String getValuByMethod(String value) {
        if (String.isNotEmpty(value)) {
            String methodName = value.substringAfter('=').substringBefore('(');
            String paramName = value.substringAfter('(').substringBefore(')');
            System.debug(methodName + ' ' + paramName);
            List<String> paramNames = String.isNotEmpty(paramName) ? paramName.split(',') : new List<String>();
            Map<String, Object> params = new Map<String, Object>();
            for (Integer i=0; i<paramNames.size(); i++) {
                params.put(String.valueOf(i), paramNames[i]);
            }
            Callable extension = (Callable) Type.forName('CSVToSObjectCallable').newInstance();
            String result = (String) extension.call(methodName, params);
            return result;
        }
        return null;
    }
    
    public class CSVToSObjectException extends Exception {}

}