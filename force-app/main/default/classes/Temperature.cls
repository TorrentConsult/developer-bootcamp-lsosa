/* ------------ Used in Deep Dive into Apex Live Session ------------ */

public with sharing class Temperature {

    public Decimal temp;
    public static Decimal maxTemp = 0;
 
    public Temperature(Decimal temp) {
        this.temp = temp;
        if (temp > maxTemp) {
            maxTemp = temp;
        } 
    }
 
    public static void run() {
        Temperature t1 = new Temperature(75);
        Temperature t2 = new Temperature(100);
        Temperature t3 = new Temperature(65);
        System.debug('Max Temp: ' + Temperature.maxTemp);   //100
    }

}