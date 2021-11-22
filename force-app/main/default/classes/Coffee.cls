/* ------------ Used in Deep Dive into Apex Live Session ------------ */

public with sharing class Coffee {

    public enum Size { SMALL, MEDIUM, LARGE, XLARGE}
    public /* TODO: final? static? */ Map<Size, Decimal> sizeToPrice = new Map<Size, Decimal> {
        Size.SMALL => 1.00, Size.MEDIUM => 2.50, Size.LARGE => 3.75, Size.XLARGE => 5
    };
    public /* TODO: final? static? */ Decimal orderTotal;

    private /* TODO: final? static? */ Size coffeeSize;
    private /* TODO: final? static? */ String customerName;

    public Coffee(String customerName) {
        /* TODO: Set customerName Class Variable from Local Variable */
    }

    public /* TODO: static? */ void addCoffee(Size coffeeSize) {
        /* TODO: Set coffeeSize Class Variable from Local Variable */
        /* TODO: Calculate orderTotal Class Variable */
    }

    public static void run() {
        Coffee ronCoffee = new Coffee('Ron');
        ronCoffee.addCoffee(Coffee.Size.SMALL);
        ronCoffee.addCoffee(Coffee.Size.MEDIUM);

        Coffee edgarCoffee = new Coffee('Edgar');
        ronCoffee.addCoffee(Coffee.Size.XLARGE);

        Decimal orderTotal;         // TODO: Update to Get Order Total
        System.debug(orderTotal);   // What's the Order Total?
    }

}