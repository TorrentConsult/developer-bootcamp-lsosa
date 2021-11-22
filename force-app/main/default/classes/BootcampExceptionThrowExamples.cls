/* ------------ Used in Exception Handling Live Session ------------ */

public with sharing class BootcampExceptionThrowExamples {

    @TestVisible static Integer numberOfExceptions = 0;

    // Custom Exception Syntax
    public class BootcampException extends Exception {}  // Extends Exception Class
    public static Decimal calculateCost(Decimal hourlyRate, Decimal numberHours) {

        if (hourlyRate <= 0 || numberHours <= 0) {
            throw new BootcampException('Hourly Rate and Number of Hours must be greater than 0');
        }
        return hourlyRate * numberHours;
    }

    // Custom Exception with Enhanced Logging
    public class EnhancedBootcampException extends Exception {

        public EnhancedBootcampException(String message, Boolean writeToLog) {
            this.setMessage(message);      //Have to use "this" to call base method
            if (writeToLog) {
                System.debug('Type Name: ' + this.getTypeName());
                System.debug('Message: ' + this.getMessage());
                System.debug('Line Number: ' + this.getLineNumber());
                System.debug('Stack Trace: ' + super.getCause().getStackTraceString()); // Workaround for Known Issue                
            }
        }

    }


    public static Decimal enhancedCalculateCost(Decimal hourlyRate, Decimal numberHours) {

        if (hourlyRate <= 0 || numberHours <= 0) {
            throw new EnhancedBootcampException('Hourly Rate and Number of Hours must be greater than 0', true);
        }
        return hourlyRate * numberHours;
    }


    public static void run() {

        //Custom Exception
        // No Exception
        Decimal cost1 = BootcampExceptionThrowExamples.calculateCost(15, 2.5);

        // Has Exception
        Decimal cost2 = BootcampExceptionThrowExamples.calculateCost(-10, 1);


        //Enhanced Custom Exception
        // No Exception
        Decimal cost3 = BootcampExceptionThrowExamples.enhancedCalculateCost(15, 2.5);

        // Has Exception
        Decimal cost4 = BootcampExceptionThrowExamples.enhancedCalculateCost(-10, 1);

    }


}