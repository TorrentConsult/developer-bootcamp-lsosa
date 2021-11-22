/* ------------ Used in OOP Using Apex Live Session ------------ */

public abstract class BankAccount {

    protected String accountNumber;
    protected Decimal balance;
    
    public virtual void deposit(Decimal amount) {
        this.balance += amount;
    }
    public virtual void withdrawal(Decimal amount) {
        this.balance -= amount;
    }

    public abstract void openAccount(Decimal startingAmount);

    public static void run() {

        /* 
            BankAccount banking = new BankAccount(); //not allowed
        */
        
    }

}