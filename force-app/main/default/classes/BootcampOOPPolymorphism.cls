/* ------------ Used in 4 Pillars of OOP Self-Guided Course ------------ */

public with sharing class BootcampOOPPolymorphism {

    public abstract class Employee {
        public abstract Decimal calculateSalary();
    }

    public class FullTimeEmployee extends Employee {

        private Decimal annualSalary;

        public FullTimeEmployee(Decimal annualSalary) {
            this.annualSalary = annualSalary;
        }

        public override Decimal calculateSalary() {
            return annualSalary;
        }
    }

    public class Contractor extends Employee {

        private Decimal hourlyRate;
        private Integer hoursPerWeek;

        public Contractor(Decimal hourlyRate, Integer hoursPerWeek) {
            this.hourlyRate = hourlyRate;
            this.hoursPerWeek = hoursPerWeek;
        }

        public override Decimal calculateSalary() {
            return hourlyRate * hoursPerWeek * 52;
        }       
    }

    public static void outputSalary() {

        Employee e1 = new FullTimeEmployee(65000);
        System.debug(e1.calculateSalary());

        Employee e2 = new Contractor(45, 32);
        System.debug(e2.calculateSalary());
    
    }

}