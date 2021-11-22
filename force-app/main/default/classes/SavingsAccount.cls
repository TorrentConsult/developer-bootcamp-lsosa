/* ------------ Used in OOP Using Apex Live Session ------------ */

public class SavingsAccount extends BankAccount {

    public override void openAccount(Decimal startingAmount) {
        this.balance = startingAmount;
        this.accountNumber = 'SV-' + Datetime.now().getTime();
    }

    public static void run() {

        SavingsAccount savings = new SavingsAccount();
        savings.openAccount(100);
        savings.deposit(100);
        savings.withdrawal(50);
        System.debug(savings);

    }

}