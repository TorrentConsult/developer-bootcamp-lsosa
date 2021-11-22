/* ------------ Used in Deep Dive into Apex Live Session ------------ */

public with sharing class BootcampDeepDiveApexConstants {

    public static final Integer SPEED_LIGHT_IN_VACUUM = 299792458;
    public static final Integer DISTANCE_EARTH_MOON_MILES = 238900;

    public static final Integer DEFAULT_RESULTS_PER_PAGE = 20;  

    private static final Map<String, String> ISO_SYMBOLS = new Map<String, String>{
        'CAD' => '$',
        'USD' => '$', 
        'EUR' => '€',
        'JPY' => '¥'
    };

    private final static Id VENDOR_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Vendor').getRecordTypeId();
    private static final Boolean IS_GUEST_USER = (UserInfo.getUserType() == 'Guest');

}