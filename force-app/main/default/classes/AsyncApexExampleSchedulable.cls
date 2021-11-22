/* ------------ Used in Writing Async Apex Live Session ------------ */

public with sharing class AsyncApexExampleSchedulable implements Schedulable {

    public void execute(SchedulableContext sc) {

        System.debug('This current time is ' + DateTime.now());

    }

}