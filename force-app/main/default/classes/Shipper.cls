/* ------------ Used in OOP Using Apex Live Session ------------ */

// Shipper Outer Class Definition 
public abstract class Shipper implements IShippingService {

    private String deliveryAddress;
    public void setDeliveryAddress(String address) {
        this.deliveryAddress = address;
    }
    public abstract String generateTrackingNumber();

    // UPSShipper Inner Class extending Shipper Class
    public class UPSShipper extends Shipper {
        public override String generateTrackingNumber() {
            return 'UPS-' + DateTime.now().getTime();
        }
    }

    // FedExShipper Virtual Inner Class extending Shipper Class
    public virtual class FedExShipper extends Shipper {
        public virtual override String generateTrackingNumber() {
            return 'FX-' + EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 9);
        }
    }

    // FedexPremiumShipper Inner Class extending FedexShipper Class
    public class FedexPremiumShipper extends FedExShipper {
        public override String generateTrackingNumber() {
            return 'FXP-' + EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 8);
        }

        public String getDeliveryStatus() {
            return 'Delivered';
        }
    }

    //BreatheTrackr Client Code
    public static void run() {

        IShippingService shippingService = (IShippingService) ShippingInjector.instantiate();
        System.debug('Tracking Number: ' + shippingService.generateTrackingNumber());

        /*
        System.debug(shippingService.getDeliveryStatus()); // Not allowed
        */

        if (shippingService instanceof Shipper.FedexPremiumShipper) {
            Shipper.FedexPremiumShipper fedexPremiumService = (Shipper.FedexPremiumShipper)shippingService;
            System.debug('Delivery Status: ' + fedexPremiumService.getDeliveryStatus());
        }
         
    }

}