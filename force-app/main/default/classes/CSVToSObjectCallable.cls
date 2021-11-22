public with sharing class CSVToSObjectCallable implements Callable {

    // Dispatch actual methods
    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'Pricebook2.getStandardPricebook' {
                return CSVToSObjectHelper.standardPricebook.Id;
            }             
            when 'UserInfo.getProfileId' {
                return UserInfo.getProfileId();
            } 
            when 'UserInfo.getLocale' {
                return UserInfo.getLocale();
            }
            when 'UserInfo.getLanguage' {
                return UserInfo.getLanguage();
            }
            when 'UserInfo.getTimeZone' {
                return UserInfo.getTimeZone().toString();
            }     
            when 'UserInfo.generateUsername' {
                return 
                    CSVToSObjectHelper.generateRandomString(5) + '.' + 
                    CSVToSObjectHelper.generateRandomString(5) + '@' + 
                    'torrentconsulting.com' + '.' + 
                    UserInfo.getOrganizationId() ;
            }
            when 'getRecordTypeId.byDeveloperName' {
                return 
                    ((SObject)Type.forName('Schema', (String)args.get('0')).newInstance())
                    .getSObjectType()
                    .getDescribe()
                    .getRecordTypeInfosByDeveloperName()
                    .get((String)args.get('1'))
                    .getRecordTypeId();
            }
            when 'getQueueId.byDeveloperName' {
                return 
                    CSVToSObjectHelper.queueByDeveloperName.get((String)args.get('0'));
            }
            when 'getUserId.byExternalId' {
                Map<String, Id> usersByExternalId = 
                    CSVToSObjectHelper.getUserIdByExternalId((String)args.get('0'));
                return usersByExternalId.get((String)args.get('1'));
            }            
            when else {
                throw new CSVToSObjectCallablException('Method not implemented');
            }
        }
    }

    public class CSVToSObjectCallablException extends Exception {}

}