public with sharing class MomException extends Exception {

    public MomException(String strMessage, List<Messaging.SingleEmailMessage > listMessages) 
    {
        
        this.setMessage(strMessage);
        
        for (Messaging.SingleEmailMessage msj : listMessages )
        {
            System.debug('Error to send '+ msj.getWhatId() );
    

    }
}
}

