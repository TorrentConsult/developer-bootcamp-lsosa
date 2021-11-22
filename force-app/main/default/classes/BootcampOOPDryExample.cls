/* ------------ Used in OOP Using Apex Live Session ------------ */

public with sharing class BootcampOOPDryExample {

    public class SavingsAccount {
        public String savingsAccountNumber;
        public Decimal balance = 0;
        public void deposit(Decimal amount) {
            this.balance += amount;
        } 
        public void withdrawal(Decimal amount) {
            this.balance -= amount;
        }
    }

    public class CheckingAccount {
        public String checkingAccountNumber;
        public String routingNumber;
        public Decimal accountBalance = 0;
        public void deposit(Decimal depositAmount) {
            this.accountBalance += depositAmount;
        } 
        public void withdrawal(Decimal withdrawalAmount) {
            this.accountBalance -= withdrawalAmount;
        }
    }    

    public class Numbers {
        public List<Integer> sortAsc(List<Integer> integers) {
            for (Integer i = 1; i < integers.size(); i++) { 
                Integer key = integers[i];
                Integer j = i - 1; 
                while (j >= 0 && integers[j] > key) { 
                    integers[j + 1] = integers[j];
                    j = j - 1; 
                } 
                integers[j + 1] = key; 
            } 
            return integers;
        }
    }

    public class Letters {
        public List<String> sortDesc(List<String> strings) {
            for (Integer i = 1; i < strings.size(); i++) { 
                String key = strings[i];
                Integer j = i - 1; 
                while (j >= 0 && strings[j] < key) { 
                    strings[j + 1] = strings[j];
                    j = j - 1; 
                } 
                strings[j + 1] = key; 
            } 
            return strings;
        }
    }

}