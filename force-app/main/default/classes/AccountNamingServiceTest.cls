/* ------------ Used in Testing Apex Triggers Live Session ------------ */

@isTest
class AccountNamingServiceTest {

    @testSetup
    static void makeData() {
        insert new Account(Name = 'Torrent Consulting');	// Step 1: Create Test Data
    }

    @isTest static void updateName_test() {
        //Step 2: Get existing data and create new data as needed
        Account acct = [SELECT Id, Name FROM Account WHERE Name Like 'Torrent Consulting%']; 	
        
        Test.startTest();						    //Step 3: Run Test.startTest() to reset governor limits
        AccountNamingService.updateName(acct);		//Step 4: Call our Service Method to set Status to Closed
        Test.stopTest();						    //Step 5: Run Test.stopTest() to mark end of test

        //Step 6: Assert our results are as expected
        System.assertEquals('New Account Name', acct.Name, 'Account Name should match');
    }

}