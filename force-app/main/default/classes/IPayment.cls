public Interface IPayment {

     void setPaymentDetails(String accountNumber, Decimal amount) ;
     String getMaskedAccountNumber();
     String makePayment();
     
}
