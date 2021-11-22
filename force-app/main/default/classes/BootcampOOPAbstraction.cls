/* ------------ Used in 4 Pillars of OOP Self-Guided Course ------------ */

public with sharing class BootcampOOPAbstraction {

    public static Decimal calculateVolume(Decimal radius) {
        return (4/3) * radius.pow(3) * Math.PI;
    }

}