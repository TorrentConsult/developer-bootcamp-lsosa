/* ------------ Used in Data and Metadata in Apex Assignment ------------ */

public class BootcampDataApexAssignment {

    //-----Assignment 1-----
    public static void updateInvitationStatus(Id weddingId, String newStatus) {
        //Assignment 1
        //TO DO 1.1: Query the Invitation__c records where Wedding__c is equal to the weddingId
        //TO DO 1.2: Loop over Invitations for each Invitation in our returned Query
        //TO DO 1.3: Update the Status__c to the passed in status in our method
        //TO DO 1.4: Use the Database.Update method to perform an update and set the allOrNone parameter to false.
        //TO DO 1.5: Store the results of the Database.Update method as a List<Database.SaveResult>
       


    }

    /* Testing
    -- Run the following code to test your work --
        Wedding__c wedding = [SELECT Id FROM Wedding__c WHERE Id IN (SELECT Wedding__c FROM Invitation__c) LIMIT 1];
        BootcampDataApexAssignment.updateInvitationStatus(wedding.Id, 'Attending');
    */


    //-----Assignment 2-----
    public static List<Wedding__c> getWeddingWithChildren(String weddingStatus) {
        //Assignment 2
        //TO DO 2.1: Write Static SOQL Query to return a List of Weddings 
            //SELECT Fields - Wedding Name, Wedding City and Wedding Start Date 
            //WHERE Clause - Filter Wedding Status equal to passed in weddingStatus
        //TO DO 2.2: Add Parent Fields to Select Clause
            //SELECT Fields - Owner Name, Account Source, Account Home Phone
        //TO DO 2.3: Add Child Subquery to return Related Wedding Invitations
            //SELECT Fields - Invitee First Name, Invitee Last Name, Invitee Email, Phone
            //WHERE Clause - Filter Invitation Status equal to Attending
        //TO DO 2.4: Add Child Subquery to return Related Wedding Vendors
            //SELECT Fields - Fixed Fee, Unit Type, Number of Hours, Number of Attendees
            //SELECT Parent Fields - Vendor Account Name
            //WHERE Clause - Filter Vendor Status equal to Selected
        //TO DO 2.5: Replace the below return null and return your query results instead
        return null;



       
    }

    /* Testing
    -- Run the following code to test your work --
        List<Wedding__c> weddings = BootcampDataApexAssignment.getWeddingWithChildren('Initial Planning');
        System.assertNotEquals(true, weddings.isEmpty(), 'Should return some weddings');
    */

    //-----Assignment 3-----
    Account t;
    public static List<List<SObject>> getSearchResults(String searchTerm) {

        //Assignment 3
        //TO DO 3.1: Write Static SOSL Query to find records using your searchTerm in NAME fields
        //TO DO 3.2: Add RETURNING Clause to search for matching (Vendor) Accounts
            //RETURNING Object - Account
            //RETURNING Fields - Account Name, Account Source, Home Phone, Billing City
            //WHERE Clause - RecordType Name equal to Vendor
        //TO DO 3.3: Add RETURNING Clause to search for matching Weddings
            //RETURNING Object - Wedding__c
            //RETURNING Fields - Wedding Name, Status, Start Date, End Date
        //TO DO 3.4: Add RETURNING Clause to search for matching Leads
            //RETURNING Object - Lead
            //RETURNING Fields - Name, Lead Source, Email, Phone
            //ORDER BY Clause - Order by CreatedDate in Descending Order
            //LIMIT - Return only 10 Records
        //TO DO 3.5: Replace the below return null and return your search results instead

        

        return null;
    }

    /* Testing
    -- Run the following code to test your work --
        List<List<SObject>> searchResults = BootcampDataApexAssignment.getSearchResults('Wedding');
        System.assertNotEquals(true, searchResults.isEmpty(), 'Should return some records');
    */




    //-----Assignment 4-----
    public static List<SObject> runQuery(SObjectType sObjType, List<String> fields, List<String> whereClauses) {
        //Assignment 4
        //TO DO 4.1: Write Dynamic SOQL to build and execute your query using the passed in SObjectType
            //Example sObjType Parameter: Invitation__c.SObjectType
        //TO DO 4.2: Update your SELECT Clause to select the List of fields that are passed in
            //Example fields Parameter: ['Invitee_First_Name__c', 'Invitee_Last_Name__c', 'Date_Sent__c']
        //TO DO 4.3: ADD a WHER E Clause using the List of String of whereClauses that are passed in
            //Example whereClauses Parameter: ['Status__c = \'Attending\'', 'State__c IN (\'MI\', \'CA\')']
            //Join the List of Strings using an AND operator
        //TO DO 4.4: Execute the Query using the Query String
        //TO DO 4.5: Replace the below return null and return your query results instead

        return null;
    }

    /* Testing
    -- Run the following code to test your work --
        List<SObject> records = BootcampDataApexAssignment.runQuery(
            Invitation__c.SObjectType, 
            new List<String>{'Invitee_First_Name__c', 'Invitee_Last_Name__c', 'Date_Sent__c'},
            new List<String>{'Status__c = \'Attending\'', 'State__c IN (\'MI\', \'CA\')'}
        );
        System.assertNotEquals(true, records.isEmpty(), 'Should return some records');
    */



    //-----Assignment 5-----
    public static List<SObjectField> getDateFormulaFields(SObjectType sObjectType) {
            
        //Assignment 5
        //TO DO 5.1: Create a new List<SObjectField> variable to hold the results
        //TO DO 5.2: Get all the fields for the provided SObjectType
        //TO DO 5.3: Loop through each field and instantiate a field describe
        //TO DO 5.4: Determine if the field is a formula field using the appropriate
            //DescribeFieldResult method
        //TO DO 5.5: Determine if the field is a date field using the appropriate
            //DescribeFieldResult method            
        //TO DO 5.6: If the field is a formula and date field, add it to our 
            //List<SObjectField> variable
        //TO DO 5.7: Replace the below return null and return your variable instead
        
        


        return null;
    }

    /* Testing
        -- Run the following code to test your work --
        List<SObjectField> formulaFields = BootcampDataApexAssignment.getDateFormulaFields(Wedding__c.SObjectType);
        System.assertNotEquals(true, formulaFields.isEmpty(), 'Should return some metadata');    
    */

}