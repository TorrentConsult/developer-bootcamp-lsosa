/* ------------ Used in Deep Dive into Apex Live Session ------------ */

public with sharing class Coin {

    private final static Map<String, Integer> denominations;
    
    static {
        denominations = new Map<String, Integer>();
        denominations.put('Penny', 1);
        denominations.put('Nickel', 5);
        denominations.put('Dime', 10);
        denominations.put('Quarter', 25);
        denominations.put('Half Dollar', 50);
        denominations.put('Dollar Coin', 100);
        System.debug('Initializor has run');
    }

    public Integer coinValue;

    public Coin(String denomination) {
        this.coinValue = denominations.get(denomination);
        System.debug(this.coinValue);
    }

    public static void run() {
        //Create First Instance of Coin
        Coin nickel = new Coin('Nickel');
        System.debug(nickel.coinValue);

        //Create Second Instance of Coin
        Coin dime = new Coin('Dime');
        System.debug(dime.coinValue);
    }

}