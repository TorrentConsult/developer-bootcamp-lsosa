/* ------------ Used in OOP Using Apex Live Session ------------ */

public class CheckingAccount extends BankAccount {

    private String routingNumber;
    private Integer lastCheckNumber;

    public override void openAccount(Decimal startingAmount) {
        this.balance = 0;
        this.accountNumber = 'CH-' + Math.floor(Math.random() * 100000).intValue() + 99999;
        this.routingNumber = '12ABCDE3';
    }

    public void writeCheck(Decimal amount, Integer checkNumber) {
        this.balance -= amount;
        this.lastCheckNumber = checkNumber;
    }

    public static void run() {

        CheckingAccount checking = new CheckingAccount();
        checking.openAccount(50);
        checking.deposit(250);
        checking.withdrawal(20);
        checking.writeCheck(50, 1050);
        System.debug(checking);

    }

}