public abstract class Payment implements IPayment {


         //Static Variables to hold the various messages we use
    public static final String SUCCESS_MESSAGE = 'Success!';
    public static final String INVALID_AMOUNT = 'Amount should be greater than 0';
    public static final String INVALID_ACCOUNT_NUMBER = 'Account number is invalid';
    public static final String MISSING_PAYMENT_INFO = 'Payment details are missing';


    //Use Static initilization to set our Valid Account Number Length
    protected final Integer validAccountNumberLength;
           
    

    //Check for a Valid Account Number Length when the value gets set
    protected  String accountNumber {
        get;
        set {
            accountNumber = value;
            if (accountNumber.length() != validAccountNumberLength) {
                throw new CardPaymentException(INVALID_ACCOUNT_NUMBER);
            }            
        }
    }

    //Check for a Valid Amount when the value gets set
    protected Decimal amount {
        get;
        set {
            amount = value;
            if (amount < 0) {
                throw new CardPaymentException(INVALID_AMOUNT);
            }
        }        
    }

    //Constructs a message with the payment information
    protected String transactionMessage {
        set; 
        get {
            return SUCCESS_MESSAGE + ' A payment of ' + this.amount + ' has been applied from account ' + getMaskedAccountNumber();
        }
    }

    //Sets our class variables based on local variables
    public abstract void setPaymentDetails(String accountNumber, Decimal amount);

    //Returns the right 5 digits of our checking account number
    public abstract String getMaskedAccountNumber();

    //Submits a payment and returns a transaction message
    public String makePayment() {
        if (this.accountNumber != null && this.amount != null) {
            return this.transactionMessage;
        } else {
            throw new CardPaymentException(MISSING_PAYMENT_INFO);
        }
    }

    public class CardPaymentException extends Exception {}
}
