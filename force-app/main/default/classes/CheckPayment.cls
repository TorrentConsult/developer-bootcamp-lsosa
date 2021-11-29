/* ------------ Used in OOP Basics Assignment ------------ */

public class CheckPayment extends Payment {

    public static final String MASKED_ACCOUNT_ERROR = 'You cannot retrieve the masked checking account number until you set a value';
    {
        this.validAccountNumberLength=10;
    }

    //Sets our class variables based on local variables
    public override  void setPaymentDetails(String accountNumber, Decimal amount) {
        this.accountNumber = accountNumber;
        this.amount = amount;
    }

    //Returns the right 5 digits of our checking account number
    public override  String getMaskedAccountNumber() {
        if (this.accountNumber != null) {
            return this.accountNumber.right(5);
        } else {
            throw new CardPaymentException(MASKED_ACCOUNT_ERROR);
        }
    }

    

}