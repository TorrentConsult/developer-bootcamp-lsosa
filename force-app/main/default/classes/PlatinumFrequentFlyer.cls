/* ------------ Used in OOP Using Apex Live Session ------------ */

public class PlatinumFrequentFlyer extends FrequentFlyer {

    public PlatinumFrequentFlyer() {
        super('P-' + EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 5));
    }

    public override String getUpgradeStatus() {
        return 'First Class';
    }

    public override Integer getBoardingZone() {
        return 1;
    }

    public void orderDinner(String meal) {
        System.debug(meal + ' is on its way soon');
    }

    public static void run() {

        PlatinumFrequentFlyer platinum = new PlatinumFrequentFlyer();
        String platinumFlyerNumber = platinum.getFlyerNumber();
        String platinumStatus = platinum.getUpgradeStatus();
        Integer platinumZone = platinum.getBoardingZone();
        platinum.orderDinner('Steak');
        System.debug(platinum);
        
    }

}