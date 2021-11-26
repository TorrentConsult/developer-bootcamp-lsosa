public class CreditCardPayment extends Payment {

    public static final String MASKED_ACCOUNT_ERROR = 'You cannot retrieve the masked checking account number until you set a value';
    
    {
        this.validAccountNumberLength=16;
    }

    //Sets our class variables based on local variables
    override public void setPaymentDetails(String accountNumber, Decimal amount) {
        this.accountNumber = accountNumber;
        this.amount = amount + (amount * .01);     //1% credit card fee applied to the amount
    }

    //Returns the left 4 digits of our credit card number
    override public String getMaskedAccountNumber() {
        if (this.accountNumber != null) {
            return this.accountNumber.left(4);
        } else {
            throw new CardPaymentException(MASKED_ACCOUNT_ERROR);
        }
    }

}