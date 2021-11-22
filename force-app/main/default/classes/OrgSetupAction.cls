global class OrgSetupAction {

    @InvocableMethod(label='OrgSetup')
    public static List<Result> OrgSetup(List<Request> requests) {
        switch on requests[0].requestMethod {
            when 'isSetupComplete' {
                return new List<Result>{new Result(OrgSetupDataOperation.instance(requests[0]).isSetupComplete())};
            }
            when 'purgeObjectList' {
				return new List<Result>{new Result(OrgSetupDataOperation.instance(requests[0]).purgeObjectList())};                
            }   
            //when 'purgeObject' {
            //    return new List<Result>{new Result(OrgSetupDataOperation.instance(requests[0]).purgeObject())};
            //}
            when 'generateObjectList' {
				return new List<Result>{new Result(OrgSetupDataOperation.instance(requests[0]).generateObjectList())};                
            }        
            //when 'generateObject' {
            //    return new List<Result>{new Result(OrgSetupDataOperation.instance(requests[0]).generateObject())};
            //}
            when 'toggleSetupComplete' {
                return new List<Result>{new Result(OrgSetupDataOperation.instance(requests[0]).toggleSetupComplete())};
            }
        }
        return null;
    }
    
    global class Request {
        
        @InvocableVariable(label='requestMethod' description='requestMethod' required='true')
        public String requestMethod;
        
        @InvocableVariable(label='staticResourceName' description='staticResourceName' required='true')
        public String staticResourceName;
 
        @InvocableVariable(label='staticResourceDateTime' description='staticResourceDateTime')
        public DateTime staticResourceDateTime;
        
        @InvocableVariable(label='objectName' description='objectName')
        public String objectName;
        
        @InvocableVariable(label='fileName' description='fileName')
        public String fileName;        
        
    }
    
    global class Result {
        @InvocableVariable(label='Result' description='Result')
  		public OrgSetupDataResult result;  
        public Result(OrgSetupDataResult result) {
            this.result = result;
        }
    }
    
}