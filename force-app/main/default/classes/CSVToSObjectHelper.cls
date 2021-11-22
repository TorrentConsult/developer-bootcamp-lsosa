public with sharing class CSVToSObjectHelper {

    public static Map<String, Id> queueByDeveloperName {
        get {
            if (queueByDeveloperName == null) {
                queueByDeveloperName = new Map<String, Id>();
                    List<Group> queues = [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue'];
                    for (Group q : queues) {
                        queueByDeveloperName.put(q.DeveloperName, q.Id);
                    }
            }
            return queueByDeveloperName;
        }
        private set;
    }

    public static Pricebook2 standardPricebook {
        get {
            if (standardPricebook == null) {
                standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
            }
            return standardPricebook;
        }
        private set;
    }
    
    public static List<User> users {
        get {
            if (users == null) {
                List<String> fields = new List<String>{'Id'};
                fields.addAll(userExternalIdFields);
                String query = 'SELECT ' + String.join(fields, ',') + ' FROM User';
                users = Database.query(query);
            }
            return users;
        }
        private set;
    }

    public static Map<String, Id> getUserIdByExternalId(String externalIdField) {
        Map<String, Id> usersByExternalId = new Map<String, Id>();
        for (User u : users) {
            usersByExternalId.put((String)u.get(externalIdField), u.Id);
        }
        return usersByExternalId;
    }

    private static List<String> userExternalIdFields {
        get {
            if (userExternalIdFields == null) {
                userExternalIdFields = new List<String>();
                Map<String, Schema.SObjectField> fieldMap = User.SObjectType.getDescribe().fields.getMap();
                for (Schema.SObjectField fld : fieldMap.Values()) {
                    Schema.DescribeFieldResult dfr = fld.getDescribe();
                    if (dfr.isExternalId()) {
                        userExternalIdFields.add(fld.getDescribe().getName());
                    }
                }
            }
            return userExternalIdFields;
        }
        private set;
    }

    public static String generateRandomString(Integer len) {
        final String chars = 'abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }

    public static Boolean isValidId(String value) {
        try {
            if (Pattern.compile('[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}').matcher(value).matches()) {
                Id id = value;
                return true;
            }
        } catch (Exception ex) { }
        return false;     
    }

    public static Boolean isMethod(Object value) {
        try {
            if (value != null && String.valueOf(value).length() > 4 && 
                String.valueOf(value).left(1) == '=' && 
                String.valueOf(value).contains('.') && 
                String.valueOf(value).contains('(') && 
                String.valueOf(value).right(1) == ')') {
                return true;
            }
        } catch (Exception ex) { }
        return false;     
    }

}