/* ------------ Used in OOP Basics Assignment ------------ */

@isTest
class PaymentTest {

    /*  TODO: Uncomment out all this code 
        You should not need to change any of the code in this class
        Run all tests and make sure none of them fail

    @isTest static void testCheckPayment() {

        String paymentClassName = 'CheckPayment';
        String accountNumber = '1234567890';
        Decimal amount = 100;

        success_test(paymentClassName, accountNumber, amount);
        invalidAmount_test(paymentClassName, accountNumber, amount);
        invalidAccountNumber_test(paymentClassName, accountNumber, amount);
        missingPaymentInfo_test(paymentClassName, accountNumber, amount);

    }

    @isTest static void testCreditCardPayment() {

        String paymentClassName = 'CreditCardPayment';
        String accountNumber = '1111222233334444';
        Decimal amount = 200;

        success_test(paymentClassName, accountNumber, amount);
        invalidAmount_test(paymentClassName, accountNumber, amount);
        invalidAccountNumber_test(paymentClassName, accountNumber, amount);
        missingPaymentInfo_test(paymentClassName, accountNumber, amount);
        
    }

    //Test 1: Should be successful
    static void success_test(String paymentClassName, String accountNumber, Decimal amount) {
        try {
            Type t = Type.forName(paymentClassName);
            IPayment paymentTest = (IPayment)t.newInstance();
            paymentTest.setPaymentDetails(accountNumber, amount);
            String paymentMessage = paymentTest.makePayment();
            System.assert(paymentMessage.contains(Payment.SUCCESS_MESSAGE), 'Payment should have been successful');
        } catch (Exception ex) {
            System.assert(false, 'Payment should have been successful');
        }
    }

    //Test 2: Invalid Amount
    static void invalidAmount_test(String paymentClassName, String accountNumber, Decimal amount) {
        try {
            Type t = Type.forName(paymentClassName);
            IPayment paymentTest = (IPayment)t.newInstance();
            paymentTest.setPaymentDetails(accountNumber, -1 * amount);
            String paymentMessage = paymentTest.makePayment();
            System.assert(false, 'Payment should have failed due to invalid amount');
        } catch (Exception ex) {
            System.assert(ex.getMessage().contains(Payment.INVALID_AMOUNT), 'Payment should have failed due to invalid amount');
        }
    }

    //Test 3: Invalid Account Number
    static void invalidAccountNumber_test(String paymentClassName, String accountNumber, Decimal amount) {
        try {
            Type t = Type.forName(paymentClassName);
            IPayment paymentTest = (IPayment)t.newInstance();
            paymentTest.setPaymentDetails(accountNumber + '0', amount);
            String paymentMessage = paymentTest.makePayment();
            System.assert(false, 'Payment should have failed due to invalid account number');
        } catch (Exception ex) {
            System.assert(ex.getMessage().contains(Payment.INVALID_ACCOUNT_NUMBER), 'Payment should have failed due to invalid account number');
        }
    }

    //Test 4: Missing Payment Info
    static void missingPaymentInfo_test(String paymentClassName, String accountNumber, Decimal amount) {
        try {
            Type t = Type.forName(paymentClassName);
            IPayment paymentTest = (IPayment)t.newInstance();
            String paymentMessage = paymentTest.makePayment();
            System.assert(false, 'Payment should have failed due to missing details');
        } catch (Exception ex) {
            System.assert(ex.getMessage().contains(Payment.MISSING_PAYMENT_INFO), 'Payment should have failed due to missing details');
        }
    }        

    */

}