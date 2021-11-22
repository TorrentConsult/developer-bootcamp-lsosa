/* ------------ Used in Deep Dive into Apex Live Session ------------ */

public with sharing class WeddingBudgetHelper {

    public Decimal foodCostPerPerson {
        private get { return foodCostPerPerson; }
        set { foodCostPerPerson = value; }
    }

    public Integer numberOfPeople {
        private get { return numberOfPeople; }
        set {
            if (numberOfPeople < 0) throw new WeddingBudgetHelperException('You can not have less than 0 persons');
            numberOfPeople = value;            
        }
    }

    public Decimal totalCost {
        get { 
            ++counter;
            return foodCostPerPerson * numberOfPeople; 
        }
    }

    public static Integer counter {
        get { 
            if (counter == null) counter = 1;
            if (counter > 3) throw new WeddingBudgetHelperException('You can only access total cost up to 3 times');
            return counter; 
        }
        private set;
    }

    public WeddingBudgetHelper(Decimal foodCostPerPerson, Integer numberOfPeople) {
        this.foodCostPerPerson = foodCostPerPerson;
        this.numberOfPeople = numberOfPeople;
    }

    public class WeddingBudgetHelperException extends Exception { }

    public static void run() {

        WeddingBudgetHelper helper1 = new WeddingBudgetHelper(25, 100);
        System.debug('Calculation counter is ' + WeddingBudgetHelper.counter + '. Total cost is ' + helper1.totalCost);

        WeddingBudgetHelper helper2 = new WeddingBudgetHelper(30, 75);
        System.debug('Calculation counter is ' + WeddingBudgetHelper.counter + '. Total cost is ' + helper2.totalCost);

        WeddingBudgetHelper helper3 = new WeddingBudgetHelper(50, 30);
        System.debug('Calculation counter is ' + WeddingBudgetHelper.counter + '. Total cost is ' + helper3.totalCost);        
        System.debug('Calculation counter is ' + WeddingBudgetHelper.counter + '. Total cost is ' + helper3.totalCost);   

    }


}