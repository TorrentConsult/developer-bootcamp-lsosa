/* ------------ Used in 4 Pillars of OOP Self-Guided Course ------------ */

public class BootcampOOPEncapsulation {

    public class BankAccount {

        private Decimal accountBalance;

        public BankAccount(Decimal startingBalance) {
            this.accountBalance = startingBalance;
        }
    
        public void deposit(Decimal depositAmount) {
            this.accountBalance += depositAmount;
        }
    
        public void withdrawal(Decimal withdrawalAmount) {
            this.accountBalance -= withdrawalAmount;
        }
    
        public Decimal getAccountBalance() {
            return accountBalance;
        }

    }

}