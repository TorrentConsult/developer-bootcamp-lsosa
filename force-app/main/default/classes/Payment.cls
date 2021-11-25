public abstract class Payment implements IPay {


         //Static Variables to hold the various messages we use
    public static final String SUCCESS_MESSAGE = 'Success!';
    public static final String INVALID_AMOUNT = 'Amount should be greater than 0';
    public static final String INVALID_ACCOUNT_NUMBER = 'Account number is invalid';
    public static final String MISSING_PAYMENT_INFO = 'Payment details are missing';
    public static final String MASKED_ACCOUNT_ERROR = 'You cannot retrieve the masked checking account number until you set a value';

    //Use Static initilization to set our Valid Account Number Length
    protected final Integer validAccountNumberLength{
    get{ return validAccountNumberLength; }
    set { validAccountNumberLength=value;}
           
    }

    //Check for a Valid Account Number Length when the value gets set
    virtual  String accountNumber {
        get;
        set {
            accountNumber = value;
            if (accountNumber.length() != validAccountNumberLength) {
                throw new CheckPaymentException(INVALID_ACCOUNT_NUMBER);
            }            
        }
    }

    //Check for a Valid Amount when the value gets set
    protected Decimal amount {
        get;
        set {
            amount = value;
            if (amount < 0) {
                throw new CheckPaymentException(INVALID_AMOUNT);
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
    public void setPaymentDetails(String accountNumber, Decimal amount) {
        this.accountNumber = accountNumber;
        this.amount = amount;
    }

    //Returns the right 5 digits of our checking account number
    public String getMaskedAccountNumber() {
        if (this.accountNumber != null) {
            return this.accountNumber.right(5);
        } else {
            throw new CheckPaymentException(MASKED_ACCOUNT_ERROR);
        }
    }

    //Submits a payment and returns a transaction message
    public String makePayment() {
        if (this.accountNumber != null && this.amount != null) {
            return this.transactionMessage;
        } else {
            throw new CheckPaymentException(MISSING_PAYMENT_INFO);
        }
    }

    
}
