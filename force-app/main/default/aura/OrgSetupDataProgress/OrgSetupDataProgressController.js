({
  
    onInit: function (component, event, helper) {
        console.log('onInit');
       
        component.set('v.subscription', null);
        component.set('v.messages', []);
        
        const empApi = component.find('empApi');
        const errorHandler = function (message) {
            helper.addMessage(component, JSON.stringify(message));
        };
        empApi.onError($A.getCallback(errorHandler));
        helper.subscribe(component, event, helper);
    },
    
    runJob: function (component, event, helper) {
		console.log('runJob');
        
        helper.executeAction(component, event, helper);
    }
    
    
})