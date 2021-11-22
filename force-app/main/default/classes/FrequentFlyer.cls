/* ------------ Used in OOP Using Apex Live Session ------------ */

public virtual class FrequentFlyer {

    private String frequentFlyerNumber;

    public FrequentFlyer() {
        this.frequentFlyerNumber = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 5);
    }

    protected FrequentFlyer(String frequentFlyerNumber) {
        this.frequentFlyerNumber = frequentFlyerNumber;
    }

    public String getFlyerNumber() {
        return this.frequentFlyerNumber;
    }

    public virtual String getUpgradeStatus() {
        return 'Comfort Class';
    }

    public virtual Integer getBoardingZone() {
        return 2;
    }

    public static void run() {

        FrequentFlyer flyer = new FrequentFlyer();
        String flyerNumber = flyer.getFlyerNumber();
        String status = flyer.getUpgradeStatus();
        Integer zone = flyer.getBoardingZone();
        System.debug(flyer);

    }

}