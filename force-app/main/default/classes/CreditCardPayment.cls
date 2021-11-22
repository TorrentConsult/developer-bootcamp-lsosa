public class CreditCardPayment {

    //Static Variables to hold the various messages we use
    public static final String SUCCESS_MESSAGE = 'Success!';
    public static final String INVALID_AMOUNT = 'Amount should be greater than 0';
    public static final String INVALID_ACCOUNT_NUMBER = 'Account number is invalid';
    public static final String MISSING_PAYMENT_INFO = 'Payment details are missing';
    public static final String MASKED_ACCOUNT_ERROR = 'You cannot retrieve the masked credit card number until you set a value';
    
    //Use Static initilization to set our Valid Account Number Length
    private final Integer validAccountNumberLength;
    {
        validAccountNumberLength = 16;
    }

    //Check for a Valid Account Number Length when the value gets set
    private String accountNumber {
        get;
        set {
            accountNumber = value;
            if (accountNumber.length() != validAccountNumberLength) {
                throw new CreditCardPaymentException(INVALID_ACCOUNT_NUMBER);
            }            
        }
    }

    //Check for a Valid Amount when the value gets set
    private Decimal amount {
        get;
        set {
            amount = value;
            if (amount < 0) {
                throw new CreditCardPaymentException(INVALID_AMOUNT);
            }
        }        
    }

    //Constructs a message with the payment information
    private String transactionMessage {
        set; 
        get {
            return SUCCESS_MESSAGE + ' A payment of ' + this.amount + ' has been applied from account ' + getMaskedAccountNumber();
        }
    }

    //Sets our class variables based on local variables
    public void setPaymentDetails(String accountNumber, Decimal amount) {
        this.accountNumber = accountNumber;
        this.amount = amount + (amount * .01);     //1% credit card fee applied to the amount
    }

    //Returns the left 4 digits of our credit card number
    public String getMaskedAccountNumber() {
        if (this.accountNumber != null) {
            return this.accountNumber.left(4);
        } else {
            throw new CreditCardPaymentException(MASKED_ACCOUNT_ERROR);
        }
    }

    //Submits a payment and returns a transaction message
    public String makePayment() {
        if (this.accountNumber != null && this.amount != null) {
            return this.transactionMessage;
        } else {
            throw new CreditCardPaymentException(MISSING_PAYMENT_INFO);
        }
    }

    public class CreditCardPaymentException extends Exception {}

}